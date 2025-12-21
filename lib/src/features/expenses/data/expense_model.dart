import 'package:hive/hive.dart';

@HiveType(typeId: 3)
class Expense extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  double amount;

  @HiveField(3)
  String currency;

  @HiveField(4)
  DateTime date;

  @HiveField(5)
  String category;

  @HiveField(6)
  bool isIncome;

  @HiveField(7)
  int sortIndex;

  @HiveField(10)
  bool isDeleted = false;

  @HiveField(11)
  DateTime? deletedAt;

  Expense({
    required this.id,
    required this.title,
    required this.amount,
    required this.currency,
    required this.date,
    required this.category,
    required this.isIncome,
    this.sortIndex = 0,
    this.isDeleted = false,
    this.deletedAt,
  });

  // --- Backup Support ---
  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'amount': amount,
    'currency': currency,
    'date': date.toIso8601String(),
    'category': category,
    'isIncome': isIncome,
    'sortIndex': sortIndex,
    'isDeleted': isDeleted,
    'deletedAt': deletedAt?.toIso8601String(),
  };

  factory Expense.fromJson(Map<String, dynamic> json) => Expense(
    id: json['id'],
    title: json['title'],
    // Handle potential Integer vs Double JSON issues
    amount: (json['amount'] as num).toDouble(),
    currency: json['currency'],
    date: DateTime.parse(json['date']),
    category: json['category'],
    isIncome: json['isIncome'] ?? false,
    sortIndex: json['sortIndex'] ?? 0,
    isDeleted: json['isDeleted'] ?? false,
    deletedAt: json['deletedAt'] != null ? DateTime.parse(json['deletedAt']) : null,
  );
}