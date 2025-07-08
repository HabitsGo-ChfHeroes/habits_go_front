import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../services/ingredient_service.dart';
import '../services/user_ingredient_service.dart';

class FavoriteFoodsScreen extends StatefulWidget {
  const FavoriteFoodsScreen({super.key});

  @override
  State<FavoriteFoodsScreen> createState() => _FavoriteFoodsScreenState();
}

class _FavoriteFoodsScreenState extends State<FavoriteFoodsScreen> {
  final IngredientService _ingredientService = IngredientService();
  final UserIngredientService _userIngredientService = UserIngredientService();
  final TextEditingController _searchController = TextEditingController();

  List<Map<String, dynamic>> filteredIngredients = [];
  List<Map<String, dynamic>> favoriteIngredients = [];
  Set<int> favoriteIngredientIds = {};
  bool _loading = true;

  int _currentPage = 0;
  final int _limit = 50;
  bool _isSearching = false;

  late int userId;

  @override
  void initState() {
    super.initState();
    userId = Provider.of<UserProvider>(context, listen: false).userId!;
    _initializeData();
  }

  Future<void> _initializeData() async {
    await _loadFavoritesFromAPI();
    await _fetchPaginatedIngredients();
  }

  Future<void> _loadFavoritesFromAPI() async {
    try {
      final favorites = await _userIngredientService.getFavoriteIngredients(userId);
      setState(() {
        favoriteIngredients = favorites;
        favoriteIngredientIds = favorites.map<int>((e) => e['id'] as int).toSet();
      });
    } catch (e) {
      print("Error al cargar favoritos: $e");
    }
  }

  Future<void> _fetchPaginatedIngredients() async {
    setState(() {
      _loading = true;
      _isSearching = false;
    });

    try {
      final skip = _currentPage * _limit;
      final ingredients = await _ingredientService.fetchIngredientsPaginated(skip, _limit);
      setState(() {
        filteredIngredients = ingredients;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar ingredientes: $e')),
      );
    }
  }

  Future<void> _searchIngredients(String query) async {
    if (query.isEmpty) {
      _fetchPaginatedIngredients();
      return;
    }

    setState(() {
      _loading = true;
      _isSearching = true;
    });

    try {
      final results = await _ingredientService.searchIngredients(query);
      setState(() {
        filteredIngredients = results;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error en búsqueda: $e')),
      );
    }
  }

  Future<void> _toggleFavorite(int ingredientId) async {
    final isFavorite = favoriteIngredientIds.contains(ingredientId);

    try {
      if (isFavorite) {
        final success = await _userIngredientService.removeFavoriteIngredient(userId, ingredientId);
        if (success) {
          await _loadFavoritesFromAPI();
        }
      } else {
        final success = await _userIngredientService.addFavoriteIngredient(userId, ingredientId);
        if (success) {
          await _loadFavoritesFromAPI();
        }
      }

      // Actualiza ingredientes después de modificar favoritos
      if (_isSearching) {
        await _searchIngredients(_searchController.text);
      } else {
        await _fetchPaginatedIngredients();
      }

      setState(() {}); // Fuerza la reconstrucción de la vista

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al actualizar favorito: $e')),
      );
    }
  }

  void _goToPreviousPage() {
    if (_currentPage > 0) {
      setState(() => _currentPage--);
      _fetchPaginatedIngredients();
    }
  }

  void _goToNextPage() {
    setState(() => _currentPage++);
    _fetchPaginatedIngredients();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> displayList;

    if (_isSearching) {
      displayList = filteredIngredients;
    } else {
      final nonFavoriteIngredients = filteredIngredients
          .where((ingredient) => !favoriteIngredientIds.contains(ingredient['id']))
          .toList();

      displayList = [
        ...favoriteIngredients,
        ...nonFavoriteIngredients,
      ];
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Selecciona tus favoritos'),
        backgroundColor: const Color(0xFF226980),
        foregroundColor: Colors.white,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Buscar ingrediente',
                prefixIcon: const Icon(Icons.search),
                border: const OutlineInputBorder(),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () => _searchIngredients(_searchController.text),
                    ),
                    IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        _fetchPaginatedIngredients();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: displayList.length,
                    itemBuilder: (context, index) {
                      final ingredient = displayList[index];
                      final id = ingredient['id'];
                      final name = ingredient['name'];
                      final isFavorite = favoriteIngredientIds.contains(id);

                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        child: ListTile(
                          title: Text(name),
                          trailing: IconButton(
                            icon: Icon(
                              isFavorite ? Icons.favorite : Icons.favorite_border,
                              color: isFavorite ? Colors.redAccent : Colors.grey,
                            ),
                            onPressed: () => _toggleFavorite(id),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                if (!_isSearching)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: _currentPage > 0 ? _goToPreviousPage : null,
                          icon: const Icon(Icons.arrow_back_ios),
                        ),
                        Text("Página ${_currentPage + 1}"),
                        IconButton(
                          onPressed: _goToNextPage,
                          icon: const Icon(Icons.arrow_forward_ios),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
