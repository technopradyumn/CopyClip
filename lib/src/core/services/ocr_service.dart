import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class OcrService {
  late TextRecognizer _textRecognizer;

  OcrService({TextRecognitionScript script = TextRecognitionScript.latin}) {
    _textRecognizer = TextRecognizer(script: script);
  }

  /// Extracts text from an image with support for different scripts.
  /// script can be latin, chinese, devanagari, japanese, korean.
  Future<String> extractText(
    String imagePath, {
    TextRecognitionScript? script,
  }) async {
    TextRecognizer? temporaryRecognizer;
    try {
      final inputImage = InputImage.fromFilePath(imagePath);

      // If a specific script is requested that differs from the default,
      // we create a temporary recognizer.
      final recognizer = (script == null)
          ? _textRecognizer
          : (temporaryRecognizer = TextRecognizer(script: script));

      final RecognizedText recognizedText = await recognizer.processImage(
        inputImage,
      );
      return recognizedText.text;
    } catch (e) {
      throw Exception('Error extracting text: $e');
    } finally {
      temporaryRecognizer?.close();
    }
  }

  void dispose() {
    _textRecognizer.close();
  }
}
