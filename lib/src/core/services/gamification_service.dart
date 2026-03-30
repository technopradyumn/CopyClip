import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/gamification_model.dart';

class GamificationService extends ChangeNotifier {
  static const String _boxName = 'gamification_box';
  static const String _key = 'user_stats';

  GamificationModel? _model;
  GamificationModel get model =>
      _model ?? GamificationModel(lastActiveDate: DateTime.now());

  bool _isInitialized = false;

  // XP rewards per feature
  static const Map<String, int> xpRewards = {
    'note': 5,
    'todo': 10,
    'expense': 5,
    'journal': 8,
    'canvas': 7,
    'clipboard': 3,
    'social_post': 5,
    'calendar_event': 5,
  };

  // Medal tiers based on level (100 levels)
  static String getMedalTier(int level) {
    if (level >= 91) return 'Legend';
    if (level >= 81) return 'Amethyst';
    if (level >= 71) return 'Sapphire';
    if (level >= 61) return 'Ruby';
    if (level >= 51) return 'Emerald';
    if (level >= 41) return 'Diamond';
    if (level >= 31) return 'Platinum';
    if (level >= 21) return 'Gold';
    if (level >= 11) return 'Silver';
    return 'Bronze';
  }

  Future<void> init() async {
    if (_isInitialized) return;

    final box = await Hive.openBox<GamificationModel>(_boxName);
    _model = box.get(_key);

    if (_model == null) {
      _model = GamificationModel(lastActiveDate: DateTime.now());
      await box.put(_key, _model!);
    } else {
      // Logic for streak update
      _model!.updateStreak();
      await _model!.save();
    }

    _isInitialized = true;
    notifyListeners();
  }

  Future<void> addXp(int amount, {String feature = 'unknown'}) async {
    if (!_isInitialized) await init();

    model.addXp(amount, feature);
    await model.save();
    notifyListeners();
  }


  /// Award XP for using a specific feature
  Future<void> recordFeatureUsage(String feature) async {
    final reward = xpRewards[feature] ?? 3;
    await addXp(reward, feature: feature);
    await recordActivity();
  }

  Future<void> recordActivity() async {
    if (!_isInitialized) await init();

    model.updateStreak();
    await model.save();
    notifyListeners();
  }
}
