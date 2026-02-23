import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

/// OCR service that runs Latin + Devanagiri recognition and merges text.
///
/// Why two scripts?
///   Images from satsaheb.org and similar sites contain both English (Latin)
///   and Hindi (Devanagiri) text. Running both in sequence and merging gives
///   complete text extraction from the full original image.
class OcrService {
  // We create recognizers lazily and keep them cached.
  TextRecognizer? _latin;
  TextRecognizer? _devanagiri;

  OcrService() {
    _latin = TextRecognizer(script: TextRecognitionScript.latin);
    try {
      _devanagiri = TextRecognizer(script: TextRecognitionScript.devanagiri);
    } catch (e) {
      debugPrint('[OCR] Devanagiri model not available, using Latin only: $e');
      _devanagiri = null;
    }
  }

  /// Extract ALL text from the image at [imagePath].
  /// Runs Latin + Devanagiri by default so both English and Hindi are captured.
  ///
  /// [script] — pass a specific script to use only that one (backward-compat).
  Future<String> extractText(
    String imagePath, {
    TextRecognitionScript? script,
  }) async {
    final file = File(imagePath);
    if (!await file.exists()) {
      debugPrint('[OCR] File not found: $imagePath');
      return '';
    }

    // Single-script mode (backward-compatible)
    if (script != null) {
      return _runSingle(imagePath, script);
    }

    // Multi-script mode: Latin + Devanagiri
    return _runMulti(imagePath);
  }

  Future<String> _runSingle(
    String imagePath,
    TextRecognitionScript script,
  ) async {
    final TextRecognizer? cached = script == TextRecognitionScript.latin
        ? _latin
        : script == TextRecognitionScript.devanagiri
        ? _devanagiri
        : null;

    final recognizer = cached ?? TextRecognizer(script: script);
    try {
      final inputImage = InputImage.fromFilePath(imagePath);
      final result = await recognizer.processImage(inputImage);
      return result.text.trim();
    } catch (e) {
      debugPrint('[OCR] Error: $e');
      return '';
    } finally {
      if (cached == null) await recognizer.close();
    }
  }

  Future<String> _runMulti(String imagePath) async {
    final inputImage = InputImage.fromFilePath(imagePath);

    // Run SEQUENTIALLY to avoid memory pressure on low-end Android devices
    String latinText = '';
    String devanagiriText = '';

    try {
      if (_latin != null) {
        final r = await _latin!.processImage(inputImage);
        latinText = r.text.trim();
      }
    } catch (e) {
      debugPrint('[OCR] Latin failed: $e');
    }

    try {
      if (_devanagiri != null) {
        final r = await _devanagiri!.processImage(inputImage);
        devanagiriText = r.text.trim();
      }
    } catch (e) {
      debugPrint('[OCR] Devanagiri failed: $e');
    }

    return _mergeTexts(latinText, devanagiriText);
  }

  /// Merge two text strings: split into lines, deduplicate, rejoin.
  String _mergeTexts(String a, String b) {
    if (a.isEmpty) return b;
    if (b.isEmpty) return a;

    // Split both into trimmed non-empty lines
    final linesA = a
        .split('\n')
        .map((l) => l.trim())
        .where((l) => l.isNotEmpty)
        .toList();
    final linesB = b
        .split('\n')
        .map((l) => l.trim())
        .where((l) => l.isNotEmpty)
        .toList();

    // Add all lines from B that aren't already present in A (by exact match or
    // high similarity — avoids duplicating lines recognised by both scripts)
    final seen = <String>{...linesA};
    final merged = [...linesA];

    for (final line in linesB) {
      if (!seen.any((existing) => _similar(line, existing))) {
        seen.add(line);
        merged.add(line);
      }
    }

    return merged.join('\n').trim();
  }

  /// Returns true if two strings are >85% similar (simple char-overlap check).
  bool _similar(String a, String b) {
    if (a == b) return true;
    if (a.isEmpty || b.isEmpty) return false;
    final shorter = a.length < b.length ? a : b;
    final longer = a.length < b.length ? b : a;
    int matches = 0;
    for (int i = 0; i < shorter.length; i++) {
      if (i < longer.length && shorter[i] == longer[i]) matches++;
    }
    return matches / longer.length > 0.85;
  }

  void dispose() {
    _latin?.close();
    _devanagiri?.close();
    _latin = null;
    _devanagiri = null;
  }
}
