import 'package:copyclip/src/core/services/notification_service.dart';
import 'package:copyclip/src/features/expenses/data/expense_model.dart';
import 'package:hive/hive.dart';
import 'package:copyclip/src/core/services/lazy_box_loader.dart';
import 'package:flutter/foundation.dart';

class ExpenseNotificationHandler {
  NotificationService _notificationService = NotificationService();

  @visibleForTesting
  set notificationService(NotificationService service) {
    _notificationService = service;
  }

  Future<void> checkAndNotify({@visibleForTesting DateTime? now}) async {
    try {
      // Ensure box is open
      if (!Hive.isBoxOpen('expenses_box')) {
        await LazyBoxLoader.getBox<Expense>('expenses_box');
      }
      final box = Hive.box<Expense>('expenses_box');

      final currentTime = now ?? DateTime.now();
      final todayStart = DateTime(
        currentTime.year,
        currentTime.month,
        currentTime.day,
      );

      // Check if any expense logged today
      print(
        'DEBUG: Checking ${box.values.length} expenses for today: $todayStart',
      );
      bool hasLoggedToday = box.values.any((e) {
        final isToday =
            !e.isDeleted &&
            e.date.isAfter(todayStart) &&
            e.date.isBefore(todayStart.add(const Duration(days: 1)));
        print('DEBUG: Expense ${e.title} Date: ${e.date} IsToday: $isToday');
        return isToday;
      });
      print('DEBUG: hasLoggedToday: $hasLoggedToday');

      if (!hasLoggedToday) {
        // Gentle nudge
        await _notificationService.showInstantNotification(
          id: 9901,
          title: "💰 Track your spending",
          body: "Forgot to log your expenses today?",
          channelId: 'expenses',
          payload: "expenses",
        );
      }

      // Check for Salary Day (approximate logic, e.g. 1st or 28th-31st)
      // This is a bit simplified. Ideally user sets this.
      // We skip for now unless we have user preferences.
    } catch (e) {
      print("Warning: Expense check failed: $e");
    }
  }
}
