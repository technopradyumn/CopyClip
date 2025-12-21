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
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  await Hive.initFlutter();

  await NotificationService().init();

  Hive.registerAdapter(NoteAdapter());
  Hive.registerAdapter(TodoAdapter());
  Hive.registerAdapter(ExpenseAdapter());
  Hive.registerAdapter(JournalEntryAdapter());
  Hive.registerAdapter(ClipboardItemAdapter());

  await Hive.openBox<Note>('notes_box');
  await Hive.openBox<Todo>('todos_box');
  await Hive.openBox<Expense>('expenses_box');
  await Hive.openBox<JournalEntry>('journal_box');
  await Hive.openBox<ClipboardItem>('clipboard_box');
  await Hive.openBox('settings');
  await Hive.openBox('theme_box');

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: Colors.transparent,
  ));

  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeManager(),
      child: const CopyClipApp(),
    ),
  );
}

class CopyClipApp extends StatefulWidget {
  const CopyClipApp({super.key});

  @override
  State<CopyClipApp> createState() => _CopyClipAppState();
}

class _CopyClipAppState extends State<CopyClipApp> with WidgetsBindingObserver {
  static const platform = MethodChannel('com.technopradyumn.copyclip/accessibility');

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _syncAllClips();
    _configureSelectNotificationSubject();
    _handleInitialNotification();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      NotificationService().init();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _syncAllClips();
    }
  }

  Future<void> _syncAllClips() async {
    try {
      final List<dynamic>? pendingClips = await platform.invokeMethod('getPendingClips');

      if (pendingClips != null && pendingClips.isNotEmpty) {
        for (var text in pendingClips) {
          await _saveToHive(text.toString());
        }
      }
    } catch (e) {
      debugPrint("Multi-sync Error: $e");
    }
  }

  Future<void> _saveToHive(String text) async {
    final box = Hive.box<ClipboardItem>('clipboard_box');
    final cleanText = text.trim();

    if (cleanText.isEmpty) return;

    bool alreadyExists = box.values.any((item) => item.content.trim() == cleanText);

    if (!alreadyExists) {
      final String uniqueId = DateTime.now().microsecondsSinceEpoch.toString();

      final newItem = ClipboardItem(
        id: uniqueId,
        content: cleanText,
        createdAt: DateTime.now(),
        type: _detectType(cleanText),
        sortIndex: box.length,
      );

      await box.put(newItem.id, newItem);
    }
  }

  String _detectType(String text) {
    if (text.startsWith('http')) return 'link';
    if (RegExp(r'^\+?[0-9]{7,15}$').hasMatch(text)) return 'phone';
    if (text.startsWith('#') || text.startsWith('Color')) return 'color';
    return 'text';
  }

  Future<void> _handleInitialNotification() async {
    final notificationPlugin = NotificationService().flutterLocalNotificationsPlugin;
    final NotificationAppLaunchDetails? launchDetails =
    await notificationPlugin.getNotificationAppLaunchDetails();

    if (launchDetails != null &&
        launchDetails.didNotificationLaunchApp &&
        launchDetails.notificationResponse?.payload != null) {
      final String payload = launchDetails.notificationResponse!.payload!;
      Future.delayed(const Duration(milliseconds: 500), () {
        _navigateToTodo(payload);
      });
    }
  }

  void _navigateToTodo(String payload) {
    final box = Hive.box<Todo>('todos_box');
    final Todo? todoToEdit = box.get(payload);
    if (todoToEdit != null) {
      router.push(AppRouter.todoEdit, extra: todoToEdit);
    }
  }

  void _configureSelectNotificationSubject() {
    NotificationService().onNotifications.stream.listen((String? payload) {
      if (payload != null) {
        _navigateToTodo(payload);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // 1. Get the provider
    final themeManager = Provider.of<ThemeManager>(context);

    return MaterialApp.router(
      title: 'CopyClip',
      debugShowCheckedModeBanner: false,

      // 2. Use the local variable `themeManager`, NOT `widget.themeManager`
      themeMode: themeManager.themeMode,
      theme: AppTheme.lightTheme(themeManager.primaryColor),
      darkTheme: AppTheme.darkTheme(themeManager.primaryColor),

      routerConfig: router,
    );
  }
}

class AccessibilityServiceManager {
  static const platform = MethodChannel('com.technopradyumn.copyclip/accessibility');

  static Future<void> requestPermission() async {
    try {
      await platform.invokeMethod('openAccessibilitySettings');
    } on PlatformException catch (e) {
      print("Error opening accessibility settings: ${e.message}");
    }
  }

  static Future<bool> isServiceEnabled() async {
    try {
      final bool isEnabled = await platform.invokeMethod('isServiceEnabled');
      return isEnabled;
    } on PlatformException catch (e) {
      print("Error checking service status: ${e.message}");
      return false;
    }
  }
}