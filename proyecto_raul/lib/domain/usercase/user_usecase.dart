import 'package:file_picker/file_picker.dart';
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

  Future<User> call(
      String email,
      String password,
      String username,
      int idprovincia,
      int idmunicipio,
      String calle,
      int role,
      List<PlatformFile> image) async {
    User userInfo = await repository.createUser(email, password, username,
        idprovincia, idmunicipio, calle, image, role);
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

class CaseUsersInfo {
  final UserRepository repository;

  CaseUsersInfo(this.repository);

  Future<List<User>> call(String email) async {
    List<User> userInfo = await repository.getUsersInfo(email);
    return userInfo;
  }
}

class CaseUseUserUpdateProfile {
  final UserRepository repository;

  CaseUseUserUpdateProfile(this.repository);

  Future<User> call(String email, String username, int idprovincia,
      int idmunicipio, String calle, List<PlatformFile> image) async {
    User userInfo = await repository.updateUserProfile(
        email, username, idprovincia, idmunicipio, calle, image);
    return userInfo;
  }
}

class CaseUserUpdateBan {
  final UserRepository repository;

  CaseUserUpdateBan(this.repository);

  Future<User> call(bool banned, String email) async {
    User userInfo = await repository.changeBan(banned, email);
    return userInfo;
  }
}

class CaseUserUpdatePass {
  final UserRepository repository;

  CaseUserUpdatePass(this.repository);

  Future<User> call(
    String password,
  ) async {
    User userInfo = await repository.updateUserPass(
      password,
    );
    return userInfo;
  }
}
