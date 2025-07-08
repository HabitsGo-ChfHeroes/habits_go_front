import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/env.dart';

class UserIngredientService {
  static const String _baseUrl = "${Env.baseUrl}/user";

  Future<List<Map<String, dynamic>>> getFavoriteIngredients(int userId) async {
    final response = await http.get(Uri.parse('$_baseUrl/$userId/favorite-ingredients'));

    if (response.statusCode == 200) {
      final List<dynamic> decoded = json.decode(response.body);
      print("✅ Datos favoritos:");
      for (var item in decoded) {
        print("🔸 ${item.toString()}");
      }
      return List<Map<String, dynamic>>.from(decoded);
    } else {
      print("❌ Error al obtener favoritos: ${response.statusCode}");
      throw Exception("Error al obtener favoritos");
    }
  }

  Future<bool> addFavoriteIngredient(int userId, int ingredientId) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/$userId/ingredients/$ingredientId'),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      print("✅ Ingrediente $ingredientId añadido a favoritos");
      return true;
    } else {
      print("❌ Error al añadir favorito: ${response.statusCode}");
      return false;
    }
  }

  Future<bool> removeFavoriteIngredient(int userId, int ingredientId) async {
    final response = await http.delete(
      Uri.parse('$_baseUrl/$userId/ingredients/$ingredientId'),
    );

    if (response.statusCode == 200 || response.statusCode == 204) {
      print("✅ Ingrediente $ingredientId eliminado de favoritos");
      return true;
    } else {
      print("❌ Error al eliminar favorito: ${response.statusCode}");
      return false;
    }
  }
}