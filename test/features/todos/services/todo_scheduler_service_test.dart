import 'dart:io';
import 'package:copyclip/src/core/services/notification_service.dart';
import 'package:copyclip/src/features/todos/data/todo_model.dart';
import 'package:copyclip/src/features/todos/data/todo_adapter.dart';
import 'package:copyclip/src/features/todos/services/todo_scheduler_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'todo_scheduler_service_test.mocks.dart';

@GenerateNiceMocks([MockSpec<NotificationService>()])
void main() {
  late TodoSchedulerService schedulerService;
  late MockNotificationService mockNotificationService;
  late Box<Todo> todoBox;

  setUpAll(() async {
    tz.initializeTimeZones();
  });

  setUp(() async {
    mockNotificationService = MockNotificationService();
    schedulerService = TodoSchedulerService();
    schedulerService.notificationService = mockNotificationService;

    // Hive Configuration
    final tempDir = await Directory.systemTemp.createTemp();
    Hive.init(tempDir.path);

    if (!Hive.isAdapterRegistered(2)) {
      // TodoAdapter is TypeId 2
      Hive.registerAdapter(TodoAdapter());
    }

    todoBox = await Hive.openBox<Todo>('todos_box');
  });

  tearDown(() async {
    try {
      if (todoBox.isOpen) await todoBox.clear();
      await todoBox.close();
      await Hive.deleteBoxFromDisk('todos_box');
    } catch (e) {
      print('TearDown error: $e');
    }
  });

  test('completeTodo simple toggle', () async {
    final todo = Todo(
      id: 'simple_toggle_1', // Unique ID
      task: 'Test Task',
      category: 'General',
      isDone: false,
      sortIndex: 0,
    );
    await todoBox.put(todo.id, todo);

    await schedulerService.completeTodo(todo);

    expect(todo.isDone, true);
    verify(mockNotificationService.cancelNotification(any)).called(1);

    // Verify persistence
    final saved = todoBox.get('simple_toggle_1');
    expect(saved!.isDone, true);
  });

  test('completeTodo recurrence daily', () async {
    final todo = Todo(
      id: 'daily_cycle_1', // Unique ID
      task: 'Daily Task',
      category: 'General',
      isDone: false,
      repeatInterval: 'daily',
      dueDate: DateTime.now(),
      hasReminder: true,
      sortIndex: 0,
    );
    await todoBox.put(todo.id, todo);

    final nextInstance = await schedulerService.completeTodo(todo);

    expect(todo.isDone, true);
    expect(nextInstance, isNotNull);
    expect(nextInstance!.repeatInterval, 'daily');
    // Verify link
    expect(todo.nextInstanceId, nextInstance.id);

    // Check if notification scheduled for next instance
    verify(
      mockNotificationService.scheduleNotification(
        id: anyNamed('id'),
        title: anyNamed('title'),
        body: anyNamed('body'),
        scheduledDate: anyNamed('scheduledDate'),
        payload: anyNamed('payload'),
      ),
    ).called(1);
  });

  test('completeTodo undo (uncheck)', () async {
    // Setup: A task that was completed and created a next instance
    final futureTask = Todo(
      id: 'future_undo_1', // Unique ID
      task: 'Daily Task',
      category: 'General',
      isDone: false,
      dueDate: DateTime.now().add(Duration(days: 1)),
    );
    await todoBox.put(futureTask.id, futureTask);

    final original = Todo(
      id: 'daily_undo_1', // Unique ID
      task: 'Daily Task',
      category: 'General',
      isDone: true, // Already done
      repeatInterval: 'daily',
      dueDate: DateTime.now(),
      nextInstanceId: futureTask.id,
    );
    await todoBox.put(original.id, original);

    // Act: Uncheck
    await schedulerService.completeTodo(original);

    // Assert
    expect(original.isDone, false);
    expect(original.nextInstanceId, null);

    // Future task should be deleted
    expect(todoBox.containsKey(futureTask.id), false);

    // Future notification cancelled
    verify(
      mockNotificationService.cancelNotification(futureTask.id.hashCode),
    ).called(1);
  });
}
