import 'package:flutter/material.dart';

class DailyPlanScreen extends StatelessWidget {
  const DailyPlanScreen({Key? key}) : super(key: key);

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Card principal azul
            Card(
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

                    // Sub-card blanca con lista de comidas
                    Card(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          children: const [
                            MealItemCard(
                              title: 'Desayuno',
                              subtitle: 'Avena + claras + plátanos',
                            ),
                            MealItemCard(
                              title: 'Media mañana',
                              subtitle: 'Yogurt natural + frutos secos',
                            ),
                            MealItemCard(
                              title: 'Almuerzo',
                              subtitle: 'Arroz + lentejas + pechuga de pollo',
                            ),
                            MealItemCard(
                              title: 'Merienda',
                              subtitle: 'Batido de proteína + pan con palta',
                            ),
                            MealItemCard(
                              title: 'Cena',
                              subtitle: 'Omelet de espinaca + camote hervido',
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),
                    // Video de rutina personalizada
                    const VideoPreviewCard(
                      youtubeUrl: 'https://www.youtube.com/watch?v=cprwLHth50c',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Checkbox Meta cumplida
            Row(
              children: [
                SizedBox(
                  height: 24,
                  width: 24,
                  child: Checkbox(
                    value: false,
                    onChanged: (value) {
                      // TODO: Marcar meta cumplida
                    },
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  'Meta cumplida',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// WIDGET REUTILIZABLE: tarjeta de comida
class MealItemCard extends StatelessWidget {
  final String title;
  final String subtitle;

  const MealItemCard({Key? key, required this.title, required this.subtitle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          const Icon(Icons.access_time, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(color: Colors.black54),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// WIDGET REUTILIZABLE: vista previa de vídeo
class VideoPreviewCard extends StatelessWidget {
  final String youtubeUrl;

  const VideoPreviewCard({Key? key, required this.youtubeUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: Integrar reproductor de YouTube con un paquete como youtube_player_flutter
    return Container(
      height: 180,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.black12,
      ),
      child: const Center(
        child: Icon(Icons.play_circle_outline, size: 48, color: Colors.black45),
      ),
    );
  }
}

// TODO: Mover MealItemCard y VideoPreviewCard a la carpeta `widgets/` para mejorar la organización.
