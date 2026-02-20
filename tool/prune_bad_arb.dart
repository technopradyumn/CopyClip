import 'dart:convert';
import 'dart:io';

void main() {
  final l10nDir = Directory('lib/src/l10n');
  final sourceFile = File('${l10nDir.path}/app_en.arb');

  if (!sourceFile.existsSync()) {
    print('Source file not found');
    return;
  }

  final sourceMap =
      jsonDecode(sourceFile.readAsStringSync()) as Map<String, dynamic>;

  final files = l10nDir.listSync().whereType<File>().where((file) {
    return file.path.endsWith('.arb') && !file.path.endsWith('app_en.arb');
  }).toList();

  int totalPruned = 0;

  for (var file in files) {
    try {
      final content = file.readAsStringSync();
      final Map<String, dynamic> map = jsonDecode(content);
      bool modified = false;

      final keysToRemove = <String>[];

      for (var key in map.keys) {
        if (key.startsWith('@')) continue;

        final sourceValue = sourceMap[key];
        final targetValue = map[key];

        if (sourceValue == null || targetValue is! String)
          continue; // Should not happen if keys match

        if (sourceValue is String) {
          // Check for plural/select corruption
          // If source has "{...plural...}" and target DOES NOT have "plural" (English keyword), it's broken.
          if (sourceValue.contains(', plural,') &&
              !targetValue.contains(', plural,')) {
            print('[PRUNE] ${file.path} -> Key "$key" (Broken Plural)');
            keysToRemove.add(key);
            continue;
          }
          if (sourceValue.contains(', select,') &&
              !targetValue.contains(', select,')) {
            print('[PRUNE] ${file.path} -> Key "$key" (Broken Select)');
            keysToRemove.add(key);
            continue;
          }

          // Check for missing 'other' clause in plural/select
          final otherRegex = RegExp(r'other\s*\{');
          if (targetValue.contains(', plural,') &&
              !otherRegex.hasMatch(targetValue)) {
            print(
              '[PRUNE] ${file.path} -> Key "$key" (Missing "other" in plural)',
            );
            keysToRemove.add(key);
            continue;
          }
          if (targetValue.contains(', select,') &&
              !otherRegex.hasMatch(targetValue)) {
            print(
              '[PRUNE] ${file.path} -> Key "$key" (Missing "other" in select)',
            );
            keysToRemove.add(key);
            continue;
          }

          // Check for placeholder mismatch
          final sourcePlaceholders = RegExp(
            r'\{([\w]+)\}',
          ).allMatches(sourceValue).map((m) => m.group(1)!).toSet();
          final targetPlaceholders = RegExp(
            r'\{([\w]+)\}',
          ).allMatches(targetValue).map((m) => m.group(1)!).toSet();

          // If source has placeholders, target MUST have them (approximately)
          // Actually, strict equality of sets is good.
          if (!SetEquality().equals(sourcePlaceholders, targetPlaceholders)) {
            // Check if target has weird placeholders (like non-ascii)
            // or just missing ones.
            print(
              '[PRUNE] ${file.path} -> Key "$key" (Placeholder Mismatch: Expected $sourcePlaceholders, Got $targetPlaceholders)',
            );
            keysToRemove.add(key);
            continue;
          }
        }
      }

      for (var key in keysToRemove) {
        map.remove(key);
        modified = true;
        totalPruned++;
      }

      if (modified) {
        const encoder = JsonEncoder.withIndent('  ');
        file.writeAsStringSync(encoder.convert(map));
      }
    } catch (e) {
      print('Error processing ${file.path}: $e');
    }
  }

  print('Pruned $totalPruned broken keys.');
}

class SetEquality {
  bool equals(Set a, Set b) {
    if (a.length != b.length) return false;
    return a.containsAll(b);
  }
}
