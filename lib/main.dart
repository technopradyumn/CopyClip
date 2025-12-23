import 'package:copyclip/src/core/router/app_router.dart';
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
import 'package:flutter_quill/flutter_quill.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:home_widget/home_widget.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'src/core/router/main_router.dart';
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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  HomeWidget.registerBackgroundCallback(homeWidgetBackgroundCallback);
  HomeWidget.setAppGroupId('group.com.technopradyumn.copyclip');

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  await Hive.initFlutter();

  Hive.registerAdapter(NoteAdapter());
  Hive.registerAdapter(TodoAdapter());
  Hive.registerAdapter(ExpenseAdapter());
  Hive.registerAdapter(JournalEntryAdapter());
  Hive.registerAdapter(ClipboardItemAdapter());

  await NotificationService().init();

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

  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeManager(),
      child: const CopyClipApp(),
    ),
  );
}

Future<void> _initializeWidgetData() async {
  final title = await HomeWidget.getWidgetData<String>('title');
  if (title != null) return;

  await HomeWidget.saveWidgetData('title', 'Clipboard');
  await HomeWidget.saveWidgetData('description', 'Access clipboard history');
  await HomeWidget.saveWidgetData('deeplink', 'copyclip://clipboard');
}

class CopyClipApp extends StatefulWidget {
  const CopyClipApp({super.key});

  @override
  State<CopyClipApp> createState() => _CopyClipAppState();
}

class _CopyClipAppState extends State<CopyClipApp>
    with WidgetsBindingObserver {
  static const MethodChannel platform =
  MethodChannel('com.technopradyumn.copyclip/accessibility');
  static const MethodChannel widgetChannel =
  MethodChannel('com.technopradyumn.copyclip/widget_handler');

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    platform.setMethodCallHandler(_handleNativeCalls);
    widgetChannel.setMethodCallHandler(_handleNativeCalls);

    _syncClipboard();
    _handleInitialNotification();
    _configureNotificationListener();
    widgetChannel.setMethodCallHandler(_handleNativeCalls);
  }

  Future<void> _handleNativeCalls(MethodCall call) async {
    if (call.method == 'navigateTo') {
      final route = call.arguments is Map
          ? call.arguments['route']
          : call.arguments;
      if (route is String) {
        router.push(route);
      }
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<void> _syncClipboard() async {
    try {
      final List<dynamic>? clips =
      await platform.invokeMethod('getPendingClips');

      if (clips == null) return;

      final box = Hive.box<ClipboardItem>('clipboard_box');

      for (final text in clips) {
        final clean = text.toString().trim();
        if (clean.isEmpty) continue;

        final exists =
        box.values.any((e) => e.content.trim() == clean);

        if (!exists) {
          box.put(
            DateTime.now().microsecondsSinceEpoch.toString(),
            ClipboardItem(
              id: DateTime.now().microsecondsSinceEpoch.toString(),
              content: clean,
              createdAt: DateTime.now(),
              type: _detectType(clean),
              sortIndex: box.length,
            ),
          );
        }
      }
    } catch (_) {}
  }

  String _detectType(String text) {
    if (text.startsWith('http')) return 'link';
    if (RegExp(r'^\+?[0-9]{7,15}$').hasMatch(text)) return 'phone';
    if (text.startsWith('#')) return 'color';
    return 'text';
  }

  Future<void> _handleInitialNotification() async {
    final details = await NotificationService()
        .flutterLocalNotificationsPlugin
        .getNotificationAppLaunchDetails();

    if (details?.didNotificationLaunchApp == true &&
        details?.notificationResponse?.payload != null) {
      _openTodo(details!.notificationResponse!.payload!);
    }
  }

  void _configureNotificationListener() {
    NotificationService().onNotifications.listen((payload) {
      if (payload != null) _openTodo(payload);
    });
  }

  void _openTodo(String id) {
    final box = Hive.box<Todo>('todos_box');
    final todo = box.get(id);
    if (todo != null) {
      router.push(AppRouter.todoEdit, extra: todo);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeManager>();

    return MaterialApp.router(
      title: 'CopyClip',
      debugShowCheckedModeBanner: false,
      themeMode: theme.themeMode,
      theme: AppTheme.lightTheme(theme.primaryColor),
      darkTheme: AppTheme.darkTheme(theme.primaryColor),
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
  }
}
