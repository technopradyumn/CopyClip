import 'dart:async';
import 'dart:convert';

import 'package:copyclip/src/core/services/home_widget_service.dart';
import 'package:copyclip/src/core/services/lazy_box_loader.dart';
import 'package:copyclip/src/core/utils/widget_sync_service.dart';
import 'package:copyclip/src/core/services/bg_worker.dart'; // ✅ NEW IMPORT
import 'package:copyclip/src/features/todos/services/todo_scheduler_service.dart'; // ✅ NEW IMPORT
import 'package:copyclip/src/core/services/notification_engine.dart'; // ✅ NEW IMPORT
import 'package:copyclip/src/features/canvas/data/canvas_adapter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:copyclip/src/features/premium/presentation/provider/premium_provider.dart';
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

import 'package:copyclip/src/features/journal/data/journal_adapter.dart';

import 'package:copyclip/src/features/notes/data/note_adapter.dart';

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

// ✅ TEST HELPER
bool isIntegrationTesting = false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final initState = AppInitializationState();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeManager()),
        ChangeNotifierProvider(create: (_) => PremiumProvider()),
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
    state.updateProgress('Loading...', 0.2);
    await dotenv.load(fileName: ".env").catchError((_) => null);

    // ✅ OPTIMIZATION: Initialize Home Widget Service
    await HomeWidgetService.initialize();

    // ✅ Initialize AdMob early with Test Device configuration
    await MobileAds.instance.updateRequestConfiguration(
      RequestConfiguration(testDeviceIds: ["144FE4F3F00EAB19BA87344D34904C8B"]),
    );
    await MobileAds.instance.initialize().catchError((e) {
      debugPrint('❌ Ad initialization error: $e');
    });

    // Step 2: Hive setup
    state.updateProgress('Setting up database...', 0.4);
    await Hive.initFlutter();

    Hive.registerAdapter(NoteAdapter());
    Hive.registerAdapter(TodoAdapter());
    Hive.registerAdapter(ExpenseAdapter());
    Hive.registerAdapter(JournalEntryAdapter());
    Hive.registerAdapter(ClipboardItemAdapter());
    await CanvasDatabase().init();

    // Step 3: System setup
    state.updateProgress('Configuring system...', 0.55);

    // ✅ CHANGE 2: Register background callback for widgets
    HomeWidget.registerBackgroundCallback(homeWidgetBackgroundCallback);
    HomeWidget.setAppGroupId('group.com.technopradyumn.copyclip');
    debugPrint('✅ Widget background callback registered');

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    // Step 4: Open only critical boxes for faster startup
    state.updateProgress('Loading...', 0.6);
    await Future.wait([
      _openBoxSafely('settings'),
      _openBoxSafely('theme_box'),
    ]);

    // ✅ OPTIMIZATION: Defer notification service init
    NotificationService().init().catchError(
      (e) => debugPrint('Notification init error: $e'),
    );

    // ✅ OPTIMIZATION: Lazy load feature boxes - they'll open when needed
    // This significantly improves startup time

    // ✅ OPTIMIZATION: Defer background tasks to post-init
    state.updateProgress('Ready', 0.9);
    _initializeBackgroundTasks().catchError(
      (e) => debugPrint('Background task error: $e'),
    );

    // ✅ NEW: Initialize Background Worker for Todos
    // We do this here (after Hive) so it can register tasks safely
    await BackgroundWorker.initialize();
    await BackgroundWorker.registerPeriodicTask();

    // ✅ NEW: Healing check on startup
    // Run once immediately to fix any missed schedules while app was dead
    TodoSchedulerService().handleMissedRecurrences().catchError(
      (e) => debugPrint("Healing error: $e"),
    );

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
        HomeWidget.saveWidgetData<String>(
          'description',
          'Your productivity companion',
        ),
        HomeWidget.saveWidgetData<String>('deeplink', 'copyclip://dashboard'),
      ]);
      debugPrint('✅ Default widget data initialized');
    }

    // ✅ NEW: Update all widgets with latest data on app start
    await _updateAllWidgets();
    debugPrint('✅ All widgets updated with latest data');

    // ✅ NEW: Reschedule daily briefing to ensure it's set
    await BackgroundWorker.rescheduleDailyBriefing();

    // ✅ NEW: Welcome Notification for first-time users
    // This is fired slightly after startup
    Future.delayed(const Duration(seconds: 2), () {
      NotificationEngine().checkAndTriggerWelcome();
    });

    // ✅ NEW: Schedule Daily Planning Notification (9 PM)
    await NotificationService().scheduleDailyNotification(
      id: 9999, // Fixed ID for daily planning
      title: 'Plan Your Tomorrow 🌙',
      body:
          'Take a moment to organize your tasks for the next day.\nA little planning tonight makes a productive tomorrow!',
      time: const TimeOfDay(hour: 21, minute: 0),
    );
  } catch (e) {
    debugPrint("❌ Widget data init error: $e");
  }
}

// ✅ CHANGE 5: NEW FUNCTION - Update all widgets with current data
Future<void> _updateAllWidgets() async {
  try {
    // Update each widget type with latest data
    // Update each widget type with latest data using Centralized Service
    await WidgetSyncService.syncAll();
  } catch (e) {
    debugPrint('❌ Error updating widgets: $e');
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
  const LoadingScreen({
    super.key,
    required this.currentStep,
    required this.progress,
  });

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
  static const widgetChannel = MethodChannel(
    'com.technopradyumn.copyclip/widget_handler',
  );

  Timer? _clipboardTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    widgetChannel.setMethodCallHandler(_handleNativeCalls);

    // ✅ Listen to widget interactions
    _setupWidgetInteractionListener();

    // ✅ Listen to notification taps
    _setupNotificationListener();

    // ✅ Initialize heavy services after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _postFrameInitialization();
      _startClipboardTimer(); // ✅ Restore Real-Time Monitoring
    });
  }

  /// ✅ OPTIMIZATION: Initialize ads and preload boxes after first frame
  Future<void> _postFrameInitialization() async {
    debugPrint('🚀 Post-frame initialization...');

    // Preload common boxes in background
    LazyBoxLoader.preloadCommonBoxes().catchError((e) {
      debugPrint('⚠️ Box preload error: $e');
    });

    debugPrint('✅ Post-frame initialization complete');
  }

  // ✅ CHANGE 8: NEW - Setup widget interaction listener
  void _setupWidgetInteractionListener() {
    // 1. Check if app was launched via widget (Cold Start)
    HomeWidget.initiallyLaunchedFromHomeWidget().then((Uri? uri) {
      if (uri != null && mounted) {
        debugPrint('🚀 Launched from widget (Cold Start): $uri');
        _handleWidgetNavigation(uri);
      }
    });

    // 2. Listen for widget clicks while running (Background/Foreground)
    HomeWidget.widgetClicked.listen((Uri? uri) {
      if (uri != null && mounted) {
        debugPrint('📱 Widget clicked: $uri');
        _handleWidgetNavigation(uri);
      }
    });
  }

  // ✅ CHANGE 9: Configure Notification Listener
  void _setupNotificationListener() {
    NotificationService().onNotifications.stream.listen((
      String? payload,
    ) async {
      if (payload == null || !mounted) return;
      debugPrint('🔔 Notification Tapped with Payload: $payload');

      // 1. Static Routes
      if (payload == 'dashboard') {
        router.go(AppRouter.root);
        return;
      } else if (payload == 'todos') {
        router.push(AppRouter.todos);
        return;
      } else if (payload == 'journal') {
        router.push(AppRouter.journal);
        return;
      } else if (payload == 'expenses') {
        router.push(AppRouter.expenses);
        return;
      } else if (payload == 'clipboard') {
        router.push(AppRouter.clipboard);
        return;
      }

      // 2. Action Actions
      if (payload.startsWith("ACTION:mark_done:")) {
        final todoId = payload.replaceAll("ACTION:mark_done:", "");
        if (!Hive.isBoxOpen('todos_box')) {
          await LazyBoxLoader.getBox<Todo>('todos_box');
        }
        final box = Hive.box<Todo>('todos_box');
        try {
          Todo? todo = box.get(todoId);
          if (todo == null) todo = box.values.firstWhere((t) => t.id == todoId);
          if (todo != null) {
            await TodoSchedulerService().completeTodo(todo);
            debugPrint("✅ Todo marked done from notification: ${todo.task}");
          }
        } catch (e) {
          debugPrint("❌ Failed to process action: $e");
        }
        return;
      }

      // 3. Dynamic Routes (IDs)
      if (!Hive.isBoxOpen('todos_box')) {
        await Future.delayed(const Duration(milliseconds: 500));
        if (!Hive.isBoxOpen('todos_box')) {
          await LazyBoxLoader.getBox<Todo>('todos_box');
        }
      }

      final box = Hive.box<Todo>('todos_box');
      Todo? todo;
      try {
        todo = box.get(payload);
        if (todo == null) {
          todo = box.values.firstWhere((t) => t.id == payload);
        }
      } catch (e) {
        // Payload might not be a Todo ID
      }

      if (todo != null && mounted) {
        debugPrint('🚀 Navigating to Todo Edit: ${todo.task}');
        router.push(AppRouter.todoEdit, extra: todo);
      } else {
        debugPrint('⚠️ Unknown payload or Todo not found: $payload');
      }
    });
  }

  void _startClipboardTimer() {
    _clipboardTimer?.cancel();
    _clipboardTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (mounted && !isIntegrationTesting) _checkClipboard();
    });
    debugPrint('📋 Clipboard Check Timer Started');
  }

  void _stopClipboardTimer() {
    _clipboardTimer?.cancel();
    _clipboardTimer = null;
    debugPrint('🛑 Clipboard Check Timer Stopped');
  }

  // Handle widget navigation
  void _handleWidgetNavigation(Uri uri) {
    final host = uri.host;

    // ✅ Handle 'app' host (Standard Deep Links)
    // Example: copyclip://app/todos/edit?id=123
    if (host == 'app') {
      final path = uri.path;
      final query = uri.query;
      final fullPath = query.isNotEmpty ? '$path?$query' : path;

      if (fullPath.isNotEmpty && mounted) {
        debugPrint('🚀 Widget Deep Link Navigation: $fullPath');
        router.push(fullPath);
      }
      return;
    }

    // Legacy/Simple Host Mapping
    final routesMap = {
      'notes': AppRouter.notes,
      'todos': AppRouter.todos,
      'expenses': AppRouter.expenses,
      'journal': AppRouter.journal,
      'calendar': AppRouter.calendar,
      'clipboard': AppRouter.clipboard,
      'canvas': AppRouter.canvas,
    };

    final route = routesMap[host];
    if (route != null && mounted) {
      router.push(route);
    }
  }

  // Native calls handler
  Future<void> _handleNativeCalls(MethodCall call) async {
    if (call.method == 'navigateTo') {
      final dynamic args = call.arguments;
      String? route;
      if (args is String)
        route = args;
      else if (args is Map)
        route = args['route'];
      if (route != null && mounted) {
        router.push(route);
        debugPrint('✅ Navigated to: $route');
      }
    } else if (call.method == 'toggleTodo') {
      final dynamic args = call.arguments;
      if (args is Map && args['id'] != null) {
        final String id = args['id'];

        // Ensure box is open
        if (!Hive.isBoxOpen('todos_box')) {
          await LazyBoxLoader.getBox<Todo>('todos_box');
        }
        final box = Hive.box<Todo>('todos_box');

        try {
          final Todo? todo = box.get(id);
          // If null, try linear search safety
          final target =
              todo ??
              (box.values.any((t) => t.id == id)
                  ? box.values.firstWhere((t) => t.id == id)
                  : null);

          if (target != null) {
            // Toggle logic
            if (!target.isDone) {
              await TodoSchedulerService().completeTodo(target);
            } else {
              target.isDone = false;
              // target.completedAt = null; // Field removed
              await target.save();
            }

            await WidgetSyncService.syncTodos();

            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    target.isDone ? "Task completed!" : "Task uncompleted",
                  ),
                  duration: const Duration(seconds: 1),
                ),
              );
            }
          }
        } catch (e) {
          debugPrint("Error toggling todo: $e");
        }
      }
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.resumed) {
      debugPrint('📱 App resumed');
      _updateAllWidgets();
      _checkClipboard(); // Instant check
      _startClipboardTimer(); // Resume monitoring
    } else if (state == AppLifecycleState.paused) {
      debugPrint('📱 App paused');
      _stopClipboardTimer(); // Save battery
    }
  }

  Future<void> _checkClipboard() async {
    try {
      if (!mounted) return;
      // ... same logic ...
      final settingsBox = Hive.box('settings');
      final bool autoSave = settingsBox.get(
        'clipboardAutoSave',
        defaultValue: false,
      );

      if (!autoSave) return;

      final ClipboardData? data = await Clipboard.getData(Clipboard.kTextPlain);
      if (data == null || data.text == null || data.text!.trim().isEmpty)
        return;

      final String newContent = data.text!.trim();
      // Ensure box is open
      if (!Hive.isBoxOpen('clipboard_box')) {
        await Hive.openBox<ClipboardItem>('clipboard_box');
      }
      final clipboardBox = Hive.box<ClipboardItem>('clipboard_box');

      // ✅ DEDUPLICATION Logic (Smart Bump):
      // 1. Check if content exists (ignoring formatting).
      // 2. If it exists, UPDATE its timestamp to now(). This "bumps" it to the top.
      // 3. This preserves custom colors/properties but marks it as "fresh".
      final existingItems = clipboardBox.values
          .where((item) => _getPlainText(item.content) == newContent)
          .toList();

      if (existingItems.isNotEmpty) {
        for (var item in existingItems) {
          item.createdAt = DateTime.now(); // Bump to top
          await item.save();
        }
        debugPrint('⬆️ Bumped ${existingItems.length} existing item(s) to top');

        if (mounted) {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Clipboard updated!"),
              behavior: SnackBarBehavior.floating,
              duration: Duration(seconds: 1),
            ),
          );
        }
        await WidgetSyncService.syncClipboard();
        return; // ✅ Stop here, don't add a duplicate
      }

      // Add to Hive
      final newItem = ClipboardItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        content: newContent,
        createdAt: DateTime.now(),
        type: 'text',
      );

      await clipboardBox.add(newItem);

      if (mounted) {
        ScaffoldMessenger.of(context).clearSnackBars(); // Prevent stacking
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Clipboard saved: ${newContent.length > 20 ? '${newContent.substring(0, 20)}...' : newContent}",
            ),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
            margin: const EdgeInsets.all(16),
          ),
        );
      }

      debugPrint('✅ Auto-saved clipboard item: ${newItem.id}');

      // Sync Widgets
      await WidgetSyncService.syncClipboard();
    } catch (e) {
      // debugPrint('❌ Clipboard check failed: $e'); // Reduce noise
    }
  }

  // ✅ Helper to extract plain text from content (handling rich text JSON)
  String _getPlainText(String content) {
    if (!content.startsWith('[')) return content.trim();
    try {
      final List<dynamic> delta = jsonDecode(content);
      String plainText = "";
      for (var op in delta) {
        if (op is Map && op['insert'] is String) plainText += op['insert'];
      }
      return plainText.trim();
    } catch (_) {
      return content.trim(); // Fallback if not valid JSON
    }
  }

  @override
  void dispose() {
    _stopClipboardTimer();
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
                durationUntilAlertAgain: const Duration(
                  days: 0,
                ), // Alert every time
              ),
              child: child ?? const SizedBox(),
            );
          },
        );
      },
    );
  }
}
