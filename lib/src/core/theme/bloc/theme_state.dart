part of 'theme_bloc.dart';

class ThemeState extends Equatable {
  final ThemeMode themeMode;
  final Color primaryColor;
  final BackgroundDesign backgroundDesign;
  final ThemeData
  themeData; // Computed for convenience/performance if needed, or derived in UI

  const ThemeState({
    required this.themeMode,
    required this.primaryColor,
    required this.backgroundDesign,
    required this.themeData,
  });

  factory ThemeState.initial() {
    return ThemeState(
      themeMode: ThemeMode.system,
      primaryColor: const Color(0xFF6366F1), // Default indigo/violet
      backgroundDesign: BackgroundDesign.classicBubbles,
      themeData: AppTheme.lightTheme(const Color(0xFF6366F1)),
    );
  }

  ThemeState copyWith({
    ThemeMode? themeMode,
    Color? primaryColor,
    BackgroundDesign? backgroundDesign,
  }) {
    // Recompute theme data when properties change
    final newMode = themeMode ?? this.themeMode;
    final newColor = primaryColor ?? this.primaryColor;
    final newDesign = backgroundDesign ?? this.backgroundDesign;

    return ThemeState(
      themeMode: newMode,
      primaryColor: newColor,
      backgroundDesign: newDesign,
      themeData: newMode == ThemeMode.dark
          ? AppTheme.darkTheme(newColor)
          : AppTheme.lightTheme(newColor),
    );
  }

  @override
  List<Object?> get props => [
    themeMode,
    primaryColor,
    backgroundDesign,
    themeData,
  ];
}
