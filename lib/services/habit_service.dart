import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/env.dart';

class HabitService {
  static const String _baseUrl = '${Env.baseUrl}/user';

  Future<void> submitHabits(int userId, Map<String, dynamic> habits) async {
    final url = Uri.parse('$_baseUrl/$userId/habits');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(habits),
    );
    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Error al actualizar habitos: ${response.statusCode}');
    }
  }
}
