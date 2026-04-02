import '../../../core/services/notification_service.dart';
import '../data/calendar_event_model.dart';

class EventNotificationService {
  static final NotificationService _notificationService = NotificationService();

  /// Constants for notification ID offsets
  static const int _OFFSET_1H = 1;
  static const int _OFFSET_1D = 2;
  static const int _OFFSET_1W = 3;

  /// Schedules reminders for an event: 1 hour, 1 day, and 1 week before.
  static Future<void> scheduleNotifications(CalendarEvent event) async {
    // First, cancel any existing ones to avoid duplicates if updating
    await cancelNotifications(event);

    if (event.isDeleted) return;

    final now = DateTime.now();
    final baseId = event.id.hashCode.abs() % 1000000;

    // 1. One Hour Before
    final oneHourBefore = event.startDate.subtract(const Duration(hours: 1));
    if (oneHourBefore.isAfter(now)) {
      await _notificationService.scheduleNotification(
        id: baseId * 10 + _OFFSET_1H,
        title: "Upcoming Event: ${event.title} ⏰",
        body: "Starts in 1 hour${event.location != null ? ' at ${event.location}' : ''}.",
        scheduledDate: oneHourBefore,
        channelId: 'calendar',
        payload: 'event:${event.id}',
      );
    }

    // 2. One Day Before
    final oneDayBefore = event.startDate.subtract(const Duration(days: 1));
    if (oneDayBefore.isAfter(now)) {
      await _notificationService.scheduleNotification(
        id: baseId * 10 + _OFFSET_1D,
        title: "Tomorrow: ${event.title} 📅",
        body: "Don't forget your event tomorrow!",
        scheduledDate: oneDayBefore,
        channelId: 'calendar',
        payload: 'event:${event.id}',
      );
    }

    // 3. One Week Before
    final oneWeekBefore = event.startDate.subtract(const Duration(days: 7));
    if (oneWeekBefore.isAfter(now)) {
      await _notificationService.scheduleNotification(
        id: baseId * 10 + _OFFSET_1W,
        title: "Next Week: ${event.title} 🗓️",
        body: "You have an event coming up in 7 days.",
        scheduledDate: oneWeekBefore,
        channelId: 'calendar',
        payload: 'event:${event.id}',
      );
    }
  }

  /// Cancels all potential reminders for an event.
  static Future<void> cancelNotifications(CalendarEvent event) async {
    final baseId = event.id.hashCode.abs() % 1000000;
    
    await Future.wait([
      _notificationService.cancelNotification(baseId * 10 + _OFFSET_1H),
      _notificationService.cancelNotification(baseId * 10 + _OFFSET_1D),
      _notificationService.cancelNotification(baseId * 10 + _OFFSET_1W),
    ]);
  }
}
