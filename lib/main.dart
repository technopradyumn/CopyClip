import 'dart:async';
import 'package:copyclip/src/features/canvas/data/canvas_adapter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:go_router/go_router.dart';
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

// --- AUTO-SAVE SERVICE ---
class ClipboardAutoSaveService {
  static final ClipboardAutoSaveService _instance = ClipboardAutoSaveService._internal();
  Timer? _clipboardCheckTimer;
  String? _lastSavedContent;

  factory ClipboardAutoSaveService() {
    return _instance;
  }

  ClipboardAutoSaveService._internal();

  void startAutoSave({Duration interval = const Duration(seconds: 2)}) {
    // Check if already running
    if (_clipboardCheckTimer != null && _clipboardCheckTimer!.isActive) {
      return;
    }

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
      // Check if setting is enabled
      final settingsBox = Hive.box('settings');
      final isAutoSaveEnabled = settingsBox.get('clipboardAutoSave', defaultValue: false) as bool;

      if (!isAutoSaveEnabled) return;

      if (!Hive.isBoxOpen('clipboard_box')) return;

      ClipboardData? data = await Clipboard.getData(Clipboard.kTextPlain);
      String? content = data?.text;

      if (content == null || content.trim().isEmpty) return;

      // Skip if same as last saved
      if (_lastSavedContent == content.trim()) return;

      final box = Hive.box<ClipboardItem>('clipboard_box');

      // Check if already exists
      bool exists = box.values.any((item) =>
      !item.isDeleted && item.content.trim() == content.trim()
      );

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

  void resetLastSavedContent() {
    _lastSavedContent = null;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Register Background Callback
  HomeWidget.registerBackgroundCallback(homeWidgetBackgroundCallback);
  HomeWidget.setAppGroupId('group.com.technopradyumn.copyclip');

  // 2. Enable Edge-to-Edge and Landscape for Tablets
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  // 3. Initialize Hive
  await Hive.initFlutter();
  await CanvasDatabase().init();

  // 4. Register Adapters
  Hive.registerAdapter(NoteAdapter());
  Hive.registerAdapter(TodoAdapter());
  Hive.registerAdapter(ExpenseAdapter());
  Hive.registerAdapter(JournalEntryAdapter());
  Hive.registerAdapter(ClipboardItemAdapter());

  // 5. Initialize Services
  await NotificationService().init();

  // 6. Open Boxes
  await Future.wait([
    Hive.openBox<Note>('notes_box'),
    Hive.openBox<Todo>('todos_box'),
    Hive.openBox<Expense>('expenses_box'),
    Hive.openBox<JournalEntry>('journal_box'),
    Hive.openBox<ClipboardItem>('clipboard_box'),
    Hive.openBox('settings'),
    Hive.openBox('theme_box'),
  ]);

  await _initializeWidgetData();

  // 7. Start Auto-save Service
  final autoSaveService = ClipboardAutoSaveService();
  final settingsBox = Hive.box('settings');
  final isAutoSaveEnabled = settingsBox.get('clipboardAutoSave', defaultValue: false) as bool;

  if (isAutoSaveEnabled) {
    autoSaveService.startAutoSave();
  }

  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeManager(),
      child: CopyClipApp(autoSaveService: autoSaveService),
    ),
  );
}

Future<void> _initializeWidgetData() async {
  final String? title = await HomeWidget.getWidgetData<String>('title');
  if (title != null) return;

  await HomeWidget.saveWidgetData<String>('title', 'Clipboard');
  await HomeWidget.saveWidgetData<String>('description', 'Access your clipboard history');
  await HomeWidget.saveWidgetData<String>('deeplink', 'copyclip://clipboard');
}

class CopyClipApp extends StatefulWidget {
  final ClipboardAutoSaveService autoSaveService;

  const CopyClipApp({super.key, required this.autoSaveService});

  @override
  State<CopyClipApp> createState() => _CopyClipAppState();
}

class _CopyClipAppState extends State<CopyClipApp> with WidgetsBindingObserver {
  // Method Channels
  static const widgetChannel = MethodChannel('com.technopradyumn.copyclip/widget_handler');

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // Channel Handlers
    widgetChannel.setMethodCallHandler(_handleNativeCalls);

    // Initial Setup
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _handleInitialNotification();
      _configureNotificationListener();
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Resume auto-save when app comes to foreground
      final settingsBox = Hive.box('settings');
      final isAutoSaveEnabled = settingsBox.get('clipboardAutoSave', defaultValue: false) as bool;

      if (isAutoSaveEnabled && (widget.autoSaveService._clipboardCheckTimer == null || !widget.autoSaveService._clipboardCheckTimer!.isActive)) {
        widget.autoSaveService.startAutoSave();
      }
    } else if (state == AppLifecycleState.paused) {
      // Keep auto-save running in background - no action needed
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

      if (args is String) {
        route = args;
      } else if (args is Map) {
        route = args['route'];
      }

      if (route != null) {
        router.push(route);
      }
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
      if (payload != null) {
        _openTodo(payload);
      }
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
    final themeManager = Provider.of<ThemeManager>(context);

    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp.router(
          title: 'CopyClip',
          debugShowCheckedModeBanner: false,
          themeMode: themeManager.themeMode,
          theme: AppTheme.lightTheme(themeManager.primaryColor),
          darkTheme: AppTheme.darkTheme(themeManager.primaryColor),
          routerConfig: router,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            FlutterQuillLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
        );
      },
    );
  }
}