import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/plan_models.dart';
import '../services/plan_service.dart';
import '../providers/user_provider.dart';

class DailyPlanScreen extends StatefulWidget {
  const DailyPlanScreen({super.key});

  @override
  State<DailyPlanScreen> createState() => _DailyPlanScreenState();
}

class _DailyPlanScreenState extends State<DailyPlanScreen> {
  List<PlanMeal> _meals = [];
  List<bool> completedMeals = [];
  
  final _planService = PlanService();
  bool _loading = true;

  late String? userGoal;

  @override
  void initState() {
    super.initState();
    fetchDailyPlan();
    userGoal = Provider.of<UserProvider>(context, listen: false).userGoal;
  }

  Future<void> fetchDailyPlan() async {
    final userId = Provider.of<UserProvider>(context, listen: false).userId;
    if (userId == null) return;

    try {
      final plan = await _planService.fetchDailyPlan(userId);
      setState(() {
        _meals = plan.meals;
        completedMeals = List.filled(_meals.length, false);
        _loading = false;
      });
    } catch (e) {
      print("Error al obtener el plan: $e");
      setState(() => _loading = false);
    }
  }

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
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.pushNamed(context, "user_settings");
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              Navigator.pushNamed(context, "alerts");
            },
          ),
        ],
      ),
      body: _loading
      ? const Center(child: CircularProgressIndicator())
      : SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          decoration: BoxDecoration(
            color: Color(0xFF226980),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 12,
                offset: Offset(0, 6),
              ),
            ],
          ),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Objetivo y duración
              Row(
                children: [
                  Icon(Icons.fitness_center, color: Colors.white),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Objetivo: ${userGoal ?? "No definido"}',
                      style: GoogleFonts.poppins(
                        textStyle: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                            ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                'Alimentos cumplidos: 5 / 5',
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
                  children: _meals.asMap().entries.map((entry) {
                    final index = entry.key;
                    final meal = entry.value;
                    return MealItemCard(
                      meal: meal,
                      onTap: () => _showMealDialog(context, meal, index),
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 24),

              Center(
                child: ElevatedButton.icon(
                  icon: Icon(Icons.show_chart),
                  label: Text('Visualizar progreso'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      vertical: 14, horizontal: 32),
                    shape: StadiumBorder(),
                    elevation: 6,
                  ),
                  onPressed: () =>
                      Navigator.pushNamed(context, 'progress'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  void _showMealDialog(BuildContext context, PlanMeal meal, int index) {
    showDialog(
      context: context,
      builder: (_) {
        bool isCompleted = completedMeals[index];

        return StatefulBuilder(
          builder: (context, setState) => Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            elevation: 16,
            insetPadding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.8,
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${meal.name}: ${meal.food.name}',
                        style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    Text(
                      'Ingredientes:\n${meal.food.ingredients.map((e) => '${e.quantity} ${e.unit} de ${e.name}').join('\n')}',
                      style: GoogleFonts.poppins(),
                    ),
                    const SizedBox(height: 12),
                    Text('Preparación:\n${meal.food.preparation}',
                        style: GoogleFonts.poppins()),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          isCompleted = !isCompleted;
                          completedMeals[index] = isCompleted;
                        });
                      },
                      child: Text(isCompleted
                          ? 'Desmarcar comida'
                          : 'Marcar comida completada'),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      isCompleted
                          ? '✅ Esta comida está completada'
                          : '❌ Esta comida no está completada',
                      style: TextStyle(
                        color: isCompleted ? Colors.green : Colors.red,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => launchUrl(Uri.parse(meal.food.videoUrl)),
                          child: const Text('Ver video'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cerrar'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class MealItemCard extends StatelessWidget {
  final PlanMeal meal;
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
          '${meal.name}: ${meal.food.name}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        onTap: onTap,
      ),
    );
  }
}
