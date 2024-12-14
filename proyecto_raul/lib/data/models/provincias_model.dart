import 'package:proyecto_raul/domain/entities/provincias.dart';

class ProvModel extends Prov {
  ProvModel({
    required super.idProvincia,
    required super.nombre,
    super.localidades,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'id_provincia': idProvincia,
      'nombre': nombre,
      'localidades': localidades?.map((puja) => puja.toJson()).toList(),
    };
  }

  factory ProvModel.fromJson(Map<String, dynamic> json) {
    return ProvModel(
      idProvincia: json['id_provincia'],
      nombre: json['nombre'],
      localidades: (json['localidades'] as List<dynamic>?)
              ?.map((puja) => ProvLocalidad.fromJson(puja))
              .toList() ??
          [],
    );
  }
}
