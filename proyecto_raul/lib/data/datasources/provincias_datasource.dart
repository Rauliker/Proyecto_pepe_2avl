import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:proyecto_raul/domain/entities/provincias.dart';

abstract class ProvRemoteDataSource {
  Future<List<Prov>> getProvsInfo();
}

class ProvRemoteDataSourceImpl implements ProvRemoteDataSource {
  final String _baseUrl = dotenv.env['API_URL'] ?? 'http://localhost:3000';
  final http.Client client;
  ProvRemoteDataSourceImpl(this.client);

  @override
  Future<List<Prov>> getProvsInfo() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/provincias'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final List<dynamic> json = jsonDecode(response.body);
      return json.map((item) => Prov.fromJson(item)).toList();
    } else {
      // print(
      //     'Fallo al obtener la información de las provincias: ${response.body}');
      throw Exception(
          'Fallo al obtener la información de las provincias: ${response.body}');
    }
  }
}
