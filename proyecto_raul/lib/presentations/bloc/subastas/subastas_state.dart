import 'package:equatable/equatable.dart';
import 'package:proyecto_raul/domain/entities/subastas_entities.dart';

abstract class SubastasState extends Equatable {
  @override
  List<Object> get props => [];
}

class SubastasInitialState extends SubastasState {}

class SubastasLoadingState extends SubastasState {}

class SubastasLoadedState extends SubastasState {
  final List<SubastaEntity> subastas;

  SubastasLoadedState(this.subastas);

  @override
  List<Object> get props => [subastas];
}

class SubastasLoadedStateId extends SubastasState {
  final SubastaEntity subastas;

  SubastasLoadedStateId(this.subastas);

  @override
  List<Object> get props => [subastas];
}

class SubastaCreatedState extends SubastasState {}

class SubastaCreatedPujaState extends SubastasState {}

class SubastaUpdatedState extends SubastasState {}

class SubastaDeletedState extends SubastasState {}

class SubastasErrorState extends SubastasState {
  final String message;

  SubastasErrorState(this.message);

  @override
  List<Object> get props => [message];
}

class SubastasPujaErrorState extends SubastasState {
  final String message;

  SubastasPujaErrorState(this.message);

  @override
  List<Object> get props => [message];
}
