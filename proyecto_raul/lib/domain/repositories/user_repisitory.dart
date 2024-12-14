import 'package:proyecto_raul/domain/entities/users.dart';

abstract class UserRepository {
  Future<User> login(String email, String password);
  Future<User> createUser(String email, String password, String username,
      int idprovincia, int idmunicipio, String calle);
  Future<User> getUserByEmail(String email);
}
