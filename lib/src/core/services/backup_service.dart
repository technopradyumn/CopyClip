import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:intl/intl.dart';

// --- IMPORT YOUR MODELS ---
// Update these paths to match your project structure
import '../../features/notes/data/note_model.dart';
import '../../features/todos/data/todo_model.dart';
import '../../features/journal/data/journal_model.dart';
import '../../features/clipboard/data/clipboard_model.dart';

class BackupService {
  // ==============================================================================
  // SECTION 2: IMAGE PROCESSING (For Quill Editors)
  // ==============================================================================

  /// Converts local file paths in Delta JSON to Base64 strings for portability
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
            if (path.startsWith('http') || path.startsWith('data:image')) {
              continue;
            }

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

  /// Converts Base64 strings in Delta JSON back to local files
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

              final fileName =
                  'img_${DateTime.now().microsecondsSinceEpoch}.png';
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

  // ==============================================================================
  // SECTION 3: CORE BACKUP FUNCTION
  // ==============================================================================

  static Future<void> createBackup(BuildContext context) async {
    try {
      // 1. Process Notes (Hive -> Map + Image Processing)
      final List<Map<String, dynamic>> notesList = [];
      if (Hive.isBoxOpen('notes_box')) {
        final notesBox = Hive.box<Note>('notes_box');
        for (var note in notesBox.values) {
          final Map<String, dynamic> noteMap = note.toJson();
          noteMap['content'] = await _processContentForExport(note.content);
          notesList.add(noteMap);
        }
      }

      // 2. Process Journal (Hive -> Map + Image Processing)
      final List<Map<String, dynamic>> journalList = [];
      if (Hive.isBoxOpen('journal_box')) {
        final journalBox = Hive.box<JournalEntry>('journal_box');
        for (var entry in journalBox.values) {
          final Map<String, dynamic> entryMap = entry.toJson();
          entryMap['content'] = await _processContentForExport(entry.content);
          journalList.add(entryMap);
        }
      }

      // 4. Assemble Final JSON Data
      final Map<String, dynamic> backupData = {
        'version': 1.4,
        'timestamp': DateTime.now().toIso8601String(),
        // Simple Hive Boxes
        'todos': Hive.isBoxOpen('todos_box')
            ? Hive.box<Todo>('todos_box').values.map((e) => e.toJson()).toList()
            : [],
        'clipboard': Hive.isBoxOpen('clipboard_box')
            ? Hive.box<ClipboardItem>(
                'clipboard_box',
              ).values.map((e) => e.toJson()).toList()
            : [],
        // Processed Lists
        'notes': notesList,
        'journal': journalList,
      };

      // 5. Write to File
      final String jsonString = jsonEncode(backupData);
      final tempDir = await getTemporaryDirectory();
      final dateStr = DateFormat('yyyyMMdd_HHmm').format(DateTime.now());
      final file = File('${tempDir.path}/CopyClip_Backup_$dateStr.json');

      await file.writeAsString(jsonString);

      // 6. Share File
      if (await file.exists()) {
        await Share.shareXFiles([
          XFile(file.path),
        ], text: 'CopyClip Full Backup (v1.4)');
      }
    } catch (e) {
      debugPrint("Global Backup Error: $e");
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Backup Failed: $e")));
      }
      rethrow;
    }
  }

  // ==============================================================================
  // SECTION 4: CORE RESTORE FUNCTION
  // ==============================================================================

  static Future<int> restoreBackup(BuildContext context) async {
    try {
      // 1. Pick File
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
      );

      if (result == null || result.files.single.path == null) return 0;

      final file = File(result.files.single.path!);
      final String content = await file.readAsString();
      final Map<String, dynamic> data = jsonDecode(content);
      int addedCount = 0;

      // 2. Restore Notes (with Image Processing)
      if (data.containsKey('notes')) {
        if (!Hive.isBoxOpen('notes_box')) await Hive.openBox<Note>('notes_box');
        final box = Hive.box<Note>('notes_box');
        for (var itemMap in data['notes']) {
          itemMap['content'] = await _processContentForImport(
            itemMap['content'],
          );
          final note = Note.fromJson(itemMap);
          if (!box.containsKey(note.id)) {
            await box.put(note.id, note);
            addedCount++;
          }
        }
      }

      // 3. Restore Journal (with Image Processing)
      if (data.containsKey('journal')) {
        if (!Hive.isBoxOpen('journal_box')) {
          await Hive.openBox<JournalEntry>('journal_box');
        }
        final box = Hive.box<JournalEntry>('journal_box');
        for (var itemMap in data['journal']) {
          itemMap['content'] = await _processContentForImport(
            itemMap['content'],
          );
          final entry = JournalEntry.fromJson(itemMap);
          if (!box.containsKey(entry.id)) {
            await box.put(entry.id, entry);
            addedCount++;
          }
        }
      }

      // 4. Restore Simple Data (Todos, Expenses, Clipboard)
      if (data.containsKey('todos')) {
        if (!Hive.isBoxOpen('todos_box')) await Hive.openBox<Todo>('todos_box');
        final box = Hive.box<Todo>('todos_box');
        for (var itemMap in data['todos']) {
          final obj = Todo.fromJson(itemMap);
          if (!box.containsKey(obj.id)) {
            await box.put(obj.id, obj);
            addedCount++;
          }
        }
      }

      if (data.containsKey('clipboard')) {
        if (!Hive.isBoxOpen('clipboard_box')) {
          await Hive.openBox<ClipboardItem>('clipboard_box');
        }
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
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Restore Failed: $e")));
      }
      rethrow;
    }
  }
}
