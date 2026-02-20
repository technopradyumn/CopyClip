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

  final files = l10nDir.listSync().whereType<File>().where((file) {
    return file.path.endsWith('.arb') && !file.path.endsWith('app_en.arb');
  }).toList();

  int totalFilled = 0;

  for (var file in files) {
    try {
      final content = file.readAsStringSync();
      Map<String, dynamic> map = {};
      try {
        map = jsonDecode(content);
      } catch (e) {
        print('Error decoding ${file.path}, starting fresh from source keys.');
      }

      bool updated = false;
      int fileFilled = 0;

      // Fill missing keys
      for (var key in sourceMap.keys) {
        if (key.startsWith('@')) {
          // Meta keys: Optional to copy, but good for context.
          // Usually gen-l10n uses the source arb for meta, so we don't strictly need them in others.
          // But if we want to be safe, we can skip or copy.
          // Let's skip meta keys to keep files smaller, as they aren't strictly required for non-template files.
          continue;
        }

        if (!map.containsKey(key)) {
          map[key] = sourceMap[key];
          updated = true;
          fileFilled++;
          totalFilled++;
        }
      }

      // Check for strict "untranslated" errors where key exists but value is empty/null (rare in valid JSON but possible)
      // If we see explicit nulls, fill them.
      for (var key in map.keys) {
        if (map[key] == null && sourceMap.containsKey(key)) {
          map[key] = sourceMap[key];
          updated = true;
        }
      }

      if (updated) {
        const encoder = JsonEncoder.withIndent('  ');
        file.writeAsStringSync(encoder.convert(map));
        print(
          'Filled $fileFilled keys in ${file.path.split(Platform.pathSeparator).last}',
        );
      }
    } catch (e) {
      print('Error processing ${file.path}: $e');
    }
  }

  print('Total missing keys filled: $totalFilled');
}
