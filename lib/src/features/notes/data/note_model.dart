import 'package:hive/hive.dart';

@HiveType(typeId: 0)
class Note extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String content;

  @HiveField(3)
  DateTime updatedAt;

  @HiveField(4)
  int? colorValue;

  @HiveField(5)
  int sortIndex;

  @HiveField(6)
  bool isDeleted;

  @HiveField(7)
  DateTime? deletedAt;

  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.updatedAt,
    this.colorValue,
    this.sortIndex = 0,
    this.isDeleted = false,
    this.deletedAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'content': content,
    'updatedAt': updatedAt.toIso8601String(),
    'colorValue': colorValue,
    'sortIndex': sortIndex,
    'isDeleted': isDeleted,
    'deletedAt': deletedAt?.toIso8601String(),
  };

  factory Note.fromJson(Map<String, dynamic> json) => Note(
    id: json['id'],
    title: json['title'],
    content: json['content'],
    updatedAt: DateTime.parse(json['updatedAt']),
    colorValue: json['colorValue'],
    sortIndex: json['sortIndex'] ?? 0,
    isDeleted: json['isDeleted'] ?? false,
    deletedAt: json['deletedAt'] != null
        ? DateTime.parse(json['deletedAt'])
        : null,
  );
}
