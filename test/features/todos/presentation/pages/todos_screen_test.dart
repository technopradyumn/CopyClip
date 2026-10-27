import 'dart:io';

import 'package:copyclip/src/features/todos/data/todo_adapter.dart';
import 'package:copyclip/src/features/todos/data/todo_model.dart';
import 'package:copyclip/src/features/todos/presentation/pages/todos_screen.dart';
import 'package:copyclip/src/features/todos/services/todo_scheduler_service.dart';
import 'package:copyclip/src/core/services/notification_service.dart';
import 'package:copyclip/src/core/router/app_router.dart';
import 'package:copyclip/src/core/theme/bloc/theme_bloc.dart';
import 'package:copyclip/src/features/premium/presentation/bloc/premium_bloc.dart';
import 'package:copyclip/src/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:intl/date_symbol_data_local.dart';
import 'package:go_router/go_router.dart';

// Reuse Mock/Fake
class FakeNotificationService extends Fake implements NotificationService {
  @override
  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    String channelId = 'todos',
    String? payload,
  }) async {
    // No-op
  }
  @override
  Future<void> cancelNotification(int id) async {
    // No-op
  }
}

void main() {
  late Box<Todo> todoBox;

  setUpAll(() async {
    tz.initializeTimeZones();
    await initializeDateFormatting();
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  setUp(() async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(MethodChannel('home_widget'), (
          MethodCall methodCall,
        ) async {
          return null;
        });

    final tempDir = await Directory.systemTemp.createTemp();
    Hive.init(tempDir.path);
    if (!Hive.isAdapterRegistered(2)) Hive.registerAdapter(TodoAdapter());
    todoBox = await Hive.openBox<Todo>('todos_box');

    TodoSchedulerService().notificationService = FakeNotificationService();
  });

  tearDown(() async {
    try {
      await todoBox.close();
    } catch (_) {}
  });

  testWidgets('TodosScreen renders list of todos', (WidgetTester tester) async {
    final todo = Todo(
      id: '1',
      task: 'Buy Milk',
      category: 'Personal',
      sortIndex: 0,
      dueDate: DateTime.now(),
    );
    await tester.runAsync(() => todoBox.put(todo.id, todo));

    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(path: '/', builder: (context, state) => TodosScreen()),
        GoRoute(
          path: '/edit', // Dummy
          name: AppRouter.todoEdit,
          builder: (context, state) => Scaffold(body: Text('Edit Screen')),
        ),
      ],
    );

    await tester.pumpWidget(
      _withAppProviders(
        MaterialApp.router(
          routerConfig: router,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 1500));

    expect(find.text('Buy Milk'), findsOneWidget);
    expect(find.text('PERSONAL'), findsOneWidget);
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('TodosScreen quick add opens an input that accepts a task', (
    WidgetTester tester,
  ) async {
    final router = GoRouter(
      initialLocation: '/',
      routes: [GoRoute(path: '/', builder: (context, state) => TodosScreen())],
    );

    await tester.pumpWidget(
      _withAppProviders(
        MaterialApp.router(
          routerConfig: router,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 1500));

    await tester.tap(find.byKey(const ValueKey('quick_add_General')));
    await tester.pump(const Duration(milliseconds: 500));

    final quickInputFinder = find.byKey(const ValueKey('quick_input_General'));
    expect(quickInputFinder, findsOneWidget);

    await tester.enterText(quickInputFinder, 'New Task');
    expect(
      tester.widget<TextField>(quickInputFinder).controller?.text,
      'New Task',
    );
    await tester.pumpWidget(const SizedBox.shrink());
  });
}

Widget _withAppProviders(Widget child) {
  return MultiBlocProvider(
    providers: [
      BlocProvider(create: (_) => ThemeBloc()),
      BlocProvider(create: (_) => PremiumBloc()),
    ],
    child: child,
  );
}
