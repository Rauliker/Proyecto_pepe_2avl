import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';

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
  final List<PlatformFile> imagen;

  const UserCreateRequest(
      {required this.email,
      required this.password,
      required this.username,
      required this.idprovincia,
      required this.idmunicipio,
      required this.calle,
      required this.imagen});

  @override
  List<Object?> get props =>
      [email, password, username, idprovincia, idmunicipio, calle, imagen];
}

class UserOtherDataRequest extends UserEvent {
  final String email;

  const UserOtherDataRequest({
    required this.email,
  });

  @override
  List<Object?> get props => [email];
}

class UserUpdateProfile extends UserEvent {
  final String email;
  final String username;
  final int idprovincia;
  final int idmunicipio;
  final String calle;
  final List<PlatformFile> imagen;

  const UserUpdateProfile(
      {required this.email,
      required this.username,
      required this.idprovincia,
      required this.idmunicipio,
      required this.calle,
      required this.imagen});

  @override
  List<Object?> get props =>
      [email, username, idprovincia, idmunicipio, calle, imagen];
}

class UserUpdatePass extends UserEvent {
  final String password;

  const UserUpdatePass({required this.password});

  @override
  List<Object?> get props => [
        password,
      ];
}
