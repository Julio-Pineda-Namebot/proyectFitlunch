import 'dart:convert';
import 'package:http/http.dart' as http;

class ProvinciaDistritoService {
  final String baseUrl = 'http://localhost:3000';

  Future<List<dynamic>> getDepartamentos() async {
    final url = Uri.parse('$baseUrl/departamento');
    final response = await http.post(url, headers: {'Content-Type': 'application/json'});

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Error al obtener departamentos: ${response.body}');
    }
  }
  
  Future<List<dynamic>> getProvincias() async {
    final url = Uri.parse('$baseUrl/provincia');
    final response = await http.post(url, headers: {'Content-Type': 'application/json'});

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Error al obtener provincias: ${response.body}');
    }
  }

  Future<List<dynamic>> getDistritos(int provinciaId) async {
    final url = Uri.parse('$baseUrl/distrito');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'provinciaId': provinciaId}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Error al obtener distritos: ${response.body}');
    }
  }
}
