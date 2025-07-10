import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../services/habit_service.dart';

class HabitsQuestionnaireScreen extends StatefulWidget {
  const HabitsQuestionnaireScreen({super.key});

  @override
  State<HabitsQuestionnaireScreen> createState() => _HabitsQuestionnaireScreenState();
}

class _HabitsQuestionnaireScreenState extends State<HabitsQuestionnaireScreen> {
  final _exerciseController = TextEditingController();
  final _waterController = TextEditingController();
  bool _smokes = false;
  bool _sleepEnough = true;
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _exerciseController.dispose();
    _waterController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final exercise = int.tryParse(_exerciseController.text.trim());
    final water = int.tryParse(_waterController.text.trim());

    if (exercise == null || water == null) {
      setState(() => _error = 'Por favor completa todos los campos num\u00e9ricos');
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });

    final userId = Provider.of<UserProvider>(context, listen: false).userId!;
    final service = HabitService();
    final data = {
      'exercise_days': exercise,
      'smokes': _smokes,
      'water_glasses': water,
      'sleep_7h': _sleepEnough,
    };

    try {
      await service.submitHabits(userId, data);
      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      setState(() => _error = 'Error al guardar los h\u00e1bitos');
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cuestionario de H\u00e1bitos'),
        backgroundColor: const Color(0xFF226980),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _exerciseController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'D\u00edas de ejercicio por semana',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('\u00bfFumas?'),
              value: _smokes,
              onChanged: (v) => setState(() => _smokes = v),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _waterController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Vasos de agua al d\u00eda',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('\u00bfDuermes al menos 7 horas?'),
              value: _sleepEnough,
              onChanged: (v) => setState(() => _sleepEnough = v),
            ),
            if (_error != null) ...[
              const SizedBox(height: 8),
              Text(_error!, style: const TextStyle(color: Colors.red)),
            ],
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _loading ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF226980),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _loading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : const Text('Guardar h\u00e1bitos'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
