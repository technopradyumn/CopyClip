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

  JournalEntry({
    required this.id,
    required this.title,
    required this.content,
    required this.date,
    this.mood = 'Neutral',
    this.sortIndex = 0,
    this.tags = const [],
    this.isFavorite = false,
  });

  // --- Backup Support ---
  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'content': content,
    'date': date.toIso8601String(),
    'mood': mood,
    'sortIndex': sortIndex,
    'tags': tags,
    'isFavorite': isFavorite,
  };

  factory JournalEntry.fromJson(Map<String, dynamic> json) => JournalEntry(
    id: json['id'],
    title: json['title'],
    content: json['content'],
    date: DateTime.parse(json['date']),
    mood: json['mood'] ?? 'Neutral',
    sortIndex: json['sortIndex'] ?? 0,
    // Safely convert JSON list to List<String>
    tags: json['tags'] != null ? List<String>.from(json['tags']) : [],
    isFavorite: json['isFavorite'] ?? false,
  );
}