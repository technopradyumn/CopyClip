import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:rxdart/rxdart.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();

  factory NotificationService() => _instance;

  NotificationService._internal();

  // Keep this public so main.dart can access it for getNotificationAppLaunchDetails
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  final onNotifications = BehaviorSubject<String?>();

  Future<void> init() async {
    tz.initializeTimeZones();

    if (Platform.isAndroid) {
      final androidImplementation =
          flutterLocalNotificationsPlugin // Fixed name
              .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin
              >();

      if (androidImplementation != null) {
        await androidImplementation.requestNotificationsPermission();
        // ✅ REQUIRED for Android 12+ (API 31+) to trigger when app is killed
        await androidImplementation.requestExactAlarmsPermission();
      }
    }

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@drawable/copyclip_logo');

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
          requestSoundPermission: false, // Request later
          requestBadgePermission: false,
          requestAlertPermission: false,
        );

    const InitializationSettings initializationSettings =
        InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsIOS,
        );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
        if (response.actionId == 'mark_done' && response.payload != null) {
          onNotifications.add("ACTION:mark_done:${response.payload}");
        } else if (response.payload != null) {
          onNotifications.add(response.payload);
        }
      },
    );

    // ✅ CHECK COLD START:
    // If app was launched by tapping a notification, we need to handle it manually here
    // because streams aren't listened to yet.
    final details = await flutterLocalNotificationsPlugin
        .getNotificationAppLaunchDetails();
    if (details != null &&
        details.didNotificationLaunchApp &&
        details.notificationResponse?.payload != null) {
      debugPrint(
        '🚀 App launched via notification payload: ${details.notificationResponse!.payload}',
      );
      // Brief delay to allow listeners to attach in main.dart
      Future.delayed(const Duration(milliseconds: 500), () {
        onNotifications.add(details.notificationResponse!.payload);
      });
    }
  }

  Future<bool> checkPermissions() async {
    if (Platform.isIOS) {
      final bool? result = await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >()
          ?.requestPermissions(alert: true, badge: true, sound: true);
      return result ?? false;
    } else if (Platform.isAndroid) {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
          flutterLocalNotificationsPlugin
              .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin
              >();

      final bool? result = await androidImplementation
          ?.requestNotificationsPermission();
      return result ?? false;
    }
    return true;
  }

  NotificationDetails _notificationDetails(String channelId) {
    String channelName = 'General';
    String channelDesc = 'General notifications';
    Importance importance = Importance.max;
    Priority priority = Priority.high;

    switch (channelId) {
      case 'todos':
        channelName = 'Tasks & Todos';
        channelDesc = 'Reminders for your tasks';
        break;
      case 'journal':
        channelName = 'Journaling';
        channelDesc = 'Daily journaling reminders';
        importance = Importance.defaultImportance;
        priority = Priority.defaultPriority;
        break;
      case 'expenses':
        channelName = 'Finance';
        channelDesc = 'Expense and salary reminders';
        break;
      case 'clipboard':
        channelName = 'Clipboard';
        channelDesc = 'Clipboard background updates';
        importance = Importance.low;
        priority = Priority.low;
        break;
    }

    return NotificationDetails(
      android: AndroidNotificationDetails(
        channelId,
        channelName,
        channelDescription: channelDesc,
        icon: '@drawable/copyclip_logo',
        importance: importance,
        priority: priority,
        ticker: 'ticker',
        playSound: true,
        styleInformation: const BigTextStyleInformation(''),
      ),
      iOS: const DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );
  }

  Future<void> showInstantNotification({
    required int id,
    required String title,
    required String body,
    String channelId = 'todos', // Default to todos for backward compat
    String? payload,
  }) async {
    await flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      _notificationDetails(channelId),
      payload: payload,
    );
  }

  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    String channelId = 'todos',
    String? payload,
  }) async {
    if (scheduledDate.isBefore(DateTime.now())) return;

    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledDate, tz.local),
      _notificationDetails(channelId),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: payload,
    );
  }

  Future<void> cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id); // Fixed name
  }

  Future<void> cancelAll() async {
    await flutterLocalNotificationsPlugin.cancelAll(); // Fixed name
  }
}
