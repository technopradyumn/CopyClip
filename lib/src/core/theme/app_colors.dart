import 'package:flutter/material.dart';
import 'emotion.dart';

class AppColors {
  // Light Theme Text
  static const Color textPrimary = Color(0xFF1F2937); // Dark Blue-Grey
  static const Color textSecondary = Color(0xFF6B7280); // Cool Grey

  // Dark Theme Text
  static const Color textLight = Color(0xFFF3F4F6); // Light Grey

  // Dark Theme Backgrounds
  static const Color surfaceDark = Color(0xFF1F2937); // Dark Grey Surface
  static const Color backgroundDark = Color(0xFF111827); // Darker Background

  // Glassmorphism (inferred)
  static const Color glassBackground = Color(
    0x1FFFFFFF,
  ); // White with low opacity
  static const Color glassBorder = Color(
    0x3FFFFFFF,
  ); // White with higher opacity

  static Color getEmotionColor(Emotion emotion) {
    switch (emotion) {
      case Emotion.happy:
        return Colors.yellow;
      case Emotion.sad:
        return Colors.blue;
      case Emotion.angry:
        return Colors.red;
      case Emotion.anxious:
        return Colors.orange;
      case Emotion.neutral:
        return Colors.grey;
      case Emotion.excited:
        return Colors.pink;
      case Emotion.calm:
        return Colors.green;
    }
  }

  // Primary/Secondary placeholders if needed by other files not yet analyzed,
  // but app_theme.dart takes primary as argument, so might not be needed here static-ly
  // unless referenced elsewhere. For now, sticking to what triggered errors.
}
