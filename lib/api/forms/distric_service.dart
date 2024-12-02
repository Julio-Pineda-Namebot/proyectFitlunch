import 'dart:convert';
import 'package:http/http.dart' as http;

class ProvinciaDistritoService {
  final String baseUrl = 'https://backend-fitlunch.onrender.com';

  Future<List<dynamic>> getDepartamentos() async {
    final url = Uri.parse('$baseUrl/distric/departamento');
    final response = await http.get(url, headers: {'Content-Type': 'application/json'});

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Error al obtener departamentos: ${response.body}');
    }
  }

  Future<List<dynamic>> getProvincias(int departamentoId) async {
    final url = Uri.parse('$baseUrl/distric/provincia/$departamentoId');
    final response = await http.get(url, headers: {'Content-Type': 'application/json'});

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Error al obtener provincias: ${response.body}');
    }
  }

  Future<List<dynamic>> getDistritos(int provinciaId) async {
    final url = Uri.parse('$baseUrl/distric/distrito/$provinciaId');
    final response = await http.get(url, headers: {'Content-Type': 'application/json'});

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Error al obtener distritos: ${response.body}');
    }
  }
}
