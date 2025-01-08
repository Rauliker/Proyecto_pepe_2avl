import 'package:file_picker/file_picker.dart';
import 'package:proyecto_raul/data/datasources/user_datasource.dart';
import 'package:proyecto_raul/domain/entities/users.dart';
import 'package:proyecto_raul/domain/repositories/user_repisitory.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;

  UserRepositoryImpl({required this.remoteDataSource});

  @override
  Future<User> login(String email, String password) async {
    return await remoteDataSource.login(email, password);
  }

  @override
  Future<User> createUser(
      String email,
      String password,
      String username,
      int idprovincia,
      int idmunicipio,
      String calle,
      List<PlatformFile> image) async {
    return await remoteDataSource.createUser(
        email, password, username, idprovincia, idmunicipio, calle, image);
  }

  @override
  Future<User> getUserByEmail(String email) async {
    return await remoteDataSource.getUserInfo(email);
  }

  @override
  Future<List<User>> getUsersInfo(String email) async {
    return await remoteDataSource.getUsersInfo(email);
  }

  @override
  Future<User> updateUserProfile(
    String email,
    String username,
    int idprovincia,
    int idmunicipio,
    String calle,
    /*List<PlatformFile> imagen */
  ) async {
    return await remoteDataSource.updateUserProfile(
      email,
      username,
      idprovincia,
      idmunicipio,
      calle, /*image*/
    );
  }

  @override
  Future<User> updateUserPass(
    String password,
  ) async {
    return await remoteDataSource.updateUserPass(
      password,
    );
  }
}
