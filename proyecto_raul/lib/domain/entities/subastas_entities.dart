class SubastaEntity {
  final int id;
  final String nombre;
  final bool open;
  final String descripcion;
  final String pujaInicial;
  final DateTime fechaFin;
  final Creator creator;
  final List<Imagen> imagenes;
  final List<Puja>? pujas;
  final int pujaActual;

  SubastaEntity({
    required this.id,
    required this.nombre,
    required this.open,
    required this.descripcion,
    required this.pujaInicial,
    required this.fechaFin,
    required this.creator,
    required this.imagenes,
    required this.pujas,
    required this.pujaActual,
  });

  factory SubastaEntity.fromJson(Map<String, dynamic> json) {
    return SubastaEntity(
      id: json['id'],
      nombre: json['nombre'],
      open: json['open'],
      descripcion: json['descripcion'],
      pujaInicial: json['pujaInicial'],
      fechaFin: DateTime.parse(json['fechaFin']),
      creator: Creator.fromJson(json['creator']),
      imagenes: (json['imagenes'] as List<dynamic>?)!
          .map((i) => Imagen.fromJson(i))
          .toList(),
      pujas: (json['pujas'] as List<dynamic>?)
          ?.map((i) => Puja.fromJson(i))
          .toList(),
      pujaActual: json['pujaActual'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'open': open,
      'descripcion': descripcion,
      'pujaInicial': pujaInicial,
      'fechaFin': fechaFin.toIso8601String(),
      'creator': creator.toJson(),
      'imagenes': imagenes.map((i) => i.toJson()).toList(),
      'pujas': pujas?.map((i) => i.toJson()).toList(),
      'pujaActual': pujaActual,
    };
  }
}

class Creator {
  final String email;
  final String username;
  final String password;
  final String avatar;
  final int role;
  final bool banned;
  final String balance;
  final String calle;

  Creator({
    required this.email,
    required this.username,
    required this.password,
    required this.avatar,
    required this.role,
    required this.banned,
    required this.balance,
    required this.calle,
  });

  factory Creator.fromJson(Map<String, dynamic> json) {
    return Creator(
      email: json['email'],
      username: json['username'],
      password: json['password'],
      avatar: json['avatar'],
      role: json['role'],
      banned: json['banned'],
      balance: json['balance'],
      calle: json['calle'],
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
    };
  }
}

class Imagen {
  final int id;
  final String url;

  Imagen({
    required this.id,
    required this.url,
  });

  factory Imagen.fromJson(Map<String, dynamic> json) {
    return Imagen(
      id: json['id'],
      url: json['url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'url': url,
    };
  }
}

class Puja {
  final int id;
  final bool iswinner;
  final String amount;
  final String emailUser;
  final bool isAuto;
  final int maxAutoBid;
  final int increment;
  final DateTime fecha;

  Puja(
      {required this.id,
      required this.iswinner,
      required this.amount,
      required this.emailUser,
      required this.fecha,
      required this.isAuto,
      required this.maxAutoBid,
      required this.increment});

  factory Puja.fromJson(Map<String, dynamic> json) {
    return Puja(
      id: json['id'] as int,
      iswinner: json['iswinner'] as bool,
      amount: json['amount'] as String,
      emailUser: json['email_user'] as String,
      fecha: DateTime.parse(json['fecha'] as String),
      isAuto: json['is_auto'] as bool,
      maxAutoBid: json['max_auto_bid'] as int,
      increment: json['increment'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'iswinner': iswinner,
      'amount': amount,
      'email_user': emailUser,
      'fecha': fecha.toIso8601String(),
    };
  }
}
