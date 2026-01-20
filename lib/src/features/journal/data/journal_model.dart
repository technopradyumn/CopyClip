import 'package:hive/hive.dart';

@HiveType(typeId: 4)
class JournalEntry extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String content;

  @HiveField(3)
  DateTime date;

  @HiveField(4)
  String mood;

  @HiveField(5)
  int sortIndex;

  @HiveField(6)
  List<String> tags;

  @HiveField(7)
  bool isFavorite;

  @HiveField(8)
  int? colorValue;

  @HiveField(10)
  bool isDeleted = false;

  @HiveField(11)
  DateTime? deletedAt;

  @HiveField(12)
  String? designId;

  @HiveField(13)
  String? pageDesignId;

  JournalEntry({
    required this.id,
    required this.title,
    required this.content,
    required this.date,
    this.mood = 'Neutral',
    this.sortIndex = 0,
    this.tags = const [],
    this.isFavorite = false,
    this.colorValue,
    this.isDeleted = false,
    this.deletedAt,
    this.designId,
    this.pageDesignId,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'content': content,
    'date': date.toIso8601String(),
    'mood': mood,
    'sortIndex': sortIndex,
    'tags': tags,
    'isFavorite': isFavorite,
    'colorValue': colorValue,
    'isDeleted': isDeleted,
    'deletedAt': deletedAt?.toIso8601String(),
    'designId': designId,
    'pageDesignId': pageDesignId,
  };

  factory JournalEntry.fromJson(Map<String, dynamic> json) => JournalEntry(
    id: json['id'],
    title: json['title'],
    content: json['content'],
    date: DateTime.parse(json['date']),
    mood: json['mood'] ?? 'Neutral',
    sortIndex: json['sortIndex'] ?? 0,
    tags: json['tags'] != null ? List<String>.from(json['tags']) : [],
    isFavorite: json['isFavorite'] ?? false,
    colorValue: json['colorValue'],
    isDeleted: json['isDeleted'] ?? false,
    deletedAt: json['deletedAt'] != null
        ? DateTime.parse(json['deletedAt'])
        : null,
    designId: json['designId'],
    pageDesignId: json['pageDesignId'],
  );
}
