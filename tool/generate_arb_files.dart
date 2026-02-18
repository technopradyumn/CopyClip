import 'dart:convert';
import 'dart:io';

// Language codes to generate (excluding 'en' and 'hi' which exist)
const List<String> targetLanguages = [
  'es',
  'fr',
  'de',
  'zh',
  'ja',
  'ru',
  'ar',
  'pt',
  'bn',
  'te',
  'mr',
  'ta',
  'ur',
  'gu',
  'kn',
  'ml',
  'or',
  'pa',
  'as',
  'it',
  'nl',
  'pl',
  'tr',
  'uk',
  'vi',
  'th',
  'id',
  'ko',
  'fa',
  'he',
  'sv',
  'no',
  'da',
  'fi',
  'hu',
  'cs',
  'ro',
  'bg',
  'el',
  'sr',
  'hr',
  'sk',
  'lt',
  'lv',
  'et',
  'sl',
  'mt',
  'sw',
  'am',
  'ne',
  'si',
  'km',
  'lo',
  'my',
  'ka',
  'hy',
  'az',
  'kk',
  'uz',
  'mn',
  'bs',
  'mk',
  'sq',
  'af',
  'zu',
  'xh',
  'fil',
  'ms',
];

// Common Translations Dictionary (Simplified/Approximated for demonstration)
// In a real scenario, this would come from a professional translation service or API.
final Map<String, Map<String, String>> translations = {
  'es': {
    'settings': 'Ajustes',
    'language': 'Idioma',
    'save': 'Guardar',
    'cancel': 'Cancelar',
    'delete': 'Eliminar',
    'edit': 'Editar',
    'share': 'Compartir',
    'copy': 'Copiar',
    'notes': 'Notas',
    'todos': 'Tareas',
    'journal': 'Diario',
    'calendar': 'Calendario',
    'clipboard': 'Portapapeles',
    'search': 'Buscar',
    'premiumFeatures': 'Funciones Premium',
    'recycleBin': 'Papelera',
    'version': 'Versión',
  },
  'fr': {
    'settings': 'Paramètres',
    'language': 'Langue',
    'save': 'Enregistrer',
    'cancel': 'Annuler',
    'delete': 'Supprimer',
    'edit': 'Modifier',
    'share': 'Partager',
    'copy': 'Copier',
    'notes': 'Notes',
    'todos': 'Tâches',
    'journal': 'Journal',
    'calendar': 'Calendrier',
    'clipboard': 'Presse-papiers',
    'search': 'Rechercher',
    'premiumFeatures': 'Fonctionnalités Premium',
    'recycleBin': 'Corbeille',
    'version': 'Version',
  },
  'de': {
    'settings': 'Einstellungen',
    'language': 'Sprache',
    'save': 'Speichern',
    'cancel': 'Abbrechen',
    'delete': 'Löschen',
    'edit': 'Bearbeiten',
    'share': 'Teilen',
    'copy': 'Kopieren',
    'notes': 'Notizen',
    'todos': 'Aufgaben',
    'journal': 'Tagebuch',
    'calendar': 'Kalender',
    'clipboard': 'Zwischenablage',
    'search': 'Suchen',
    'premiumFeatures': 'Premium-Funktionen',
    'recycleBin': 'Papierkorb',
    'version': 'Version',
  },
  'zh': {
    'settings': '设置',
    'language': '语言',
    'save': '保存',
    'cancel': '取消',
    'delete': '删除',
    'edit': '编辑',
    'share': '分享',
    'copy': '复制',
    'notes': '笔记',
    'todos': '待办事项',
    'journal': '日记',
    'calendar': '日历',
    'clipboard': '剪贴板',
    'search': '搜索',
    'premiumFeatures': '高级功能',
    'recycleBin': '回收站',
    'version': '版本',
  },
  // Add more basic dictionaries here as needed...
  // For mass generation, we will mainly use English fallback if translation is missing,
  // but this structure allows easy expansion.
};

void main() async {
  final File enFile = File('lib/src/l10n/app_en.arb');
  if (!enFile.existsSync()) {
    print('Error: lib/src/l10n/app_en.arb not found.');
    return;
  }

  final String enContent = enFile.readAsStringSync();
  final Map<String, dynamic> enJson = jsonDecode(enContent);

  for (final lang in targetLanguages) {
    final Map<String, dynamic> newJson = {};
    newJson['@@locale'] = lang;

    enJson.forEach((key, value) {
      if (key.startsWith('@')) return; // Skip metadata keys like @@locale

      // Try to find translation
      if (translations.containsKey(lang) &&
          translations[lang]!.containsKey(key)) {
        newJson[key] = translations[lang]![key];
      } else {
        // Fallback to English (or mocked translation for completeness if desired)
        newJson[key] = value;
      }
    });

    final File newFile = File('lib/src/l10n/app_$lang.arb');
    newFile.writeAsStringSync(
      const JsonEncoder.withIndent('  ').convert(newJson),
    );
    print('Generated lib/src/l10n/app_$lang.arb');
  }
  print('Done generating ${targetLanguages.length} ARB files.');
}
