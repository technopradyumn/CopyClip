import 'package:hive/hive.dart';

part 'gamification_model.g.dart';

@HiveType(typeId: 20) // Choosing TypeID 20 to avoid collisions
class GamificationModel extends HiveObject {
  @HiveField(0)
  int xp;

  @HiveField(1)
  int level;

  @HiveField(2)
  int streak;

  @HiveField(3)
  DateTime lastActiveDate;

  GamificationModel({
    this.xp = 0,
    this.level = 1,
    this.streak = 0,
    required this.lastActiveDate,
  });

  int get xpToNextLevel => level * 100;

  double get progressToNextLevel => xp / xpToNextLevel;

  void addXp(int amount) {
    xp += amount;
    while (xp >= xpToNextLevel) {
      xp -= xpToNextLevel;
      level++;
    }
  }

  void updateStreak() {
    final now = DateTime.now();
    final difference = now.difference(lastActiveDate).inDays;

    if (difference == 1) {
      streak++;
    } else if (difference > 1) {
      streak = 1;
    }
    lastActiveDate = now;
  }
}
