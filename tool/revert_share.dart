import 'dart:io';

void main() {
  final dir = Directory('lib');
  if (!dir.existsSync()) return;

  dir.listSync(recursive: true).forEach((entity) {
    if (entity is File && entity.path.endsWith('.dart')) {
      String content = entity.readAsStringSync();
      bool changed = false;

      // Revert SharePlus -> Share
      if (content.contains('SharePlus.share')) {
        content = content.replaceAll('SharePlus.share', 'Share.share');
        changed = true;
      }

      if (changed) {
        entity.writeAsStringSync(content);
        print('Reverted ${entity.path}');
      }
    }
  });
}
