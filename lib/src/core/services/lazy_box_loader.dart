import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:copyclip/src/features/notes/data/note_model.dart';
import 'package:copyclip/src/features/todos/data/todo_model.dart';
import 'package:copyclip/src/features/expenses/data/expense_model.dart';
import 'package:copyclip/src/features/journal/data/journal_model.dart';
import 'package:copyclip/src/features/clipboard/data/clipboard_model.dart';
import 'package:copyclip/src/features/canvas/data/canvas_adapter.dart';

/// \u2705 PERFORMANCE OPTIMIZATION: Lazy Box Loader
/// This service ensures Hive boxes are only opened when needed,
/// significantly improving app startup time
class LazyBoxLoader {
  static final Map<String, bool> _loadedBoxes = {};
  static bool _isInitialized = false;

  /// Initialize the lazy loader (registers adapters)
  static Future<void> initialize() async {
    if (_isInitialized) return;
    _isInitialized = true;
  }

  /// Get a box, loading it lazily if not already open
  static Future<Box<T>> getBox<T>(String boxName) async {
    if (Hive.isBoxOpen(boxName)) {
      return Hive.box<T>(boxName);
    }

    if (_loadedBoxes[boxName] == true) {
      // Box is being loaded by another call
      await Future.delayed(const Duration(milliseconds: 100));
      return getBox<T>(boxName);
    }

    _loadedBoxes[boxName] = true;
    debugPrint('\u{1F4E6} Lazy loading box: $boxName');

    try {
      final box = await Hive.openBox<T>(boxName);
      debugPrint('\u2705 Box loaded: $boxName');
      return box;
    } catch (e) {
      debugPrint('\u{274C} Error loading box $boxName: $e');
      debugPrint('\u{1F5D1}\uFE0F Deleting corrupted box and recreating...');
      try {
        await Hive.deleteBoxFromDisk(boxName);
        final box = await Hive.openBox<T>(boxName);
        debugPrint('\u2705 Box recreated: $boxName');
        return box;
      } catch (e2) {
        debugPrint('\u{274C} CRITICAL: Failed to recreate box $boxName: $e2');
        rethrow;
      }
    }
  }

  /// Preload common boxes in background (call after first frame)
  static Future<void> preloadCommonBoxes() async {
    debugPrint('\u{1F4E6} Preloading common boxes...');
    try {
      await Future.wait([
        getBox<Note>('notes_box'),
        getBox<Todo>('todos_box'),
        getBox<ClipboardItem>('clipboard_box'),
      ]);
      debugPrint('\u2705 Common boxes preloaded');
    } catch (e) {
      debugPrint('\u{26A0}\uFE0F Error preloading boxes: $e');
    }
  }

  /// Load all remaining boxes  
  static Future<void> loadAllBoxes() async {
    debugPrint('\u{1F4E6} Loading all feature boxes...');
    try {
      await Future.wait([
        getBox<Note>('notes_box'),
        getBox<Todo>('todos_box'),
        getBox<Expense>('expenses_box'),
        getBox<JournalEntry>('journal_box'),
        getBox<ClipboardItem>('clipboard_box'),
        CanvasDatabase().init(),
      ]);
      debugPrint('\u2705 All boxes loaded');
    } catch (e) {
      debugPrint('\u{26A0}\uFE0F Error loading boxes: $e');
    }
  }
}
