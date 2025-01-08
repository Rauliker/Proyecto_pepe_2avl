import 'package:equatable/equatable.dart';
import 'package:proyecto_raul/domain/entities/users.dart';

abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object?> get props => [];
}

class LoginInitial extends UserState {}

class LoginLoading extends UserState {}

class LoginSuccess extends UserState {
  final User user;

  const LoginSuccess(this.user);

  @override
  List<Object?> get props => [user];
}

class LoginFailure extends UserState {
  final String message;

  const LoginFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class UserCreated extends UserState {
  final User user;

  const UserCreated({required this.user});

  @override
  List<Object?> get props => [user];
}

class SignupLoading extends UserState {}

class SignupSuccess extends UserState {
  final User user;

  const SignupSuccess(this.user);

  @override
  List<Object?> get props => [user];
}

class SignupFailure extends UserState {
  final String message;

  const SignupFailure(this.message);

  @override
  List<Object?> get props => [message];
}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserLoaded extends UserState {
  final User user;

  const UserLoaded(this.user);

  @override
  List<Object?> get props => [user];
}

class UserError extends UserState {
  final String message;

  const UserError({required this.message});

  @override
  List<Object?> get props => [message];
}

// Estado inicial
class UserOtherInitial extends UserState {}

// Estado cargando
class UserOtherLoading extends UserState {}

// Estado cargado
class UserOtherLoaded extends UserState {
  final List<User> users; // Cambiado a lista si es necesario

  const UserOtherLoaded(this.users);

  @override
  List<Object?> get props => [users];
}

// Estado de error
class UserOtherError extends UserState {
  final String message;

  const UserOtherError(
      {this.message = "Error desconocido al cargar Userincias."});

  @override
  List<Object?> get props => [message];
}
