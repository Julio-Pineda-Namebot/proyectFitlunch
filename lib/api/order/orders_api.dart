import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fitlunch/utils/storage_utils.dart';
import 'package:logger/logger.dart';

class OrderApi {
  final String _baseUrl = 'https://backend-fitlunch.onrender.com';

  final logger = Logger();

  /// Realiza un nuevo pedido
  Future<Map<String, dynamic>> makeOrder(int mealId, int quantity, int addressId) async {
    final String? authToken = await StorageUtils.getAuthToken();

    final url = Uri.parse("$_baseUrl/order/make_order");

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
        body: json.encode({
          'mealId': mealId,
          'quantity': quantity,
          'N_ID_DIRECCION': addressId,
        }),
      );
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception("Error al realizar el pedido: ${response.body}");
      }
    } catch (error) {
      throw Exception("Error al conectar con el servidor: $error");
    }
  }

  // Obtiene los pedidos del usuario
  Future<List<dynamic>> fetchUserOrders() async {
    final String? authToken = await StorageUtils.getAuthToken();
    final url = Uri.parse("$_baseUrl/order/myorders");

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
      );

      if (response.statusCode == 200) {
        final decodedResponse = json.decode(response.body);
        final data = decodedResponse['data'];
        
        if (data is Map<String, dynamic>) {
          final pedidos = data.entries.expand((entry) {
            final fecha = entry.key;
            final pedidosDelDia = entry.value as List<dynamic>;
            return pedidosDelDia.map((pedido) => {
              ...pedido,
              'fechaFormateada': fecha,
            });
          }).toList();
          return pedidos;
        } else {
          throw Exception("Estructura inesperada en la respuesta del servidor.");
        }
      } else {
        throw Exception("Error al obtener pedidos: ${response.body}");
      }
    } catch (error) {
      throw Exception("Error al conectar con el servidor: $error");
    }
  }
}
