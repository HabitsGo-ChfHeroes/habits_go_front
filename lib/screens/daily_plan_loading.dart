import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:provider/provider.dart';

import '../services/plan_food_service.dart';
import '../providers/user_provider.dart';

class DailyPlanLoadingScreen extends StatefulWidget {
  const DailyPlanLoadingScreen({super.key});

  @override
  State<DailyPlanLoadingScreen> createState() => _DailyPlanLoadingScreenState();
}

class _DailyPlanLoadingScreenState extends State<DailyPlanLoadingScreen> {
  final _planService = PlanFoodService();

  @override
  void initState() {
    super.initState();
    _startDailyPlanGeneration();
  }

  Future<void> _startDailyPlanGeneration() async {
    try {
      final userId = Provider.of<UserProvider>(context, listen: false).userId!;
      final message = await _planService.generateDailyPlan(userId);

      if (message.contains("exitosamente")) {
        // Suponiendo que 'generado exitosamente' está en el mensaje
        if (mounted) {
          Navigator.of(context).pushReplacementNamed("daily_plan");
        }
      } else {
        _showError("No se pudo generar el plan diario. Intenta nuevamente.");
      }
    } catch (e) {
      _showError("Error de conexión: ${e.toString()}");
    }
  }

  void _showError(String msg) {
    if (mounted) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Error"),
          content: Text(msg),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF226980),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Estamos generando tu plan de alimentación',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  textStyle: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ),
              const SizedBox(height: 8),
              AnimatedTextKit(
                animatedTexts: [
                  TyperAnimatedText(
                    '.',
                    speed: const Duration(milliseconds: 300),
                    textStyle: GoogleFonts.poppins(
                      fontSize: 40,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  TyperAnimatedText(
                    '..',
                    speed: const Duration(milliseconds: 300),
                    textStyle: GoogleFonts.poppins(
                      fontSize: 40,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  TyperAnimatedText(
                    '...',
                    speed: const Duration(milliseconds: 300),
                    textStyle: GoogleFonts.poppins(
                      fontSize: 40,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
                repeatForever: true,
                isRepeatingAnimation: true,
                pause: const Duration(milliseconds: 200),
              ),
              const SizedBox(height: 24),
              Text(
                'Esto puede tardar unos segundos. Por favor, espera.',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  textStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white70,
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
