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

  Future<void> init() async {
    if (_isInitialized) return;

    final box = await Hive.openBox<GamificationModel>(_boxName);
    _model = box.get(_key);

    if (_model == null) {
      _model = GamificationModel(lastActiveDate: DateTime.now());
      await box.put(_key, _model!);
    } else {
      _model!.updateStreak();
      await _model!.save();
    }

    _isInitialized = true;
    notifyListeners();
  }

  Future<void> addXp(int amount) async {
    if (!_isInitialized) await init();

    model.addXp(amount);
    await model.save();
    notifyListeners();
  }

  Future<void> recordActivity() async {
    if (!_isInitialized) await init();

    model.updateStreak();
    await model.save();
    notifyListeners();
  }
}
