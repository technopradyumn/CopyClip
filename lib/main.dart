import 'dart:async';
import 'package:copyclip/src/features/canvas/data/canvas_adapter.dart';
import 'package:flutter/foundation.dart'; // Required for kDebugMode
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' show dotenv;
import 'package:flutter_quill/flutter_quill.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:home_widget/home_widget.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:copyclip/src/core/router/app_router.dart';
import 'package:copyclip/src/core/router/main_router.dart';
import 'package:copyclip/src/core/services/notification_service.dart';
import 'package:copyclip/src/core/theme/app_theme.dart';
import 'package:copyclip/src/core/theme/theme_manager.dart';
import 'package:copyclip/src/features/clipboard/data/clipboard_adapter.dart';
import 'package:copyclip/src/features/clipboard/data/clipboard_model.dart';
import 'package:copyclip/src/features/expenses/data/expense_adapter.dart';
import 'package:copyclip/src/features/expenses/data/expense_model.dart';
import 'package:copyclip/src/features/journal/data/journal_adapter.dart';
import 'package:copyclip/src/features/journal/data/journal_model.dart';
import 'package:copyclip/src/features/notes/data/note_adapter.dart';
import 'package:copyclip/src/features/notes/data/note_model.dart';
import 'package:copyclip/src/features/todos/data/todo_adapter.dart';
import 'package:copyclip/src/features/todos/data/todo_model.dart';
import 'src/l10n/app_localizations.dart';
import 'package:upgrader/upgrader.dart';

// ==========================================
// BACKGROUND CALLBACKS & SERVICES
// ==========================================

@pragma("vm:entry-point")
Future<void> homeWidgetBackgroundCallback(Uri? uri) async {
  if (uri == null || uri.scheme != 'copyclip') return;

  final featureId = uri.host;
  final routesMap = {
    'notes': AppRouter.notes,
    'todos': AppRouter.todos,
    'expenses': AppRouter.expenses,
    'journal': AppRouter.journal,
    'calendar': AppRouter.calendar,
    'clipboard': AppRouter.clipboard,
  };

  final route = routesMap[featureId];
  if (route == null) return;

  const channel = MethodChannel('com.technopradyumn.copyclip/widget_handler');
  try {
    await channel.invokeMethod('navigateTo', {'route': route});
  } catch (_) {}
}

class RateUpgraderMessages extends UpgraderMessages {
  @override
  String get buttonTitleIgnore => 'Rate App';
}

class ClipboardAutoSaveService {
  static final ClipboardAutoSaveService _instance = ClipboardAutoSaveService._internal();
  Timer? _clipboardCheckTimer;
  String? _lastSavedContent;

  factory ClipboardAutoSaveService() => _instance;

  ClipboardAutoSaveService._internal();

  void startAutoSave({Duration interval = const Duration(seconds: 2)}) {
    if (_clipboardCheckTimer != null && _clipboardCheckTimer!.isActive) return;

    _clipboardCheckTimer = Timer.periodic(interval, (_) async {
      await _checkAndSaveClipboard();
    });
    debugPrint("Auto-save service started");
  }

  void stopAutoSave() {
    _clipboardCheckTimer?.cancel();
    _clipboardCheckTimer = null;
    debugPrint("Auto-save service stopped");
  }

  Future<void> _checkAndSaveClipboard() async {
    try {
      if (!Hive.isBoxOpen('settings') || !Hive.isBoxOpen('clipboard_box')) return;

      final settingsBox = Hive.box('settings');
      final isAutoSaveEnabled = settingsBox.get('clipboardAutoSave', defaultValue: false) as bool;

      if (!isAutoSaveEnabled) return;

      ClipboardData? data = await Clipboard.getData(Clipboard.kTextPlain);
      String? content = data?.text;

      if (content == null || content.trim().isEmpty) return;
      if (_lastSavedContent == content.trim()) return;

      final box = Hive.box<ClipboardItem>('clipboard_box');
      bool exists = box.values.any((item) => !item.isDeleted && item.content.trim() == content.trim());

      if (!exists) {
        final newItem = ClipboardItem(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          content: content.trim(),
          createdAt: DateTime.now(),
          type: _detectType(content),
          sortIndex: -1,
        );
        await box.put(newItem.id, newItem);
        _lastSavedContent = content.trim();
        debugPrint("Auto-saved clipboard item");
      }
    } catch (e) {
      debugPrint("Auto-save error: $e");
    }
  }

  String _detectType(String text) {
    if (text.startsWith('http')) return 'link';
    if (RegExp(r'^\+?[0-9]{7,15}$').hasMatch(text)) return 'phone';
    return 'text';
  }
}

void main() async {
  final startTime = DateTime.now();
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Fire and Forget Ads (Do NOT await)
  MobileAds.instance.initialize();

  // 2. Register Background Callback
  HomeWidget.registerBackgroundCallback(homeWidgetBackgroundCallback);
  HomeWidget.setAppGroupId('group.com.technopradyumn.copyclip');

  // 3. System UI
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  // 4. Initialize Hive & Adapters
  await Hive.initFlutter();

  Hive.registerAdapter(NoteAdapter());
  Hive.registerAdapter(TodoAdapter());
  Hive.registerAdapter(ExpenseAdapter());
  Hive.registerAdapter(JournalEntryAdapter());
  Hive.registerAdapter(ClipboardItemAdapter());

  // 5. CRITICAL: Open ONLY Settings/Theme boxes here for fast launch
  // We leave the heavy boxes (Notes/Todos) for the Splash Screen
  await Future.wait([
    Hive.openBox('settings'),
    Hive.openBox('theme_box'),
  ]);

  // 6. Run App Immediately
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeManager(),
      child: const RootAppWrapper(),
    ),
  );
}

// ==========================================
// ROOT WRAPPER (Handles Theme & ScreenUtil)
// ==========================================

class RootAppWrapper extends StatelessWidget {
  const RootAppWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context);

    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        // We use a State wrapper to handle the Async Initialization
        return InitializationWrapper(
          themeMode: themeManager.themeMode,
          lightTheme: AppTheme.lightTheme(themeManager.primaryColor),
          darkTheme: AppTheme.darkTheme(themeManager.primaryColor),
        );
      },
    );
  }
}

class InitializationWrapper extends StatefulWidget {
  final ThemeMode themeMode;
  final ThemeData lightTheme;
  final ThemeData darkTheme;

  const InitializationWrapper({
    super.key,
    required this.themeMode,
    required this.lightTheme,
    required this.darkTheme,
  });

  @override
  State<InitializationWrapper> createState() => _InitializationWrapperState();
}

class _InitializationWrapperState extends State<InitializationWrapper> {
  bool _isReady = false;

  @override
  void initState() {
    super.initState();
    _loadHeavyResources();
  }

  Future<void> _loadHeavyResources() async {
    final start = DateTime.now();

    try {
      // 1. Load Environment & Databases Parallel
      await Future.wait([
        dotenv.load(fileName: ".env"),
        CanvasDatabase().init(),
        NotificationService().init(),
        // Open heavy boxes
        Hive.openBox<Note>('notes_box'),
        Hive.openBox<Todo>('todos_box'),
        Hive.openBox<Expense>('expenses_box'),
        Hive.openBox<JournalEntry>('journal_box'),
        Hive.openBox<ClipboardItem>('clipboard_box'),
        _initializeWidgetData(),
      ]);

      // 2. Start Services
      _startAutoSaveService();

      // 3. Artificial Delay (Optional: Smoothness)
      // Ensure splash shows for at least 1.5 seconds so it doesn't flicker
      final elapsed = DateTime.now().difference(start);
      if (elapsed.inMilliseconds < 10) {
        await Future.delayed(Duration(milliseconds: 10 - elapsed.inMilliseconds));
      }

    } catch (e) {
      debugPrint("Initialization Error: $e");
    } finally {
      if (mounted) {
        setState(() {
          _isReady = true;
        });
      }
    }
  }

  Future<void> _initializeWidgetData() async {
    final String? title = await HomeWidget.getWidgetData<String>('title');
    if (title != null) return;
    await HomeWidget.saveWidgetData<String>('title', 'Clipboard');
    await HomeWidget.saveWidgetData<String>('description', 'Access your clipboard history');
    await HomeWidget.saveWidgetData<String>('deeplink', 'copyclip://clipboard');
  }

  void _startAutoSaveService() {
    final autoSaveService = ClipboardAutoSaveService();
    final settingsBox = Hive.box('settings');
    final isAutoSaveEnabled = settingsBox.get('clipboardAutoSave', defaultValue: false) as bool;
    if (isAutoSaveEnabled) {
      autoSaveService.startAutoSave();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isReady) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        themeMode: widget.themeMode,
        theme: widget.lightTheme,
        darkTheme: widget.darkTheme,
        home: Scaffold(
          backgroundColor: widget.themeMode == ThemeMode.dark ? Colors.black : Colors.white,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/logo/copyclip_logo.png',
                  width: 120,
                  height: 120,
                ),
              ],
            ),
          ),
        ),
      );
    }

    // 2. If Ready, show the Real App with Router
    return CopyClipApp(
      themeMode: widget.themeMode,
      lightTheme: widget.lightTheme,
      darkTheme: widget.darkTheme,
    );
  }
}

class CopyClipApp extends StatefulWidget {
  final ThemeMode themeMode;
  final ThemeData lightTheme;
  final ThemeData darkTheme;

  const CopyClipApp({
    super.key,
    required this.themeMode,
    required this.lightTheme,
    required this.darkTheme,
  });

  @override
  State<CopyClipApp> createState() => _CopyClipAppState();
}

class _CopyClipAppState extends State<CopyClipApp> with WidgetsBindingObserver {
  static const widgetChannel = MethodChannel('com.technopradyumn.copyclip/widget_handler');

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // Attach Listeners ONLY after app is ready
    widgetChannel.setMethodCallHandler(_handleNativeCalls);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _handleInitialNotification();
      _configureNotificationListener();
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final service = ClipboardAutoSaveService();
    if (state == AppLifecycleState.resumed) {
      final settingsBox = Hive.box('settings');
      if (settingsBox.get('clipboardAutoSave', defaultValue: false) as bool) {
        service.startAutoSave();
      }
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<void> _handleNativeCalls(MethodCall call) async {
    if (call.method == 'navigateTo') {
      final dynamic args = call.arguments;
      String? route;
      if (args is String) route = args;
      else if (args is Map) route = args['route'];

      if (route != null) router.push(route);
    }
  }

  Future<void> _handleInitialNotification() async {
    final notificationPlugin = NotificationService().flutterLocalNotificationsPlugin;
    final launchDetails = await notificationPlugin.getNotificationAppLaunchDetails();
    if (launchDetails?.didNotificationLaunchApp == true && launchDetails?.notificationResponse?.payload != null) {
      final payload = launchDetails!.notificationResponse!.payload!;
      Future.delayed(const Duration(milliseconds: 500), () => _openTodo(payload));
    }
  }

  void _configureNotificationListener() {
    NotificationService().onNotifications.listen((String? payload) {
      if (payload != null) _openTodo(payload);
    });
  }

  void _openTodo(String id) {
    if (!Hive.isBoxOpen('todos_box')) return;
    final box = Hive.box<Todo>('todos_box');
    final todo = box.get(id);
    if (todo != null) {
      router.push(AppRouter.todoEdit, extra: todo);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'CopyClip',
      debugShowCheckedModeBanner: false,
      themeMode: widget.themeMode,
      theme: widget.lightTheme,
      darkTheme: widget.darkTheme,
      routerConfig: router,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        FlutterQuillLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      builder: (context, child) {
        return UpgradeAlert(
          upgrader: Upgrader(
            debugLogging: kDebugMode,
            messages: RateUpgraderMessages(),
          ),
          showIgnore: true,
          showLater: true,
          barrierDismissible: false,
          onIgnore: () {
            debugPrint("User clicked Rate App");
            return true;
          },
          child: child ?? const SizedBox(),
        );
      },
    );
  }
}