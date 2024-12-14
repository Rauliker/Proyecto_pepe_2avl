import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:proyecto_raul/data/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class UserRemoteDataSource {
  Future<UserModel> login(String email, String password);

  Future<UserModel> getUserInfo(String email);

  Future<UserModel> createUser(String email, String password, String username,
      int provincia, int municipio, String calle);
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final String _baseUrl = dotenv.env['API_URL'] ?? 'http://localhost:3000';
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final http.Client client;

  UserRemoteDataSourceImpl(this.client);

  @override
  Future<UserModel> login(String email, String password) async {
    try {
      // Intentar iniciar sesión con Firebase
      final UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = userCredential.user;

      if (user != null) {
        // Si el login en Firebase es exitoso, obtenemos los datos del usuario desde la API
        final url = Uri.parse('$_baseUrl/users/login');
        final body = jsonEncode({'email': email, 'password': password});
        final headers = {'Content-Type': 'application/json'};

        final response = await client.post(url, body: body, headers: headers);

        if (response.statusCode == 200 || response.statusCode == 201) {
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('email', email);
          final json = jsonDecode(response.body);
          return UserModel.fromJson(json);
        } else {
          throw Exception(
              'Error al obtener datos del usuario. Código de estado: ${response.statusCode}');
        }
      } else {
        throw Exception(
            'Error al iniciar sesión con Firebase: Usuario no encontrado.');
      }
    } on FirebaseAuthException catch (e) {
      throw Exception('Error de Firebase: ${e.message}');
    } catch (e) {
      throw Exception('Error inesperado al iniciar sesión: $e');
    }
  }

  @override
  Future<UserModel> createUser(String email, String password, String username,
      int provincia, int municipio, String calle) async {
    try {
      final url = Uri.parse('$_baseUrl/users');
      final body = jsonEncode({
        "email": email,
        "username": username,
        "password": password,
        "banned": false,
        "provinciaId": provincia,
        "localidadId": municipio,
        "calle": calle
      });
      final headers = {'Content-Type': 'application/json'};

      final response = await client.post(url, body: body, headers: headers);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final json = jsonDecode(response.body);
        return UserModel.fromJson(json);
      } else {
        throw Exception(
            'Error al crear usuario. Código de estado: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error inesperado al crear usuario: $e');
    }
  }

  @override
  Future<UserModel> getUserInfo(String email) async {
    try {
      final url = Uri.parse('$_baseUrl/users/$email');
      final headers = {'Content-Type': 'application/json'};

      final response = await client.get(url, headers: headers);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final json = jsonDecode(response.body);
        return UserModel.fromJson(json);
      } else {
        throw Exception(
            'Error al obtener información del usuario. Código de estado: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception(
          'Error inesperado al obtener información del usuario: $e');
    }
  }
}
