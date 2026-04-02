import 'package:copyclip/src/core/services/notification_service.dart';
import 'package:copyclip/src/core/services/time_zone_service.dart';
import 'package:flutter/material.dart';

enum NotificationType {
  morningRoutine,
  middayProductivity,
  eveningPlanning,
  nightRoutine,
  featureSpecific,
  contextual,
}

class NotificationEngine {
  static final NotificationEngine _instance = NotificationEngine._internal();
  factory NotificationEngine() => _instance;
  NotificationEngine._internal();

  final NotificationService _notificationService = NotificationService();
  final TimeZoneService _timeZoneService = TimeZoneService();

  Future<void> initialize() async {
    await _timeZoneService.initialize();
    await _notificationService.init();
    await _scheduleDailyRoutine();
  }

  // Schedule all daily notifications adjusted to local time
  Future<void> _scheduleDailyRoutine() async {
    // 1. Morning Routine (7:00 AM)
    await _scheduleDaily(
      id: 1001,
      title: "Good Morning! 🌅",
      body: "Check your todos for today and start fresh!",
      hour: 7,
      minute: 0,
    );

    // 2. Quick Clipboard Review (8:00 AM)
    await _scheduleDaily(
      id: 1002,
      title: "Clipboard Review 📋",
      body: "Quick check: 3 items from yesterday might need action.",
      hour: 8,
      minute: 0,
      channelId: 'clipboard',
    );

    // 3. Journal Prompt (8:30 AM)
    await _scheduleDaily(
      id: 1003,
      title: "Daily Journal 📔",
      body: "How are you feeling today? Take a moment to reflect.",
      hour: 8,
      minute: 30,
      channelId: 'journal',
    );

    // 4. Lunch Break / Expenses (12:30 PM)
    await _scheduleDaily(
      id: 1004,
      title: "Lunch Break & Budget 🍽️",
      body: "Enjoy your meal! Don't forget to log your lunch expense.",
      hour: 12,
      minute: 30,
      channelId: 'expenses',
    );

    // 5. Afternoon Todos (1:30 PM)
    await _scheduleDaily(
      id: 1005,
      title: "Afternoon Focus 🚀",
      body: "Keep the momentum going! Check your remaining tasks.",
      hour: 13,
      minute: 30,
    );

    // 6. Evening Wrap-up (6:00 PM)
    await _scheduleDaily(
      id: 1006,
      title: "Wrap Up 🌇",
      body: "Save important clipboard items before the day ends.",
      hour: 18,
      minute: 0,
      channelId: 'clipboard',
    );

    // 7. Expense Update (7:00 PM)
    await _scheduleDaily(
      id: 1007,
      title: "Expense Tracker 💰",
      body: "Update your tracker with today's spending.",
      hour: 19,
      minute: 0,
      channelId: 'expenses',
    );

    // 8. Tomorrow Planning (8:00 PM)
    await _scheduleDaily(
      id: 1008,
      title: "Plan Tomorrow 🌙",
      body: "A productive tomorrow starts tonight. Plan your tasks.",
      hour: 20,
      minute: 0,
    );

    // 9. Evening Reflection (9:00 PM)
    await _scheduleDaily(
      id: 1009,
      title: "Evening Reflection ✍️",
      body: "Reflect on your day. What went well?",
      hour: 21,
      minute: 0,
      channelId: 'journal',
    );

    // 10. Goodnight (10:00 PM)
    await _scheduleDaily(
      id: 1010,
      title: "Goodnight! 😴",
      body: "Rest well. See your calendar preview for tomorrow.",
      hour: 22,
      minute: 0,
      channelId: 'calendar',
    );
  }

  Future<void> _scheduleDaily({
    required int id,
    required String title,
    required String body,
    required int hour,
    required int minute,
    String channelId = 'todos',
    String? payload,
  }) async {
    await _notificationService.scheduleDailyNotification(
      id: id,
      title: title,
      body: body,
      time: TimeOfDay(hour: hour, minute: minute),
      channelId: channelId,
      payload: payload ?? channelId,
    );
  }

  Future<void> triggerMorningBriefing() async {
    await _notificationService.showInstantNotification(
      id: 777,
      title: "Good Morning! ☀️",
      body: "Ready to conquer your tasks today?",
      channelId: "todos",
    );
  }

  Future<void> triggerEveningCheck() async {
    await _notificationService.showInstantNotification(
      id: 888,
      title: "Evening Check 🌙",
      body: "Almost done for the day! Check any remaining tasks.",
      channelId: "todos",
    );
  }

  // Called from main.dart on startup or cold start
  void checkAndTriggerWelcome() {
    // Logic to check if it's the very first launch, etc.
  }
}
