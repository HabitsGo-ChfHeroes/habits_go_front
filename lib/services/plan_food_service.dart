import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/env.dart';

class PlanFoodService {
  static const String _baseUrl = '${Env.baseUrl}/plan/food';

  Future<bool> toggleMealStatus(int planFoodId) async {
    final url = Uri.parse('$_baseUrl/$planFoodId/status');

    try {
      final response = await http.put(url);
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<int> planFoodsCompleted(int planId) async {
    final url = Uri.parse('$_baseUrl/plan/$planId/completed/meals');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data as int;
      } else {
        throw Exception('Error al obtener la cantidad de alimentos completados del plan');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }
}
