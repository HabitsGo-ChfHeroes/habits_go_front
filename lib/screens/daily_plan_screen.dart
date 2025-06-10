import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';
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
    ingredients: 'Avena, agua, plátano, nueces, jarabe de arce',
    preparation: '''
1. Lleva a ebullición 2 ⅔ tazas de agua con una pizca de sal.
2. Añade 2 tazas de avena de cocción rápida y cocina a fuego lento 5–7 min, removiendo a menudo.
3. Sirve en un tazón y cubre con rodajas de plátano, ⅓ taza de nueces y 2 cda de jarabe de arce.''',
    videoUrl: 'https://www.youtube.com/shorts/SMhf7YiN1h0',
  ),
  Meal(
    type: 'Media mañana',
    dishName: 'Yogur con frutos secos',
    ingredients: 'Yogur natural, frutos secos, pasas/dátiles, miel (opcional)',
    preparation: '''
1. Coloca 150 g de yogur en un bol.
2. Añade 2 cda de frutos secos mixtos y 1 cda de pasas o dátiles troceados.
3. Opcional: rocía 1 cda de miel y espolvorea canela.''',
    videoUrl: 'https://www.youtube.com/shorts/garw6-Ja-vo',
  ),
  Meal(
    type: 'Almuerzo',
    dishName: 'Pollo a la plancha con lentejas',
    ingredients: 'Pechuga de pollo, lentejas, arroz, especias',
    preparation: '''
1. Marina 150 g de pechuga con aceite, ajo, sal, pimienta, comino y pimentón; reposa 15 min.
2. Cocina en sartén antiadherente 3–4 min por lado.
3. Saltea cebolla y ajo, añade ½ taza de lentejas y 1 taza de agua o caldo; cuece 20 min.
4. Sirve con ½ taza de arroz cocido.''',
    videoUrl: 'https://www.youtube.com/shorts/whMSvJHvFwA',
  ),
  Meal(
    type: 'Merienda',
    dishName: 'Batido de proteína y tostada de aguacate',
    ingredients: 'Proteína en polvo, leche, plátano, aguacate, pan integral, yogur',
    preparation: '''
1. Licúa 1 cda de proteína, 200 ml de leche, ½ plátano e hielo.
2. Machaca ½ aguacate con yogur, limón, sal y pimienta.
3. Tuesta pan integral y unta la mezcla de aguacate.''',
    videoUrl: 'https://www.youtube.com/shorts/_1j3-Kl7YmE',
  ),
  Meal(
    type: 'Cena',
    dishName: 'Omelet de espinaca',
    ingredients: 'Huevos, leche, espinacas, queso, mantequilla',
    preparation: '''
1. Bate 2 huevos con 2 cda de leche, sal y pimienta.
2. Vierte en sartén con mantequilla, añade ½ taza de espinacas y queso.
3. Dobla y cocina 1–2 min más hasta fundir el queso.''',
    videoUrl: 'https://www.youtube.com/watch?v=Q2U_3CcFjnk',
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
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.teal.shade600,
              Colors.teal.shade300,
            ],
          ),
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
                    'Objetivo: Ganar masa muscular',
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
              child: ElevatedButton.icon(
                icon: Icon(Icons.show_chart),
                label: Text('Visualizar progreso'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      vertical: 14, horizontal: 32),
                  shape: StadiumBorder(),
                  elevation: 6,
                  shadowColor: Colors.teal.withOpacity(0.4),
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


  void _showMealDialog(BuildContext context, Meal meal) {
showDialog(
  context: context,
  builder: (_) => Dialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
    elevation: 16,
    insetPadding: EdgeInsets.symmetric(horizontal: 32, vertical: 24),
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${meal.type}: ${meal.dishName}',
            style: GoogleFonts.poppins(
              fontSize: 20, fontWeight: FontWeight.bold
            )),
          const SizedBox(height: 12),
          Text('Ingredientes:\n${meal.ingredients}',
            style: GoogleFonts.poppins()),
          const SizedBox(height: 12),
          Text('Preparación:\n${meal.preparation}',
            style: GoogleFonts.poppins()),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => launchUrl(Uri.parse(meal.videoUrl)),
                child: Text('Ver video'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cerrar'),
              ),
            ],
          )
        ],
      ),
    ),
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
