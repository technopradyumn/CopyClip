import 'dart:io';

import 'package:copyclip/src/features/todos/data/todo_adapter.dart';
import 'package:copyclip/src/features/todos/data/todo_model.dart';
import 'package:copyclip/src/features/todos/presentation/pages/todos_screen.dart';
import 'package:copyclip/src/features/todos/services/todo_scheduler_service.dart';
import 'package:copyclip/src/core/services/notification_service.dart';
import 'package:copyclip/src/core/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mockito/mockito.dart';
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
      await todoBox.clear();
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
    await todoBox.put(todo.id, todo);

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

    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    await tester.pumpAndSettle();

    expect(find.text('Buy Milk'), findsOneWidget);
    expect(find.text('Personal'), findsOneWidget);
  });

  testWidgets('TodosScreen quick add works', (WidgetTester tester) async {
    final router = GoRouter(
      initialLocation: '/',
      routes: [GoRoute(path: '/', builder: (context, state) => TodosScreen())],
    );

    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    await tester.pumpAndSettle();

    // Verify empty state
    expect(find.text('No tasks found.'), findsOneWidget);

    // We can't trigger quick add easily if list is empty?
    // Quick Add requires a category header to be visible?
    // Code: "if (isExpanded) ... if (_searchQuery.isEmpty) ... flatList.add(QuickAddItem(category))"
    // But categories come from `grouped`.
    // If no todos, "grouped['General'] = []" (Line 278).
    // So 'General' header should be there?

    // Let's check if 'General' is found.
    expect(find.text('General'), findsOneWidget);

    // Tap the Quick Add button (Plus icon near header?)
    // Need to find the widget.
    // QuickAddItem renders what?

    // I need to look at _buildListItem for QuickAddItem.
    // Assuming it has a specific key or icon.
    // In `todos_screen.dart`:
    // key = ValueKey('quick_add_${item.category}');

    await tester.tap(find.byKey(ValueKey('quick_add_General')));
    await tester.pumpAndSettle();

    // Check if TextField appears
    // key = ValueKey('quick_input_General');
    expect(find.byKey(ValueKey('quick_input_General')), findsOneWidget);

    // Enter text
    await tester.enterText(
      find.byKey(ValueKey('quick_input_General')),
      'New Task',
    );
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();

    // Verify it is added
    expect(find.text('New Task'), findsOneWidget);

    // Verify DB
    expect(todoBox.values.any((t) => t.task == 'New Task'), true);
  });
}
