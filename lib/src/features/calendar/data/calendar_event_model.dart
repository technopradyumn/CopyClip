import 'package:hive/hive.dart';

@HiveType(typeId: 21)
class CalendarEvent extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String description;

  @HiveField(3)
  DateTime startDate;

  @HiveField(4)
  DateTime endDate;

  @HiveField(5)
  bool isAllDay;

  @HiveField(6)
  String? location;

  @HiveField(7)
  String? url;

  @HiveField(8)
  String? colorCode;

  @HiveField(9)
  String? repeatInterval;

  @HiveField(10)
  int reminderMinutesBefore;

  @HiveField(11)
  bool isDeleted = false;
  
  @HiveField(12)
  DateTime createdAt;

  @HiveField(13)
  String? designPatternId;

  CalendarEvent({
    required this.id,
    required this.title,
    this.description = '',
    required this.startDate,
    required this.endDate,
    this.isAllDay = false,
    this.location,
    this.url,
    this.colorCode,
    this.repeatInterval,
    this.reminderMinutesBefore = 0,
    this.isDeleted = false,
    this.designPatternId,
    DateTime? createdAt,
  }) : this.createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'startDate': startDate.toIso8601String(),
    'endDate': endDate.toIso8601String(),
    'isAllDay': isAllDay,
    'location': location,
    'url': url,
    'colorCode': colorCode,
    'repeatInterval': repeatInterval,
    'reminderMinutesBefore': reminderMinutesBefore,
    'isDeleted': isDeleted,
    'createdAt': createdAt.toIso8601String(),
    'designPatternId': designPatternId,
  };

  factory CalendarEvent.fromJson(Map<String, dynamic> json) => CalendarEvent(
    id: json['id'],
    title: json['title'],
    description: json['description'] ?? '',
    startDate: DateTime.parse(json['startDate']),
    endDate: DateTime.parse(json['endDate']),
    isAllDay: json['isAllDay'] ?? false,
    location: json['location'],
    url: json['url'],
    colorCode: json['colorCode'],
    repeatInterval: json['repeatInterval'],
    reminderMinutesBefore: json['reminderMinutesBefore'] ?? 0,
    isDeleted: json['isDeleted'] ?? false,
    designPatternId: json['designPatternId'],
    createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
  );
}

