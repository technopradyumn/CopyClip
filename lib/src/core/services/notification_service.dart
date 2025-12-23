import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive/hive.dart';
import 'package:copyclip/src/features/todos/data/todo_model.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:rxdart/rxdart.dart';
import '../../features/todos/data/todo_adapter.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  final onNotifications = BehaviorSubject<String?>();

  Future<void> init() async {
    tz.initializeTimeZones();

    if (Platform.isAndroid) {
      final androidImplementation = flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
      if (androidImplementation != null) {
        await androidImplementation.requestNotificationsPermission();
        await androidImplementation.requestExactAlarmsPermission();
      }
    }

    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@drawable/copyclip_logo');

    const DarwinInitializationSettings initializationSettingsIOS = DarwinInitializationSettings();

    await flutterLocalNotificationsPlugin.initialize(
      const InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsIOS),
      onDidReceiveNotificationResponse: (NotificationResponse response) async {

        if (response.actionId == 'action_complete' && response.payload != null) {
          try {
            // --- CRITICAL FIX FOR BACKGROUND UPDATES ---
            if (!Hive.isAdapterRegistered(2)) { // 2 is your Todo typeId
              Hive.registerAdapter(TodoAdapter());
            }

            if (!Hive.isBoxOpen('todos_box')) {
              await Hive.openBox<Todo>('todos_box');
            }

            final box = Hive.box<Todo>('todos_box');
            final todo = box.get(response.payload);

            if (todo != null) {
              todo.isDone = true;
              await todo.save();

              // Force UI to refresh if app is open
              onNotifications.add("refresh");

              if (response.id != null) {
                await flutterLocalNotificationsPlugin.cancel(response.id!);
              }
            }
          } catch (e) {
            debugPrint("Background Database Error: $e");
          }
        }

        if (response.payload != null && response.actionId == null) {
          onNotifications.add(response.payload);
        }
      },
    );
  }

  /// Master function implementing ALL AndroidNotificationDetails features
  AndroidNotificationDetails _getMegaAndroidDetails({
    String? body,
    int? progressValue,
    bool isIndeterminate = false,
  }) {
    return AndroidNotificationDetails(
      'copyclip_ultimate_channel',
      'CopyClip Ultimate Alerts',
      channelDescription: 'Every single feature enabled',
      icon: '@drawable/copyclip_logo',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
      vibrationPattern: Int64List.fromList([0, 500, 200, 500]),
      groupKey: 'com.copyclip.MEGA_GROUP',
      setAsGroupSummary: false,
      groupAlertBehavior: GroupAlertBehavior.all,
      autoCancel: false,
      ongoing: true, // Non-removable by Clear All
      silent: false,
      color: const Color(0xFF4CAF50),
      largeIcon: const DrawableResourceAndroidBitmap('@drawable/copyclip_logo'),
      onlyAlertOnce: false,
      showWhen: true,
      when: DateTime.now().millisecondsSinceEpoch,
      usesChronometer: false,
      chronometerCountDown: false,
      channelShowBadge: true,
      showProgress: progressValue != null,
      maxProgress: 100,
      progress: progressValue ?? 0,
      indeterminate: isIndeterminate,
      channelAction: AndroidNotificationChannelAction.createIfNotExists,
      enableLights: true,
      ledColor: const Color(0xFF4CAF50),
      ledOnMs: 1000,
      ledOffMs: 500,
      ticker: 'New Ultra-Notification',
      visibility: NotificationVisibility.public,
      timeoutAfter: null,
      category: AndroidNotificationCategory.reminder,
      fullScreenIntent: true,
      shortcutId: 'copyclip_shortcut_1',
      subText: 'CopyClip Task Manager',
      tag: 'task_alert',
      colorized: true,
      number: 1,
      audioAttributesUsage: AudioAttributesUsage.notification,

      styleInformation: BigTextStyleInformation(
        body ?? 'Manage your tasks efficiently.',
        contentTitle: 'Priority Task',
        summaryText: 'Action Required',
        htmlFormatContent: true,
        htmlFormatTitle: true,
      ),
    );
  }

  Future<void> showInstantNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    await flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      NotificationDetails(android: _getMegaAndroidDetails(body: body)),
      payload: payload, // Ensure this is the Todo.id
    );
  }

  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? payload,
  }) async {
    if (scheduledDate.isBefore(DateTime.now())) return;

    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledDate, tz.local),
      NotificationDetails(android: _getMegaAndroidDetails(body: body)),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
      payload: payload,
    );
  }

  Future<void> showProgressNotification({
    required int id,
    required int progress,
    required String title,
  }) async {
    await flutterLocalNotificationsPlugin.show(
      id,
      title,
      'Syncing...',
      NotificationDetails(android: _getMegaAndroidDetails(progressValue: progress)),
    );
  }

  Future<void> cancelNotification(int id) async => await flutterLocalNotificationsPlugin.cancel(id);

  Future<void> cancelAll() async => await flutterLocalNotificationsPlugin.cancelAll();

  Future<void> showUltraNotification({required int id, required String title, required String body, String? payload}) async {
    await flutterLocalNotificationsPlugin.show(
      id, title, body, NotificationDetails(android: _getMegaAndroidDetails(body: body)),
      payload: payload,
    );
  }

  Future<void> showMegaProgress({required int id, required int progress}) async {
    await flutterLocalNotificationsPlugin.show(
      id, 'Processing...', 'Syncing your data',
      NotificationDetails(android: _getMegaAndroidDetails(progressValue: progress)),
    );
  }
}