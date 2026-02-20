# scripts/generate_language_map.py
import os

# Define the languages with their native names and flags
# This list includes common languages and can be expanded.
languages = {
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
    'he': {'name': 'עברית', 'flag': '🇮🇱'},
    'hi': {'name': 'हिन्दी', 'flag': '🇮🇳'},
    'hr': {'name': 'Hrvatski', 'flag': '🇭🇷'},
    'hu': {'name': 'Magyar', 'flag': '🇭🇺'},
    'hy': {'name': 'Հայերեն', 'flag': '🇦🇲'},
    'id': {'name': 'Bahasa Indonesia', 'flag': '🇮🇩'},
    'is': {'name': 'Íslenska', 'flag': '🇮🇸'},
    'it': {'name': 'Italiano', 'flag': '🇮🇹'},
    'ja': {'name': '日本語', 'flag': '🇯🇵'},
    'ka': {'name': 'ქართული', 'flag': '🇬🇪'},
    'kk': {'name': 'Қазақ тілі', 'flag': '🇰🇿'},
    'km': {'name': 'ខ្មែរ', 'flag': '🇰🇭'},
    'kn': {'name': 'ಕನ್ನಡ', 'flag': '🇮🇳'},
    'ko': {'name': '한국어', 'flag': '🇰🇷'},
    'ky': {'name': 'Кыргызча', 'flag': '🇰🇬'},
    'lo': {'name': 'ລາວ', 'flag': '🇱🇦'},
    'lt': {'name': 'Lietuvių', 'flag': '🇱🇹'},
    'lv': {'name': 'Latviešu', 'flag': '🇱🇻'},
    'mk': {'name': 'Македонски', 'flag': '🇲🇰'},
    'ml': {'name': 'മലയാളം', 'flag': '🇮🇳'},
    'mn': {'name': 'Монгол', 'flag': '🇲🇳'},
    'mr': {'name': 'मराठी', 'flag': '🇮🇳'},
    'ms': {'name': 'Bahasa Melayu', 'flag': '🇲🇾'},
    'my': {'name': 'ဗမာစာ', 'flag': '🇲🇲'},
    'nb': {'name': 'Norsk Bokmål', 'flag': '🇳🇴'},
    'ne': {'name': 'नेपाली', 'flag': '🇳🇵'},
    'nl': {'name': 'Nederlands', 'flag': '🇳🇱'},
    'no': {'name': 'Norsk', 'flag': '🇳🇴'},
    'or': {'name': 'ଓଡ଼ିଆ', 'flag': '🇮🇳'},
    'pa': {'name': 'ਪੰਜਾਬੀ', 'flag': '🇮🇳'},
    'pl': {'name': 'Polski', 'flag': '🇵🇱'},
    'pt': {'name': 'Português', 'flag': '🇵🇹'},
    'ro': {'name': 'Română', 'flag': '🇷🇴'},
    'ru': {'name': 'Русский', 'flag': '🇷🇺'},
    'si': {'name': 'සිංහල', 'flag': '🇱🇰'},
    'sk': {'name': 'Slovenčina', 'flag': '🇸🇰'},
    'sl': {'name': 'Slovenščina', 'flag': '🇸🇮'},
    'sq': {'name': 'Shqip', 'flag': '🇦🇱'},
    'sr': {'name': 'Српски', 'flag': '🇷🇸'},
    'sv': {'name': 'Svenska', 'flag': '🇸🇪'},
    'sw': {'name': 'Kiswahili', 'flag': '🇰🇪'},
    'ta': {'name': 'தமிழ்', 'flag': '🇮🇳'},
    'te': {'name': 'తెలుగు', 'flag': '🇮🇳'},
    'th': {'name': 'ไทย', 'flag': '🇹🇭'},
    'tl': {'name': 'Tagalog', 'flag': '🇵🇭'},
    'tr': {'name': 'Türkçe', 'flag': '🇹🇷'},
    'uk': {'name': 'Українська', 'flag': '🇺🇦'},
    'ur': {'name': 'اردو', 'flag': '🇵🇰'},
    'uz': {'name': 'O‘zbek', 'flag': '🇺🇿'},
    'vi': {'name': 'Tiếng Việt', 'flag': '🇻🇳'},
    'zh': {'name': '中文', 'flag': '🇨🇳'},
    'zu': {'name': 'IsiZulu', 'flag': '🇿🇦'},
}

# Values for region specific locales can be mapped to the base language or specific flags
# For this task, we will try to stick to base languages or map specific ones if they are distinct enough
# or if the user requested "all the other languages file".
# The previous step generated files for many locales like 'ar_SA', 'zn_CN' etc.
# We should ensure those are covered or mapped.

# Output file path
output_file = 'lib/src/core/const/languages.dart'

dart_content = """import 'package:flutter/material.dart';

class LanguageConstants {
  static const Map<String, Map<String, String>> supportedLanguages = {
"""

# Sort languages by code for tidiness
sorted_keys = sorted(languages.keys())

for key in sorted_keys:
    data = languages[key]
    # Escape single quotes in names just in case
    name = data['name'].replace("'", "\\'")
    flag = data['flag']
    dart_content += f"    '{key}': {{'name': '{name}', 'flag': '{flag}'}},\n"

dart_content += """  };

  static List<Locale> get supportedLocales =>
      supportedLanguages.keys.map((code) => Locale(code)).toList();
}
"""

with open(output_file, 'w', encoding='utf-8') as f:
    f.write(dart_content)

print(f"Generated {output_file} with {len(languages)} languages.")
