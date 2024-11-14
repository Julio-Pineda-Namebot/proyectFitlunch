import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiDireccion {
  final String baseUrl = 'http://localhost:3000';

  Future<void> addDireccion(Map<String, dynamic> direccionData) async {
    final url = Uri.parse('$baseUrl/direccion/add');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(direccionData),
    );

    if (response.statusCode != 200) {
      throw Exception('Error al agregar dirección: ${response.body}');
    }
  }

  Future<void> updateDireccion(Map<String, dynamic> direccionData) async {
    final url = Uri.parse('$baseUrl/direccion/update');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(direccionData),
    );

    if (response.statusCode != 200) {
      throw Exception('Error al actualizar dirección: ${response.body}');
    }
  }
}