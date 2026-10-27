import 'package:flutter/material.dart';

const version = '1.0.0';
const buildNumber = '100';

class AppConstants {
  static const double cornerRadius = 16.0;
  static const double borderWidth = 1.0;
  static const double selectedBorderWidth = 2.0;

  // Seamless Top Bar
  static const double headerTitleSize = 28.0;
  static const double headerSubtitleSize = 14.0;
  static const double headerIconSize = 24.0;
}

/// Consistent feature colors used across the entire app
/// Each feature has a unique color for visual identity
class FeatureColors {
  // Warm amber for notes
  static const Color notes = Color(0xFFFFB74D);

  // Fresh green for todos
  static const Color todos = Color(0xFF66BB6A);

  // Calm blue for journal
  static const Color journal = Color(0xFF42A5F5);

  // Rich purple for clipboard
  static const Color clipboard = Color(0xFFAB47BC);
}
