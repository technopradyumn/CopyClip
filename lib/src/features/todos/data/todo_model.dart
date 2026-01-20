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

  @HiveField(12)
  String? repeatInterval; // daily, weekly, monthly, yearly, custom

  @HiveField(13)
  List<int>? repeatDays; // 1=Mon, 7=Sun

  @HiveField(14)
  String? nextInstanceId; // Tracks the ID of the task created by recurrence

  DateTime? get date => dueDate;

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
    this.repeatInterval,
    this.repeatDays,
    this.nextInstanceId,
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
    'repeatInterval': repeatInterval,
    'repeatDays': repeatDays,
    'nextInstanceId': nextInstanceId,
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
    deletedAt: json['deletedAt'] != null
        ? DateTime.parse(json['deletedAt'])
        : null,
    repeatInterval: json['repeatInterval'],
    repeatDays: json['repeatDays'] != null
        ? List<int>.from(json['repeatDays'])
        : null,
    nextInstanceId: json['nextInstanceId'],
  );
}
