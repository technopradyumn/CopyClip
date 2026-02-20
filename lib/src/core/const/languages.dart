import 'package:flutter/material.dart';

class LanguageConstants {
  static const Map<String, Map<String, String>> supportedLanguages = {
    'af': {'name': 'Afrikaans', 'flag': '🇿🇦'},
    'am': {'name': 'አማርኛ', 'flag': '🇪🇹'},
    'ar': {'name': 'العربية', 'flag': '🇸🇦'},
    'as': {'name': 'অসমীয়া', 'flag': '🇮🇳'},
    'az': {'name': 'Azərbaycan', 'flag': '🇦🇿'},
    'be': {'name': 'Беларуская', 'flag': '🇧🇾'},
    'bg': {'name': 'Български', 'flag': '🇧🇬'},
    'bn': {'name': 'বাংলা', 'flag': '🇧🇩'},
    'bs': {'name': 'Bosanski', 'flag': '🇧🇦'},
    'ca': {'name': 'Català', 'flag': '🇪🇸'},
    'cs': {'name': 'Čeština', 'flag': '🇨🇿'},
    'cy': {'name': 'Cymraeg', 'flag': 'gb-wls'},
    'da': {'name': 'Dansk', 'flag': '🇩🇰'},
    'de': {'name': 'Deutsch', 'flag': '🇩🇪'},
    'el': {'name': 'Ελληνικά', 'flag': '🇬🇷'},
    'en': {'name': 'English', 'flag': '🇺🇸'},
    'es': {'name': 'Español', 'flag': '🇪🇸'},
    'et': {'name': 'Eesti', 'flag': '🇪🇪'},
    'eu': {'name': 'Euskara', 'flag': '🇪🇸'},
    'fa': {'name': 'فارسی', 'flag': '🇮🇷'},
    'fi': {'name': 'Suomi', 'flag': '🇫🇮'},
    'fil': {'name': 'Filipino', 'flag': '🇵🇭'},
    'fr': {'name': 'Français', 'flag': '🇫🇷'},
    'gl': {'name': 'Galego', 'flag': '🇪🇸'},
    'gu': {'name': 'ગુજરાતી', 'flag': '🇮🇳'},
    'hi': {'name': 'हिन्दी', 'flag': '🇮🇳'},
    'zh': {'name': '中文', 'flag': '🇨🇳'},
  };

  static List<Locale> get supportedLocales =>
      supportedLanguages.keys.map((code) => Locale(code)).toList();
}