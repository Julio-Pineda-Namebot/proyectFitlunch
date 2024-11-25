import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiService {
  final String baseUrl = 'http://localhost:3000'; 
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

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
        
        if (datau.containsKey('token')) {
          await secureStorage.write(key: 'auth_token', value: datau['token']);
        }
        
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('name', datau['name']);
        await prefs.setString('apellido', datau['apellido']);
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
  
  Future<String?> register(Map<String, dynamic> userData) async {
    final url = Uri.parse('$baseUrl/register');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(userData),
      );

      if (response.statusCode == 200) {
        return 'Registro exitoso. Verifica tu correo electrónico.';
      } else {
        final error = json.decode(response.body)['message'];
        return error ?? 'Error al registrar usuario';
      }
    } catch (error) {
      return 'Error al conectar con el servidor';
    }
  }

  Future<Map<String, dynamic>?> verifyCode(String email, String code) async {
    final url = Uri.parse('$baseUrl/verify_code');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'X_EMAIL': email, 'X_CODIGO_VERIFICACION': code}),
      );

      if (response.statusCode == 200) {
        final datau = json.decode(response.body);
        
        if (datau.containsKey('token')) {
          await secureStorage.write(key: 'auth_token', value: datau['token']);
        }

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('name', datau['user']['name']);
        await prefs.setString('apellido', datau['user']['apellido']);
        await prefs.setString('email', datau['user']['email']);
        await prefs.setString('telefono', datau['user']['telefono']);
        await prefs.setString('fecha_nac', datau['user']['fecha_nac'] ?? '');
        await prefs.setString('sexo', datau['user']['sexo'] ?? '');

        return datau; 
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'Error en la verificación');
      }
    } catch (error) {
      rethrow; 
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
