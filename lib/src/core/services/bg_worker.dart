import 'package:copyclip/src/features/todos/data/todo_adapter.dart';
import 'package:copyclip/src/features/todos/data/todo_model.dart';
import 'package:copyclip/src/features/todos/services/todo_scheduler_service.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:workmanager/workmanager.dart';
import 'package:flutter/foundation.dart';
import 'dart:io';

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
      }

      // 2. Execute Logic
      switch (task) {
        case kTaskCheckMissedTodos:
        case Workmanager.iOSBackgroundTask:
          // Ensure box for todos is open for this specific service
          if (!Hive.isBoxOpen('todos_box')) {
            await Hive.openBox<Todo>('todos_box');
          }
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
      await Workmanager().registerPeriodicTask(
        "periodic-main-check",
        kTaskCheckMissedTodos,
        frequency: const Duration(hours: 4),
        constraints: Constraints(requiresBatteryNotLow: true),
        existingWorkPolicy: ExistingPeriodicWorkPolicy.keep,
      );
    }
  }
}
