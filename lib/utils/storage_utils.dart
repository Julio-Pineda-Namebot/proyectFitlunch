import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:async';

class StorageUtils {
  static const FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  /// Guarda el token JWT en almacenamiento seguro
  static Future<void> saveAuthToken(String token) async {
    await _secureStorage.write(key: 'auth_token', value: token);
  }

  /// Obtiene el token JWT desde almacenamiento seguro
  static Future<String?> getAuthToken() async {
    return await _secureStorage.read(key: 'auth_token');
  }

  /// Elimina el token JWT del almacenamiento seguro
  static Future<void> removeAuthToken() async {
    await _secureStorage.delete(key: 'auth_token');
  }

  static final StreamController<Map<String, String>> _userDetailsController = StreamController<Map<String, String>>.broadcast();

  static Stream<Map<String, String>> get userDetailsStream => _userDetailsController.stream;
  /// Guarda datos del usuario en SharedPreferences
  static Future<void> saveUserDetails(Map<String, String> userDetails) async {
    final prefs = await SharedPreferences.getInstance();
    for (var key in userDetails.keys) {
      await prefs.setString(key, userDetails[key]!);
    }
    _userDetailsController.add(userDetails);
  }
  
  /// Obtiene datos del usuario desde SharedPreferences
  static Future<Map<String, String>> getUserDetails() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'name': prefs.getString('name') ?? 'Usuario',
      'apellido': prefs.getString('apellido') ?? 'Apellido',
      'email': prefs.getString('email') ?? 'example@gmail.com',
      'telefono': prefs.getString('telefono') ?? '',
      'fecha_nac': prefs.getString('fecha_nac') ?? '',
      'sexo': prefs.getString('sexo') ?? '',
    };
  }

  /// Limpia todos los datos del usuario (incluyendo el token)
  static Future<void> clearAll() async {
    await _secureStorage.deleteAll();
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  Future<void> clearPlanId() async {
    const FlutterSecureStorage secureStorage = FlutterSecureStorage();
    await secureStorage.delete(key: 'plan_id');
  }
}