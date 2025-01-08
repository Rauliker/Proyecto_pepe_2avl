import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:proyecto_raul/domain/usercase/subastas_usecase.dart';
import 'package:proyecto_raul/presentations/bloc/subastas/subastas_event.dart';
import 'package:proyecto_raul/presentations/bloc/subastas/subastas_state.dart';

class SubastasBloc extends Bloc<SubastasEvent, SubastasState> {
  final CaseFetchAllSubastas fetchAllSubastas;
  final CaseFetchSubastasPorUsuario fetchSubastasPorUsuario;
  final CaseFetchSubastasDeOtroUsuario fetchSubastasDeOtroUsuario;
  final CaseCreateSubasta createSubasta;
  final CaseUpdateSubasta updateSubasta;
  final CaseDeleteSubasta deleteSubasta;
  final CaseFetchSubastasPorId fetchSubastasPorId;
  final CaseMakePuja makePuja;

  SubastasBloc(
    this.fetchAllSubastas,
    this.fetchSubastasPorUsuario,
    this.fetchSubastasDeOtroUsuario,
    this.createSubasta,
    this.updateSubasta,
    this.deleteSubasta,
    this.fetchSubastasPorId,
    this.makePuja,
  ) : super(SubastasInitialState()) {
    on<FetchAllSubastasEvent>((event, emit) async {
      emit(SubastasLoadingState());
      try {
        final subastas = await fetchAllSubastas.call();
        emit(SubastasLoadedState(subastas));
      } catch (e) {
        emit(SubastasErrorState(e.toString()));
      }
    });

    on<FetchSubastasPorUsuarioEvent>((event, emit) async {
      emit(SubastasLoadingState());
      try {
        final subastas = await fetchSubastasPorUsuario.call(event.email);
        emit(SubastasLoadedState(subastas));
      } catch (e) {
        emit(SubastasErrorState(e.toString()));
      }
    });

    on<FetchSubastasPorIdEvent>((event, emit) async {
      emit(SubastasLoadingState());
      try {
        final subastas = await fetchSubastasPorId.call(event.id);
        emit(SubastasLoadedStateId(subastas));
      } catch (e) {
        emit(SubastasErrorState(e.toString()));
      }
    });

    on<FetchSubastasDeOtroUsuarioEvent>((event, emit) async {
      emit(SubastasLoadingState());
      try {
        final subastas = await fetchSubastasDeOtroUsuario.call(event.userId);
        emit(SubastasLoadedState(subastas));
      } catch (e) {
        emit(SubastasErrorState(e.toString()));
      }
    });

    on<CreateSubastaEvent>((event, emit) async {
      emit(SubastasLoadingState());
      try {
        await createSubasta.call(event.nombre, event.descripcion,
            event.subInicial, event.fechaFin, event.creatorId, event.imagenes);
        emit(SubastaCreatedState());
        add(FetchAllSubastasEvent());
      } catch (e) {
        emit(SubastasErrorState(e.toString()));
      }
    });

    on<CreateSubastaPujaEvent>((event, emit) async {
      emit(SubastasLoadingState());
      try {
        await makePuja.call(event.idPuja, event.email, event.puja);
        emit(SubastaCreatedPujaState());
      } catch (e) {
        emit(SubastasPujaErrorState(e.toString()));
      }
    });

    on<UpdateSubastaEvent>((event, emit) async {
      emit(SubastasLoadingState());
      try {
        await updateSubasta.call(
            event.id, event.nombre, event.descripcion, event.fechaFin);
        emit(SubastaUpdatedState());
      } catch (e) {
        emit(SubastasErrorState(e.toString()));
      }
    });

    on<DeleteSubastaEvent>((event, emit) async {
      emit(SubastasLoadingState());
      try {
        await deleteSubasta.call(event.id);

        emit(SubastaDeletedState());
      } catch (e) {
        emit(SubastasErrorState(e.toString()));
      }
    });
  }
}
