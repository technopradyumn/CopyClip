import 'dart:convert';
import 'dart:io';

void main() async {
  final l10nDir = Directory('lib/src/l10n');
  final enFile = File('${l10nDir.path}/app_en.arb');

  if (!enFile.existsSync()) {
    print('Error: app_en.arb not found at ${enFile.path}');
    exit(1);
  }

  // 1. Read Master English File
  final enContent = await enFile.readAsString();
  final Map<String, dynamic> enMap = jsonDecode(enContent);
  final Set<String> allKeys = enMap.keys.toSet();

  print('Loaded app_en.arb with ${allKeys.length} keys.');

  // 2. Iterate all other ARB files
  final files = l10nDir.listSync().whereType<File>().where((f) {
    return f.path.endsWith('.arb') && !f.path.endsWith('app_en.arb');
  }).toList();

  for (final file in files) {
    final fileName = file.uri.pathSegments.last;
    try {
      final content = await file.readAsString();
      final Map<String, dynamic> targetMap = jsonDecode(content);

      int addedCount = 0;

      // 3. Add missing keys
      for (final key in allKeys) {
        if (!targetMap.containsKey(key)) {
          targetMap[key] = enMap[key];
          addedCount++;
        }
      }

      if (addedCount > 0) {
        // 4. Sort keys to match English order (optional but good for diffs)
        final sortedMap = <String, dynamic>{};
        for (final key in allKeys) {
          if (targetMap.containsKey(key)) {
            sortedMap[key] = targetMap[key];
          }
        }
        // Add any extra keys that might be in target but not in EN (rare but possible)
        for (final key in targetMap.keys) {
          if (!allKeys.contains(key)) {
            sortedMap[key] = targetMap[key];
          }
        }

        // 5. Write back
        final encoder = JsonEncoder.withIndent('  ');
        await file.writeAsString(encoder.convert(sortedMap));
        print('Updated $fileName: Added $addedCount missing keys.');
      } else {
        print('Skipped $fileName: Up to date.');
      }
    } catch (e) {
      print('Error processing $fileName: $e');
    }
  }

  print('Sync complete.');
}
