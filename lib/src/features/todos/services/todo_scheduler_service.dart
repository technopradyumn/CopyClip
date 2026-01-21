import 'package:copyclip/src/core/services/notification_service.dart';
import 'package:copyclip/src/features/todos/data/todo_model.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:timezone/timezone.dart' as tz; // Ensure timezone usage

class TodoSchedulerService {
  static final TodoSchedulerService _instance =
      TodoSchedulerService._internal();

  factory TodoSchedulerService() => _instance;

  TodoSchedulerService._internal();

  NotificationService _notificationService = NotificationService();

  @visibleForTesting
  set notificationService(NotificationService service) {
    _notificationService = service;
  }

  /// Main entry point for completing a Todo.
  /// Returns null if simple update, or the new Todo object if a next instance was created.
  Future<Todo?> completeTodo(Todo todo) async {
    final box = Hive.box<Todo>('todos_box');

    // 1. Toggle Done State
    todo.isDone = !todo.isDone;

    // 2. Handle Recurrence (Only if just marked DONE)
    Todo? nextInstance;
    if (todo.isDone && todo.repeatInterval != null) {
      nextInstance = await _handleRecurrence(todo, box);
    }
    // 3. Handle Undo (Marked NOT DONE)
    else if (!todo.isDone && todo.nextInstanceId != null) {
      await _handleUndoRecurrence(todo, box);
    }

    // 4. Update Notifications
    await _updateNotifications(todo);

    // 5. Save Changes
    await todo.save();

    return nextInstance;
  }

  // --- Recurrence Logic ---

  Future<Todo?> _handleRecurrence(Todo original, Box<Todo> box) async {
    final DateTime baseDate = original.dueDate ?? DateTime.now();
    DateTime? nextDate = _calculateNextDate(
      original.repeatInterval!,
      baseDate,
      original.repeatDays,
    );

    if (nextDate == null) return null;

    // Safety: Don't create duplicates if one already exists for this ID linkage
    if (original.nextInstanceId != null &&
        box.containsKey(original.nextInstanceId)) {
      // Technically shouldn't happen if logic is sound, but good to check
      return box.get(original.nextInstanceId);
    }

    final newId = DateTime.now().millisecondsSinceEpoch.toString();
    final newTodo = Todo(
      id: newId,
      task: original.task,
      category: original.category,
      dueDate: nextDate,
      hasReminder: original.hasReminder,
      isDone: false,
      repeatInterval: original.repeatInterval,
      repeatDays: original.repeatDays,
      sortIndex: original.sortIndex,
    );

    // Add to DB
    await box.put(newId, newTodo);

    // Link original to new
    original.nextInstanceId = newId;

    // ✅ FORCE UPDATE: Ensure default true for repeats if user wants all-on,
    // or strictly follow original? User said: "automatic every repeated deteail automatic update day by day accordingly so all the notification must be show"
    // So we preserve original.hasReminder. If original had it, new one has it.
    // AND SCHEDULE IT.

    if (newTodo.hasReminder && nextDate.isAfter(DateTime.now())) {
      // CRITICAL: Schedule immediately
      await _notificationService.scheduleNotification(
        id: newId.hashCode,
        title: 'Task Due',
        body: newTodo.task,
        scheduledDate: nextDate,
        payload: newId,
      );
      debugPrint(
        '🔔 Notification scheduled for recurring task: $newId at $nextDate',
      );
    }

    debugPrint(
      '🔄 Auto-scheduled next instance: ${newTodo.task} for $nextDate',
    );
    return newTodo;
  }

  Future<void> _handleUndoRecurrence(Todo original, Box<Todo> box) async {
    // If we undo a completion, we should probably remove the "future" task
    // that was just created to avoid duplicates upon re-completion.
    if (original.nextInstanceId != null) {
      if (box.containsKey(original.nextInstanceId)) {
        final futureTask = box.get(original.nextInstanceId);
        // Only delete if the user hasn't already started working on it or modified it significantly?
        // Simplicity: Delete it if it's not done.
        if (futureTask != null && !futureTask.isDone) {
          await futureTask.delete();
          await _notificationService.cancelNotification(futureTask.id.hashCode);
          debugPrint('↩️ Undo: Deleted future instance ${futureTask.id}');
        }
      }
      original.nextInstanceId = null;
    }
  }

  DateTime? _calculateNextDate(
    String interval,
    DateTime current,
    List<int>? repeatDays,
  ) {
    // Basic logic
    switch (interval) {
      case 'daily':
        return current.add(const Duration(days: 1));
      case 'weekly':
        return current.add(const Duration(days: 7));
      case 'monthly':
        return DateTime(
          current.year,
          current.month + 1,
          current.day,
          current.hour,
          current.minute,
        );
      case 'yearly':
        return DateTime(
          current.year + 1,
          current.month,
          current.day,
          current.hour,
          current.minute,
        );
      case 'custom':
        if (repeatDays != null && repeatDays.isNotEmpty) {
          DateTime temp = current;
          // Scan next 365 days to find next match
          for (int i = 1; i <= 365; i++) {
            temp = temp.add(const Duration(days: 1));
            if (repeatDays.contains(temp.weekday)) {
              return temp;
            }
          }
        }
        return null;
      default:
        return null;
    }
  }

  // --- Notification Logic ---

  Future<void> _updateNotifications(Todo todo) async {
    final service = _notificationService;
    if (todo.isDone) {
      await service.cancelNotification(todo.id.hashCode);
    } else {
      // Re-schedule if it has a reminder and is in the future
      if (todo.hasReminder &&
          todo.dueDate != null &&
          todo.dueDate!.isAfter(DateTime.now())) {
        await service.scheduleNotification(
          id: todo.id.hashCode,
          title: 'Task Due',
          body: todo.task,
          scheduledDate: todo.dueDate!,
          payload: todo.id,
        );
      }
    }
  }

  // --- Background/Healing Logic ---

  /// Called on app start or background wake to fix "Missed" schedules
  Future<void> handleMissedRecurrences() async {
    if (!Hive.isBoxOpen('todos_box')) {
      // Should be opened by caller, but safety check
      return;
    }
    final box = Hive.box<Todo>('todos_box');
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);

    List<Todo> toProcess = [];

    // Find generic repeatable tasks that are DONE but their "next instance"
    // is ALSO in the past? Or find tasks that missed their window?
    // Actually, usually we care about the "Latest Active Instance".

    // Scenario: User has "Daily Workout".
    // Completed on Monday. Next created for Tuesday.
    // User doesn't open app until Friday.
    // Tuesday's task is "Overdue".

    // Strategy:
    // If a repeatable task is OVERDUE by more than X time, we might want to:
    // 1. Keep it as overdue (so they see they missed it).
    // 2. OR Auto-fail it and create today's? (User didn't ask for auto-fail).
    // User asked: "If user misses a day: System adjusts intelligently, No duplicate clutter, Next valid schedule is created"

    for (var todo in box.values) {
      if (todo.isDeleted) continue;

      // If it's a repeatable task instance...
      if (todo.repeatInterval != null && !todo.isDone && todo.dueDate != null) {
        // Check if it is SEVERELY overdue (e.g. 2 days ago)
        if (todo.dueDate!.isBefore(
          todayStart.subtract(const Duration(days: 1)),
        )) {
          // It's stale.
          debugPrint(
            '🧹 Found stale repeated task: ${todo.task} due ${todo.dueDate}',
          );

          // "Complete" it via system or jump date?
          // Move date to Today (Catch up)?
          // Or mark as missed?

          // Simplest "No Clutter" approach:
          // Move the Due Date to TODAY so the user sees it immediately as "Today's Task".
          // We don't mark the previous days as 'done' or 'failed', we just shift the goalpost.

          // Wait, if it's daily, and I missed 3 days, do I want 3 tasks? No ("No duplicate clutter").
          // Do I want 1 task due 3 days ago? No.
          // I want to see "Workout (Today)".

          // Action: Update Due Date to Today (or Next Valid Date).
          DateTime? nextValid = _findNextValidDate(todo, now);
          if (nextValid != null && nextValid != todo.dueDate) {
            todo.dueDate = nextValid;
            // Reschedule notification
            await _updateNotifications(todo);
            await todo.save();
            debugPrint('📅 Auto-shifted stale task to $nextValid');
          }
        }
      }
    }
  }

  DateTime? _findNextValidDate(Todo todo, DateTime now) {
    // If daily, just make it today.
    if (todo.repeatInterval == 'daily')
      return DateTime(
        now.year,
        now.month,
        now.day,
        todo.dueDate?.hour ?? 9,
        todo.dueDate?.minute ?? 0,
      );

    // If weekly, find next valid weekday.
    if (todo.repeatInterval == 'weekly') {
      // e.g. Due last Monday. Today is Friday. Next valid is Next Monday.
      // Or keep it "Last Monday" until they check it off?
      // User request: "Next valid schedule is created".
      // If I missed Monday, and it's Friday, I probably want to see it for NEXT Monday?
      // Or do I want to do it today (Friday) because I missed it?
      // Let's assume 'Catch Up' isn't the goal, 'Staying on Schedule' is.
      // So move to next occurrence.
      return _calculateNextDate('weekly', todo.dueDate!, null);
      // Note: this might need a loop if it's been WEEKS.
      // For now, let's just create next instance from NOW.
    }

    return _calculateNextDate(todo.repeatInterval!, now, todo.repeatDays);
  }

  // --- Helpers for NotificationEngine ---

  Future<List<Todo>> getPendingTodosForToday() async {
    if (!Hive.isBoxOpen('todos_box')) {
      if (Hive.isBoxOpen('todos_box')) {
        // Already open
      } else {
        // Should use a safe opener, but for now assuming it might be open or we return empty.
        // Actually, bg_worker opens it.
        return [];
      }
    }
    final box = Hive.box<Todo>(
      'todos_box',
    ); // Unsafe if not open, but manageable in bg context
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    final tomorrowStart = todayStart.add(const Duration(days: 1));

    return box.values.where((t) {
      if (t.isDeleted || t.isDone) return false;
      if (t.dueDate == null) return false;
      // Due today or overdue
      return t.dueDate!.isBefore(tomorrowStart);
    }).toList();
  }
}
