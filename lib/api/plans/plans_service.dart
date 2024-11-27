import 'dart:convert';
import 'package:http/http.dart' as http;

class PlansService {
  final String baseUrl = 'http://localhost:3000';

  Future<List<Map<String, dynamic>>> fetchPlans() async {
    final response = await http.get(Uri.parse('$baseUrl/plan/plans'));

    if(response.statusCode == 200){
      final List<dynamic> data = json.decode(response.body);
      return data.cast<Map<String, dynamic>>();
    }else{
      throw Exception('Error al obtener los planes');
    }
  }
}