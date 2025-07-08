import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/env.dart';
import '../models/plan_models.dart';

class PlanService {
  static const String _baseUrl = '${Env.baseUrl}/plan';

  Future<PlanDetailResponse> fetchDailyPlan(int userId) async {
    final url = Uri.parse('$_baseUrl/user/$userId/daily/plan');

    final resp = await http.get(url);

    if (resp.statusCode == 200) {
      final data = jsonDecode(resp.body);
      return PlanDetailResponse.fromJson(data);
    } else {
      throw Exception('No se pudo obtener el plan diario');
    }
  }

  // Método para actualizar el comentario
  Future<Map<String, dynamic>?>  updatePlanComment(int planId, String comment) async {
    final url = Uri.parse('$_baseUrl/$planId/comment');

    final body = jsonEncode({
      'comment': comment,
    });

    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
   } else {
      throw Exception('No se pudo actualizar el comentario');
    }
  }

  Future<String> fetchPlanComment(int planId) async {
    final url = Uri.parse('$_baseUrl/$planId/comment'); // Asegúrate de que sea 'comment' y no 'commet'

    final response = await http.get(url);

    if (response.statusCode == 200) {
      return response.body.replaceAll('"', '');
    } else {
      throw Exception('No se pudo obtener el comentario del plan');
    }
  }
}
