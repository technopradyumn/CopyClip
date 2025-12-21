import 'package:hive/hive.dart';

@HiveType(typeId: 2)
class Todo extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String task;

  @HiveField(2)
  String category;

  @HiveField(3)
  bool isDone;

  @HiveField(4)
  DateTime? dueDate;

  @HiveField(5)
  bool hasReminder;

  @HiveField(6)
  int sortIndex;

  @HiveField(10)
  bool isDeleted = false;

  @HiveField(11)
  DateTime? deletedAt;

  Todo({
    required this.id,
    required this.task,
    required this.category,
    this.isDone = false,
    this.dueDate,
    this.hasReminder = false,
    this.sortIndex = 0,
    this.isDeleted = false,
    this.deletedAt,
  });

  // --- Backup Support ---
  Map<String, dynamic> toJson() => {
    'id': id,
    'task': task,
    'category': category,
    'isDone': isDone,
    'dueDate': dueDate?.toIso8601String(),
    'hasReminder': hasReminder,
    'sortIndex': sortIndex,
    'isDeleted': isDeleted,
    'deletedAt': deletedAt?.toIso8601String(),
  };

  factory Todo.fromJson(Map<String, dynamic> json) => Todo(
    id: json['id'],
    task: json['task'],
    category: json['category'],
    isDone: json['isDone'] ?? false,
    dueDate: json['dueDate'] != null ? DateTime.parse(json['dueDate']) : null,
    hasReminder: json['hasReminder'] ?? false,
    sortIndex: json['sortIndex'] ?? 0,
    isDeleted: json['isDeleted'] ?? false,
    deletedAt: json['deletedAt'] != null ? DateTime.parse(json['deletedAt']) : null,
  );
}