import 'dart:convert';
import 'dart:io';

import 'package:translator/translator.dart';

Future<void> main() async {
  final translator = GoogleTranslator();
  final l10nDir = Directory('lib/src/l10n');
  final sourceFile = File('${l10nDir.path}/app_en.arb');

  if (!await sourceFile.exists()) {
    print('Source file app_en.arb not found.');
    return;
  }

  final sourceContent = await sourceFile.readAsString();
  final Map<String, dynamic> sourceMap = jsonDecode(sourceContent);

  // Get all arb files
  final files = l10nDir.listSync().whereType<File>().where((file) {
    return file.path.endsWith('.arb') && !file.path.endsWith('app_en.arb');
  }).toList();

  files.sort((a, b) => a.path.compareTo(b.path));

  print('Found ${files.length} files to process.');

  for (var file in files) {
    final fileName = file.path.split(Platform.pathSeparator).last;
    // Extract locale from filename app_zh_CN.arb -> zh-CN
    // Filename format: app_{locale}.arb
    final localePart = fileName.replaceAll('app_', '').replaceAll('.arb', '');
    // Google Translator expects 'zh-cn', not 'zh_CN' usually, but let's check.
    // The package handles most standardized codes.
    // However, for composed locales like zh_CN, we might need to fix the separator.
    final targetLang = localePart.replaceAll('_', '-');

    print('Processing $fileName ($targetLang)...');

    try {
      final content = await file.readAsString();
      Map<String, dynamic> map = {};
      try {
        map = jsonDecode(content);
      } catch (e) {
        print('Error parsing $fileName, starting with empty map.');
      }

      bool updated = false;
      int translatedCount = 0;

      for (var key in sourceMap.keys) {
        if (key.startsWith('@')) continue; // Skip metadata keys

        final sourceValue = sourceMap[key];

        // Skip if key already exists and has a value different from source (assuming manual translation)
        // BUT, our previous step populated files with English. So we need to translate if value == sourceValue
        // OR if the key is missing.
        var currentVal = map[key];

        // Check for placeholder mismatch
        final sourcePlaceholders = RegExp(
          r'\{([\w]+)\}',
        ).allMatches(sourceValue).map((m) => m.group(1)).toSet();
        if (currentVal != null) {
          final targetPlaceholders = RegExp(
            r'\{([\w]+)\}',
          ).allMatches(currentVal).map((m) => m.group(1)).toSet();
          if (sourcePlaceholders.length != targetPlaceholders.length ||
              !sourcePlaceholders.containsAll(targetPlaceholders)) {
            print('Fixing broken placeholders in $fileName for key "$key"');
            currentVal = null; // Force re-translation
          }
        }

        if (currentVal == null || currentVal == sourceValue) {
          // Needs translation

          // Add slight delay to avoid rate limiting
          await Future.delayed(Duration(milliseconds: 50));

          // Check for complex ICU format (plural, select)
          // Google Translate corrupts these structures, so we skip translation for them and use English.
          if (sourceValue.contains(', plural,') ||
              sourceValue.contains(', select,')) {
            print(
              'Skipping complex ICU translation for "$key" in $fileName. Using English.',
            );
            map[key] = sourceValue;
            updated = true;
            continue;
          }

          try {
            // Protect placeholders
            var textToTranslate = sourceValue;
            final placeholders = <String>[];
            final placeholderMatches = RegExp(
              r'\{([\w]+)\}',
            ).allMatches(sourceValue);
            int i = 0;
            for (var match in placeholderMatches) {
              final placeholder = match.group(0)!;
              placeholders.add(placeholder);
              // Use a format that Google Translate is likely to preserve, usually numbers or specific markers
              // Using a unique ID pattern.
              textToTranslate = textToTranslate.replaceFirst(
                placeholder,
                '<$i>',
              );
              i++;
            }

            final translation = await translator.translate(
              textToTranslate,
              to: targetLang,
            );

            var translatedText = translation.text;

            // Restore placeholders
            for (int j = 0; j < placeholders.length; j++) {
              // Google translate might add spaces like < 0 > or <0>
              // We try to find <j> with flexible spacing
              final pattern = RegExp(r'<\s*' + j.toString() + r'\s*>');
              if (pattern.hasMatch(translatedText)) {
                translatedText = translatedText.replaceFirst(
                  pattern,
                  placeholders[j],
                );
              } else {
                // Fallback: if not found, we might have a problem.
                // But often it works. If not, we might append it or leave it broken (which will be caught next run)
                // For now, let's just append if missing? No, that's dangerous.
                // Let's print a warning.
                print(
                  'Warning: Clean placeholder <$j> not found in translation of "$sourceValue" to $targetLang',
                );
              }
            }

            // Escape single quotes for ICU format
            // If the string contains single quotes that aren't already escaped, escape them.
            // But we must be careful not to double-escape if the translator (unlikely) returned escaped quotes.
            // The safest bet with Google Translate output is that it returns "Don't" (unescaped).
            // So we apply the same fix logic.
            if (translatedText.contains("'")) {
              String temp = translatedText.replaceAll("''", "##DOUBLE_QUOTE##");
              if (temp.contains("'")) {
                translatedText = translatedText.replaceAll("'", "''");
              }
              translatedText = translatedText.replaceAll(
                "##DOUBLE_QUOTE##",
                "''",
              );
            }

            map[key] = translatedText;
          } catch (e) {
            // Try fallback to base language
            if (targetLang.contains('-')) {
              print('Failed to translate "$sourceValue" to $targetLang: $e');
              continue;
              // Removed complex nested fallback for brevity/clarity,
              // focusing on fixing the placeholder issue first.
            } else {
              print('Failed to translate "$sourceValue" to $targetLang: $e');
              continue;
            }
          }
          updated = true;
          translatedCount++;

          // Periodically save to avoid losing all progress if it crashes
          if (translatedCount % 10 == 0) {
            await file.writeAsString(
              const JsonEncoder.withIndent('  ').convert(map),
            );
          }
        }
      }

      if (updated) {
        await file.writeAsString(
          const JsonEncoder.withIndent('  ').convert(map),
        );
        print('Updated $fileName with $translatedCount translations.');
      } else {
        print('$fileName already up to date.');
      }
    } catch (e) {
      print('Error processing file $fileName: $e');
    }

    // Delay between files
    await Future.delayed(Duration(milliseconds: 100));
  }
}
