import 'package:hive/hive.dart';
import 'package:flutter/material.dart';

@HiveType(typeId: 10)
class DrawingStroke extends HiveObject {
  @HiveField(0)
  List<double> points;

  @HiveField(1)
  int color;

  @HiveField(2)
  double strokeWidth;

  @HiveField(3)
  DateTime createdAt;

  @HiveField(4)
  int penType;

  DrawingStroke({
    required this.points,
    required this.color,
    this.strokeWidth = 2.0,
    DateTime? createdAt,
    this.penType = 0,
  }) : createdAt = createdAt ?? DateTime.now();
}

@HiveType(typeId: 11)
class CanvasText extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String text;

  @HiveField(2)
  Offset position;

  @HiveField(3)
  int color;

  @HiveField(4)
  double fontSize;

  @HiveField(5)
  double containerWidth;

  @HiveField(6)
  double containerHeight;

  @HiveField(7)
  bool bold;

  @HiveField(8)
  bool italic;

  @HiveField(9)
  bool underline;

  CanvasText({
    required this.id,
    required this.text,
    required this.position,
    required this.color,
    this.fontSize = 20.0,
    this.containerWidth = 200.0,
    this.containerHeight = 100.0,
    this.bold = false,
    this.italic = false,
    this.underline = false,
  });
}

@HiveType(typeId: 14)
class CanvasPage extends HiveObject {
  @HiveField(0)
  List<DrawingStroke> strokes;

  @HiveField(1)
  List<CanvasText> textElements;

  CanvasPage({
    this.strokes = const [],
    this.textElements = const [],
  });
}

@HiveType(typeId: 15)
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
  List<CanvasPage> pages;

  @HiveField(5)
  DateTime createdAt;

  @HiveField(6)
  DateTime lastModified;

  @HiveField(7)
  bool isFavorite;

  @HiveField(8)
  bool isDeleted;

  @HiveField(9)
  DateTime? deletedAt;

  @HiveField(10)
  String? thumbnailPath;

  @HiveField(11)
  Color backgroundColor;

  @HiveField(12)
  bool horizontalScroll;

  CanvasNote({
    required this.id,
    required this.title,
    required this.folderId,
    this.description,
    List<CanvasPage>? pages,
    DateTime? createdAt,
    DateTime? lastModified,
    this.isFavorite = false,
    this.isDeleted = false,
    this.deletedAt,
    this.thumbnailPath,
    Color? backgroundColor,
    this.horizontalScroll = false,
  })  : pages = pages ?? [CanvasPage()],
        createdAt = createdAt ?? DateTime.now(),
        lastModified = lastModified ?? DateTime.now(),
        backgroundColor = backgroundColor ?? Colors.white;
}

@HiveType(typeId: 12)
class CanvasFolder extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String? parentFolderId;

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
}