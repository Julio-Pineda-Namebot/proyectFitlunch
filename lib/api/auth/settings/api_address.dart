import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fitlunch/utils/storage_utils.dart';

class ApiDireccion {
  final String baseUrl = 'https://backend-fitlunch.onrender.com';

  Future<void> addDireccion(Map<String, dynamic> direccionData) async {
    final authToken = await StorageUtils.getAuthToken();
    if (authToken == null) {
      throw Exception('Token de autenticación no encontrado');
    }

    final url = Uri.parse('$baseUrl/profile/add_addres');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken',
      },
      body: jsonEncode(direccionData),
    );

    if (response.statusCode == 201) { 
      return; 
    } else if (response.statusCode != 200) {
      throw Exception('Error al agregar dirección: ${response.body}');
    }
  }

  Future<void> updateDireccion(int id, Map<String, dynamic> direccionData) async {
    final authToken = await StorageUtils.getAuthToken();
    if (authToken == null) {
      throw Exception('Token de autenticación no encontrado');
    }

    final url = Uri.parse('$baseUrl/profile/update_address/$id');
    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken',
      },
      body: jsonEncode(direccionData),
    );
    if (response.statusCode != 200) {
      throw Exception('Error al actualizar dirección: ${response.body}');
    }
  }
  
  Future<List<Map<String, dynamic>>> fetchAddresses() async {
    final authToken = await StorageUtils.getAuthToken();
    if (authToken == null) {
      throw Exception('No se encontró el token de autenticación');
    }

    final url = Uri.parse('$baseUrl/profile/get_addresses');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Error al obtener las direcciones: ${response.body}');
    }

    final List<dynamic> data = json.decode(response.body)['addresses'];
    return data.map((address) => address as Map<String, dynamic>).toList();
  }
}