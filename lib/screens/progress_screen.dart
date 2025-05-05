import 'package:flutter/material.dart';
import 'package:habits_go_front/widgets/evolution_graphic.dart';
import 'package:habits_go_front/widgets/progress_summary_card.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Mi progreso', style: TextStyle(color: Color(0xFF003A79), fontWeight: FontWeight.w700, fontSize: 22)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: BackButton(color: Colors.black),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Container(
        margin: EdgeInsets.only(top: 14, left: 14, right: 14, bottom: 24),
        padding: EdgeInsets.only(top: 20, left: 14, right: 14, bottom: 20),
        decoration: BoxDecoration(
          color: Color(0xFF226980),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            Text(
              'Resumen semanal de tus hábitos y resultados',
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 18),
            ),
            SizedBox(height: 16),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(top: 24, left: 16, right: 16, bottom: 24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  children: [
                    Center(
                      child: Column(
                        children: [
                          Text(
                            'GRÁFICA DE EVOLUCIÓN',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 200,
                            child: EvolutionGraphic(),
                          )
                        ],
                      )
                    ),
                    SizedBox(height: 16),
                    GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 1.9,
                      shrinkWrap: true,
                      children: const [
                        ProgressSummaryCard(icon: Icons.check_circle, title: '85%', subtitle: 'Cumplimiento de esta semana'),
                        ProgressSummaryCard(icon: Icons.monitor_weight, title: '1,2 KG', subtitle: 'Cambio de peso'),
                        ProgressSummaryCard(icon: Icons.access_time, title: 'MIÉRCOLES', subtitle: 'Día más productivo'),
                        ProgressSummaryCard(icon: Icons.restaurant_menu, title: '32/35', subtitle: 'Comidas registradas'),
                      ],
                    ),
                    Text(
                      '¡Buen trabajo! Has sido constante esta semana. Podrías aumentar tus porciones si sigues ganando masa muscular.',
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 20),
                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF0E5D74),
                          shape: StadiumBorder(),
                          padding: EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                        ),
                        onPressed: () {},
                        child: Text('Volver al plan', style: TextStyle(color: Colors.white)),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}