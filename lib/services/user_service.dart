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
}
