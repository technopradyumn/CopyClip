import 'dart:math' as math;
import 'package:hive/hive.dart';

part 'gamification_model.g.dart';

@HiveType(typeId: 20) // Choosing TypeID 20 to avoid collisions
class GamificationModel extends HiveObject {
  @HiveField(0)
  int totalXp;

  @HiveField(1)
  int level; // We'll keep this as a cached value, but it's derived from totalXp

  @HiveField(2)
  int streak;

  @HiveField(5)
  int bestStreak;

  @HiveField(3)
  DateTime lastActiveDate;

  @HiveField(4)
  Map<String, Map<String, int>> dailyFeatureXp; // Date Key -> {Feature -> XP}

  GamificationModel({
    this.totalXp = 0,
    this.level = 1,
    this.streak = 0,
    this.bestStreak = 0,
    required this.lastActiveDate,
    Map<String, Map<String, int>>? dailyFeatureXp,
  }) : dailyFeatureXp = dailyFeatureXp ?? {};

  // Formula: Level = floor(sqrt(totalXp / 10)) + 1
  // Max Level 100 reached at 98,010 XP
  static int calculateLevelFromXp(int xp) {
    if (xp <= 0) return 1;
    final calculated = (math.sqrt(xp / 10)).floor() + 1;
    return math.min(calculated, 100);
  }


  int get xpForCurrentLevel => (level - 1) * (level - 1) * 10;
  int get xpToNextLevel => level * level * 10;
  
  double get progressToNextLevel {
    final currentLevelBase = xpForCurrentLevel;
    final nextLevelBase = xpToNextLevel;
    if (nextLevelBase == currentLevelBase) return 0.0;
    // Ensure we don't go below 0 or above 1
    final progress = (totalXp - currentLevelBase) / (nextLevelBase - currentLevelBase);
    return progress.clamp(0.0, 1.0);
  }

  void addXp(int amount, String feature) {
    if (amount <= 0) return;
    totalXp += amount;
    
    // Update daily history
    final now = DateTime.now();
    final dateKey = _getDateKey(now);
    
    dailyFeatureXp[dateKey] ??= {};
    final currentFeatureXp = dailyFeatureXp[dateKey]![feature] ?? 0;
    dailyFeatureXp[dateKey]![feature] = currentFeatureXp + amount;

    // Recalculate level
    _updateLevel();
    lastActiveDate = now;
  }

  void _updateLevel() {
    level = calculateLevelFromXp(totalXp);
  }


  String _getDateKey(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  void updateStreak() {
    final now = DateTime.now();
    final difference = now.difference(lastActiveDate).inDays;

    if (difference == 1) {
      streak++;
    } else if (difference > 1) {
      streak = 1;
    }
    
    if (streak > bestStreak) {
      bestStreak = streak;
    }
    lastActiveDate = now;
  }

}
