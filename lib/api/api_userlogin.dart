import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  final String baseUrl = 'http://localhost:3000'; 

  Future<Map<String, dynamic>?> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/login');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'X_EMAIL': email, 'X_CONTRASENA': password}),
      );

      if (response.statusCode == 200) {
        final datau = json.decode(response.body);

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('name', datau['name']);
        await prefs.setString('apellido', datau['apellido']);
        await prefs.setString('direction', datau['direction'] ?? '');
        await prefs.setString('email', datau['email']);
        await prefs.setString('telefono', datau['telefono']);
        await prefs.setString('fecha_nac', datau['fecha_nac'] ?? '');
        await prefs.setString('sexo', datau['sexo'] ?? '');

        return datau;
      } else if (response.statusCode == 401) {
        throw Exception('Correo o contraseña incorrectos');
      } else {
        throw Exception('Error del servidor');
      }
    } catch (error) {
      return null;
    }
  }
  
  Future<Map<String, dynamic>?> register(Map<String, dynamic> userData) async {
    final url = Uri.parse('$baseUrl/register');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(userData),
      );

      if (response.statusCode == 200) {
        final datau = json.decode(response.body);

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('name', datau['name']);
        await prefs.setString('apellido', datau['apellido']);
        await prefs.setString('direction', datau['direction'] ?? '');
        await prefs.setString('email', datau['email']);
        await prefs.setString('telefono', datau['telefono']);
        await prefs.setString('fecha_nac', datau['fecha_nac'] ?? '');
        await prefs.setString('sexo', datau['sexo'] ?? '');
        
        return datau;
      } else {
        throw Exception('Error al registrar usuario');
      }
    } catch (error) {
      return null;
    }
  }

  Future<String?> verifyCode(String email, String code) async {
    final url = Uri.parse('$baseUrl/verify_code');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'X_EMAIL': email, 'X_CODIGO_VERIFICACION': code}),
      );

      if (response.statusCode == 200) {
        return null;
      } else {
        return 'Código de verificación inválido';
      }
    } catch (error) {
      return 'Error al verificar código';
    }
  }

  Future<String?> resendCode(String email) async {
    final url = Uri.parse('$baseUrl/resend_code');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'X_EMAIL': email}),
      );

      if (response.statusCode == 200) {
        return null; 
      } else {
        return 'Error al reenviar código';
      }
    } catch (error) {
      return 'Error al conectar con el servidor';
    }
  }

  Future<String?> sendRecoveryEmail(String email) async {
    final url = Uri.parse('$baseUrl/confirm_password');
    try{
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'X_EMAIL': email}),
      );

       if (response.statusCode == 200) {
        return null;
      } else {
        return json.decode(response.body)['message'] ?? 'Error al enviar código de recuperación';
      }
    }catch(error){
      return 'Error al conectar con el servidor';
    }
  }

  Future<String?> resetPassword(String email, String codigo, String nuevaContrasena) async {
    final url = Uri.parse('$baseUrl/new_password');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'X_EMAIL': email,
          'X_CODIGO_VERIFICACION': codigo,
          'X_CONTRASENA': nuevaContrasena,
        }),
      );

      if (response.statusCode == 200) {
        return null;
      } else {
        return json.decode(response.body)['message'] ?? 'Error al cambiar la contraseña';
      }
    } catch (error) {
      return 'Error al conectar con el servidor';
    }
  }
}
