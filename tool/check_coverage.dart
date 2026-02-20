import 'dart:convert';
import 'dart:io';

void main() {
  final l10nDir = Directory('lib/src/l10n');
  final sourceFile = File('${l10nDir.path}/app_en.arb');

  if (!sourceFile.existsSync()) {
    print('Source file app_en.arb not found.');
    return;
  }

  final sourceContent = sourceFile.readAsStringSync();
  final Map<String, dynamic> sourceMap = jsonDecode(sourceContent);
  final totalKeys = sourceMap.keys.where((k) => !k.startsWith('@')).length;

  // Hardcoded list from LanguageConstants for simplicity in this script,
  // or we could parse the file. Parsing is better to be in sync.
  // For now, let's just check ALL arb files and if they match a simple code like 'af', 'ar', etc.

  final files = l10nDir.listSync().whereType<File>().where((file) {
    return file.path.endsWith('.arb') && !file.path.endsWith('app_en.arb');
  }).toList();

  print(
    'Analyzing ${files.length} language files against ${totalKeys} keys...',
  );

  List<String> badLanguages = [];

  for (var file in files) {
    try {
      final content = file.readAsStringSync();
      final Map<String, dynamic> map = jsonDecode(content);

      int translated = 0;
      for (var key in map.keys) {
        if (key.startsWith('@')) continue;
        // Logic: specific value != english value
        if (sourceMap.containsKey(key)) {
          if (file.path.endsWith('app_es.arb') && translated < 5) {
            print(
              'Debug: $key | "${map[key]}" vs "${sourceMap[key]}" | Equal? ${map[key] == sourceMap[key]}',
            );
          }
          if (map[key] != sourceMap[key]) {
            translated++;
          }
        }
      }

      double ratio = totalKeys > 0 ? translated / totalKeys : 0.0;
      String filename = file.path
          .split(Platform.pathSeparator)
          .last; // app_es.arb
      String code = filename.replaceAll('app_', '').replaceAll('.arb', '');

      if (ratio < 0.5) {
        // Strict threshold: Less than 50% translated
        print('[Low Coverage] $code: ${(ratio * 100).toStringAsFixed(1)}%');
        badLanguages.add(code);
      } else {
        // print('[OK] $code: ${(ratio * 100).toStringAsFixed(1)}%');
      }
    } catch (e) {
      print('Error reading ${file.path}: $e');
    }
  }

  print('\n-- Recommendation --');
  print('Remove these codes from LanguageConstants:');
  for (var lang in badLanguages) {
    print("'$lang'");
  }

  File('bad_languages.json').writeAsStringSync(jsonEncode(badLanguages));
}
