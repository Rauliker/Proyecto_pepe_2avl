import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:proyecto_raul/domain/entities/subastas_entities.dart';

class SubastasRemoteDataSource {
  final String baseUrl = dotenv.env['API_URL'] ?? 'http://localhost:3000';
  final http.Client client;
  SubastasRemoteDataSource(this.client);

  /// Crear una nueva subasta
  Future<void> createSubasta(
    String nombre,
    String descripcion,
    String subInicial,
    String fechaFin,
    String creatorId,
    List<PlatformFile> imagenes,
  ) async {
    final url = Uri.parse('$baseUrl/pujas');

    final request = http.MultipartRequest('POST', url);
    request.fields['nombre'] = nombre;
    request.fields['descripcion'] = descripcion;
    request.fields['pujaInicial'] = subInicial;
    request.fields['fechaFin'] = fechaFin;
    request.fields['creatorId'] = creatorId;

    for (var file in imagenes) {
      if (file.bytes != null) {
        request.files.add(
          http.MultipartFile.fromBytes(
            'files',
            file.bytes!,
            filename: file.name,
          ),
        );
      }
    }

    final response = await request.send();
    if (response.statusCode != 201) {
      throw Exception('Error al crear la subasta: ${response.statusCode}');
    }
  }

  /// Obtener todas las subastas
  Future<List<SubastaEntity>> getAllSubastas() async {
    final url = Uri.parse('$baseUrl/pujas');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => SubastaEntity.fromJson(json)).toList();
    } else {
      throw Exception('Error al obtener las subastas: ${response.body}');
    }
  }

  /// Eliminar una subasta por ID
  Future<void> deleteSubasta(int id) async {
    final url = Uri.parse('$baseUrl/pujas/$id');
    final response = await http.delete(url);

    if (response.statusCode != 200) {
      throw Exception('Error al eliminar la subasta: ${response.body}');
    }
  }

  /// Obtener subastas de otro usuario
  Future<List<SubastaEntity>> getSubastasDeOtroUsuario(String userId) async {
    final url = Uri.parse('$baseUrl/pujas/other/$userId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => SubastaEntity.fromJson(json)).toList();
    } else {
      throw Exception(
          'Error al obtener las subastas del usuario: ${response.body}');
    }
  }

  /// Obtener subastas por email de usuario
  Future<List<SubastaEntity>> getSubastasPorUsuario(String email) async {
    final url = Uri.parse('$baseUrl/pujas/my/$email');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => SubastaEntity.fromJson(json)).toList();
    } else {
      throw Exception(response.body);
    }
  }

  /// Obtener una subasta por ID
  Future<SubastaEntity> getSubastaById(int id) async {
    final url = Uri.parse('$baseUrl/pujas/$id');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return SubastaEntity.fromJson(data);
    } else {
      throw Exception('Error al obtener la subasta: ${response.body}');
    }
  }

  /// Actualizar una subasta
  Future<void> updateSubasta(
      int id, String nombre, String descripcion, String fechaFin) async {
    final url = Uri.parse('$baseUrl/pujas/$id');

    // Crear el JSON manualmente en lugar de depender de un objeto `subasta`
    final Map<String, dynamic> subastaData = {
      'nombre': nombre,
      'descripcion': descripcion,
      'fechaFin': fechaFin,
    };

    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(subastaData), // Convertir el mapa en JSON
    );

    if (response.statusCode != 200) {
      throw Exception('Error al actualizar la subasta: ${response.body}');
    }
  }

  Future<void> makePuja(int idPuja, String email, String puja) async {
    final url = Uri.parse('$baseUrl/pujas/bid');

    // Crear el JSON manualmente en lugar de depender de un objeto `subasta`
    final Map<String, dynamic> subastaData = {
      "userId": email,
      "email_user": email,
      "pujaId": idPuja,
      "bidAmount": puja
    };

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(subastaData), // Convertir el mapa en JSON
    );

    if (response.statusCode != 201 && response.statusCode != 200) {
      throw Exception('Error al actualizar la subasta: ${response.body}');
    }
  }
}
