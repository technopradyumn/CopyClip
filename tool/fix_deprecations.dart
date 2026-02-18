import 'dart:io';

void main() {
  final dir = Directory('lib');
  if (!dir.existsSync()) return;

  dir.listSync(recursive: true).forEach((entity) {
    if (entity is File && entity.path.endsWith('.dart')) {
      String content = entity.readAsStringSync();
      bool changed = false;

      // Fix Share -> SharePlus
      // Check if file imports share_plus
      if (content.contains('package:share_plus/share_plus.dart')) {
        if (content.contains('Share.share(')) {
          content = content.replaceAll('Share.share(', 'SharePlus.share(');
          changed = true;
        }
        if (content.contains('Share.shareXFiles(')) {
          content = content.replaceAll(
            'Share.shareXFiles(',
            'SharePlus.shareXFiles(',
          );
          changed = true;
        }
      }

      // Fix Color.value -> Color.toARGB32()
      // Regex for variables ending in "olor" or "Color" accessing .value
      final colorRegex = RegExp(r'\b([a-zA-Z0-9_]*[Cc]olor)\.value\b');
      if (colorRegex.hasMatch(content)) {
        content = content.replaceAllMapped(
          colorRegex,
          (m) => '${m.group(1)}.toARGB32()',
        );
        changed = true;
      }

      // Regex for "c.value" often used in color picker callbacks
      final cValueRegex = RegExp(r'\b(c)\.value\b');
      if (cValueRegex.hasMatch(content)) {
        content = content.replaceAllMapped(
          cValueRegex,
          (m) => '${m.group(1)}.toARGB32()',
        );
        changed = true;
      }

      // Fix background -> surface in ThemeData (if missed)
      if (content.contains('colorScheme.background')) {
        content = content.replaceAll(
          'colorScheme.background',
          'colorScheme.surface',
        );
        changed = true;
      }

      if (changed) {
        entity.writeAsStringSync(content);
        print('Fixed ${entity.path}');
      }
    }
  });
}
