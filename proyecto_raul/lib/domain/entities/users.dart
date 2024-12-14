class User {
  final String email;
  final String username;
  final String password;
  final int role;
  final bool banned;
  final double? balance;
  final String calle;
  final Provincia provincia;
  final Localidad localidad;
  final List<Puja>? createdPujas;
  final List<PujaBid>? pujaBids;

  User(
      {required this.email,
      required this.username,
      required this.password,
      required this.role,
      required this.banned,
      required this.balance,
      required this.provincia,
      required this.localidad,
      required this.createdPujas,
      required this.pujaBids,
      required this.calle});
}

class Provincia {
  final int idProvincia;
  final String nombre;

  Provincia({
    required this.idProvincia,
    required this.nombre,
  });

  Map<String, dynamic> toJson() {
    return {
      'id_provincia': idProvincia,
      'nombre': nombre,
    };
  }

  factory Provincia.fromJson(Map<String, dynamic> json) {
    return Provincia(
      idProvincia: json['id_provincia'],
      nombre: json['nombre'],
    );
  }
}

class Localidad {
  final int idLocalidad;
  final String nombre;

  Localidad({
    required this.idLocalidad,
    required this.nombre,
  });

  Map<String, dynamic> toJson() {
    return {
      'id_localidad': idLocalidad,
      'nombre': nombre,
    };
  }

  factory Localidad.fromJson(Map<String, dynamic> json) {
    return Localidad(
      idLocalidad: json['id_localidad'],
      nombre: json['nombre'],
    );
  }
}

class Puja {
  final int id;
  final String nombre;
  final String descripcion;
  final String pujaInicial;
  final String pujaActual;
  final DateTime fechaFin;

  Puja({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.pujaInicial,
    required this.pujaActual,
    required this.fechaFin,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'descripcion': descripcion,
      'pujaInicial': pujaInicial,
      'pujaActual': pujaActual,
      'fechaFin': fechaFin.toIso8601String(),
    };
  }

  factory Puja.fromJson(Map<String, dynamic> json) {
    return Puja(
      id: json['id'],
      nombre: json['nombre'],
      descripcion: json['descripcion'],
      pujaInicial: json['pujaInicial'],
      pujaActual: json['pujaActual'],
      fechaFin: DateTime.parse(json['fechaFin']),
    );
  }
}

class PujaBid {
  final int id;
  final String amount;
  final String emailUser;

  PujaBid({required this.id, required this.amount, required this.emailUser});

  Map<String, dynamic> toJson() {
    return {'id': id, 'amount': amount, 'email_user': emailUser};
  }

  factory PujaBid.fromJson(Map<String, dynamic> json) {
    return PujaBid(
        id: json['id'], amount: json['amount'], emailUser: json['email_user']);
  }
}
