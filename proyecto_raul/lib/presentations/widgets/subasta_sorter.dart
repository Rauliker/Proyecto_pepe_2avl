import 'package:proyecto_raul/domain/entities/subastas_entities.dart';

class SubastaSorter {
  static List<SubastaEntity> sortSubastas(
      List<SubastaEntity> subastas,
      bool isPriceSortAscending,
      bool isDateSortAscending,
      bool isPriceSort,
      bool isDateSort) {
    if (isPriceSort) {
      subastas.sort((a, b) => isPriceSortAscending
          ? a.pujaActual.compareTo(b.pujaActual)
          : b.pujaActual.compareTo(a.pujaActual));
    } else if (isDateSort) {
      subastas.sort((a, b) => isDateSortAscending
          ? a.fechaFin.compareTo(b.fechaFin)
          : b.fechaFin.compareTo(a.fechaFin));
    }
    return subastas;
  }
}
