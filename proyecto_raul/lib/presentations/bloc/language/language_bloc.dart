import 'dart:ui';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:proyecto_raul/presentations/bloc/language/language_event.dart';
import 'package:proyecto_raul/presentations/bloc/language/language_state.dart';

class LanguageBloc extends Bloc<LanguageEvent, LanguageState> {
  LanguageBloc() : super(LanguageState(const Locale('es'))) {
    on<ChangeLanguageEvent>((event, emit) {
      emit(LanguageState(event.locale));
    });
  }
}
