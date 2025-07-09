import 'package:http/http.dart' as http;
import 'dart:convert';
import '../config/env.dart';

class PaymentService {
  final String _baseUrl = "${Env.baseUrl}/payment/membership"; // cámbialo por tu IP si es necesario

  Future<bool> makeMembershipPayment(int userId) async {
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          "user_id": userId,
          "amount": 9,
          "currency": "USD"
        }),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print("Error en el servidor: ${response.body}");
        return false;
      }
    } catch (e) {
      print("Error de red: $e");
      return false;
    }
  }

  Future<Map<String, dynamic>?> fetchLatestMembershipPayment(int userId) async {
    try {
      final response = await http.get(
        Uri.parse("$_baseUrl/latest/$userId"),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return jsonData;
      } else {
        print("Error al obtener pago: ${response.statusCode} - ${response.body}");
        return null;
      }
    } catch (e) {
      print("Error de red: $e");
      return null;
    }
  }
}