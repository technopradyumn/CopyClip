import 'package:hive/hive.dart';
import 'package:flutter/material.dart';

// Drawing Stroke Adapter
class DrawingStrokeAdapter extends TypeAdapter<DrawingStroke> {
  @override
  final int typeId = 10;

  @override
  DrawingStroke read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{};
    for (var i = 0; i < numOfFields; i++) {
      final fieldId = reader.readByte();
      fields[fieldId] = reader.read();
    }

    return DrawingStroke(
      points: List<double>.from(fields[0] as List),
      color: fields[1] as int,
      strokeWidth: fields[2] as double,
      createdAt: fields[3] as DateTime,
      penType: fields[4] as int? ?? 0, // Add penType with default
    );
  }

  @override
  void write(BinaryWriter writer, DrawingStroke obj) {
    writer.writeByte(5); // Changed from 4 to 5
    writer.writeByte(0);
    writer.write(obj.points);
    writer.writeByte(1);
    writer.write(obj.color);
    writer.writeByte(2);
    writer.write(obj.strokeWidth);
    writer.writeByte(3);
    writer.write(obj.createdAt);
    writer.writeByte(4);
    writer.write(obj.penType); // Add penType serialization
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is DrawingStrokeAdapter &&
              runtimeType == other.runtimeType &&
              typeId == other.typeId;
}

// Canvas Note Adapter
class CanvasNoteAdapter extends TypeAdapter<CanvasNote> {
  @override
  final int typeId = 11;

  @override
  CanvasNote read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{};
    for (var i = 0; i < numOfFields; i++) {
      final fieldId = reader.readByte();
      fields[fieldId] = reader.read();
    }

    return CanvasNote(
      id: fields[0] as String,
      title: fields[1] as String,
      folderId: fields[2] as String,
      description: fields[3] as String?,
      strokes: (fields[4] as List?)?.cast<DrawingStroke>() ?? [],
      textBlocks: (fields[5] as List?)?.cast<String>() ?? [],
      createdAt: fields[6] as DateTime,
      lastModified: fields[7] as DateTime,
      isFavorite: fields[8] as bool,
      isDeleted: fields[9] as bool,
      deletedAt: fields[10] as DateTime?,
      thumbnailPath: fields[11] as String?,
      backgroundColor: Color(fields[12] as int? ?? Colors.white.value),
    );
  }

  @override
  void write(BinaryWriter writer, CanvasNote obj) {
    writer.writeByte(13);
    writer.writeByte(0);
    writer.write(obj.id);
    writer.writeByte(1);
    writer.write(obj.title);
    writer.writeByte(2);
    writer.write(obj.folderId);
    writer.writeByte(3);
    writer.write(obj.description);
    writer.writeByte(4);
    writer.write(obj.strokes);
    writer.writeByte(5);
    writer.write(obj.textBlocks);
    writer.writeByte(6);
    writer.write(obj.createdAt);
    writer.writeByte(7);
    writer.write(obj.lastModified);
    writer.writeByte(8);
    writer.write(obj.isFavorite);
    writer.writeByte(9);
    writer.write(obj.isDeleted);
    writer.writeByte(10);
    writer.write(obj.deletedAt);
    writer.writeByte(11);
    writer.write(obj.thumbnailPath);
    writer.writeByte(12);
    writer.write(obj.backgroundColor.value);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is CanvasNoteAdapter &&
              runtimeType == other.runtimeType &&
              typeId == other.typeId;
}

// Canvas Folder Adapter
class CanvasFolderAdapter extends TypeAdapter<CanvasFolder> {
  @override
  final int typeId = 12;

  @override
  CanvasFolder read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{};
    for (var i = 0; i < numOfFields; i++) {
      final fieldId = reader.readByte();
      fields[fieldId] = reader.read();
    }

    return CanvasFolder(
      id: fields[0] as String,
      name: fields[1] as String,
      parentFolderId: fields[2] as String?,
      color: Color(fields[3] as int? ?? 0xFF64B5F6),
      createdAt: fields[4] as DateTime,
      lastModified: fields[5] as DateTime,
      isDeleted: fields[6] as bool,
      deletedAt: fields[7] as DateTime?,
      sortIndex: fields[8] as int,
    );
  }

  @override
  void write(BinaryWriter writer, CanvasFolder obj) {
    writer.writeByte(9);
    writer.writeByte(0);
    writer.write(obj.id);
    writer.writeByte(1);
    writer.write(obj.name);
    writer.writeByte(2);
    writer.write(obj.parentFolderId);
    writer.writeByte(3);
    writer.write(obj.color.value);
    writer.writeByte(4);
    writer.write(obj.createdAt);
    writer.writeByte(5);
    writer.write(obj.lastModified);
    writer.writeByte(6);
    writer.write(obj.isDeleted);
    writer.writeByte(7);
    writer.write(obj.deletedAt);
    writer.writeByte(8);
    writer.write(obj.sortIndex);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is CanvasFolderAdapter &&
              runtimeType == other.runtimeType &&
              typeId == other.typeId;
}

// --- Stroke Model for Drawing ---
class DrawingStroke {
  List<double> points;
  int color;
  double strokeWidth;
  DateTime createdAt;
  int penType; // Add penType field

  DrawingStroke({
    required this.points,
    required this.color,
    this.strokeWidth = 2.0,
    DateTime? createdAt,
    this.penType = 0, // Default to ballpoint
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() => {
    'points': points,
    'color': color,
    'strokeWidth': strokeWidth,
    'createdAt': createdAt.toIso8601String(),
    'penType': penType,
  };

  factory DrawingStroke.fromJson(Map<String, dynamic> json) => DrawingStroke(
    points: List<double>.from(json['points'] ?? []),
    color: json['color'] ?? Colors.black.value,
    strokeWidth: (json['strokeWidth'] ?? 2.0).toDouble(),
    createdAt: json['createdAt'] != null
        ? DateTime.parse(json['createdAt'])
        : DateTime.now(),
    penType: json['penType'] ?? 0,
  );
}

// --- Canvas Note Model ---
class CanvasNote extends HiveObject {
  static const String boxName = 'canvas_notes';

  late String id;
  late String title;
  late String folderId;
  String? description;
  late List<DrawingStroke> strokes;
  late List<String> textBlocks;
  late DateTime createdAt;
  late DateTime lastModified;
  late bool isFavorite;
  late bool isDeleted;
  DateTime? deletedAt;
  String? thumbnailPath;
  late Color backgroundColor;

  CanvasNote({
    required this.id,
    required this.title,
    required this.folderId,
    this.description,
    List<DrawingStroke>? strokes,
    List<String>? textBlocks,
    DateTime? createdAt,
    DateTime? lastModified,
    this.isFavorite = false,
    this.isDeleted = false,
    this.deletedAt,
    this.thumbnailPath,
    Color? backgroundColor,
  }) {
    this.strokes = strokes ?? [];
    this.textBlocks = textBlocks ?? [];
    this.createdAt = createdAt ?? DateTime.now();
    this.lastModified = lastModified ?? DateTime.now();
    this.backgroundColor = backgroundColor ?? Colors.white;
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'folderId': folderId,
    'description': description,
    'strokes': strokes.map((s) => s.toJson()).toList(),
    'textBlocks': textBlocks,
    'createdAt': createdAt.toIso8601String(),
    'lastModified': lastModified.toIso8601String(),
    'isFavorite': isFavorite,
    'isDeleted': isDeleted,
    'deletedAt': deletedAt?.toIso8601String(),
    'thumbnailPath': thumbnailPath,
    'backgroundColor': backgroundColor.value,
  };

  factory CanvasNote.fromJson(Map<String, dynamic> json) => CanvasNote(
    id: json['id'],
    title: json['title'],
    folderId: json['folderId'],
    description: json['description'],
    strokes: (json['strokes'] as List?)
        ?.map((s) => DrawingStroke.fromJson(s))
        .toList(),
    textBlocks: List<String>.from(json['textBlocks'] ?? []),
    createdAt: json['createdAt'] != null
        ? DateTime.parse(json['createdAt'])
        : DateTime.now(),
    lastModified: json['lastModified'] != null
        ? DateTime.parse(json['lastModified'])
        : DateTime.now(),
    isFavorite: json['isFavorite'] ?? false,
    isDeleted: json['isDeleted'] ?? false,
    deletedAt: json['deletedAt'] != null
        ? DateTime.parse(json['deletedAt'])
        : null,
    thumbnailPath: json['thumbnailPath'],
    backgroundColor:
    Color(json['backgroundColor'] ?? Colors.white.value),
  );
}

// --- Canvas Folder Model ---
class CanvasFolder extends HiveObject {
  static const String boxName = 'canvas_folders';

  late String id;
  late String name;
  String? parentFolderId;
  late Color color;
  late DateTime createdAt;
  late DateTime lastModified;
  late bool isDeleted;
  DateTime? deletedAt;
  late int sortIndex;

  CanvasFolder({
    required this.id,
    required this.name,
    this.parentFolderId,
    Color? color,
    DateTime? createdAt,
    DateTime? lastModified,
    this.isDeleted = false,
    this.deletedAt,
    this.sortIndex = 0,
  }) {
    this.color = color ?? const Color(0xFF64B5F6);
    this.createdAt = createdAt ?? DateTime.now();
    this.lastModified = lastModified ?? DateTime.now();
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'parentFolderId': parentFolderId,
    'color': color.value,
    'createdAt': createdAt.toIso8601String(),
    'lastModified': lastModified.toIso8601String(),
    'isDeleted': isDeleted,
    'deletedAt': deletedAt?.toIso8601String(),
    'sortIndex': sortIndex,
  };

  factory CanvasFolder.fromJson(Map<String, dynamic> json) => CanvasFolder(
    id: json['id'],
    name: json['name'],
    parentFolderId: json['parentFolderId'],
    color: Color(json['color'] ?? 0xFF64B5F6),
    createdAt: json['createdAt'] != null
        ? DateTime.parse(json['createdAt'])
        : DateTime.now(),
    lastModified: json['lastModified'] != null
        ? DateTime.parse(json['lastModified'])
        : DateTime.now(),
    isDeleted: json['isDeleted'] ?? false,
    deletedAt: json['deletedAt'] != null
        ? DateTime.parse(json['deletedAt'])
        : null,
    sortIndex: json['sortIndex'] ?? 0,
  );
}

// --- Database Service ---
class CanvasDatabase {
  static final CanvasDatabase _instance = CanvasDatabase._internal();

  factory CanvasDatabase() {
    return _instance;
  }

  CanvasDatabase._internal();

  late Box<CanvasNote> _notesBox;
  late Box<CanvasFolder> _foldersBox;

  Future<void> init() async {
    // Register adapters first
    if (!Hive.isAdapterRegistered(10)) {
      Hive.registerAdapter(DrawingStrokeAdapter());
    }
    if (!Hive.isAdapterRegistered(11)) {
      Hive.registerAdapter(CanvasNoteAdapter());
    }
    if (!Hive.isAdapterRegistered(12)) {
      Hive.registerAdapter(CanvasFolderAdapter());
    }

    _notesBox = await Hive.openBox<CanvasNote>(CanvasNote.boxName);
    _foldersBox = await Hive.openBox<CanvasFolder>(CanvasFolder.boxName);

    // Create default folder if none exist
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

      for (var note in getNotesByFolder(id)) {
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