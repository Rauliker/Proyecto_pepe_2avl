import 'package:file_picker/file_picker.dart';
import 'package:proyecto_raul/domain/entities/subastas_entities.dart';
import 'package:proyecto_raul/domain/repositories/sub_repository.dart';

class CaseFetchAllSubastas {
  final SubastasRepository subastasRepository;

  CaseFetchAllSubastas(this.subastasRepository);

  Future<List<SubastaEntity>> call() async {
    return await subastasRepository.getAllSubastas();
  }
}

class CaseFetchSubastasPorUsuario {
  final SubastasRepository subastasRepository;

  CaseFetchSubastasPorUsuario(this.subastasRepository);

  Future<List<SubastaEntity>> call(String email) async {
    return await subastasRepository.getSubastasPorUsuario(email);
  }
}

class CaseFetchSubastasPorId {
  final SubastasRepository subastasRepository;

  CaseFetchSubastasPorId(this.subastasRepository);

  Future<SubastaEntity> call(int id) async {
    return await subastasRepository.getSubastaById(id);
  }
}

class CaseFetchSubastasDeOtroUsuario {
  final SubastasRepository subastasRepository;

  CaseFetchSubastasDeOtroUsuario(this.subastasRepository);

  Future<List<SubastaEntity>> call(String userId) async {
    return await subastasRepository.getSubastasDeOtroUsuario(userId);
  }
}

class CaseCreateSubasta {
  final SubastasRepository subastasRepository;

  CaseCreateSubasta(this.subastasRepository);

  Future<void> call(
    String nombre,
    String descripcion,
    String subInicial,
    String fechaFin,
    String creatorId,
    List<PlatformFile> imagenes,
  ) async {
    return await subastasRepository.createSubasta(
        nombre, descripcion, subInicial, fechaFin, creatorId, imagenes);
  }
}

class CaseUpdateSubasta {
  final SubastasRepository subastasRepository;

  CaseUpdateSubasta(this.subastasRepository);

  Future<void> call(
      int id, String nombre, String decripcion, String fechaFin) async {
    return await subastasRepository.updateSubasta(
        id, nombre, decripcion, fechaFin);
  }
}

class CaseDeleteSubasta {
  final SubastasRepository subastasRepository;

  CaseDeleteSubasta(this.subastasRepository);

  Future<void> call(int id) async {
    return await subastasRepository.deleteSubasta(id);
  }
}

class CaseMakePuja {
  final SubastasRepository subastasRepository;

  CaseMakePuja(this.subastasRepository);

  Future<void> call(int idPuja, String email, String puja) async {
    return await subastasRepository.makePuja(idPuja, email, puja);
  }
}
