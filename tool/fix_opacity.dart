import 'dart:io';

void main() {
  final dir = Directory('lib');
  if (!dir.existsSync()) {
    print('lib directory not found');
    return;
  }

  int fixedCount = 0;
  dir.listSync(recursive: true).forEach((entity) {
    if (entity is File && entity.path.endsWith('.dart')) {
      String content = entity.readAsStringSync();
      bool changed = false;

      // Fix withOpacity -> withValues
      if (content.contains('.withOpacity(')) {
        content = content.replaceAllMapped(
          RegExp(r'\.withOpacity\(([^)]+)\)'),
          (match) => '.withValues(alpha: ${match.group(1)})',
        );
        changed = true;
      }

      // Fix colorScheme.background -> colorScheme.surface (safe simple migration)
      if (content.contains('colorScheme.background')) {
        content = content.replaceAll(
          'colorScheme.background',
          'colorScheme.surface',
        );
        changed = true;
      }

      // Fix WillPopScope -> PopScope (Partial fix, might need manual check for onWillPop logic, but deprecated warning suggests PopScope)
      // Actually WillPopScope is complex to migrate automatically as API changed significantly.
      // I will skip WillPopScope auto-fix for now and let user/manual fix handle it if needed, or focused later.

      if (changed) {
        entity.writeAsStringSync(content);
        print('Fixed ${entity.path}');
        fixedCount++;
      }
    }
  });
  print('Finished fixing $fixedCount files.');
}
