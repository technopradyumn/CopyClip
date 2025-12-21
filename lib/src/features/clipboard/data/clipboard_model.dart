import 'package:hive/hive.dart';

@HiveType(typeId: 5)
class ClipboardItem extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  String content;
  @HiveField(2)
  DateTime createdAt;
  @HiveField(3)
  String type;
  @HiveField(4)
  int sortIndex;
  @HiveField(5)
  int? colorValue;
  @HiveField(10)
  bool isDeleted = false;
  @HiveField(11)
  DateTime? deletedAt;

  ClipboardItem({
    required this.id,
    required this.content,
    required this.createdAt,
    required this.type,
    this.sortIndex = 0,
    this.colorValue,
    this.isDeleted = false,
    this.deletedAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'content': content,
    'createdAt': createdAt.toIso8601String(),
    'type': type,
    'sortIndex': sortIndex,
    'colorValue': colorValue,
    'isDeleted': isDeleted,
    'deletedAt': deletedAt?.toIso8601String(),
  };

  factory ClipboardItem.fromJson(Map<String, dynamic> json) => ClipboardItem(
    id: json['id'],
    content: json['content'],
    createdAt: DateTime.parse(json['createdAt']),
    type: json['type'],
    sortIndex: json['sortIndex'] ?? 0,
    colorValue: json['colorValue'],
    isDeleted: json['isDeleted'] ?? false,
    deletedAt: json['deletedAt'] != null ? DateTime.parse(json['deletedAt']) : null,
  );
}