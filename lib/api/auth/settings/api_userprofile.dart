import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fitlunch/utils/storage_utils.dart';

class ApiUserprofile {
  final String baseUrl = 'https://backend-fitlunch.onrender.com';

  Future<void> updateProfile(Map<String, String> profileData) async {
    final authToken = await StorageUtils.getAuthToken();
    if (authToken == null) {
      throw Exception('No se encontró el token de autenticación');
    }
    final url = Uri.parse('$baseUrl/profile/update_profile');

    String? fechaNac = profileData['fecha_nac'];
      if (fechaNac != null && fechaNac.isNotEmpty) {
      try {
        DateTime.parse(fechaNac);
      } catch (e) {
        throw Exception('Fecha de nacimiento inválida');
      }
    }

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken',
      },
      body: jsonEncode({
        'X_NOMBRE': profileData['name'] ?? '',
        'X_APELLIDO': profileData['apellido'] ?? '',
        'X_TELEFONO': profileData['telefono'] ?? '',
        'X_SEXO': profileData['sexo'] ?? '',
        'X_FECHA_NAC': fechaNac,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Error al actualizar el perfil: ${response.body}');
    }
  }

  Future<void> deleteUser() async {
    final authToken = await StorageUtils.getAuthToken();
    if (authToken == null) {
      throw Exception('No se encontró el token de autenticación');
    }
    final url = Uri.parse('$baseUrl/delete/delete_user');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken',
      },
      // Puedes enviar el ID del usuario en el cuerpo si es necesario
      // body: jsonEncode({'userId': userId}), 
    );

    if (response.statusCode != 200) {
      throw Exception('Error al eliminar el usuario: ${response.body}');
    }
  }
}
