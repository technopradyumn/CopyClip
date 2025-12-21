import 'package:hive/hive.dart';

@HiveType(typeId: 5)
class ClipboardItem extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String content;

  @HiveField(2)
  final DateTime createdAt;

  @HiveField(3)
  final String type;

  @HiveField(4)
  int sortIndex;

  ClipboardItem({
    required this.id,
    required this.content,
    required this.createdAt,
    required this.type,
    this.sortIndex = 0,
  });

  // --- Backup Support ---
  Map<String, dynamic> toJson() => {
    'id': id,
    'content': content,
    'createdAt': createdAt.toIso8601String(),
    'type': type,
    'sortIndex': sortIndex,
  };

  factory ClipboardItem.fromJson(Map<String, dynamic> json) => ClipboardItem(
    id: json['id'],
    content: json['content'],
    createdAt: DateTime.parse(json['createdAt']),
    type: json['type'],
    sortIndex: json['sortIndex'] ?? 0,
  );
}