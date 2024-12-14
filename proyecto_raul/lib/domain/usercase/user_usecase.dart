import 'package:proyecto_raul/domain/entities/users.dart';
import 'package:proyecto_raul/domain/repositories/user_repisitory.dart';

class CaseUser {
  final UserRepository repository;

  CaseUser(this.repository);

  Future<User> call(String email, String password) async {
    User user = await repository.login(email, password);
    return user;
  }
}

class CreateUser {
  final UserRepository repository;

  CreateUser(this.repository);

  Future<User> call(String email, String password, String username,
      int idprovincia, int idmunicipio, String calle) async {
    User userInfo = await repository.createUser(
        email, password, username, idprovincia, idmunicipio, calle);
    return userInfo;
  }
}

class CaseUserInfo {
  final UserRepository repository;

  CaseUserInfo(this.repository);

  Future<User> call(String email) async {
    User userInfo = await repository.getUserByEmail(email);
    return userInfo;
  }
}
