import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/plan_models.dart';
import '../services/plan_service.dart';
import '../services/plan_food_service.dart';
import '../providers/user_provider.dart';

class DailyPlanScreen extends StatefulWidget {
  const DailyPlanScreen({super.key});

  @override
  State<DailyPlanScreen> createState() => _DailyPlanScreenState();
}

class _DailyPlanScreenState extends State<DailyPlanScreen> {
  List<PlanMeal> _meals = [];
  List<bool> completedMeals = [];
  int? _planId;

  final _planService = PlanService();
  final _planFoodService = PlanFoodService();
  bool _loading = true;
  int _completedCount = 0;

  static const List<String> _adviceMessages = [
    'Incluye más vegetales verdes en tus comidas.',
    'No olvides tomar suficiente agua durante el día.',
    'Evita las bebidas azucaradas para reducir calorías.',
    'Come frutas como snack saludable.',
    'Prefiere granos integrales en lugar de harinas refinadas.',
    'Reduce el consumo de sal para cuidar tu presión.',
    'Agrega proteínas magras como pollo o pescado.',
    'Planifica tus comidas para evitar tentaciones.',
    'Mantén porciones moderadas para un equilibrio saludable.',
    'No te saltes el desayuno, te da energía.',
    'Elige grasas saludables como las del aguacate.',
    'Come despacio para mejorar la digestión.',
    'Incluye legumbres al menos una vez por semana.',
    'Evita comer tarde en la noche.',
    'Balancea cada plato con carbohidratos, proteína y vegetales.',
  ];
  late String _advice;

  late String? userGoal;

  @override
  void initState() {
    super.initState();
    fetchDailyPlan();
    userGoal = Provider.of<UserProvider>(context, listen: false).userGoal;
    _advice = (_adviceMessages.toList()..shuffle()).first;
  }

  Future<void> fetchDailyPlan() async {
    final userId = Provider.of<UserProvider>(context, listen: false).userId;
    if (userId == null) return;

    try {
      final plan = await _planService.fetchDailyPlan(userId);
      final count = await _planFoodService.planFoodsCompleted(plan.planId);

      setState(() {
        _planId = plan.planId;
        _meals = plan.meals;
        _completedCount = count;
        completedMeals = List.generate(
          _meals.length,
          (i) => _meals[i].status == 'Completado',
        );
        _loading = false;
      });
    } catch (e) {
      print("Error al obtener el plan: $e");
      setState(() => _loading = false);
    }
  }

  Future<void> _showMealDialog(BuildContext context, PlanMeal meal, int index) {
    return showDialog(
      context: context,
      builder: (_) {
        return StatefulBuilder(
          builder:
              (context, setDialogState) => Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                elevation: 16,
                insetPadding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 24,
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.8,
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${meal.name}: ${meal.food.name}',
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Ingredientes:\n${meal.food.ingredients.map((e) => '${e.quantity} ${e.unit} de ${e.name}').join('\n')}',
                          style: GoogleFonts.poppins(),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Preparación:\n${meal.food.preparation}',
                          style: GoogleFonts.poppins(),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () async {
                            final oldStatus = meal.status;
                            final newStatus =
                                oldStatus == 'Completado'
                                    ? 'No completado'
                                    : 'Completado';

                            setDialogState(() {
                              meal.status = newStatus;
                              completedMeals[index] = newStatus == 'Completado';
                            });

                            final success = await _planFoodService
                                .toggleMealStatus(meal.planFoodId);

                            if (!success) {
                              setDialogState(() {
                                meal.status = oldStatus;
                                completedMeals[index] =
                                    oldStatus == 'Completado';
                              });

                              showDialog(
                                context: context,
                                builder:
                                    (_) => AlertDialog(
                                      title: const Text("Error"),
                                      content: const Text(
                                        "No se pudo actualizar el estado. Intenta nuevamente.",
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed:
                                              () => Navigator.pop(context),
                                          child: const Text("OK"),
                                        ),
                                      ],
                                    ),
                              );
                            }
                          },
                          child: Text(
                            meal.status == 'Completado'
                                ? 'Desmarcar comida'
                                : 'Marcar comida completada',
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          meal.status == 'Completado'
                              ? '✅ Esta comida está completada'
                              : '❌ Esta comida no está completada',
                          style: TextStyle(
                            color:
                                meal.status == 'Completado'
                                    ? Colors.green
                                    : Colors.red,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed:
                                  () =>
                                      launchUrl(Uri.parse(meal.food.videoUrl)),
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
            icon: const Icon(Icons.favorite),
            onPressed: () => Navigator.pushNamed(context, "favorite_foods"),
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => Navigator.pushNamed(context, "user_settings"),
          ),
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () => Navigator.pushNamed(context, "alerts"),
          ),
        ],
      ),
      body:
          _loading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF226980),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
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
                      Row(
                        children: [
                          const Icon(Icons.fitness_center, color: Colors.white),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Objetivo: ${userGoal ?? "No definido"}',
                              style: GoogleFonts.poppins(
                                textStyle: Theme.of(
                                  context,
                                ).textTheme.titleMedium?.copyWith(
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
                      Text(
                        'Alimentos cumplidos: $_completedCount / ${_meals.length}',
                        style: const TextStyle(color: Colors.white70),
                      ),
                      const SizedBox(height: 16),
                      Card(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children:
                              _meals.asMap().entries.map((entry) {
                                final index = entry.key;
                                final meal = entry.value;
                                return MealItemCard(
                                  meal: meal,
                                  onTap: () async {
                                    await _showMealDialog(context, meal, index);
                                    if (_planId != null) {
                                      final updatedCount =
                                          await _planFoodService
                                              .planFoodsCompleted(_planId!);
                                      setState(() {
                                        _completedCount = updatedCount;
                                      });
                                    }
                                  },
                                );
                              }).toList(),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Center(
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.show_chart),
                          label: const Text('Visualizar progreso'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              vertical: 14,
                              horizontal: 32,
                            ),
                            shape: const StadiumBorder(),
                            elevation: 6,
                          ),
                          onPressed:
                              () => Navigator.pushNamed(context, 'progress'),
                        ),
                      ),
                      const SizedBox(height: 16),

                      Center(
  child: ElevatedButton.icon(
    icon: const Icon(Icons.comment),
    label: const Text('Añadir comentario'),
    style: ElevatedButton.styleFrom(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 32),
      shape: const StadiumBorder(),
      elevation: 6,
    ),
    onPressed: () {
      showDialog(
        context: context,
        builder: (context) {
          String comentario = '';
          final TextEditingController _controller = TextEditingController();

          return FutureBuilder<String>(
            future: _planService.fetchPlanComment(_planId!),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const AlertDialog(
                  content: SizedBox(
                    height: 80,
                    child: Center(child: CircularProgressIndicator()),
                  ),
                );
              } else if (snapshot.hasError) {
                return AlertDialog(
                  title: const Text('Error'),
                  content: Text('No se pudo cargar el comentario: ${snapshot.error}'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cerrar'),
                    ),
                  ],
                );
              } else {
                comentario = snapshot.data ?? '';
                _controller.text = comentario;

                return AlertDialog(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  title: const Text('Añadir comentario'),
                  content: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Escribe tu comentario aquí',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                    onChanged: (value) => comentario = value,
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancelar'),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (comentario.trim().isNotEmpty) {
                          try {
                            await _planService.updatePlanComment(_planId!, comentario);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Comentario guardado')),
                            );
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Error: $e')),
                            );
                          }
                          Navigator.pop(context);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Por favor ingresa un comentario')),
                          );
                        }
                      },
                      child: const Text('Guardar'),
                    ),
                  ],
                );
              }
            },
          );
        },
      );
    },
  ),
),

                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.lightbulb,
                                color: Color(0xFF226980)),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                _advice,
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                      ),

                    ],
                  ),
                ),
              ),
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
