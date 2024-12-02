import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fitlunch/utils/storage_utils.dart';
import 'package:logger/logger.dart';

class ProgramApi {
  final String _baseUrl = 'https://backend-fitlunch.onrender.com';

  final logger = Logger();

  /// Obtiene las comidas de un usuario para un día específico
  Future<List<Map<String, dynamic>>> fetchUserMeals(String day) async {
    // Obtén el token almacenado
    final String? authToken = await StorageUtils.getAuthToken();

    // Construir la URL del endpoint
    final url = Uri.parse("$_baseUrl/food/user-meals/$day");

    try {
      // Realizar la solicitud GET
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
      );

      // Manejar la respuesta del servidor
      if (response.statusCode == 200) {
        // Parsear el JSON si la solicitud fue exitosa
        final List<dynamic> meals = json.decode(response.body);
        logger.i("Comidas obtenidas para $day: ${meals.length} comidas encontradas.");
        return meals.cast<Map<String, dynamic>>();
      } else if (response.statusCode == 404) {
        logger.w("No hay comidas asignadas para este día o usuario no encontrado.");
        return [];
      } else {
        logger.e("Error: ${response.statusCode}, ${response.body}");
        throw Exception('Error al obtener las comidas: ${response.statusCode}');
      }
    } catch (error) {
      logger.e("Error al realizar la solicitud: $error");
      throw Exception('Error al realizar la solicitud: $error');
    }
  }
}
