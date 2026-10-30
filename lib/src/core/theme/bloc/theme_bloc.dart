import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:copyclip/src/core/utils/widget_sync_service.dart';
import '../app_theme.dart';
import '../app_colors.dart';
import '../emotion.dart';
import '../background_design.dart';

part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  static const String _boxName = 'theme_box';

  ThemeBloc() : super(ThemeState.initial()) {
    on<LoadTheme>(_onLoadTheme);
    on<ChangeThemeMode>(_onChangeThemeMode);
    on<ChangePrimaryColor>(_onChangePrimaryColor);
    on<ChangeBackgroundDesign>(_onChangeBackgroundDesign);
    on<ToggleApplyBackgroundToWidgets>(_onToggleApplyBackgroundToWidgets);
    on<UpdateEmotionalColor>(_onUpdateEmotionalColor);
  }

  Future<void> _onLoadTheme(LoadTheme event, Emitter<ThemeState> emit) async {
    try {
      final box = await Hive.openBox(_boxName);

      // Load Mode
      final modeStr = box.get('theme_mode', defaultValue: 'system');
      ThemeMode mode;
      switch (modeStr) {
        case 'light':
          mode = ThemeMode.light;
          break;
        case 'dark':
          mode = ThemeMode.dark;
          break;
        default:
          mode = ThemeMode.system;
      }

      // Load Color
      final colorVal = box.get('primary_color_value', defaultValue: 0xFF6366F1);
      final color = Color(colorVal);

      // Load Background Design
      final designStr = box.get(
        'background_design',
        defaultValue: BackgroundDesign.classicBubbles.name,
      );
      final design = BackgroundDesign.values.firstWhere(
        (e) => e.name == designStr,
        orElse: () => BackgroundDesign.classicBubbles,
      );

      // Load Apply Background to Widgets
      final applyToWidgets =
          box.get('apply_background_to_widgets', defaultValue: false);

      emit(
        state.copyWith(
          themeMode: mode,
          primaryColor: color,
          backgroundDesign: design,
          applyBackgroundToWidgets: applyToWidgets,
        ),
      );

      await WidgetSyncService.syncThemeAndBackground(
        design: design,
        applyToWidgets: applyToWidgets,
        primaryColor: color,
        mode: mode,
      );
    } catch (e) {
      debugPrint("❌ Error loading theme: $e");
    }
  }

  Future<void> _onChangeBackgroundDesign(
    ChangeBackgroundDesign event,
    Emitter<ThemeState> emit,
  ) async {
    final box = await Hive.openBox(_boxName);
    await box.put('background_design', event.design.name);
    emit(state.copyWith(backgroundDesign: event.design));

    await WidgetSyncService.syncThemeAndBackground(
      design: event.design,
      applyToWidgets: state.applyBackgroundToWidgets,
      primaryColor: state.primaryColor,
      mode: state.themeMode,
    );
  }

  Future<void> _onToggleApplyBackgroundToWidgets(
    ToggleApplyBackgroundToWidgets event,
    Emitter<ThemeState> emit,
  ) async {
    final box = await Hive.openBox(_boxName);
    await box.put('apply_background_to_widgets', event.allow);
    emit(state.copyWith(applyBackgroundToWidgets: event.allow));

    await WidgetSyncService.syncThemeAndBackground(
      design: state.backgroundDesign,
      applyToWidgets: event.allow,
      primaryColor: state.primaryColor,
      mode: state.themeMode,
    );
  }

  Future<void> _onChangeThemeMode(
    ChangeThemeMode event,
    Emitter<ThemeState> emit,
  ) async {
    final box = await Hive.openBox(_boxName);
    await box.put('theme_mode', event.mode.name);
    emit(state.copyWith(themeMode: event.mode));

    await WidgetSyncService.syncThemeAndBackground(
      design: state.backgroundDesign,
      applyToWidgets: state.applyBackgroundToWidgets,
      primaryColor: state.primaryColor,
      mode: event.mode,
    );
  }

  Future<void> _onChangePrimaryColor(
    ChangePrimaryColor event,
    Emitter<ThemeState> emit,
  ) async {
    final box = await Hive.openBox(_boxName);
    await box.put('primary_color_value', event.color.toARGB32());
    emit(state.copyWith(primaryColor: event.color));

    await WidgetSyncService.syncThemeAndBackground(
      design: state.backgroundDesign,
      applyToWidgets: state.applyBackgroundToWidgets,
      primaryColor: event.color,
      mode: state.themeMode,
    );
  }

  Future<void> _onUpdateEmotionalColor(
    UpdateEmotionalColor event,
    Emitter<ThemeState> emit,
  ) async {
    // Get color from emotion
    final color = AppColors.getEmotionColor(event.emotion);

    // Save and emit
    final box = await Hive.openBox(_boxName);
    await box.put('primary_color_value', color.toARGB32());

    emit(state.copyWith(primaryColor: color));

    await WidgetSyncService.syncThemeAndBackground(
      design: state.backgroundDesign,
      applyToWidgets: state.applyBackgroundToWidgets,
      primaryColor: color,
      mode: state.themeMode,
    );
  }
}
