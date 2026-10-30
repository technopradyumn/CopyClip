part of 'theme_bloc.dart';

class ThemeState extends Equatable {
  final ThemeMode themeMode;
  final Color primaryColor;
  final BackgroundDesign backgroundDesign;
  final bool applyBackgroundToWidgets;
  final ThemeData themeData;

  const ThemeState({
    required this.themeMode,
    required this.primaryColor,
    required this.backgroundDesign,
    required this.applyBackgroundToWidgets,
    required this.themeData,
  });

  factory ThemeState.initial() {
    return ThemeState(
      themeMode: ThemeMode.system,
      primaryColor: const Color(0xFF6366F1), // Default indigo/violet
      backgroundDesign: BackgroundDesign.classicBubbles,
      applyBackgroundToWidgets: false,
      themeData: AppTheme.lightTheme(const Color(0xFF6366F1)),
    );
  }

  ThemeState copyWith({
    ThemeMode? themeMode,
    Color? primaryColor,
    BackgroundDesign? backgroundDesign,
    bool? applyBackgroundToWidgets,
  }) {
    // Recompute theme data when properties change
    final newMode = themeMode ?? this.themeMode;
    final newColor = primaryColor ?? this.primaryColor;
    final newDesign = backgroundDesign ?? this.backgroundDesign;
    final newApply = applyBackgroundToWidgets ?? this.applyBackgroundToWidgets;

    return ThemeState(
      themeMode: newMode,
      primaryColor: newColor,
      backgroundDesign: newDesign,
      applyBackgroundToWidgets: newApply,
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
        applyBackgroundToWidgets,
        themeData,
      ];
}
