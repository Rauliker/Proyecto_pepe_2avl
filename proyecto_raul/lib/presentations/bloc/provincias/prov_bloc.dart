import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:proyecto_raul/domain/usercase/prov_usercase.dart';
import 'package:proyecto_raul/presentations/bloc/provincias/prov_event.dart';
import 'package:proyecto_raul/presentations/bloc/provincias/prov_state.dart';

class ProvBloc extends Bloc<ProvEvent, ProvState> {
  final CaseProvInfo provInfo;

  ProvBloc(this.provInfo) : super(ProvInitial()) {
    on<ProvDataRequest>((event, emit) async {
      emit(ProvLoading());
      try {
        final prov = await provInfo();
        emit(ProvLoaded(prov));
      } catch (e) {
        emit(ProvError(message: e.toString()));
      }
    });
  }
}
