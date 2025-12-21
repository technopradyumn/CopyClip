
import 'package:flutter/material.dart';

// Define your color palette as abstract properties
abstract class AppColors {
  // Primary and accent colors
  Color get primary;
  Color get secondary;

  // Surface and background colors
  Color get surface;
  Color get background;
  Color get onSurface;
  Color get onBackground;

  // Special purpose colors
  Color get destructive;
  Color get glassBackground;

  // Text colors
  Color get textPrimary;
  Color get textSecondary;
}

// Concrete implementation for the light theme
class LightThemeColors implements AppColors {
  @override
  Color get primary => const Color(0xFF6200EE);
  @override
  Color get secondary => const Color(0xFF03DAC6);

  @override
  Color get surface => Colors.white;
  @override
  Color get background => const Color(0xFFF2F2F7);
  @override
  Color get onSurface => Colors.black87;
  @override
  Color get onBackground => Colors.black;

  @override
  Color get destructive => Colors.red;
  @override
  Color get glassBackground => Colors.white.withOpacity(0.6);

  @override
  Color get textPrimary => Colors.black87;
  @override
  Color get textSecondary => Colors.black54;
}

// Concrete implementation for the dark theme
class DarkThemeColors implements AppColors {
  @override
  Color get primary => const Color(0xFFBB86FC);
  @override
  Color get secondary => const Color(0xFF03DAC6);

  @override
  Color get surface => const Color(0xFF121212);
  @override
  Color get background => const Color(0xFF1C1C1E);
  @override
  Color get onSurface => Colors.white;
  @override
  Color get onBackground => Colors.white;

  @override
  Color get destructive => Colors.redAccent;
  @override
  Color get glassBackground => Colors.black.withOpacity(0.5);

  @override
  Color get textPrimary => Colors.white;
  @override
  Color get textSecondary => Colors.white70;
}
