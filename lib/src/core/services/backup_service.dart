import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:intl/intl.dart';

// Import all your Models
import '../../features/notes/data/note_model.dart';
import '../../features/todos/data/todo_model.dart';
import '../../features/expenses/data/expense_model.dart';
import '../../features/journal/data/journal_model.dart';
import '../../features/clipboard/data/clipboard_model.dart';

class BackupService {

  /// --- IMAGE PROCESSING: EXPORT ---
  static Future<String> _processContentForExport(String content) async {
    if (content.isEmpty || !content.startsWith('[')) return content;
    try {
      final List<dynamic> delta = jsonDecode(content);
      for (var op in delta) {
        if (op is Map && op.containsKey('insert') && op['insert'] is Map) {
          final insert = op['insert'] as Map;
          if (insert.containsKey('image')) {
            final String path = insert['image'].toString();

            // Skip if already base64 or a network URL
            if (path.startsWith('http') || path.startsWith('data:image')) continue;

            final file = File(path);
            if (await file.exists()) {
              final bytes = await file.readAsBytes();
              insert['image'] = 'data:image/png;base64,${base64Encode(bytes)}';
            }
          }
        }
      }
      return jsonEncode(delta);
    } catch (e) {
      debugPrint("Export Processing Error: $e");
      return content;
    }
  }

  /// --- IMAGE PROCESSING: IMPORT ---
  static Future<String> _processContentForImport(String content) async {
    if (content.isEmpty || !content.startsWith('[')) return content;
    try {
      final List<dynamic> delta = jsonDecode(content);
      final directory = await getApplicationDocumentsDirectory();

      // Create a specific folder for restored images
      final imagesDir = Directory('${directory.path}/restored_media');
      if (!await imagesDir.exists()) await imagesDir.create();

      for (var op in delta) {
        if (op is Map && op.containsKey('insert') && op['insert'] is Map) {
          final insert = op['insert'] as Map;
          if (insert.containsKey('image')) {
            final String imageVal = insert['image'].toString();

            if (imageVal.startsWith('data:image')) {
              final base64Data = imageVal.split(',').last;
              final bytes = base64Decode(base64Data);

              final fileName = 'img_${DateTime.now().microsecondsSinceEpoch}.png';
              final file = File('${imagesDir.path}/$fileName');
              await file.writeAsBytes(bytes);

              insert['image'] = file.path;
            }
          }
        }
      }
      return jsonEncode(delta);
    } catch (e) {
      debugPrint("Import Processing Error: $e");
      return content;
    }
  }

  /// --- CREATE BACKUP (EXPORT) ---
  static Future<void> createBackup(BuildContext context) async {
    try {
      // 1. Process Notes
      final List<Map<String, dynamic>> notesList = [];
      final notesBox = Hive.box<Note>('notes_box');
      for (var note in notesBox.values) {
        final Map<String, dynamic> noteMap = note.toJson();
        noteMap['content'] = await _processContentForExport(note.content);
        notesList.add(noteMap);
      }

      // 2. Process Journal
      final List<Map<String, dynamic>> journalList = [];
      final journalBox = Hive.box<JournalEntry>('journal_box');
      for (var entry in journalBox.values) {
        final Map<String, dynamic> entryMap = entry.toJson();
        entryMap['content'] = await _processContentForExport(entry.content);
        journalList.add(entryMap);
      }

      // 3. Assemble JSON
      final Map<String, dynamic> backupData = {
        'version': 1.3,
        'timestamp': DateTime.now().toIso8601String(),
        'notes': notesList,
        'journal': journalList,
        'todos': Hive.box<Todo>('todos_box').values.map((e) => e.toJson()).toList(),
        'expenses': Hive.box<Expense>('expenses_box').values.map((e) => e.toJson()).toList(),
        'clipboard': Hive.box<ClipboardItem>('clipboard_box').values.map((e) => e.toJson()).toList(),
      };

      final String jsonString = jsonEncode(backupData);
      final tempDir = await getTemporaryDirectory();
      final dateStr = DateFormat('yyyyMMdd_HHmm').format(DateTime.now());
      final file = File('${tempDir.path}/CopyClip_Backup_$dateStr.json');

      await file.writeAsString(jsonString);

      if (await file.exists()) {
        await Share.shareXFiles([XFile(file.path)], text: 'CopyClip Full Backup');
      }
    } catch (e) {
      debugPrint("Global Backup Error: $e");
      rethrow;
    }
  }

  /// --- RESTORE BACKUP (IMPORT) ---
  static Future<int> restoreBackup(BuildContext context) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
      );

      if (result == null || result.files.single.path == null) return 0;

      final file = File(result.files.single.path!);
      final String content = await file.readAsString();
      final Map<String, dynamic> data = jsonDecode(content);
      int addedCount = 0;

      // RESTORE NOTES
      if (data.containsKey('notes')) {
        final box = Hive.box<Note>('notes_box');
        for (var itemMap in data['notes']) {
          itemMap['content'] = await _processContentForImport(itemMap['content']);
          final note = Note.fromJson(itemMap);
          if (!box.containsKey(note.id)) {
            await box.put(note.id, note);
            addedCount++;
          }
        }
      }

      // RESTORE JOURNAL
      if (data.containsKey('journal')) {
        final box = Hive.box<JournalEntry>('journal_box');
        for (var itemMap in data['journal']) {
          itemMap['content'] = await _processContentForImport(itemMap['content']);
          final entry = JournalEntry.fromJson(itemMap);
          if (!box.containsKey(entry.id)) {
            await box.put(entry.id, entry);
            addedCount++;
          }
        }
      }

      // RESTORE OTHERS (Direct)
      final otherModules = {
        'todos': (json) => Todo.fromJson(json),
        'expenses': (json) => Expense.fromJson(json),
        'clipboard': (json) => ClipboardItem.fromJson(json),
      };

      // --- RESTORE TODOS ---
      if (data.containsKey('todos')) {
        final box = Hive.box<Todo>('todos_box');
        for (var itemMap in data['todos']) {
          final obj = Todo.fromJson(itemMap);
          if (!box.containsKey(obj.id)) {
            await box.put(obj.id, obj);
            addedCount++;
          }
        }
      }

      // --- RESTORE EXPENSES ---
      if (data.containsKey('expenses')) {
        final box = Hive.box<Expense>('expenses_box');
        for (var itemMap in data['expenses']) {
          final obj = Expense.fromJson(itemMap);
          if (!box.containsKey(obj.id)) {
            await box.put(obj.id, obj);
            addedCount++;
          }
        }
      }

      // --- RESTORE CLIPBOARD ---
      if (data.containsKey('clipboard')) {
        final box = Hive.box<ClipboardItem>('clipboard_box');
        for (var itemMap in data['clipboard']) {
          final obj = ClipboardItem.fromJson(itemMap);
          if (!box.containsKey(obj.id)) {
            await box.put(obj.id, obj);
            addedCount++;
          }
        }
      }

      return addedCount;
    } catch (e) {
      debugPrint("Global Restore Error: $e");
      rethrow;
    }
  }
}