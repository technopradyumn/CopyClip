import 'package:hive/hive.dart';
import 'package:flutter/material.dart';

import 'canvas_adapter.dart';

// --- Stroke Model for Drawing ---
@HiveType(typeId: 10)
class DrawingStroke extends HiveObject {
  @HiveField(0)
  List<double> points; // x1, y1, x2, y2, ...

  @HiveField(1)
  int color;

  @HiveField(2)
  double strokeWidth;

  @HiveField(3)
  DateTime createdAt;

  DrawingStroke({
    required this.points,
    required this.color,
    this.strokeWidth = 2.0,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() => {
    'points': points,
    'color': color,
    'strokeWidth': strokeWidth,
    'createdAt': createdAt.toIso8601String(),
  };

  factory DrawingStroke.fromJson(Map<String, dynamic> json) => DrawingStroke(
    points: List<double>.from(json['points'] ?? []),
    color: json['color'] ?? Colors.black.value,
    strokeWidth: (json['strokeWidth'] ?? 2.0).toDouble(),
    createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
  );
}

// --- Canvas Note Model ---
@HiveType(typeId: 11)
class CanvasNote extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String folderId;

  @HiveField(3)
  String? description;

  @HiveField(4)
  List<DrawingStroke> strokes;

  @HiveField(5)
  List<String> textBlocks; // JSON strings of text content

  @HiveField(6)
  DateTime createdAt;

  @HiveField(7)
  DateTime lastModified;

  @HiveField(8)
  bool isFavorite;

  @HiveField(9)
  bool isDeleted;

  @HiveField(10)
  DateTime? deletedAt;

  @HiveField(11)
  String? thumbnailPath;

  @HiveField(12)
  Color backgroundColor; // Canvas background color

  CanvasNote({
    required this.id,
    required this.title,
    required this.folderId,
    this.description,
    this.strokes = const [],
    this.textBlocks = const [],
    DateTime? createdAt,
    DateTime? lastModified,
    this.isFavorite = false,
    this.isDeleted = false,
    this.deletedAt,
    this.thumbnailPath,
    Color? backgroundColor,
  })  : createdAt = createdAt ?? DateTime.now(),
        lastModified = lastModified ?? DateTime.now(),
        backgroundColor = backgroundColor ?? Colors.white;

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
    strokes: (json['strokes'] as List?)?.map((s) => DrawingStroke.fromJson(s)).toList() ?? [],
    textBlocks: List<String>.from(json['textBlocks'] ?? []),
    createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
    lastModified: json['lastModified'] != null ? DateTime.parse(json['lastModified']) : DateTime.now(),
    isFavorite: json['isFavorite'] ?? false,
    isDeleted: json['isDeleted'] ?? false,
    deletedAt: json['deletedAt'] != null ? DateTime.parse(json['deletedAt']) : null,
    thumbnailPath: json['thumbnailPath'],
    backgroundColor: Color(json['backgroundColor'] ?? Colors.white.value),
  );
}

// --- Canvas Folder Model ---
@HiveType(typeId: 12)
class CanvasFolder extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String? parentFolderId; // For nested folders

  @HiveField(3)
  Color color;

  @HiveField(4)
  DateTime createdAt;

  @HiveField(5)
  DateTime lastModified;

  @HiveField(6)
  bool isDeleted;

  @HiveField(7)
  DateTime? deletedAt;

  @HiveField(8)
  int sortIndex;

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
  })  : color = color ?? const Color(0xFF64B5F6),
        createdAt = createdAt ?? DateTime.now(),
        lastModified = lastModified ?? DateTime.now();

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
    createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
    lastModified: json['lastModified'] != null ? DateTime.parse(json['lastModified']) : DateTime.now(),
    isDeleted: json['isDeleted'] ?? false,
    deletedAt: json['deletedAt'] != null ? DateTime.parse(json['deletedAt']) : null,
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
    Hive.registerAdapter(DrawingStrokeAdapter());
    Hive.registerAdapter(CanvasNoteAdapter());
    Hive.registerAdapter(CanvasFolderAdapter());

    _notesBox = await Hive.openBox<CanvasNote>('canvas_notes');
    _foldersBox = await Hive.openBox<CanvasFolder>('canvas_folders');
  }

  // --- Note Operations ---
  Future<void> saveNote(CanvasNote note) async {
    note.lastModified = DateTime.now();
    await _notesBox.put(note.id, note);
  }

  CanvasNote? getNote(String id) => _notesBox.get(id);

  List<CanvasNote> getNotesByFolder(String folderId) {
    return _notesBox.values.where((n) => n.folderId == folderId && !n.isDeleted).toList();
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
    return _notesBox.values.where((n) => n.folderId == folderId && !n.isDeleted).length;
  }

  int getTotalNotes() {
    return _notesBox.values.where((n) => !n.isDeleted).length;
  }
}