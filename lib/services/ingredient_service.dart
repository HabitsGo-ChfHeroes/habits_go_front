import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/env.dart';

class IngredientService {
  static const String _baseUrl = "${Env.baseUrl}/ingredient";

  Future<List<Map<String, dynamic>>> fetchIngredientsPaginated(int skip, int limit) async {
    final response = await http.get(Uri.parse("$_baseUrl/list?skip=$skip&limit=$limit"));
    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(json.decode(response.body));
    } else {
      throw Exception("Error al cargar ingredientes paginados");
    }
  }

  Future<List<Map<String, dynamic>>> searchIngredients(String query) async {
    final response = await http.get(Uri.parse("$_baseUrl/search?query=$query"));
    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(json.decode(response.body));
    } else {
      throw Exception("Error al buscar ingredientes");
    }
  }
}