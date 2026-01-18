import 'package:copyclip/src/features/canvas/data/canvas_model.dart';
import 'package:copyclip/src/features/clipboard/data/clipboard_model.dart';
import 'package:copyclip/src/features/expenses/data/expense_model.dart';

import 'package:copyclip/src/features/journal/data/journal_model.dart';
import 'package:copyclip/src/features/notes/data/note_model.dart';
import 'package:copyclip/src/features/todos/data/todo_model.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:home_widget/home_widget.dart';
import 'package:intl/intl.dart';
import 'dart:convert';

class WidgetSyncService {
  static const String appGroupId =
      'group.copyclip_app'; // Optional: Use if you have iOS App Group later

  /// Syncs all widget data at once.
  /// Ensure Hive boxes are open before calling this.
  static Future<void> syncAll() async {
    await Future.wait([
      syncNotes(),
      syncTodos(),
      syncFinance(),
      syncJournal(),
      syncClipboard(),
      syncCalendar(),
      syncCanvas(),
    ]);

    // Update all widgets
    try {
      await HomeWidget.updateWidget(androidName: 'NotesWidgetProvider');
      await HomeWidget.updateWidget(androidName: 'TodosWidgetProvider');
      await HomeWidget.updateWidget(androidName: 'ExpensesWidgetProvider');
      await HomeWidget.updateWidget(androidName: 'JournalWidgetProvider');
      await HomeWidget.updateWidget(androidName: 'ClipboardWidgetProvider');
      await HomeWidget.updateWidget(androidName: 'CalendarWidgetProvider');
      await HomeWidget.updateWidget(androidName: 'CanvasWidgetProvider');
    } catch (e) {
      print('Error updating widgets: $e');
    }
  }

  // --- NOTES ---
  static Future<void> syncNotes() async {
    try {
      final box = Hive.isBoxOpen('notes_box')
          ? Hive.box<Note>('notes_box')
          : await Hive.openBox<Note>('notes_box');
      final count = box.values.where((n) => !n.isDeleted).length;

      // Save list data (Top 5)
      final notesList = box.values.where((n) => !n.isDeleted).toList()
        ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));

      final topNotes = notesList.take(5).map((e) {
        return {
          'title': e.title.isEmpty ? 'Untitled' : e.title,
          'date': DateFormat('MMM d').format(e.updatedAt),
          'id': e.id,
        };
      }).toList();

      await HomeWidget.saveWidgetData<String>(
        'notes_data',
        jsonEncode(topNotes),
      );
      await HomeWidget.saveWidgetData<String>('notes_count', '$count Notes');
      await HomeWidget.saveWidgetData<bool>('has_notes', count > 0);

      // Update specific widget
      await HomeWidget.updateWidget(androidName: 'NotesWidgetProvider');
    } catch (e) {
      print('Error syncing notes: $e');
    }
  }

  // --- TODOS ---
  static Future<void> syncTodos() async {
    try {
      final box = Hive.isBoxOpen('todos_box')
          ? Hive.box<Todo>('todos_box')
          : await Hive.openBox<Todo>(
              'todos_box',
            ); // Note: Box name 'todos_box' per edit screen
      final activeTodos = box.values.where((t) => !t.isDeleted);
      final total = activeTodos.length;
      final completed = activeTodos.where((t) => t.isDone).length;

      await HomeWidget.saveWidgetData<String>(
        'todos_progress',
        '$completed/$total Done',
      );

      // Save list data (Top 20 items, Pending first)
      final todoList = box.values.where((t) => !t.isDeleted).toList();
      todoList.sort((a, b) {
        if (a.isDone == b.isDone) return a.sortIndex.compareTo(b.sortIndex);
        return a.isDone ? 1 : -1; // Pending first
      });

      final widgetTodos = todoList.take(20).map((t) {
        return {
          'task': t.task,
          'id': t.id,
          'isDone': t.isDone,
          'category': t.category,
          'hasReminder': t.dueDate != null,
        };
      }).toList();

      await HomeWidget.saveWidgetData<String>(
        'todos_data',
        jsonEncode(widgetTodos),
      );

      await HomeWidget.updateWidget(androidName: 'TodosWidgetProvider');
    } catch (e) {
      print('Error syncing todos: $e');
    }
  }

  // --- FINANCE ---
  static Future<void> syncFinance() async {
    try {
      final box = Hive.isBoxOpen('expenses_box')
          ? Hive.box<Expense>('expenses_box')
          : await Hive.openBox<Expense>('expenses_box');

      double income = 0;
      double expense = 0;

      for (var e in box.values) {
        if (e.isDeleted) continue; // Filter Deleted
        if (e.isIncome) {
          income += e.amount;
        } else {
          expense += e.amount;
        }
      }
      final total = income - expense;
      final currency = '\$'; // Or get from settings

      await HomeWidget.saveWidgetData<String>(
        'total_balance',
        '$currency${total.toStringAsFixed(2)}',
      );
      await HomeWidget.saveWidgetData<String>(
        'income_amount',
        '$currency${income.toStringAsFixed(0)}',
      );
      await HomeWidget.saveWidgetData<String>(
        'expense_amount',
        '$currency${expense.toStringAsFixed(0)}',
      );

      // Save raw values for Progress Bars
      await HomeWidget.saveWidgetData<String>('income_val', income.toString());
      await HomeWidget.saveWidgetData<String>(
        'expense_val',
        expense.toString(),
      );

      // Save Transaction List (Top 5)
      final allTx = box.values.where((e) => !e.isDeleted).toList()
        ..sort((a, b) => b.date.compareTo(a.date));

      final recentTx = allTx.take(5).map((e) {
        return {
          'title': e.title.isEmpty ? 'Transaction' : e.title,
          'amount':
              '${e.isIncome ? '+' : '-'}${currency}${e.amount.toStringAsFixed(0)}',
          'isIncome': e.isIncome,
          'date': DateFormat('MMM d').format(e.date),
          'id': e.id,
        };
      }).toList();

      await HomeWidget.saveWidgetData<String>(
        'expenses_data',
        jsonEncode(recentTx),
      );
      await HomeWidget.saveWidgetData<int>('expenses_count', allTx.length);

      await HomeWidget.updateWidget(androidName: 'ExpensesWidgetProvider');
    } catch (e) {
      print('Error syncing finance: $e');
    }
  }

  // --- JOURNAL ---
  static Future<void> syncJournal() async {
    try {
      final box = Hive.isBoxOpen('journal_box')
          ? Hive.box<JournalEntry>('journal_box')
          : await Hive.openBox<JournalEntry>('journal_box');

      final activeEntries = box.values.where((e) => !e.isDeleted).toList();
      String lastEntry = '';
      if (activeEntries.isNotEmpty) {
        try {
          // Assuming activeEntries is already sorted by insertion order or we sort it
          // Hive values iteration order is usually insertion order.
          // But safest is to sort by date if relying on date.
          activeEntries.sort((a, b) => a.date.compareTo(b.date));
          final lastJournal = activeEntries.last;
          lastEntry = lastJournal.date.toIso8601String();
        } catch (e) {
          print('Error getting last entry: $e');
        }
      }

      await HomeWidget.saveWidgetData<String>('journal_last_entry', lastEntry);
      await HomeWidget.saveWidgetData<int>(
        'journal_total_entries',
        activeEntries.length,
      );
      await HomeWidget.saveWidgetData<int>(
        'journal_streak',
        _calculateJournalStreak(activeEntries),
      );

      // Save List Data (Top 5)
      final entries = box.values.where((e) => !e.isDeleted).toList()
        ..sort((a, b) => b.date.compareTo(a.date));

      final topEntries = entries.take(5).map((e) {
        return {
          'title': e.title.isEmpty ? 'Entry' : e.title,
          'date': DateFormat('MMM d').format(e.date),
          'mood': _getEmojiForMood(e.mood),
          'id': e.id,
        };
      }).toList();

      await HomeWidget.saveWidgetData<String>(
        'journal_data',
        jsonEncode(topEntries),
      );

      await HomeWidget.updateWidget(androidName: 'JournalWidgetProvider');
    } catch (e) {
      print('Error syncing journal: $e');
    }
  }

  static int _calculateJournalStreak(List<dynamic> entries) {
    try {
      if (entries.isEmpty) return 0;

      // Ensure sorted by date ascending
      entries.sort((a, b) => a.date.compareTo(b.date));

      int streak = 1;
      final lastEntry = entries.last;
      DateTime lastDate = lastEntry.date;

      for (int i = entries.length - 2; i >= 0; i--) {
        try {
          final entry = entries[i];
          final entryDate = entry.date;
          final diff = lastDate.difference(entryDate).inDays;

          if (diff == 1) {
            streak++;
            lastDate = entryDate;
          } else if (diff == 0) {
            // Same day, continue
            continue;
          } else {
            break;
          }
        } catch (e) {
          break;
        }
      }
      return streak;
    } catch (e) {
      return 0;
    }
  }

  static String _getEmojiForMood(String mood) {
    switch (mood.toLowerCase()) {
      case 'happy':
        return '😊';
      case 'sad':
        return '😢';
      case 'angry':
        return '😠';
      case 'neutral':
        return '😐';
      case 'excited':
        return '🤩';
      default:
        return '📖';
    }
  }

  // --- CLIPBOARD ---
  static Future<void> syncClipboard() async {
    try {
      final box = Hive.isBoxOpen('clipboard_box')
          ? Hive.box<ClipboardItem>('clipboard_box')
          : await Hive.openBox<ClipboardItem>('clipboard_box');

      String latestContent = "No clips yet";
      if (box.isNotEmpty) {
        // Simple approach: last one added
        final latest = box.values.last;
        latestContent = latest.content;
      }

      await HomeWidget.saveWidgetData<String>(
        'latest_clip_content',
        latestContent,
      );

      // Top 5 Clips
      final clipsList = box.values.toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

      // Attempt to clean quill delta if needed, for now just passing raw or simple
      // Better extraction needed for real apps, but let's try strict plain text logic if possible
      // Actually, let's just rely on the fact that we stored json.
      // For the widget, we want PLAIN TEXT.
      // WidgetSyncService doesn't have easy Quill Access.
      // We'll trust the 'content' is json string, and we might send a placeholder "Rich Text" or try to parse locally?
      // Let's just send "Clip" for now or raw string.
      // Refined:
      final simpleClips = clipsList.take(5).map((c) {
        String text = "Clip";
        try {
          if (c.content.contains('"insert":"')) {
            final List<dynamic> delta = jsonDecode(c.content);
            text = delta.map((op) => op['insert']).join();
          } else {
            text = c.content;
          }
        } catch (_) {
          text = c.content;
        }
        return {'content': text.trim(), 'id': c.id};
      }).toList();

      await HomeWidget.saveWidgetData<String>(
        'clipboard_data',
        jsonEncode(simpleClips),
      );

      await HomeWidget.updateWidget(androidName: 'ClipboardWidgetProvider');
    } catch (e) {
      print('Error syncing clipboard: $e');
    }
  }

  // --- CALENDAR ---
  static Future<void> syncCalendar() async {
    try {
      // Placeholder for now
      await HomeWidget.saveWidgetData<String>('events_count', 'No events');
      await HomeWidget.updateWidget(androidName: 'CalendarWidgetProvider');
    } catch (e) {
      print('Error syncing calendar: $e');
    }
  }

  // --- CANVAS ---
  static Future<void> syncCanvas() async {
    try {
      final box = Hive.isBoxOpen('canvas_notes')
          ? Hive.box<CanvasNote>('canvas_notes')
          : await Hive.openBox<CanvasNote>('canvas_notes');
      final count = box.length;

      await HomeWidget.saveWidgetData<String>(
        'canvas_count',
        '$count sketches',
      );

      // Save List Data (Top 5)
      final sketches = box.values.where((e) => !e.isDeleted).toList()
        ..sort((a, b) => b.lastModified.compareTo(a.lastModified));

      final topSketches = sketches.take(5).map((e) {
        return {
          'title': e.title.isEmpty ? 'Untitled Sketch' : e.title,
          'date': DateFormat('MMM d').format(e.lastModified),
          'id': e.id,
        };
      }).toList();

      await HomeWidget.saveWidgetData<String>(
        'canvas_data',
        jsonEncode(topSketches),
      );
      await HomeWidget.updateWidget(androidName: 'CanvasWidgetProvider');
    } catch (e) {
      print('Error syncing canvas: $e');
    }
  }
}
