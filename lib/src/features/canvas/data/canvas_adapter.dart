// lib/src/features/canvas/data/canvas_adapter.dart

import 'package:hive/hive.dart';
import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'canvas_model.dart';

class DrawingStrokeAdapter extends TypeAdapter<DrawingStroke> {
  @override
  final int typeId = 10;

  @override
  DrawingStroke read(BinaryReader reader) {
    final numFields = reader.readByte();
    final fields = <int, dynamic>{};
    for (var i = 0; i < numFields; i++) {
      fields[reader.readByte()] = reader.read();
    }

    return DrawingStroke(
      points: List<double>.from(fields[0] ?? []),
      color: fields[1] as int,
      strokeWidth: (fields[2] as num?)?.toDouble() ?? 2.0,
      createdAt: fields[3] as DateTime,
      penType: fields[4] as int? ?? 0,
    );
  }

  @override
  void write(BinaryWriter writer, DrawingStroke obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.points)
      ..writeByte(1)
      ..write(obj.color)
      ..writeByte(2)
      ..write(obj.strokeWidth)
      ..writeByte(3)
      ..write(obj.createdAt)
      ..writeByte(4)
      ..write(obj.penType);
  }
}

class CanvasTextAdapter extends TypeAdapter<CanvasText> {
  @override
  final int typeId = 11;

  @override
  CanvasText read(BinaryReader reader) {
    final numFields = reader.readByte();
    final fields = <int, dynamic>{};
    for (var i = 0; i < numFields; i++) {
      fields[reader.readByte()] = reader.read();
    }

    final positionData = fields[2] as List<dynamic>? ?? [0.0, 0.0];
    return CanvasText(
      id: fields[0] as String,
      text: fields[1] as String? ?? '',
      position: Offset(
        (positionData[0] as num).toDouble(),
        (positionData[1] as num).toDouble(),
      ),
      color: fields[3] as int,
      fontSize: (fields[4] as num?)?.toDouble() ?? 20.0,
      containerWidth: (fields[5] as num?)?.toDouble() ?? 200.0,
      containerHeight: (fields[6] as num?)?.toDouble() ?? 100.0,
      bold: fields[7] as bool? ?? false,
      italic: fields[8] as bool? ?? false,
      underline: fields[9] as bool? ?? false,
    );
  }

  @override
  void write(BinaryWriter writer, CanvasText obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.text)
      ..writeByte(2)
      ..write([obj.position.dx, obj.position.dy])
      ..writeByte(3)
      ..write(obj.color)
      ..writeByte(4)
      ..write(obj.fontSize)
      ..writeByte(5)
      ..write(obj.containerWidth)
      ..writeByte(6)
      ..write(obj.containerHeight)
      ..writeByte(7)
      ..write(obj.bold)
      ..writeByte(8)
      ..write(obj.italic)
      ..writeByte(9)
      ..write(obj.underline);
  }
}

class CanvasPageAdapter extends TypeAdapter<CanvasPage> {
  @override
  final int typeId = 14;

  @override
  CanvasPage read(BinaryReader reader) {
    final numFields = reader.readByte();
    final fields = <int, dynamic>{};
    for (var i = 0; i < numFields; i++) {
      fields[reader.readByte()] = reader.read();
    }

    return CanvasPage(
      strokes: (fields[0] as List?)?.cast<DrawingStroke>() ?? [],
      textElements: (fields[1] as List?)?.cast<CanvasText>() ?? [],
      backgroundImageBytes: fields[2] as Uint8List?,
    );
  }

  @override
  void write(BinaryWriter writer, CanvasPage obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.strokes)
      ..writeByte(1)
      ..write(obj.textElements)
      ..writeByte(2)
      ..write(obj.backgroundImageBytes);
  }
}

class CanvasNoteAdapter extends TypeAdapter<CanvasNote> {
  @override
  final int typeId = 15;

  @override
  CanvasNote read(BinaryReader reader) {
    final numFields = reader.readByte();
    final fields = <int, dynamic>{};
    for (var i = 0; i < numFields; i++) {
      fields[reader.readByte()] = reader.read();
    }

    return CanvasNote(
      id: fields[0] as String,
      title: fields[1] as String,
      folderId: fields[2] as String,
      description: fields[3] as String?,
      pages: (fields[4] as List?)?.cast<CanvasPage>() ?? [CanvasPage()],
      createdAt: fields[5] as DateTime,
      lastModified: fields[6] as DateTime,
      isFavorite: fields[7] as bool? ?? false,
      isDeleted: fields[8] as bool? ?? false,
      deletedAt: fields[9] as DateTime?,
      thumbnailPath: fields[10] as String?,
      backgroundColor: Color(fields[11] as int? ?? Colors.white.value),
      horizontalScroll: fields[12] as bool? ?? false,
    );
  }

  @override
  void write(BinaryWriter writer, CanvasNote obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.folderId)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.pages)
      ..writeByte(5)
      ..write(obj.createdAt)
      ..writeByte(6)
      ..write(obj.lastModified)
      ..writeByte(7)
      ..write(obj.isFavorite)
      ..writeByte(8)
      ..write(obj.isDeleted)
      ..writeByte(9)
      ..write(obj.deletedAt)
      ..writeByte(10)
      ..write(obj.thumbnailPath)
      ..writeByte(11)
      ..write(obj.backgroundColor.value)
      ..writeByte(12)
      ..write(obj.horizontalScroll);
  }
}

class CanvasFolderAdapter extends TypeAdapter<CanvasFolder> {
  @override
  final int typeId = 12;

  @override
  CanvasFolder read(BinaryReader reader) {
    final numFields = reader.readByte();
    final fields = <int, dynamic>{};
    for (var i = 0; i < numFields; i++) {
      fields[reader.readByte()] = reader.read();
    }

    return CanvasFolder(
      id: fields[0] as String,
      name: fields[1] as String,
      parentFolderId: fields[2] as String?,
      color: Color(fields[3] as int? ?? 0xFF64B5F6),
      createdAt: fields[4] as DateTime,
      lastModified: fields[5] as DateTime,
      isDeleted: fields[6] as bool? ?? false,
      deletedAt: fields[7] as DateTime?,
      sortIndex: fields[8] as int? ?? 0,
    );
  }

  @override
  void write(BinaryWriter writer, CanvasFolder obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.parentFolderId)
      ..writeByte(3)
      ..write(obj.color.value)
      ..writeByte(4)
      ..write(obj.createdAt)
      ..writeByte(5)
      ..write(obj.lastModified)
      ..writeByte(6)
      ..write(obj.isDeleted)
      ..writeByte(7)
      ..write(obj.deletedAt)
      ..writeByte(8)
      ..write(obj.sortIndex);
  }
}

// --- Database Service ---
class CanvasDatabase {
  static final CanvasDatabase _instance = CanvasDatabase._internal();

  factory CanvasDatabase() => _instance;

  CanvasDatabase._internal();

  static const String notesBoxName = 'canvas_notes';
  static const String foldersBoxName = 'canvas_folders';

  late Box<CanvasNote> _notesBox;
  late Box<CanvasFolder> _foldersBox;

  Future<void> init() async {
    // Register all adapters
    if (!Hive.isAdapterRegistered(10))
      Hive.registerAdapter(DrawingStrokeAdapter());
    if (!Hive.isAdapterRegistered(11))
      Hive.registerAdapter(CanvasTextAdapter());
    if (!Hive.isAdapterRegistered(12))
      Hive.registerAdapter(CanvasFolderAdapter());
    if (!Hive.isAdapterRegistered(14))
      Hive.registerAdapter(CanvasPageAdapter());
    if (!Hive.isAdapterRegistered(15))
      Hive.registerAdapter(CanvasNoteAdapter());

    _notesBox = await Hive.openBox<CanvasNote>(notesBoxName);
    _foldersBox = await Hive.openBox<CanvasFolder>(foldersBoxName);

    // Create default folder if none exists
    if (_foldersBox.isEmpty) {
      final defaultFolder = CanvasFolder(
        id: 'default',
        name: 'My Sketches',
        color: const Color(0xFF4DB6AC),
      );
      await saveFolder(defaultFolder);
    }
  }

  // --- Note Operations ---
  Future<void> saveNote(CanvasNote note) async {
    note.lastModified = DateTime.now();
    await _notesBox.put(note.id, note);
  }

  CanvasNote? getNote(String id) => _notesBox.get(id);

  List<CanvasNote> getNotesByFolder(String folderId) {
    return _notesBox.values
        .where((n) => n.folderId == folderId && !n.isDeleted)
        .toList();
  }

  List<CanvasNote> getFavoriteNotes() {
    return _notesBox.values.where((n) => n.isFavorite && !n.isDeleted).toList();
  }

  Future<void> deleteNote(String id) async {
    final note = _notesBox.get(id);
    if (note != null) {
      note.isDeleted = true;
      note.deletedAt = DateTime.now();
      await _notesBox.put(id, note);
    }
  }

  Future<void> permanentlyDeleteNote(String id) async {
    await _notesBox.delete(id);
  }

  // --- Folder Operations ---
  Future<void> saveFolder(CanvasFolder folder) async {
    folder.lastModified = DateTime.now();
    await _foldersBox.put(folder.id, folder);
  }

  CanvasFolder? getFolder(String id) => _foldersBox.get(id);

  List<CanvasFolder> getAllFolders() {
    return _foldersBox.values.where((f) => !f.isDeleted).toList();
  }

  List<CanvasFolder> getRootFolders() {
    return _foldersBox.values
        .where((f) => f.parentFolderId == null && !f.isDeleted)
        .toList();
  }

  List<CanvasFolder> getSubFolders(String parentId) {
    return _foldersBox.values
        .where((f) => f.parentFolderId == parentId && !f.isDeleted)
        .toList();
  }

  Future<void> deleteFolder(String id) async {
    final folder = _foldersBox.get(id);
    if (folder != null) {
      folder.isDeleted = true;
      folder.deletedAt = DateTime.now();
      await _foldersBox.put(id, folder);

      // Soft delete all notes in this folder
      final notesInFolder = getNotesByFolder(id);
      for (var note in notesInFolder) {
        await deleteNote(note.id);
      }
    }
  }

  Future<void> permanentlyDeleteFolder(String id) async {
    await _foldersBox.delete(id);
  }

  // --- Statistics ---
  int getNoteCount(String folderId) {
    return _notesBox.values
        .where((n) => n.folderId == folderId && !n.isDeleted)
        .length;
  }

  int getTotalNotes() {
    return _notesBox.values.where((n) => !n.isDeleted).length;
  }
}
