import 'package:proyecto_raul/domain/entities/subastas_entities.dart';

class SubastaFilter {
  static List<SubastaEntity> filterSubastas(
      List<SubastaEntity> subastas, String query) {
    return subastas.where((subasta) {
      return subasta.nombre.toLowerCase().contains(query.toLowerCase()) ||
          subasta.descripcion.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }
}
