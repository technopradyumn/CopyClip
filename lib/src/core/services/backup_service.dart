import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:intl/intl.dart';

// Import Models
import '../../features/notes/data/note_model.dart';
import '../../features/todos/data/todo_model.dart';
import '../../features/expenses/data/expense_model.dart';
import '../../features/journal/data/journal_model.dart';
import '../../features/clipboard/data/clipboard_model.dart';

class BackupService {

  // --- EXPORT DATA ---
  static Future<void> createBackup(BuildContext context) async {
    try {
      final backupData = {
        'version': 1,
        'timestamp': DateTime.now().toIso8601String(),
        'notes': Hive.box<Note>('notes_box').values.map((e) => e.toJson()).toList(),
        'todos': Hive.box<Todo>('todos_box').values.map((e) => e.toJson()).toList(),
        'expenses': Hive.box<Expense>('expenses_box').values.map((e) => e.toJson()).toList(),
        'journal': Hive.box<JournalEntry>('journal_box').values.map((e) => e.toJson()).toList(),
        'clipboard': Hive.box<ClipboardItem>('clipboard_box').values.map((e) => e.toJson()).toList(),
      };

      final jsonString = jsonEncode(backupData);
      final directory = await getTemporaryDirectory();
      final dateStr = DateFormat('yyyyMMdd_HHmm').format(DateTime.now());
      final fileName = 'CopyClip_Backup_$dateStr.json';
      final file = File('${directory.path}/$fileName');

      await file.writeAsString(jsonString);
      await Share.shareXFiles([XFile(file.path)], text: 'CopyClip Backup File');

    } catch (e) {
      throw Exception("Export failed: $e");
    }
  }

  // --- IMPORT DATA (APPEND MODE) ---
  static Future<int> restoreBackup(BuildContext context) async {
    try {
      // 1. Pick File
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
      );

      if (result != null && result.files.single.path != null) {
        final file = File(result.files.single.path!);
        final jsonString = await file.readAsString();
        final Map<String, dynamic> data = jsonDecode(jsonString);

        int addedCount = 0;

        // Helper to add if not exists
        Future<void> addIfNotExists<T>(Box<T> box, T item, String id) async {
          if (!box.containsKey(id)) {
            await box.put(id, item);
            addedCount++;
          }
        }

        // Notes
        if (data['notes'] != null) {
          final box = Hive.box<Note>('notes_box');
          for (var item in data['notes']) {
            final obj = Note.fromJson(item);
            await addIfNotExists(box, obj, obj.id);
          }
        }

        // Todos
        if (data['todos'] != null) {
          final box = Hive.box<Todo>('todos_box');
          for (var item in data['todos']) {
            final obj = Todo.fromJson(item);
            await addIfNotExists(box, obj, obj.id);
          }
        }

        // Expenses
        if (data['expenses'] != null) {
          final box = Hive.box<Expense>('expenses_box');
          for (var item in data['expenses']) {
            final obj = Expense.fromJson(item);
            await addIfNotExists(box, obj, obj.id);
          }
        }

        // Journal
        if (data['journal'] != null) {
          final box = Hive.box<JournalEntry>('journal_box');
          for (var item in data['journal']) {
            final obj = JournalEntry.fromJson(item);
            await addIfNotExists(box, obj, obj.id);
          }
        }

        // Clipboard
        if (data['clipboard'] != null) {
          final box = Hive.box<ClipboardItem>('clipboard_box');
          for (var item in data['clipboard']) {
            final obj = ClipboardItem.fromJson(item);
            await addIfNotExists(box, obj, obj.id);
          }
        }

        return addedCount; // Return number of new items added
      } else {
        throw Exception("Selection cancelled");
      }
    } catch (e) {
      throw Exception("Import failed: $e");
    }
  }
}