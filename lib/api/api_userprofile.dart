import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fitlunch/utils/storage_utils.dart'; 

  Future<void> updateProfile(Map<String, String> profileData) async {
    final userDetails = await loadUserDetails(); 
    final url = Uri.parse('http://192.168.1.42:3000/profile/update_profile');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'X_EMAIL': userDetails['email'],
        'X_NOMBRE': profileData['name'] ?? '',
        'X_APELLIDO': profileData['apellido'] ?? '',
        'X_TELEFONO': profileData['telefono'] ?? '',
        'X_SEXO': profileData['sexo'] ?? '',
        'X_FECHA_NAC': profileData['fecha_nac'],
      }),
    );
  
    if (response.statusCode != 200) { 
    throw Exception('Error al actualizar el perfil: ${response.body}');
    }
  }