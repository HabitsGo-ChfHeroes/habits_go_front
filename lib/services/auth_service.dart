import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/env.dart';

class AuthService {
  static const String _baseUrl = '${Env.baseUrl}/auth';

  Future<bool> register({
    required String email,
    required String firstName,
    required String lastName,
    required String password,
    required double height,
    required double weight,
    required String goal,
  }) async {
    final url = Uri.parse('$_baseUrl/register');
    final resp = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'first_name': firstName,
        'last_name': lastName,
        'password': password,
        'height': height,
        'weight': weight,
        'goal': goal,
      }),
    );

    return resp.statusCode == 200;
  }

  Future<Map<String, dynamic>?> login(String username, String password) async {
    final url = Uri.parse('$_baseUrl/login');
    final resp = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': username,
        'password': password,
      }),
    );
    if (resp.statusCode == 200) {
      final userData = jsonDecode(resp.body);
      return userData;
    }
    return null;
  }
}