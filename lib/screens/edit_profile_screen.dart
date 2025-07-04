import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/user_service.dart';
import '../providers/user_provider.dart';

class EditProfileScreen extends StatefulWidget {
  final double initialHeight;
  final double initialWeight;
  final String initialGoal;

  const EditProfileScreen({
    super.key,
    required this.initialHeight,
    required this.initialWeight,
    required this.initialGoal,
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late TextEditingController _heightController;
  late TextEditingController _weightController;
  String? selectedGoal;
  bool _loading = false;
  String? _error;

  final _userService = UserService();

  @override
  void initState() {
    super.initState();
    _heightController =
        TextEditingController(text: widget.initialHeight.toString());
    _weightController =
        TextEditingController(text: widget.initialWeight.toString());
    selectedGoal = widget.initialGoal;
  }

  @override
  void dispose() {
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  Future<void> _submitChanges() async {
    final height = double.tryParse(_heightController.text);
    final weight = double.tryParse(_weightController.text);

    if (height == null || weight == null || selectedGoal == null) {
      setState(() => _error = "Completa todos los campos correctamente.");
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);

      final result = await _userService.updateUserProfile(
        userId: userProvider.userId!,
        height: height,
        weight: weight,
        goal: selectedGoal!,
      );

      if (result != null && result['goal'] != null) {
        userProvider.setUserGoal(result['goal']);
      }

      setState(() => _loading = false);
      Navigator.of(context).pop(true);
    } catch (e) {
      setState(() {
        _loading = false;
        _error = "Error al guardar los cambios.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        title: const Text("Editar Perfil"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: const Color(0xFF226980),
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Editar Datos",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF226980),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _weightController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: "Peso (kg)",
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: _heightController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: "Altura (cm)",
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    "Objetivo",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Column(
                    children: [
                      RadioListTile<String>(
                        title: const Text("Perder peso"),
                        value: "Perder peso",
                        groupValue: selectedGoal,
                        onChanged: (value) =>
                            setState(() => selectedGoal = value),
                      ),
                      RadioListTile<String>(
                        title: const Text("Ganar masa muscular"),
                        value: "Ganar masa muscular",
                        groupValue: selectedGoal,
                        onChanged: (value) =>
                            setState(() => selectedGoal = value),
                      ),
                      RadioListTile<String>(
                        title: const Text("Mejorar la alimentacion"),
                        value: "Mejorar la alimentacion",
                        groupValue: selectedGoal,
                        onChanged: (value) =>
                            setState(() => selectedGoal = value),
                      ),
                    ],
                  ),
                  if (_error != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(_error!,
                          style: const TextStyle(color: Colors.red)),
                    ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _loading ? null : _submitChanges,
                      icon: const Icon(Icons.save),
                      label: _loading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text("Guardar Cambios"),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        backgroundColor: const Color(0xFF226980),
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
