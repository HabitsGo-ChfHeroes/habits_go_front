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
}
