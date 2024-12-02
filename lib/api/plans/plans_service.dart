import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';

class PlansService {
  final String baseUrl = 'https://backend-fitlunch.onrender.com';
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  final logger = Logger();
  
  Future<List<Map<String, dynamic>>> fetchPlans() async {
    final response = await http.get(Uri.parse('$baseUrl/plan/plans'));

    if(response.statusCode == 200){
      final List<dynamic> data = json.decode(response.body);
      return data.cast<Map<String, dynamic>>();
    }else{
      throw Exception('Error al obtener los planes');
    }
  }

  Future<int?> getActivePlanId() async {
    final url = Uri.parse('$baseUrl/plan/active-plan');
    final token = await secureStorage.read(key: 'auth_token'); 
    
    if (token == null) {
      logger.e('No se encontró el token de autenticación');
      return null;
    }

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final planId = data['planId'] as int?;

        if (planId != null) {
          await secureStorage.write(key: 'plan_id', value: planId.toString());
          logger.i('Plan ID guardado exitosamente en secureStorage');
        } else {
          logger.w('No se encontró un plan activo en la respuesta');
        }

        return planId;
      } else {
        logger.e('Error fetching active plan: ${response.statusCode}');
        return null;
      }
    } catch (error) {
      logger.e('Error fetching active plan: $error');
      return null;
    }
  }

  Future<void> cancelarPlan() async {
    final url = Uri.parse('$baseUrl/plan/cancel-plan');
    final token = await secureStorage.read(key: 'auth_token');

    if (token == null) {
      logger.e('No se encontró el token de autenticación');
      throw Exception('No se encontró el token de autenticación');
    }

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        logger.i('Plan cancelado exitosamente');
        // Actualizar la UI si es necesario
        // setState(() {}); // Forzar una reconstrucción de la UI
      } else {
        logger.e('Error al cancelar el plan: ${response.statusCode}');
        throw Exception('Error al cancelar el plan'); // Re-lanzar el error
      }
    } catch (error) {
      logger.e('Error al cancelar el plan: $error');
    }
  }
}