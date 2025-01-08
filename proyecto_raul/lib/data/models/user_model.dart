import 'package:proyecto_raul/domain/entities/users.dart';

class UserModel extends User {
  UserModel({
    required super.email,
    required super.username,
    required super.password,
    required super.avatar,
    required super.role,
    required super.banned,
    super.balance,
    required super.calle,
    required super.provincia,
    required super.localidad,
    // super.createdPujas,
    // super.pujaBids,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      email: json['email'] ?? '',
      username: json['username'] ?? '',
      password: json['password'] ?? '',
      role: json['role'] ?? 2,
      avatar: json['avatar'],
      banned: json['banned'] ?? false,
      balance: double.tryParse(json['balance']),
      calle: json['calle'] ?? '',
      provincia: Provincia(
        idProvincia: json['provincia']?['id_provincia'] ?? 0,
        nombre: json['provincia']?['nombre'] ?? '',
      ),
      localidad: Localidad(
        idLocalidad: json['localidad']?['id_localidad'] ?? 0,
        nombre: json['localidad']?['nombre'] ?? '',
      ),
      // createdPujas: (json['createdPujas'] as List<dynamic>?)
      //         ?.map((puja) => Puja.fromJson(puja))
      //         .toList() ??
      //     [],
      // pujaBids: (json['pujaBids'] as List<dynamic>?)
      //         ?.map((bid) => PujaBid.fromJson(bid))
      //         .toList() ??
      //     [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'username': username,
      'password': password,
      'avatar': avatar,
      'role': role,
      'banned': banned,
      'balance': balance,
      'calle': calle,
      'provincia': {
        'id_provincia': provincia.idProvincia,
        'nombre': provincia.nombre,
      },
      'localidad': {
        'id_localidad': localidad.idLocalidad,
        'nombre': localidad.nombre,
      },
      // 'createdPujas': createdPujas?.map((puja) => puja.toJson()).toList(),
      // 'pujaBids': pujaBids?.map((bid) => bid.toJson()).toList(),
    };
  }
}
