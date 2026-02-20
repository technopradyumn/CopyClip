import 'dart:async';
import 'dart:convert';

import 'package:copyclip/src/core/services/home_widget_service.dart';
import 'package:copyclip/src/core/services/lazy_box_loader.dart';
import 'package:copyclip/src/core/utils/widget_sync_service.dart';
import 'package:copyclip/src/core/providers/locale_provider.dart';
import 'package:copyclip/src/core/services/bg_worker.dart';
import 'package:copyclip/src/features/todos/services/todo_scheduler_service.dart';
import 'package:copyclip/src/core/services/notification_engine.dart';
import 'package:copyclip/src/features/canvas/data/canvas_adapter.dart';
import 'package:flutter/material.dart';
// import 'package:copyclip/src/features/premium/presentation/provider/premium_provider.dart'; // 🗑️ REMOVED
import 'package:flutter/services.dart';
import 'package:copyclip/src/core/theme/bloc/theme_bloc.dart';
import 'package:copyclip/src/features/premium/presentation/bloc/premium_bloc.dart';
import 'package:copyclip/src/features/premium/presentation/bloc/premium_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
import 'package:copyclip/src/core/services/app_update_service.dart';

import 'package:copyclip/src/core/services/notification_service.dart';
import 'package:copyclip/src/core/theme/app_theme.dart';
import 'package:copyclip/src/core/services/gamification_service.dart';
import 'package:copyclip/src/core/models/gamification_model.dart';

import 'package:copyclip/src/features/clipboard/data/clipboard_adapter.dart';
import 'package:copyclip/src/features/clipboard/data/clipboard_model.dart';
import 'package:copyclip/src/features/expenses/data/expense_adapter.dart';

import 'package:copyclip/src/features/journal/data/journal_adapter.dart';

import 'package:copyclip/src/features/notes/data/note_adapter.dart';

import 'package:copyclip/src/features/todos/data/todo_adapter.dart';
import 'package:copyclip/src/features/todos/data/todo_model.dart';
import 'package:copyclip/src/features/social_post/data/social_post_model.dart'; // Added
import 'package:copyclip/src/core/const/languages.dart';
import 'src/l10n/app_localizations.dart';

import 'package:upgrader/upgrader.dart';
import 'package:uuid/uuid.dart';

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
  String? message(UpgraderMessage messageKey) {
    if (messageKey == UpgraderMessage.buttonTitleIgnore) {
      return 'Rate App';
    }
    return super.message(messageKey);
  }
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
        ChangeNotifierProvider.value(value: initState),
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
        ChangeNotifierProvider(create: (_) => GamificationService()..init()),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => ThemeBloc()..add(LoadTheme())),
          BlocProvider(create: (_) => PremiumBloc()),
        ],
        child: const LoadingApp(),
      ),
    ),
  );

  // ✅ OPTIMIZATION: Fire and forget init while app launches
  _initializeApp(initState);
}

Future<void> _initializeApp(AppInitializationState state) async {
  try {
    // Step 1: Basic services (Critical only)
    await dotenv.load(fileName: ".env").catchError((_) => null);

    // Step 2: Hive setup (Critical)
    await Hive.initFlutter();
    _registerAdapters();

    // Step 3: Critical System setup
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    // Step 4: Open ONLY critical boxes for UI
    // Grouping awaits for parallelism
    await Future.wait([
      _openBoxSafely('settings'),
      _openBoxSafely('theme_box'),
      CanvasDatabase().init(),
    ]);

    state.complete();
    debugPrint("✅ Critical initialization complete");
  } catch (e, stackTrace) {
    debugPrint("❌ Initialization error: $e\n$stackTrace");
    state.complete(); // Ensure app loads even on error
  }
}

void _registerAdapters() {
  Hive.registerAdapter(NoteAdapter());
  Hive.registerAdapter(TodoAdapter());
  Hive.registerAdapter(ExpenseAdapter());
  Hive.registerAdapter(JournalEntryAdapter());
  Hive.registerAdapter(ClipboardItemAdapter());
  Hive.registerAdapter(SocialPostAdapter());
  Hive.registerAdapter(GamificationModelAdapter());
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

    // ✅ NEW: Initialize Smart Notification Engine (Timezone aware)
    await NotificationEngine().initialize();

    // ✅ NEW: Welcome Notification for first-time users
    // This is fired slightly after startup
    Future.delayed(const Duration(seconds: 2), () {
      NotificationEngine().checkAndTriggerWelcome();
    });
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

    // ✅ Load Premium Data (Safe place after Hive Init)
    context.read<PremiumBloc>().add(LoadPremiumData());

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
    debugPrint('🚀 Post-frame initialization STARTED');

    // 1. Initialize Home Widget Service & Callbacks
    try {
      if (!isIntegrationTesting) {
        await HomeWidgetService.initialize();
        HomeWidget.registerBackgroundCallback(homeWidgetBackgroundCallback);
        HomeWidget.setAppGroupId('group.com.technopradyumn.copyclip');
      }
    } catch (e) {
      debugPrint('⚠️ HomeWidget init error: $e');
    }

    // 2. Preload common boxes in background
    try {
      await LazyBoxLoader.preloadCommonBoxes();
    } catch (e) {
      debugPrint('⚠️ Box preload error: $e');
    }

    // 3. Notifications & Background Workers
    try {
      NotificationService().init();
      await BackgroundWorker.initialize();
      await BackgroundWorker.registerPeriodicTask();
    } catch (e) {
      debugPrint('⚠️ Background worker error: $e');
    }

    // 4. Healing check
    try {
      await TodoSchedulerService().handleMissedRecurrences();
    } catch (e) {
      debugPrint("Healing error: $e");
    }

    // 5. Defer background tasks
    try {
      await _initializeBackgroundTasks();
    } catch (e) {
      debugPrint('Background task error: $e');
    }

    // 6. Ads
    try {
      await MobileAds.instance.updateRequestConfiguration(
        RequestConfiguration(
          testDeviceIds: ["144FE4F3F00EAB19BA87344D34904C8B"],
        ),
      );
      await MobileAds.instance.initialize();
    } catch (e) {
      debugPrint('❌ Ad init error: $e');
    }

    // 7. Check for Updates
    try {
      await AppUpdateService.instance.checkForUpdate();
    } catch (e) {
      debugPrint('Update check error: $e');
    }

    debugPrint('✅ Post-frame initialization COMPLETE');
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
          todo ??= box.values.firstWhere((t) => t.id == todoId);
          await TodoSchedulerService().completeTodo(todo);
          debugPrint("✅ Todo marked done from notification: ${todo.task}");
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
        todo ??= box.values.firstWhere((t) => t.id == payload);
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
      if (args is String) {
        route = args;
      } else if (args is Map)
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
                    target.isDone
                        ? AppLocalizations.of(context)!.taskCompletedExclamation
                        : AppLocalizations.of(
                            context,
                          )!.taskUncompletedExclamation,
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

      final settingsBox = Hive.box('settings');
      final bool autoSave = settingsBox.get(
        'clipboardAutoSave',
        defaultValue: false,
      );

      if (!autoSave) return;

      final ClipboardData? data = await Clipboard.getData(Clipboard.kTextPlain);
      if (data == null || data.text == null) return;

      final String rawContent = data.text!;
      final String trimmedContent = rawContent.trim();

      if (trimmedContent.isEmpty) return;

      // Ensure box is open
      if (!Hive.isBoxOpen('clipboard_box')) {
        await Hive.openBox<ClipboardItem>('clipboard_box');
      }
      final clipboardBox = Hive.box<ClipboardItem>('clipboard_box');

      // ✅ DEDUPLICATION & BUMPING Logic (Refined):
      // Find ALL items that match this content (trimmed)
      final matchingItems =
          clipboardBox.values
              .where((item) => _getPlainText(item.content) == trimmedContent)
              .toList()
            ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

      if (matchingItems.isNotEmpty) {
        // Keep the most recent one, delete the rest if any
        final keptItem = matchingItems.first;

        // Delete older duplicates if they exist
        if (matchingItems.length > 1) {
          for (int i = 1; i < matchingItems.length; i++) {
            await matchingItems[i].delete();
          }
          debugPrint(
            '🗑️ Deleted ${matchingItems.length - 1} extra duplicates',
          );
        }

        // Bump the kept item to top
        keptItem.createdAt = DateTime.now();
        await keptItem.save();

        debugPrint('⬆️ Bumped existing item to top');

        if (mounted) {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                AppLocalizations.of(context)!.clipboardUpdatedExclamation,
              ),
              behavior: SnackBarBehavior.floating,
              duration: Duration(seconds: 1),
            ),
          );
        }
        await WidgetSyncService.syncClipboard();
        return;
      }

      // Add as NEW item
      // Use UUID + timestamp for guaranteed uniqueness
      final uuid = const Uuid();
      final newItem = ClipboardItem(
        id: uuid.v4(),
        content: trimmedContent,
        createdAt: DateTime.now(),
        type: 'text',
      );

      await clipboardBox.put(newItem.id, newItem);

      if (mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context)!.clipboardSavedContent(
                trimmedContent.length > 20
                    ? '${trimmedContent.substring(0, 20)}...'
                    : trimmedContent,
              ),
            ),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
            margin: const EdgeInsets.all(16),
          ),
        );
      }

      debugPrint('✅ Auto-saved clipboard item: ${newItem.id}');
      await WidgetSyncService.syncClipboard();
    } catch (e) {
      debugPrint('❌ Clipboard check error: $e');
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
    // OLD: final themeManager = Provider.of<ThemeManager>(context);
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, themeState) {
        final localeProvider = Provider.of<LocaleProvider>(context);
        return ScreenUtilInit(
          designSize: const Size(390, 844),
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (context, child) {
            return MaterialApp.router(
              title: 'CopyClip',
              debugShowCheckedModeBanner: false,

              // ✅ Locale Support
              locale: localeProvider.locale,

              // ✅ Updated Theme Usage from BLoC State
              themeMode: themeState.themeMode,
              theme: AppTheme.lightTheme(themeState.primaryColor),
              darkTheme: AppTheme.darkTheme(themeState.primaryColor),

              routerConfig: router,
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
                FlutterQuillLocalizations.delegate,
              ],
              supportedLocales: LanguageConstants.supportedLocales,
              localeResolutionCallback: (locale, supportedLocales) {
                for (var supportedLocale in supportedLocales) {
                  if (supportedLocale.languageCode == locale?.languageCode) {
                    return supportedLocale;
                  }
                }
                return const Locale('en');
              },

              builder: (context, child) {
                return UpgradeAlert(
                  navigatorKey: router.routerDelegate.navigatorKey,
                  upgrader: Upgrader(
                    debugLogging: true,
                    debugDisplayAlways: true,
                    messages: RateUpgraderMessages(),
                    durationUntilAlertAgain: const Duration(days: 0),
                  ),
                  child: child ?? const SizedBox(),
                );
              },
            );
          },
        );
      },
    );
  }
}
