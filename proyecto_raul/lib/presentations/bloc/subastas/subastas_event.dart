import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';

abstract class SubastasEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchAllSubastasEvent extends SubastasEvent {}

class FetchSubastasPorUsuarioEvent extends SubastasEvent {
  final String email;

  FetchSubastasPorUsuarioEvent(this.email);

  @override
  List<Object> get props => [email];
}

class FetchSubastasPorIdEvent extends SubastasEvent {
  final int id;

  FetchSubastasPorIdEvent(this.id);

  @override
  List<Object> get props => [id];
}

class FetchSubastasDeOtroUsuarioEvent extends SubastasEvent {
  final String userId;

  FetchSubastasDeOtroUsuarioEvent(this.userId);

  @override
  List<Object> get props => [userId];
}

class CreateSubastaEvent extends SubastasEvent {
  final String nombre;
  final String descripcion;
  final String subInicial;
  final String fechaFin;
  final String creatorId;
  final List<PlatformFile> imagenes;
  CreateSubastaEvent({
    required this.nombre,
    required this.descripcion,
    required this.subInicial,
    required this.fechaFin,
    required this.creatorId,
    required this.imagenes,
  });

  @override
  List<Object> get props =>
      [nombre, descripcion, subInicial, fechaFin, creatorId, imagenes];
}

class UpdateSubastaEvent extends SubastasEvent {
  final int id;
  final String nombre;
  final String descripcion;
  final String fechaFin;

  UpdateSubastaEvent(
      {required this.id,
      required this.nombre,
      required this.descripcion,
      required this.fechaFin});

  @override
  List<Object> get props => [id, nombre];
}

class DeleteSubastaEvent extends SubastasEvent {
  final int id;

  DeleteSubastaEvent(this.id);

  @override
  List<Object> get props => [id];
}

class CreateSubastaPujaEvent extends SubastasEvent {
  final int idPuja;
  final String email;
  final String puja;
  CreateSubastaPujaEvent(
      {required this.idPuja, required this.email, required this.puja});

  @override
  List<Object> get props => [idPuja, email, puja];
}
