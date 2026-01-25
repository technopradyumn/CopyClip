import 'package:copyclip/src/features/todos/data/todo_adapter.dart';
import 'package:copyclip/src/features/todos/data/todo_model.dart';
import 'package:copyclip/src/features/todos/services/todo_scheduler_service.dart';
import 'package:copyclip/src/core/services/notification_engine.dart'; // ✅ NEW
import 'package:hive_flutter/hive_flutter.dart';
import 'package:workmanager/workmanager.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';

const String kTaskMorningBriefing =
    "com.technopradyumn.copyclip.morningBriefing";
const String kTaskEveningCheck = "com.technopradyumn.copyclip.eveningCheck";
const String kTaskCheckMissedTodos =
    "com.technopradyumn.copyclip.checkMissedTodos";

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    debugPrint("👷 Background Worker Started: $task");

    try {
      // 1. Initialize Hive (Required in Isolate)
      if (Platform.isAndroid || Platform.isIOS) {
        await Hive.initFlutter();
        if (!Hive.isAdapterRegistered(2)) {
          Hive.registerAdapter(TodoAdapter());
        }
        // Register other adapters needed for checks
        // Expense(3), Journal(4) - assuming IDs based on context.
        // We'll trust LazyBoxLoader logic or manual reg here?
        // Let's register them if needed. Safer to use try/catch or check registry.
      }

      // 2. Open Boxes
      // Using raw Hive.openBox since LazyBoxLoader might be complex in isolate without proper setup?
      // Actually, NotificationEngine uses LazyBoxLoader.
      // So we just need to init Hive and Adapters.

      // 3. Execute Logic
      // Note: NotificationEngine internally opens boxes via LazyBoxLoader.
      // BUT LazyBoxLoader depends on Hive being initialized.

      switch (task) {
        case kTaskMorningBriefing:
          await NotificationEngine().triggerMorningBriefing();
          break;
        case kTaskEveningCheck:
          await NotificationEngine().triggerEveningCheck();
          break;
        case kTaskCheckMissedTodos:
        case Workmanager.iOSBackgroundTask:
          // Ensure box for todos is open for this specific service
          if (!Hive.isBoxOpen('todos_box'))
            await Hive.openBox<Todo>('todos_box');
          await TodoSchedulerService().handleMissedRecurrences();
          break;
      }

      debugPrint("✅ Background Worker Completed");
      return Future.value(true);
    } catch (e) {
      debugPrint("❌ Background Worker Failed: $e");
      return Future.value(false);
    }
  });
}

class BackgroundWorker {
  static Future<void> initialize() async {
    await Workmanager().initialize(
      callbackDispatcher,
      isInDebugMode: kDebugMode,
    );
    debugPrint("🚀 Workmanager Initialized");
  }

  static Future<void> registerPeriodicTask() async {
    if (Platform.isAndroid) {
      // 1. Morning Briefing (~7:30 AM)
      // Workmanager periodic is interval-based, not time-based.
      // We schedule a periodic every 24h, with an initial delay?
      // Best effort: Schedule every 4 hours and check time inside?
      // OR use an exact alarm? NotificationService uses exact alarms.
      // Workmanager is for "guaranteed" background work.
      // Let's stick to simple "Every 12h" or "Every 6h" checks and have the Engine decide "Is it time?".

      // We'll use a single periodic task that runs frequently (every 4h? min 15m).
      // Let's stick to the existing 6h check but expand it.
      await Workmanager().registerPeriodicTask(
        "periodic-main-check",
        kTaskCheckMissedTodos, // usage of same ID for compat or new?
        // Let's upgrade this to a generic 'smart-check'
        frequency: const Duration(hours: 4),
        constraints: Constraints(requiresBatteryNotLow: true),
        existingWorkPolicy: ExistingPeriodicWorkPolicy.keep,
      );

      // NOTE: For SPECIFIC time (7:30am), it's better to use
      // flutter_local_notifications `zonedSchedule` for the NOTIFICATION itself if data is static.
      // But we need DYNAMIC data (tasks count).
      // So we need code to run at 7:30am.
      // Workmanager supports oneOffTask with delay.
      // Routine: App Open -> Calculate time to 7:30am -> Schedule OneOff.
      // This is more reliable for specific times.

      await _scheduleDailyBriefingWorker();
    }
  }

  static Future<void> _scheduleDailyBriefingWorker() async {
    final now = DateTime.now();
    var scheduledDate = DateTime(now.year, now.month, now.day, 7, 30);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    final timeDiff = scheduledDate.difference(now);

    await Workmanager().registerOneOffTask(
      "daily-briefing-oneoff",
      kTaskMorningBriefing,
      initialDelay: timeDiff,
      constraints: Constraints(requiresBatteryNotLow: true),
      existingWorkPolicy: ExistingWorkPolicy.replace,
    );
  }

  static Future<void> _scheduleEveningWorker() async {
    final now = DateTime.now();
    var scheduledDate = DateTime(now.year, now.month, now.day, 19, 0); // 7 PM
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    final timeDiff = scheduledDate.difference(now);

    await Workmanager().registerOneOffTask(
      "evening-check-oneoff",
      kTaskEveningCheck,
      initialDelay: timeDiff,
      constraints: Constraints(requiresBatteryNotLow: true),
      existingWorkPolicy: ExistingWorkPolicy.replace,
    );
  }

  /// Call this when app opens to re-schedule/ensure the next briefing is set
  static Future<void> rescheduleDailyBriefing() async {
    await _scheduleDailyBriefingWorker();
    await _scheduleEveningWorker();
  }
}
