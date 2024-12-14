import 'package:equatable/equatable.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object?> get props => [];
}

class LoginRequested extends UserEvent {
  final String email;
  final String password;

  const LoginRequested({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

class UserDataRequest extends UserEvent {
  final String email;

  const UserDataRequest({
    required this.email,
  });

  @override
  List<Object?> get props => [email];
}

class UserCreateRequest extends UserEvent {
  final String email;
  final String password;
  final String username;
  final int idprovincia;
  final int idmunicipio;
  final String calle;

  const UserCreateRequest({
    required this.email,
    required this.password,
    required this.username,
    required this.idprovincia,
    required this.idmunicipio,
    required this.calle,
  });

  @override
  List<Object?> get props =>
      [email, password, username, idprovincia, idmunicipio, calle];
}
