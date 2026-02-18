import 'package:copyclip/src/core/services/lazy_box_loader.dart';
import 'package:flutter/material.dart';

class LocaleProvider extends ChangeNotifier {
  Locale? _locale;

  LocaleProvider() {
    _loadLocale();
  }

  Locale? get locale => _locale;

  Future<void> _loadLocale() async {
    final box = await LazyBoxLoader.getBox<dynamic>('settings');
    final String? languageCode = box.get('language_code');
    final String? countryCode = box.get('country_code');

    if (languageCode != null) {
      _locale = Locale(languageCode, countryCode);
      notifyListeners();
    }
  }

  Future<void> setLocale(Locale? locale) async {
    if (_locale == locale) return;

    _locale = locale;
    final box = await LazyBoxLoader.getBox<dynamic>('settings');

    if (locale == null) {
      await box.delete('language_code');
      await box.delete('country_code');
    } else {
      await box.put('language_code', locale.languageCode);
      if (locale.countryCode != null) {
        await box.put('country_code', locale.countryCode);
      } else {
        await box.delete('country_code');
      }
    }

    notifyListeners();
  }

  void clearLocale() {
    setLocale(null); // Set to system default
  }
}
