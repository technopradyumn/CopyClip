import 'dart:convert';
import 'dart:io';

void main() {
  final l10nDir = Directory('lib/src/l10n');
  final enFile = File('${l10nDir.path}/app_en.arb');

  if (!enFile.existsSync()) {
    print('Error: app_en.arb not found');
    exit(1);
  }

  final enContent = enFile.readAsStringSync();
  final Map<String, dynamic> enJson = jsonDecode(enContent);

  // Sort keys for consistent ordering
  final sortedKeys = enJson.keys.toList()..sort();

  final files = l10nDir.listSync();
  int updatedFiles = 0;

  for (var entity in files) {
    if (entity is File &&
        entity.path.endsWith('.arb') &&
        !entity.path.endsWith('app_en.arb')) {
      final file = entity;
      String content;
      try {
        content = file.readAsStringSync();
      } catch (e) {
        print('Error reading ${file.path}: $e');
        continue;
      }

      Map<String, dynamic> json;
      try {
        json = jsonDecode(content);
      } catch (e) {
        print('Error decoding JSON in ${file.path}, initializing empty: $e');
        json = {};
      }

      bool changed = false;
      int addedCount = 0;

      // Ensure locale key exists and is correct based on filename
      final filename = file.path.split(Platform.pathSeparator).last;
      final localeCode = filename.replaceAll('app_', '').replaceAll('.arb', '');
      if (json['@@locale'] != localeCode) {
        json['@@locale'] = localeCode;
        changed = true;
      }

      // Add missing keys
      for (var key in sortedKeys) {
        if (!json.containsKey(key)) {
          json[key] = enJson[key];
          addedCount++;
          changed = true;
        }
      }

      if (changed) {
        // Create a new map with sorted keys to match enFile order mostly (optional but nice)
        final Map<String, dynamic> newJson = {};
        // Put @@locale first
        if (json.containsKey('@@locale')) {
          newJson['@@locale'] = json['@@locale'];
        }

        for (var key in sortedKeys) {
          // @@locale is skipped here as it's not in enJson usually or handled above
          if (key == '@@locale') continue;
          if (json.containsKey(key)) {
            newJson[key] = json[key];
          }
        }
        // Add any extra keys that might exist in target but not in EN (rare but possible)
        for (var key in json.keys) {
          if (key != '@@locale' && !sortedKeys.contains(key)) {
            newJson[key] = json[key];
          }
        }

        const encoder = JsonEncoder.withIndent('  ');
        file.writeAsStringSync(encoder.convert(newJson));
        print('Updated ${file.path}: Added $addedCount keys.');
        updatedFiles++;
      }
    }
  }

  print('Sync complete. Updated $updatedFiles files.');
}
