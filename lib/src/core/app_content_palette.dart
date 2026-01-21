import 'package:flutter/material.dart';

class AppContentPalette {
  /// The 5 core iOS System Colors
  static const List<Color> palette = [
    Color(0xFFF2F2F7), // System Gray 6 (Premium White)
    Color(0xFFFF9A95), // Lighter Red
    Color(0xFF5AB0FF), // Lighter Blue
    Color(0xFF34C759), // System Green
    Color(0xFF5856D6), // System Indigo (iOS Purple)
  ];

  /// Provides a color from its integer value for Hive storage.
  static Color getColorFromValue(int value) {
    return palette.firstWhere(
      (color) => color.value == value,
      orElse: () => const Color(0xFFF2F2F7),
    );
  }

  /// Provides a contrasting color (Black or White) for the background.
  static Color getContrastColor(Color color) {
    final brightness = ThemeData.estimateBrightnessForColor(color);
    return brightness == Brightness.dark ? Colors.white : Colors.black87;
  }

  /// ✅ NEW: Returns the default background color based on current Theme Brightness.
  static Color getDefaultColor(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return brightness == Brightness.dark
        ? const Color(0xFF1C1C1E) // Dark Mode Default (Dark Grey)
        : const Color(0xFFF2F2F7); // Light Mode Default (Light Grey)
  }
}
