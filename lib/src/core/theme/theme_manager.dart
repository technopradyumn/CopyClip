import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class ThemeManager extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  Color _primaryColor = Colors.amberAccent; // Default color

  ThemeMode get themeMode => _themeMode;
  Color get primaryColor => _primaryColor;

  ThemeManager() {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final box = await Hive.openBox('theme_box');

    // Load Theme Mode
    final themeString = box.get('theme_mode', defaultValue: 'system');
    if (themeString == 'light') _themeMode = ThemeMode.light;
    else if (themeString == 'dark') _themeMode = ThemeMode.dark;
    else _themeMode = ThemeMode.system;

    // Load Primary Color
    final colorValue = box.get('primary_color_value', defaultValue: Colors.amberAccent.value);
    _primaryColor = Color(colorValue);

    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    final box = await Hive.openBox('theme_box');
    await box.put('theme_mode', mode.name);
    notifyListeners();
  }

  Future<void> setPrimaryColor(Color color) async {
    _primaryColor = color;
    final box = await Hive.openBox('theme_box');
    await box.put('primary_color_value', color.value);
    notifyListeners();
  }
}