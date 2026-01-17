import 'dart:async';
import 'dart:isolate';
import 'package:copyclip/src/core/services/home_widget_service.dart';
import 'package:copyclip/src/features/canvas/data/canvas_adapter.dart';
import 'package:flutter/foundation.dart';
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

// ============================================
// ✅ ENHANCED BACKGROUND CALLBACK FOR WIDGETS
// ============================================
@pragma("vm:entry-point")
Future<void> homeWidgetBackgroundCallback(Uri? uri) async {
  if (uri == null || uri.scheme != 'copyclip') return;

  debugPrint('🔔 Widget callback received: $uri');

  final featureId = uri.host;
  final routesMap = {
    'notes': AppRouter.notes,
    'todos': AppRouter.todos,
    'expenses': AppRouter.expenses,
    'journal': AppRouter.journal,
    'calendar': AppRouter.calendar,
    'clipboard': AppRouter.clipboard,
    'canvas': AppRouter.canvas,
  };

  final route = routesMap[featureId];
  if (route == null) {
    debugPrint('⚠️ Unknown widget route: $featureId');
    return;
  }

  // Send to native handler
  const channel = MethodChannel('com.technopradyumn.copyclip/widget_handler');
  try {
    await channel.invokeMethod('navigateTo', {'route': route});
    debugPrint('✅ Widget navigation sent: $route');
  } catch (e) {
    debugPrint('❌ Widget navigation failed: $e');
  }
}

class RateUpgraderMessages extends UpgraderMessages {
  @override
  String get buttonTitleIgnore => 'Rate App';
}

// --- APP STATE MANAGER ---
class AppInitializationState extends ChangeNotifier {
  bool _isInitialized = false;
  String _currentStep = 'Starting...';
  double _progress = 0.0;

  bool get isInitialized => _isInitialized;
  String get currentStep => _currentStep;
  double get progress => _progress;

  void updateProgress(String step, double progress) {
    _currentStep = step;
    _progress = progress;
    notifyListeners();
  }

  void complete() {
    _isInitialized = true;
    _progress = 1.0;
    notifyListeners();
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final initState = AppInitializationState();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeManager()),
        ChangeNotifierProvider.value(value: initState),
      ],
      child: const LoadingApp(),
    ),
  );

  try {
    await _initializeApp(initState);
  } catch (e) {
    debugPrint("❌ Fatal initialization error: $e");
  }
}

Future<void> _initializeApp(AppInitializationState state) async {
  try {
    // Step 1: Basic services
    state.updateProgress('Initializing services...', 0.1);
    await Future.wait([
      dotenv.load(fileName: ".env").catchError((_) => null),
    ]);

    // ✅ CHANGE 1: Initialize Home Widget Service FIRST
    state.updateProgress('Setting up widgets...', 0.2);
    await HomeWidgetService.initialize();
    debugPrint('✅ Home Widget Service initialized');

    state.updateProgress('Initializing ads...', 0.25);
    await MobileAds.instance.initialize();

    // Step 2: Hive setup
    state.updateProgress('Setting up database...', 0.4);
    await Hive.initFlutter();

    Hive.registerAdapter(NoteAdapter());
    Hive.registerAdapter(TodoAdapter());
    Hive.registerAdapter(ExpenseAdapter());
    Hive.registerAdapter(JournalEntryAdapter());
    Hive.registerAdapter(ClipboardItemAdapter());

    // Step 3: System setup
    state.updateProgress('Configuring system...', 0.55);

    // ✅ CHANGE 2: Register background callback for widgets
    HomeWidget.registerBackgroundCallback(homeWidgetBackgroundCallback);
    HomeWidget.setAppGroupId('group.com.technopradyumn.copyclip');
    debugPrint('✅ Widget background callback registered');

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    // Step 4: Open critical boxes
    state.updateProgress('Loading data...', 0.7);
    await Future.wait([
      _openBoxSafely('settings'),
      _openBoxSafely('theme_box'),
      NotificationService().init(),
    ]);

    // Step 5: Open remaining boxes (SAFELY)
    state.updateProgress('Loading features...', 0.85);

    // Open boxes sequentially to handle corruption
    await _openBoxSafely<Note>('notes_box');
    await _openBoxSafely<Todo>('todos_box');
    await _openBoxSafely<Expense>('expenses_box');
    await _openBoxSafely<JournalEntry>('journal_box');
    await _openBoxSafely<ClipboardItem>('clipboard_box');
    await CanvasDatabase().init();

    // ✅ CHANGE 3: Initialize background tasks and update widgets
    state.updateProgress('Finalizing...', 0.95);
    await _initializeBackgroundTasks();

    state.complete();
    debugPrint("✅ App initialization complete");

  } catch (e, stackTrace) {
    debugPrint("❌ Initialization error: $e\n$stackTrace");
    state.complete();
  }
}

/// Helper to safely open a Hive box.
Future<Box<T>> _openBoxSafely<T>(String boxName) async {
  try {
    return await Hive.openBox<T>(boxName);
  } catch (e) {
    debugPrint("❌ Error opening box '$boxName': $e");
    debugPrint("🗑️ Deleting corrupted box '$boxName' and recreating...");
    try {
      await Hive.deleteBoxFromDisk(boxName);
      return await Hive.openBox<T>(boxName);
    } catch (e2) {
      debugPrint("❌ CRITICAL: Failed to recreate box '$boxName': $e2");
      rethrow;
    }
  }
}

// ✅ CHANGE 4: Enhanced background tasks initialization
Future<void> _initializeBackgroundTasks() async {
  try {
    // Initialize default widget data if not exists
    final String? title = await HomeWidget.getWidgetData<String>('title');
    if (title == null) {
      await Future.wait([
        HomeWidget.saveWidgetData<String>('title', 'CopyClip'),
        HomeWidget.saveWidgetData<String>('description', 'Your productivity companion'),
        HomeWidget.saveWidgetData<String>('deeplink', 'copyclip://dashboard'),
      ]);
      debugPrint('✅ Default widget data initialized');
    }

    // ✅ NEW: Update all widgets with latest data on app start
    await _updateAllWidgets();
    debugPrint('✅ All widgets updated with latest data');

  } catch (e) {
    debugPrint("❌ Widget data init error: $e");
  }
}

// ✅ CHANGE 5: NEW FUNCTION - Update all widgets with current data
Future<void> _updateAllWidgets() async {
  try {
    // Update each widget type with latest data
    await Future.wait([
      _updateWidgetIfExists('notes'),
      _updateWidgetIfExists('todos'),
      _updateWidgetIfExists('expenses'),
      _updateWidgetIfExists('journal'),
      _updateWidgetIfExists('clipboard'),
    ]);
  } catch (e) {
    debugPrint('❌ Error updating widgets: $e');
  }
}

// Helper to update a widget if it exists
Future<void> _updateWidgetIfExists(String widgetType) async {
  try {
    final activeWidget = await HomeWidget.getWidgetData<String>('widget_type');

    // Only update if this widget type is active
    if (activeWidget == widgetType) {
      switch (widgetType) {
        case 'notes':
          await HomeWidgetService.updateNotesWidget();
          break;
        case 'todos':
          await HomeWidgetService.updateTodosWidget();
          break;
        case 'expenses':
          await HomeWidgetService.updateExpensesWidget();
          break;
        case 'journal':
          await HomeWidgetService.updateJournalWidget();
          break;
        case 'clipboard':
          await HomeWidgetService.updateClipboardWidget();
          break;
      }
    }
  } catch (e) {
    debugPrint('Error updating $widgetType widget: $e');
  }
}

// --- LOADING APP & SCREEN ---
class LoadingApp extends StatelessWidget {
  const LoadingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppInitializationState>(
      builder: (context, initState, _) {
        if (!initState.isInitialized) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: LoadingScreen(
              currentStep: initState.currentStep,
              progress: initState.progress,
            ),
          );
        }
        return const MainApp();
      },
    );
  }
}

class LoadingScreen extends StatelessWidget {
  final String currentStep;
  final double progress;
  const LoadingScreen({super.key, required this.currentStep, required this.progress});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/logo/copyclip_logo.png',
                width: 120,
                height: 120,
              ),
              const SizedBox(height: 24),
              const Text(
                'CopyClip',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              // const SizedBox(height: 12),
              // Text(
              //   currentStep,
              //   style: const TextStyle(
              //     fontSize: 14,
              //     color: Colors.grey,
              //   ),
              //   textAlign: TextAlign.center,
              // ),
              // const SizedBox(height: 24),
              // // ✅ CHANGE 6: Added progress indicator
              // SizedBox(
              //   width: 200,
              //   child: LinearProgressIndicator(
              //     value: progress,
              //     backgroundColor: Colors.grey[200],
              //     valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

// --- MAIN APP ---
class MainApp extends StatefulWidget {
  const MainApp({super.key});
  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> with WidgetsBindingObserver {
  static const widgetChannel = MethodChannel('com.technopradyumn.copyclip/widget_handler');

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    widgetChannel.setMethodCallHandler(_handleNativeCalls);

    // ✅ CHANGE 7: Listen to widget interactions
    _setupWidgetInteractionListener();
  }

  // ✅ CHANGE 8: NEW - Setup widget interaction listener
  void _setupWidgetInteractionListener() {
    HomeWidget.widgetClicked.listen((Uri? uri) {
      if (uri != null && mounted) {
        debugPrint('📱 Widget clicked: $uri');
        _handleWidgetNavigation(uri);
      }
    });
  }

  // ✅ CHANGE 9: NEW - Handle widget navigation
  void _handleWidgetNavigation(Uri uri) {
    final featureId = uri.host;
    final routesMap = {
      'notes': AppRouter.notes,
      'todos': AppRouter.todos,
      'expenses': AppRouter.expenses,
      'journal': AppRouter.journal,
      'calendar': AppRouter.calendar,
      'clipboard': AppRouter.clipboard,
      'canvas': AppRouter.canvas,
    };

    final route = routesMap[featureId];
    if (route != null && mounted) {
      router.push(route);
    }
  }

  Future<void> _handleNativeCalls(MethodCall call) async {
    if (call.method == 'navigateTo') {
      final dynamic args = call.arguments;
      String? route;
      if (args is String) route = args;
      else if (args is Map) route = args['route'];
      if (route != null && mounted) {
        router.push(route);
        debugPrint('✅ Navigated to: $route');
      }
    }
  }

  // ✅ CHANGE 10: Update widgets when app resumes
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.resumed) {
      debugPrint('📱 App resumed - updating widgets');
      _updateAllWidgets();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
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
          builder: (context, child) {
            return UpgradeAlert(
              upgrader: Upgrader(
                debugLogging: false,
                messages: RateUpgraderMessages(),
                durationUntilAlertAgain: const Duration(days: 7),
              ),
              child: child ?? const SizedBox(),
            );
          },
        );
      },
    );
  }
}