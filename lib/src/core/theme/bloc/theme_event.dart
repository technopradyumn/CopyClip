part of 'theme_bloc.dart';

abstract class ThemeEvent extends Equatable {
  const ThemeEvent();

  @override
  List<Object?> get props => [];
}

class LoadTheme extends ThemeEvent {}

class ChangeThemeMode extends ThemeEvent {
  final ThemeMode mode;
  const ChangeThemeMode(this.mode);

  @override
  List<Object?> get props => [mode];
}

class ChangePrimaryColor extends ThemeEvent {
  final Color color;
  const ChangePrimaryColor(this.color);

  @override
  List<Object?> get props => [color];
}

class ChangeBackgroundDesign extends ThemeEvent {
  final BackgroundDesign design;
  const ChangeBackgroundDesign(this.design);

  @override
  List<Object?> get props => [design];
}

class UpdateEmotionalColor extends ThemeEvent {
  final Emotion emotion;
  const UpdateEmotionalColor(this.emotion);

  @override
  List<Object?> get props => [emotion];
}
