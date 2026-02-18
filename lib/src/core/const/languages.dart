import 'package:flutter/material.dart';

class LanguageConstants {
  static const Map<String, Map<String, String>> supportedLanguages = {
    'en': {'name': 'English', 'flag': '🇺🇸'},
    'es': {'name': 'Español', 'flag': '🇪🇸'},
    'hi': {'name': 'हिन्दी', 'flag': '🇮🇳'},
    'fr': {'name': 'Français', 'flag': '🇫🇷'},
    'de': {'name': 'Deutsch', 'flag': '🇩🇪'},
    'zh': {'name': '中文', 'flag': '🇨🇳'},
  };

  static List<Locale> get supportedLocales =>
      supportedLanguages.keys.map((code) => Locale(code)).toList();
}
