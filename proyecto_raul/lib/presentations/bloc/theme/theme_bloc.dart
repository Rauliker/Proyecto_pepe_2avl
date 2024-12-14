import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:proyecto_raul/config/theme/theme.dart';

import 'theme_events.dart';
import 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  late AppTheme _originalTheme;

  ThemeBloc()
      : super(ThemeState(
            currentTheme:
                AppTheme(selectedColor: 0, isDarkmode: false, sizeText: 18))) {
    _originalTheme = state.currentTheme;
    on<ThemeSelected>(_onThemeSelected);
    on<ApplyTheme>(_onApplyTheme);
    on<CancelTheme>(_onCancelTheme);
  }

  void _onThemeSelected(ThemeSelected event, Emitter<ThemeState> emit) {
    final temporalyTheme = AppTheme(
        selectedColor: event.selectedColor,
        isDarkmode: event.isDarkMode,
        sizeText: event.sizeText,
        selectedFontFamily: event.fontFamily);
    emit(ThemeState(
      currentTheme: temporalyTheme,
      temporalTheme: temporalyTheme,
    ));
  }

  void _onApplyTheme(ApplyTheme event, Emitter<ThemeState> emit) {
    if (state.temporalTheme != null) {
      _originalTheme = state.temporalTheme!;
      emit(ThemeState(currentTheme: state.temporalTheme!));
    } else {
      emit(ThemeState(currentTheme: _originalTheme));
    }
  }

  void _onCancelTheme(CancelTheme event, Emitter<ThemeState> emit) {
    emit(ThemeState(currentTheme: _originalTheme));
  }
}
