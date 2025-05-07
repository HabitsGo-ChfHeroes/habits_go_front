import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

// Modelo de datos para cada comida
typedef MealType = String; // e.g., Desayuno, Almuerzo

class Meal {
  final MealType type;
  final String dishName;
  final String ingredients;
  final String preparation;
  final String videoUrl;

  const Meal({
    required this.type,
    required this.dishName,
    required this.ingredients,
    required this.preparation,
    required this.videoUrl,
  });
}

class DailyPlanScreen extends StatefulWidget {
  const DailyPlanScreen({super.key});

  @override
  State<DailyPlanScreen> createState() => _DailyPlanScreenState();
}

class _DailyPlanScreenState extends State<DailyPlanScreen> {
  bool _isCompleted = false;

  // Datos estáticos de ejemplo para cada comida
  static const List<Meal> meals = [
    Meal(
      type: 'Desayuno',
      dishName: 'Tazón de avena con plátano',
      ingredients: 'Avena, claras de huevo y rodajas de plátano',
      preparation: 'Mezcla 1 taza de avena con 3 claras y cocina a fuego medio. Añade rodajas de plátano encima.',
      videoUrl: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
    ),
    Meal(
      type: 'Media mañana',
      dishName: 'Yogur con frutos secos',
      ingredients: 'Yogur natural y mezcla de frutos secos',
      preparation: 'Sirve 1 vaso de yogur y añade una porción de frutos secos por encima.',
      videoUrl: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
    ),
    Meal(
      type: 'Almuerzo',
      dishName: 'Pollo a la plancha con lentejas',
      ingredients: 'Pechuga de pollo, lentejas y arroz blanco',
      preparation: 'Cocina 150g de pechuga a la plancha, sirve con ½ taza de lentejas y ½ taza de arroz.',
      videoUrl: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
    ),
    Meal(
      type: 'Merienda',
      dishName: 'Batido y tostada de aguacate',
      ingredients: 'Proteína en polvo, pan integral y aguacate',
      preparation: 'Prepara un batido con proteína y agua. Tuesta pan e unta aguacate.',
      videoUrl: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
    ),
    Meal(
      type: 'Cena',
      dishName: 'Omelet de espinaca',
      ingredients: 'Huevos y espinacas frescas',
      preparation: 'Bate 2 huevos, añade espinacas y cocina el omelet en sartén antiadherente.',
      videoUrl: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plan para hoy'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // TODO: Navegar a pantalla de notificaciones
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          color: Colors.teal,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Objetivo y duración
                Row(
                  children: const [
                    Icon(Icons.fitness_center, color: Colors.white),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Objetivo: Ganar masa muscular',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'Duración estimada: 45 min',
                  style: TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 16),

                // Lista de comidas como mini-cards clicables
                Card(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: meals.map((meal) {
                      return MealItemCard(
                        meal: meal,
                        onTap: () => _showMealDialog(context, meal),
                      );
                    }).toList(),
                  ),
                ),

                const SizedBox(height: 24),

                // Checkbox Meta cumplida
                Row(
                  children: [
                    Checkbox(
                      value: _isCompleted,
                      onChanged: (value) {
                        setState(() {
                          _isCompleted = value ?? false;
                        });
                      },
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Meta cumplida',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.teal,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    onPressed: () {
                      // TODO: Navegar a pantalla de progreso
                      Navigator.pushNamed(context, "progress");
                    },
                    child: const Text(
                      "Visualizar progreso",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showMealDialog(BuildContext context, Meal meal) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('${meal.type}: ${meal.dishName}'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Ingredientes:\n${meal.ingredients}'),
              const SizedBox(height: 12),
              Text('Preparación:\n${meal.preparation}'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              final uri = Uri.parse(meal.videoUrl);
              if (await canLaunchUrl(uri)) {
                await launchUrl(
                  uri,
                  mode: LaunchMode.externalApplication,
                );
              }
            },
            child: const Text('Ver video'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }
}

// Widget reutilizable: mini-card clicable de comida
class MealItemCard extends StatelessWidget {
  final Meal meal;
  final VoidCallback onTap;

  const MealItemCard({super.key, required this.meal, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: const Icon(Icons.restaurant_menu),
        title: Text(
          '${meal.type}: ${meal.dishName}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        onTap: onTap,
      ),
    );
  }
}
