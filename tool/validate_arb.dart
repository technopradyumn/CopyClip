import 'dart:convert';
import 'dart:io';

void main() {
  final l10nDir = Directory('lib/src/l10n');
  final files = l10nDir.listSync().whereType<File>().where((file) {
    return file.path.endsWith('.arb');
  }).toList();

  int errorCount = 0;

  for (var file in files) {
    try {
      final content = file.readAsStringSync();
      final Map<String, dynamic> map = jsonDecode(content);

      for (var key in map.keys) {
        if (key.startsWith('@')) continue;
        final value = map[key];
        if (value is String) {
          if (_hasSyntaxError(value)) {
            print('[ERROR] ${file.path} -> Key: "$key"');
            print('        Value: "$value"');
            errorCount++;
          }
        }
      }
    } catch (e) {
      print('[FATAL] JSON Decode Error in ${file.path}: $e');
      errorCount++;
    }
  }

  if (errorCount == 0) {
    print('No errors found!');
  } else {
    print('Found $errorCount errors.');
  }
}

bool _hasSyntaxError(String value) {
  // Check for unescaped single quotes
  // A single quote is unescaped if it is NOT followed by another single quote
  // AND it is inside a brace pair or just generally in the text where formatting might occur.
  // Actually, ICU syntax says ANY single quote starts quoted text unless expanded.

  // Heuristic: Odd number of single quotes is suspicious, but '' is an escape.
  // So ' -> start quote
  // '' -> literal '

  // We want to find cases where we have something like "Don't" which should be "Don''t"

  // Regex to find single quotes that are likely text apostrophes.
  // Matches ' that is NOT followed by '
  final singleQuoteRegex = RegExp(r"'(?!')");

  // However, '{' is valid quoting.
  // But generally, looking for "Recents'" or "Don't" etc.

  // Simple check: count single quotes.
  // If we have "Don't", matches = 1.
  // If "Don''t", matches = 0 (because we only match ' not followed by ').
  // Wait, ' not followed by ' matches the second ' in ''? No, r"'(?!')" matches a ' if the next char is not '.
  // In "Don''t":
  // 1st ': next is '. No match.
  // 2nd ': next is t. MATCH.

  // So "Don''t" would match. That's wrong.
  // We want to detect "Don't".

  // Let's iterate.
  for (int i = 0; i < value.length; i++) {
    if (value[i] == "'") {
      // Check next char
      if (i + 1 < value.length && value[i + 1] == "'") {
        // Escaped quote (''), skip next
        i++;
      } else {
        // Unescaped quote.
        // This is valid IF it is escaping syntax, e.g. '{' -> '{
        // But if it is like "isn't", it is invalid in ICU if it wraps placeholders.
        // Actually, in Flutter l10n, even simple strings might strict mode check this.
        // But USUALLY it breaks when you have placeholders.

        // If the string HAS braces, then unescaped quotes are dangerous.
        if (value.contains('{')) {
          // If we found a single quote that isn't doubled, and the string contains {, strict mode might fail.
          // But ' { ' is valid escaping of {.
          // "Don't {arg}" -> parse error or behavior error?
          // "Don't {arg}" -> "Don" + quoted string "t {arg}" -> "Don" + "t {arg}" literal. No placeholder substitution.
          // This is usually what users complain about: variable not replaced.
          // OR "Lexing error" if braces are unbalanced because of quoting.

          // Simplest heuristic: suspicious if we are in a string with valid-looking placeholders
          // but have single quotes that look like apostrophes.
          return true;
        }
      }
    }
  }

  // Also check for unbalanced braces just in case
  int balance = 0;
  for (int i = 0; i < value.length; i++) {
    // We need to ignore braces inside '...' quoted sections if we were doing a full parser,
    // but '...' handling is what we are trying to debug.
    // So let's just do a naive check.
    if (value[i] == '{') balance++;
    if (value[i] == '}') balance--;
  }
  if (balance != 0) return true;

  return false;
}
