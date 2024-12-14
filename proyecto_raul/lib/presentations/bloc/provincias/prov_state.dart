import 'package:equatable/equatable.dart';
import 'package:proyecto_raul/domain/entities/provincias.dart';

abstract class ProvState extends Equatable {
  const ProvState();

  @override
  List<Object?> get props => [];
}

// Estado inicial
class ProvInitial extends ProvState {}

// Estado cargando
class ProvLoading extends ProvState {}

// Estado cargado
class ProvLoaded extends ProvState {
  final List<Prov> provincias; // Cambiado a lista si es necesario

  const ProvLoaded(this.provincias);

  @override
  List<Object?> get props => [provincias];
}

// Estado de error
class ProvError extends ProvState {
  final String message;

  const ProvError({this.message = "Error desconocido al cargar provincias."});

  @override
  List<Object?> get props => [message];
}
