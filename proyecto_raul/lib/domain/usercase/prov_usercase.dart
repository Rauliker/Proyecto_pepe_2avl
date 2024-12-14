import 'package:proyecto_raul/domain/entities/provincias.dart';
import 'package:proyecto_raul/domain/repositories/prov_repository.dart';

class CaseProvInfo {
  final ProvRepository repository;

  CaseProvInfo(this.repository);

  Future<List<Prov>> call() async {
    List<Prov> provInfo = await repository.getRepProvInfo();
    return provInfo;
  }
}
