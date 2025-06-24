import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:habits_go_front/providers/user_provider.dart';
import 'package:habits_go_front/services/user_service.dart';
import 'package:habits_go_front/widgets/evolution_graphic.dart';
import 'package:habits_go_front/widgets/progress_summary_card.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  String completionPercentage = '-';
  String mostProductiveDay = '-';
  String mealsSummary = '-';
  List<int> weeklyEvolutionData = [];

  @override
  void initState() {
    super.initState();
    fetchProgressData();
  }

  Future<void> fetchProgressData() async {
    final userId = Provider.of<UserProvider>(context, listen: false).userId;
    if (userId == null) return;

    try {
      final userService = UserService();

      final results = await Future.wait([
        userService.getWeeklyCompletion(userId),
        userService.getMostProductiveDay(userId),
        userService.getMealsSummary(userId),
        userService.getWeeklyEvolution(userId)
      ]);

      setState(() {
        completionPercentage = '${results[0] as int}%';
        mostProductiveDay = results[1] as String;
        mealsSummary = results[2] as String;
        weeklyEvolutionData = results[3] as List<int>;
      });
    } catch (e) {
      print('Error al obtener métricas de progreso: $e');
    }
  }

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
            icon: Icon(Icons.person, color: Colors.black),
            onPressed: () {
              Navigator.of(context).pushNamed("user_settings");
            },
          ),
          IconButton(
            icon: Icon(Icons.notifications, color: Colors.black),
            onPressed: () {
              Navigator.of(context).pushNamed("alerts");
            },
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
                            child: EvolutionGraphic(data: weeklyEvolutionData),
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
                      children: [
                        ProgressSummaryCard(icon: Icons.check_circle, title: completionPercentage, subtitle: 'Cumplimiento de esta semana'),
                        const ProgressSummaryCard(icon: Icons.monitor_weight, title: '1,2 KG', subtitle: 'Cambio de peso'),
                        ProgressSummaryCard(icon: Icons.access_time, title: mostProductiveDay, subtitle: 'Día más productivo'),
                        ProgressSummaryCard(icon: Icons.restaurant_menu, title: mealsSummary, subtitle: 'Comidas registradas'),
                      ],
                    ),
                    SizedBox(height: 20),
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
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
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