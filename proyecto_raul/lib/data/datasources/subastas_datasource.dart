import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:proyecto_raul/domain/entities/subastas_entities.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    int i = 0;
    final url = Uri.parse('$baseUrl/pujas');

    final request = http.MultipartRequest('Post', url);
    request.fields['nombre'] = nombre;
    request.fields['descripcion'] = descripcion;
    request.fields['pujaInicial'] = subInicial;
    request.fields['fechaFin'] = fechaFin;
    request.fields['creatorId'] = creatorId;

    for (var file in imagenes) {
      if (file.bytes != null) {
        final extension = file.name.contains('.')
            ? file.name.substring(file.name.lastIndexOf('.'))
            : '';

        final fileName = '$creatorId-$nombre-$i$extension';

        i++;
        request.files.add(
          http.MultipartFile.fromBytes(
            'files',
            file.bytes!,
            filename: fileName,
          ),
        );
      }
    }

    final response = await request.send();
    if (response.statusCode != 201) {
      final responseBody = await response.stream.bytesToString();
      throw Exception(
          'Error al crear la subasta: ${response.statusCode} $responseBody');
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
  Future<void> eliminarImagenes(int id, List<String> eliminatedImages) async {
    final url = Uri.parse('$baseUrl/pujas/$id/eliminar-imagenes');

    // Crear la solicitud DELETE con las imágenes eliminadas
    final body = jsonEncode({'eliminatedImages': eliminatedImages});
    final headers = {'Content-Type': 'application/json'};

    try {
      final response = await http.delete(url, headers: headers, body: body);

      if (response.statusCode != 200) {
        throw Exception(
            'Error al eliminar imágenes de la subasta: ${response.body}');
      }

      // print('Imágenes eliminadas con éxito: ${response.body}');
    } catch (e) {
      throw Exception('No se pudo eliminar las imágenes. Detalles: $e');
    }
  }

  Future<void> actualizarSubasta(int id, String nombre, String descripcion,
      String fechaFin, List<PlatformFile> added, String pujaInicial) async {
    final url = Uri.parse('$baseUrl/pujas/$id');

    // Crear la solicitud PUT
    final request = http.MultipartRequest('PUT', url);

    // Agregar campos al formulario
    request.fields['nombre'] = nombre;
    request.fields['descripcion'] = descripcion;
    request.fields['pujaInicial'] = pujaInicial;
    request.fields['fechaFin'] =
        "$fechaFin ${DateTime.now().hour}:${DateTime.now().minute}:${DateTime.now().second} GMT+1";

    // Agregar imágenes nuevas
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('email') ?? 'unknown_user';
    int i = 0;

    for (var file in added) {
      if (file.bytes != null) {
        final extension = file.name.contains('.')
            ? file.name.substring(file.name.lastIndexOf('.'))
            : '';
        final fileName = '$email-$nombre-$i$extension';
        i++;
        request.files.add(
          http.MultipartFile.fromBytes(
            'files',
            file.bytes!,
            filename: fileName,
          ),
        );
      }
    }

    // Enviar la solicitud
    try {
      final response = await request.send();

      // Leer el cuerpo de la respuesta
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode != 200) {
        throw Exception('Error al actualizar la subasta: $responseBody');
      }

      // print('Subasta actualizada con éxito: $responseBody');
    } catch (e) {
      throw Exception('No se pudo actualizar la subasta. Detalles: $e');
    }
  }

  Future<void> updateSubasta(
      int id,
      String nombre,
      String descripcion,
      String fechaFin,
      List<String> eliminatedImages,
      List<PlatformFile> added,
      String pujaInicial) async {
    // 1. Eliminar imágenes
    if (eliminatedImages.isNotEmpty) {
      await eliminarImagenes(id, eliminatedImages);
    }

    // 2. Actualizar los demás parámetros
    await actualizarSubasta(
        id, nombre, descripcion, fechaFin, added, pujaInicial);
  }

  Future<void> makePuja(int idPuja, String email, String puja, bool isAuto,
      String incrementController, String maxAutoController) async {
    final url = Uri.parse('$baseUrl/pujas/bid');
    DateTime now = DateTime.now();

    final Map<String, dynamic> subastaData = {
      "userId": email,
      "email_user": email,
      "pujaId": idPuja,
      "bidAmount": puja,
      "is_auto": isAuto,
      "max_auto_bid":
          double.tryParse(maxAutoController) ?? 0.0, // Convertir a número
      "increment":
          double.tryParse(incrementController) ?? 0.0, // Convertir a número
      "fecha": now.toIso8601String(),
    };

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(subastaData),
    );

    if (response.statusCode != 201 && response.statusCode != 200) {
      throw Exception('Error al actualizar la subasta: ${response.body}');
    }
  }
}
