import 'package:file_picker/file_picker.dart';
import 'package:proyecto_raul/domain/entities/subastas_entities.dart';

abstract class SubastasRepository {
  Future<void> createSubasta(
    String nombre,
    String descripcion,
    String subInicial,
    String fechaFin,
    String creatorId,
    List<PlatformFile> imagenes,
  );
  Future<List<SubastaEntity>> getAllSubastas();
  Future<void> deleteSubasta(int id);
  Future<List<SubastaEntity>> getSubastasDeOtroUsuario(String userId);
  Future<List<SubastaEntity>> getSubastasPorUsuario(String email);
  Future<SubastaEntity> getSubastaById(int id);
  Future<void> updateSubasta(
      int id,
      String nombre,
      String descripcion,
      String fechaFin,
      List<String> eliminatedImages,
      List<PlatformFile> added,
      String pujaInicial);
  Future<void> makePuja(int idPuja, String email, String puja, bool isAuto,
      String incrementController, String maxAutoController);
}
