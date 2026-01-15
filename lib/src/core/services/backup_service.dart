import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
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
import '../../features/expenses/data/expense_model.dart';
import '../../features/journal/data/journal_model.dart';
import '../../features/clipboard/data/clipboard_model.dart';
import '../../features/canvas/data/canvas_model.dart';

class BackupService {

  // ==============================================================================
  // SECTION 1: CANVAS SERIALIZATION HELPERS (Complex Object Mapping)
  // ==============================================================================

  static Map<String, dynamic> _canvasFolderToMap(CanvasFolder folder) {
    return {
      'id': folder.id,
      'name': folder.name,
      'parentFolderId': folder.parentFolderId,
      'color': folder.color.value,
      'createdAt': folder.createdAt.toIso8601String(),
      'lastModified': folder.lastModified.toIso8601String(),
      'isDeleted': folder.isDeleted,
      'deletedAt': folder.deletedAt?.toIso8601String(),
      'sortIndex': folder.sortIndex,
    };
  }

  static CanvasFolder _mapToCanvasFolder(Map<String, dynamic> map) {
    return CanvasFolder(
      id: map['id'],
      name: map['name'],
      parentFolderId: map['parentFolderId'],
      color: Color(map['color']),
      createdAt: DateTime.parse(map['createdAt']),
      lastModified: DateTime.parse(map['lastModified']),
      isDeleted: map['isDeleted'] ?? false,
      deletedAt: map['deletedAt'] != null ? DateTime.parse(map['deletedAt']) : null,
      sortIndex: map['sortIndex'] ?? 0,
    );
  }

  static Map<String, dynamic> _canvasNoteToMap(CanvasNote note) {
    return {
      'id': note.id,
      'title': note.title,
      'folderId': note.folderId,
      'description': note.description,
      'createdAt': note.createdAt.toIso8601String(),
      'lastModified': note.lastModified.toIso8601String(),
      'isFavorite': note.isFavorite,
      'isDeleted': note.isDeleted,
      'deletedAt': note.deletedAt?.toIso8601String(),
      'thumbnailPath': note.thumbnailPath,
      'backgroundColor': note.backgroundColor.value,
      'horizontalScroll': note.horizontalScroll,
      // Nested Page Serialization
      'pages': note.pages.map((p) => {
        // Serialize Strokes
        'strokes': p.strokes.map((s) => {
          'points': s.points,
          'color': s.color,
          'strokeWidth': s.strokeWidth,
          'createdAt': s.createdAt.toIso8601String(),
          'penType': s.penType,
        }).toList(),
        // Serialize Text Elements
        'textElements': p.textElements.map((t) => {
          'id': t.id,
          'text': t.text,
          'dx': t.position.dx, // Deconstruct Offset
          'dy': t.position.dy, // Deconstruct Offset
          'color': t.color,
          'fontSize': t.fontSize,
          'containerWidth': t.containerWidth,
          'containerHeight': t.containerHeight,
          'bold': t.bold,
          'italic': t.italic,
          'underline': t.underline,
        }).toList(),
      }).toList(),
    };
  }

  static CanvasNote _mapToCanvasNote(Map<String, dynamic> map) {
    final pagesList = (map['pages'] as List).map((pMap) {
      // 1. Parse Strokes
      final strokes = (pMap['strokes'] as List).map((sMap) {
        return DrawingStroke(
          points: List<double>.from(sMap['points']),
          color: sMap['color'],
          strokeWidth: (sMap['strokeWidth'] as num).toDouble(),
          createdAt: DateTime.parse(sMap['createdAt']),
          penType: sMap['penType'] ?? 0,
        );
      }).toList();

      // 2. Parse Text
      final texts = (pMap['textElements'] as List).map((tMap) {
        return CanvasText(
          id: tMap['id'],
          text: tMap['text'],
          position: Offset((tMap['dx'] as num).toDouble(), (tMap['dy'] as num).toDouble()), // Reconstruct Offset
          color: tMap['color'],
          fontSize: (tMap['fontSize'] as num).toDouble(),
          containerWidth: (tMap['containerWidth'] as num).toDouble(),
          containerHeight: (tMap['containerHeight'] as num).toDouble(),
          bold: tMap['bold'] ?? false,
          italic: tMap['italic'] ?? false,
          underline: tMap['underline'] ?? false,
        );
      }).toList();

      return CanvasPage(strokes: strokes, textElements: texts);
    }).toList();

    return CanvasNote(
      id: map['id'],
      title: map['title'],
      folderId: map['folderId'],
      description: map['description'],
      pages: pagesList,
      createdAt: DateTime.parse(map['createdAt']),
      lastModified: DateTime.parse(map['lastModified']),
      isFavorite: map['isFavorite'] ?? false,
      isDeleted: map['isDeleted'] ?? false,
      deletedAt: map['deletedAt'] != null ? DateTime.parse(map['deletedAt']) : null,
      thumbnailPath: map['thumbnailPath'],
      backgroundColor: Color(map['backgroundColor']),
      horizontalScroll: map['horizontalScroll'] ?? false,
    );
  }

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

      // 3. Process Canvas (Complex serialization)
      // Ensure boxes are open
      if (!Hive.isBoxOpen('canvas_notes')) await Hive.openBox<CanvasNote>('canvas_notes');
      if (!Hive.isBoxOpen('canvas_folders')) await Hive.openBox<CanvasFolder>('canvas_folders');

      final canvasNotesList = Hive.box<CanvasNote>('canvas_notes')
          .values.map((n) => _canvasNoteToMap(n)).toList();

      final canvasFoldersList = Hive.box<CanvasFolder>('canvas_folders')
          .values.map((f) => _canvasFolderToMap(f)).toList();

      // 4. Assemble Final JSON Data
      final Map<String, dynamic> backupData = {
        'version': 1.4,
        'timestamp': DateTime.now().toIso8601String(),
        // Simple Hive Boxes
        'todos': Hive.isBoxOpen('todos_box') ? Hive.box<Todo>('todos_box').values.map((e) => e.toJson()).toList() : [],
        'expenses': Hive.isBoxOpen('expenses_box') ? Hive.box<Expense>('expenses_box').values.map((e) => e.toJson()).toList() : [],
        'clipboard': Hive.isBoxOpen('clipboard_box') ? Hive.box<ClipboardItem>('clipboard_box').values.map((e) => e.toJson()).toList() : [],
        // Processed Lists
        'notes': notesList,
        'journal': journalList,
        // Canvas Data
        'canvas_notes': canvasNotesList,
        'canvas_folders': canvasFoldersList,
      };

      // 5. Write to File
      final String jsonString = jsonEncode(backupData);
      final tempDir = await getTemporaryDirectory();
      final dateStr = DateFormat('yyyyMMdd_HHmm').format(DateTime.now());
      final file = File('${tempDir.path}/CopyClip_Backup_$dateStr.json');

      await file.writeAsString(jsonString);

      // 6. Share File
      if (await file.exists()) {
        await Share.shareXFiles([XFile(file.path)], text: 'CopyClip Full Backup (v1.4)');
      }
    } catch (e) {
      debugPrint("Global Backup Error: $e");
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Backup Failed: $e")));
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
          itemMap['content'] = await _processContentForImport(itemMap['content']);
          final note = Note.fromJson(itemMap);
          if (!box.containsKey(note.id)) {
            await box.put(note.id, note);
            addedCount++;
          }
        }
      }

      // 3. Restore Journal (with Image Processing)
      if (data.containsKey('journal')) {
        if (!Hive.isBoxOpen('journal_box')) await Hive.openBox<JournalEntry>('journal_box');
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

      // 4. Restore Simple Data (Todos, Expenses, Clipboard)
      if (data.containsKey('todos')) {
        if (!Hive.isBoxOpen('todos_box')) await Hive.openBox<Todo>('todos_box');
        final box = Hive.box<Todo>('todos_box');
        for (var itemMap in data['todos']) {
          final obj = Todo.fromJson(itemMap);
          if (!box.containsKey(obj.id)) { await box.put(obj.id, obj); addedCount++; }
        }
      }

      if (data.containsKey('expenses')) {
        if (!Hive.isBoxOpen('expenses_box')) await Hive.openBox<Expense>('expenses_box');
        final box = Hive.box<Expense>('expenses_box');
        for (var itemMap in data['expenses']) {
          final obj = Expense.fromJson(itemMap);
          if (!box.containsKey(obj.id)) { await box.put(obj.id, obj); addedCount++; }
        }
      }

      if (data.containsKey('clipboard')) {
        if (!Hive.isBoxOpen('clipboard_box')) await Hive.openBox<ClipboardItem>('clipboard_box');
        final box = Hive.box<ClipboardItem>('clipboard_box');
        for (var itemMap in data['clipboard']) {
          final obj = ClipboardItem.fromJson(itemMap);
          if (!box.containsKey(obj.id)) { await box.put(obj.id, obj); addedCount++; }
        }
      }

      // 5. Restore Canvas Folders
      if (data.containsKey('canvas_folders')) {
        if (!Hive.isBoxOpen('canvas_folders')) await Hive.openBox<CanvasFolder>('canvas_folders');
        final box = Hive.box<CanvasFolder>('canvas_folders');
        for (var itemMap in data['canvas_folders']) {
          final folder = _mapToCanvasFolder(itemMap);
          if (!box.containsKey(folder.id)) {
            await box.put(folder.id, folder);
            addedCount++;
          }
        }
      }

      // 6. Restore Canvas Notes
      if (data.containsKey('canvas_notes')) {
        if (!Hive.isBoxOpen('canvas_notes')) await Hive.openBox<CanvasNote>('canvas_notes');
        final box = Hive.box<CanvasNote>('canvas_notes');
        for (var itemMap in data['canvas_notes']) {
          final note = _mapToCanvasNote(itemMap);
          if (!box.containsKey(note.id)) {
            await box.put(note.id, note);
            addedCount++;
          }
        }
      }

      return addedCount;
    } catch (e) {
      debugPrint("Global Restore Error: $e");
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Restore Failed: $e")));
      }
      rethrow;
    }
  }
}