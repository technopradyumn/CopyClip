import 'package:copyclip/src/core/services/notification_service.dart';
import 'package:copyclip/src/features/expenses/services/expense_notification_handler.dart';
import 'package:copyclip/src/features/journal/services/journal_notification_handler.dart';
import 'package:copyclip/src/features/todos/services/todo_scheduler_service.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:copyclip/src/core/services/lazy_box_loader.dart';

class NotificationEngine {
  static final NotificationEngine _instance = NotificationEngine._internal();

  factory NotificationEngine() => _instance;

  NotificationEngine._internal();

  /// Called by Background Worker daily at ~7:30 AM
  Future<void> triggerMorningBriefing() async {
    debugPrint('🌅 Triggering Morning Briefing...');
    try {
      final todos = await TodoSchedulerService().getPendingTodosForToday();
      final count = todos.length;

      if (count > 0) {
        // Construct a nice message
        // "Good Morning! You have 5 tasks today including 'Buy groceries'..."
        final firstTask = todos.first.task;
        String body = "You have $count tasks scheduled for today.";
        if (count == 1) {
          body = "Here is your focus for today: $firstTask";
        } else {
          body = "Top priority: $firstTask. Plus ${count - 1} others.";
        }

        await NotificationService().showInstantNotification(
          id: 8888, // Fixed ID for briefing to replace previous
          title: "☀️ Today's Plan",
          body: body,
          channelId: 'todos',
          payload: "dashboard", // Open dashboard
        );
      }
    } catch (e) {
      debugPrint("❌ Morning Briefing Failed: $e");
    }
  }

  /// Called by Background Worker daily at ~8:00 PM
  Future<void> triggerEveningCheck() async {
    debugPrint('🌙 Triggering Evening Check...');

    // 1. Task Check for Evening Planning
    try {
      final todos = await TodoSchedulerService().getPendingTodosForToday();
      final count = todos.length;

      String title = "🌙 Evening Wrap-Up";
      String body = "Time to plan for tomorrow!";

      if (count > 0) {
        body =
            "You have $count pending tasks. Finish them up and plan for tomorrow!";
      }

      await NotificationService().showInstantNotification(
        id: 8890,
        title: title,
        body: body,
        channelId: 'todos',
        payload: "dashboard",
      );
    } catch (e) {
      debugPrint("Warning: Evening task check failed: $e");
    }

    // 2. Run other handlers
    await Future.wait([
      JournalNotificationHandler().checkAndNotify(),
      ExpenseNotificationHandler().checkAndNotify(),
    ]);
  }

  /// Called weekly (e.g., Sunday evening)
  Future<void> triggerWeeklyReport() async {
    // Placeholder for weekly summary
    debugPrint('📅 Weekly report trigger (Not implemented yet)');
  }

  /// Called on app startup to welcome new users
  Future<void> checkAndTriggerWelcome() async {
    try {
      // Ensure box is open (should be by main.dart, but safe check)
      if (!Hive.isBoxOpen('settings')) {
        await LazyBoxLoader.getBox('settings');
      }
      final box = Hive.box('settings');

      final bool hasSeenWelcome = box.get(
        'has_seen_welcome',
        defaultValue: false,
      );

      if (!hasSeenWelcome) {
        debugPrint(
          '👋 First time user detected. Sending welcome notification...',
        );
        await NotificationService().showInstantNotification(
          id: 8899,
          title: "👋 Welcome to CopyClip!",
          body:
              "We're glad you're here. Tap to set up your first task or explore the dashboard.",
          channelId: 'todos', // Use high priority channel
          payload: "dashboard",
        );

        await box.put('has_seen_welcome', true);
      }
    } catch (e) {
      debugPrint("❌ Welcome notification failed: $e");
    }
  }
}
