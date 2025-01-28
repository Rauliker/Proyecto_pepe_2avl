import 'package:file_picker/file_picker.dart';
import 'package:proyecto_raul/domain/entities/users.dart';

abstract class UserRepository {
  Future<User> login(String email, String password);
  Future<User> createUser(
      String email,
      String password,
      String username,
      int idprovincia,
      int idmunicipio,
      String calle,
      List<PlatformFile> image,
      int role);
  Future<User> getUserByEmail(String email);
  Future<List<User>> getUsersInfo(String email);
  Future<User> updateUserProfile(String email, String username, int idprovincia,
      int idmunicipio, String calle, List<PlatformFile> imagen);
  Future<User> updateUserPass(
    String password,
  );
  Future<User> changeBan(bool banned, String email);
}
