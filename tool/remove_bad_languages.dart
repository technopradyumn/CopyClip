import 'dart:convert';
import 'dart:io';

void main() {
  final badFile = File('bad_languages.json');
  if (!badFile.existsSync()) {
    print('bad_languages.json not found');
    return;
  }

  final List<dynamic> badLanguagesJson = jsonDecode(badFile.readAsStringSync());
  final Set<String> badLanguages = badLanguagesJson.cast<String>().toSet();

  final langFile = File('lib/src/core/const/languages.dart');
  final lines = langFile.readAsLinesSync();
  final newLines = <String>[];

  bool inMap = false;
  int removedCount = 0;

  for (var line in lines) {
    if (line.trim().startsWith(
      'static const Map<String, Map<String, String>> supportedLanguages = {',
    )) {
      inMap = true;
      newLines.add(line);
      continue;
    }

    if (inMap && line.trim() == '};') {
      inMap = false;
      newLines.add(line);
      continue;
    }

    if (inMap) {
      // Line format: 'af': {'name': 'Afrikaans', 'flag': '🇿🇦'},
      final match = RegExp(r"^\s*'([a-zA-Z_]+)':").firstMatch(line);
      if (match != null) {
        final code = match.group(1)!;
        if (badLanguages.contains(code)) {
          print('Removing $code');
          removedCount++;
          continue; // Skip this line
        }
      }
    }

    newLines.add(line);
  }

  langFile.writeAsStringSync(
    newLines.join('\n'),
  ); // No newline at end of file usually in dart writes? join(Platform.lineTerminator) better.
  print('Removed $removedCount languages.');
}
