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

  // Cosmic Aura Palette (Sophisticated & Unique)
  static const Color auroraPink = Color(0xFFF472B6);
  static const Color cosmicIndigo = Color(0xFF6366F1);
  static const Color nebulaViolet = Color(0xFF8B5CF6);
  static const Color starlightTeal = Color(0xFF2DD4BF);
  static const Color solarAmber = Color(0xFFF59E0B);
  static const Color novaEmerald = Color(0xFF10B981);
}
