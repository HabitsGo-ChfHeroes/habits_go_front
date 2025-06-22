import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  static const String _baseUrl = 'http://192.168.18.21:8000/api/auth'; // Reemplazar 0.0.0.0 con la IP de tu servidor

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
    
    print('Response: ${resp.body}');

    return resp.statusCode == 200;
  }

  Future<bool> login(String username, String password) async {
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
      // final userData = jsonDecode(resp.body);
      return true;
    }
    return false;
  }
}