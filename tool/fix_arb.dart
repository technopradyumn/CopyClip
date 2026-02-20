import 'dart:convert';
import 'dart:io';

void main() {
  final l10nDir = Directory('lib/src/l10n');
  final files = l10nDir.listSync().whereType<File>().where((file) {
    return file.path.endsWith('.arb');
  }).toList();

  int fixedCount = 0;

  for (var file in files) {
    try {
      final content = file.readAsStringSync();
      final Map<String, dynamic> map = jsonDecode(content);
      bool modified = false;

      for (var key in map.keys) {
        if (key.startsWith('@')) continue;
        final value = map[key];
        if (value is String) {
          // Fix unescaped single quotes
          // Logic:
          // 1. Hide existing valid escapes ('')
          // 2. Escape remaining single quotes (') -> ('')
          // 3. Restore hidden escapes

          if (value.contains("'")) {
            String temp = value.replaceAll("''", "##DOUBLE_QUOTE##");
            if (temp.contains("'")) {
              // We have unescaped quotes
              String fixed = temp.replaceAll("'", "''");
              // Restore
              fixed = fixed.replaceAll("##DOUBLE_QUOTE##", "''");

              if (fixed != value) {
                print('[FIX] ${file.path} -> Key: "$key"');
                print('      Old: "$value"');
                print('      New: "$fixed"');
                map[key] = fixed;
                modified = true;
              }
            }
          }
        }
      }

      if (modified) {
        const encoder = JsonEncoder.withIndent('  ');
        file.writeAsStringSync(encoder.convert(map));
        fixedCount++;
      }
    } catch (e) {
      print('[FATAL] Error processing ${file.path}: $e');
    }
  }

  print('Fixed $fixedCount files.');
}
