import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/env.dart';

class UserService {
  static const String _baseUrl = '${Env.baseUrl}/user';

  Future<Map<String, dynamic>?> getUserDetail(int userId) async {
    final url = Uri.parse('$_baseUrl/$userId');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final userData = jsonDecode(response.body);
        return userData;
      } else {
        throw Exception('Error al obtener los datos del usuario.');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  Future<int> getWeeklyCompletion(int userId) async {
    final url = Uri.parse('$_baseUrl/$userId/weekly/completion');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        return int.parse(response.body);
      } else {
        throw Exception('Error al obtener el porcentaje de cumplimiento semanal.');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  Future<String> getMostProductiveDay(int userId) async {
    final url = Uri.parse('$_baseUrl/$userId/weekly/top/days');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        return response.body.replaceAll('"', '');
      } else {
        throw Exception('Error al obtener el día más productivo.');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  Future<String> getMealsSummary(int userId) async {
    final url = Uri.parse('$_baseUrl/$userId/meal/completion/summary');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        return response.body.replaceAll('"', '');
      } else {
        throw Exception('Error al obtener el resumen de comidas.');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  Future<List<int>> getWeeklyEvolution(int userId) async {
    final url = Uri.parse('$_baseUrl/$userId/weekly/evolution');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((e) => e as int).toList();
      } else {
        throw Exception('Error al obtener los datos de evolución semanal.');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }
}
