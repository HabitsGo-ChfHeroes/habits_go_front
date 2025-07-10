import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/plan_service.dart';
import '../providers/user_provider.dart';

class CommentScreen extends StatefulWidget {
  const CommentScreen({super.key});

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  final TextEditingController _controller = TextEditingController();
  bool _loading = true;
  bool _saving = false;
  int? _planId;

  @override
  void initState() {
    super.initState();
    _loadComment();
  }

  Future<void> _loadComment() async {
    final userId = Provider.of<UserProvider>(context, listen: false).userId;
    if (userId == null) {
      setState(() => _loading = false);
      return;
    }
    final service = PlanService();
    try {
      final plan = await service.fetchDailyPlan(userId);
      _planId = plan.planId;
      final comment = await service.fetchPlanComment(plan.planId);
      if (mounted) {
        setState(() {
          _controller.text = comment;
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _loading = false);
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cargar: $e')),
      );
    }
  }

  Future<void> _saveComment() async {
    if (_planId == null) return;
    final text = _controller.text.trim();
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor ingresa un comentario')),
      );
      return;
    }
    setState(() => _saving = true);
    final service = PlanService();
    try {
      await service.updatePlanComment(_planId!, text);
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Comentario guardado')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Comentario diario'),
        backgroundColor: const Color(0xFF226980),
        foregroundColor: Colors.white,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  TextField(
                    controller: _controller,
                    maxLines: 5,
                    decoration: const InputDecoration(
                      hintText: 'Escribe tu comentario',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _saving ? null : _saveComment,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF226980),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: _saving
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                            )
                          : const Text('Guardar'),
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
