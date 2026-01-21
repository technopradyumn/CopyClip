import 'package:copyclip/src/core/services/notification_service.dart';
import 'package:copyclip/src/features/journal/data/journal_model.dart'; // Correct import
import 'package:hive/hive.dart';
import 'package:copyclip/src/core/services/lazy_box_loader.dart';
import 'package:flutter/foundation.dart';

class JournalNotificationHandler {
  NotificationService _notificationService = NotificationService();

  @visibleForTesting
  set notificationService(NotificationService service) {
    _notificationService = service;
  }

  Future<void> checkAndNotify({@visibleForTesting DateTime? now}) async {
    try {
      // Ensure box is open
      if (!Hive.isBoxOpen('journal_box')) {
        await LazyBoxLoader.getBox<JournalEntry>('journal_box');
      }
      final box = Hive.box<JournalEntry>('journal_box');

      final currentTime = now ?? DateTime.now();
      final todayStart = DateTime(
        currentTime.year,
        currentTime.month,
        currentTime.day,
      );

      // Check if any entry today
      bool hasEntryToday = box.values.any(
        (e) =>
            !e.isDeleted &&
            e.date.isAfter(todayStart) &&
            e.date.isBefore(todayStart.add(const Duration(days: 1))),
      );

      if (!hasEntryToday) {
        await _notificationService.showInstantNotification(
          id: 9902,
          title: "✍️ How was your day?",
          body: "Take a moment to reflect and write a quick note.",
          channelId: 'journal',
          payload: "journal",
        );
      }
    } catch (e) {
      print("Warning: Journal check failed: $e");
    }
  }
}
