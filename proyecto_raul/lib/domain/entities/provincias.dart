class Prov {
  final int idProvincia;
  final String nombre;
  final List<ProvLocalidad>? localidades;

  Prov({
    required this.idProvincia,
    required this.nombre,
    required this.localidades,
  });
  Map<String, dynamic> toJson() {
    return {
      'id_provincia': idProvincia,
      'nombre': nombre,
      'localidades': localidades?.map((puja) => puja.toJson()).toList(),
    };
  }

  factory Prov.fromJson(Map<String, dynamic> json) {
    return Prov(
      idProvincia: json['id_provincia'],
      nombre: json['nombre'],
      localidades: (json['localidades'] as List<dynamic>?)
              ?.map((puja) => ProvLocalidad.fromJson(puja))
              .toList() ??
          [],
    );
  }
}

class ProvLocalidad {
  final int idLocalidad;
  final String nombre;

  ProvLocalidad({
    required this.idLocalidad,
    required this.nombre,
  });

  Map<String, dynamic> toJson() {
    return {
      'id_localidad': idLocalidad,
      'nombre': nombre,
    };
  }

  factory ProvLocalidad.fromJson(Map<String, dynamic> json) {
    return ProvLocalidad(
      idLocalidad: json['id_localidad'],
      nombre: json['nombre'],
    );
  }
}
