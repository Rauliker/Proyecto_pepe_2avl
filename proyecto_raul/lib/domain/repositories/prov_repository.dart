import 'package:proyecto_raul/domain/entities/provincias.dart';

abstract class ProvRepository {
  Future<List<Prov>> getRepProvInfo();
}
