import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../providers/user_provider.dart';

class UserImcGoalPage extends StatefulWidget {
  final String firstName;
  final String lastName;
  final String email;
  final String password;

  const UserImcGoalPage({
    super.key,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
  });

  @override
  State<UserImcGoalPage> createState() => _UserImcGoalPageState();
}

class _UserImcGoalPageState extends State<UserImcGoalPage>
    with SingleTickerProviderStateMixin {
  final TextEditingController _pesoController = TextEditingController();
  final TextEditingController _tallaController = TextEditingController();

  double? imc;
  bool imcCalculated = false;
  String? selectedGoal;
  bool _loading = false;
  String? _error;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  final _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_animationController);
  }

  @override
  void dispose() {
    _pesoController.dispose();
    _tallaController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void calcularImc() {
    final peso = double.tryParse(_pesoController.text);
    final tallaCm = double.tryParse(_tallaController.text);

    if (peso != null && tallaCm != null && peso > 0 && tallaCm > 0) {
      final tallaM = tallaCm / 100;
      setState(() {
        imc = peso / (tallaM * tallaM);
        imcCalculated = true;
        _animationController.forward(from: 0.0);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Ingresa valores válidos para peso y talla."),
        ),
      );
    }
  }

  String obtenerEstadoImc(double imc) {
    if (imc < 18.5) return "Bajo peso";
    if (imc < 25) return "Saludable";
    if (imc < 30) return "Sobrepeso";
    return "Obesidad";
  }

  Future<void> _submitRegistration() async {
    if (!imcCalculated || selectedGoal == null) {
      setState(() => _error = "Calcula el IMC y selecciona un objetivo primero.");
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });

    final height = double.tryParse(_tallaController.text)!;
    final weight = double.tryParse(_pesoController.text)!;

    final result = await _authService.register(
      email:    widget.email,
      firstName: widget.firstName,
      lastName:  widget.lastName,
      password: widget.password,
      height:   height,
      weight:   weight,
      goal:     selectedGoal!,
    );

    setState(() => _loading = false);

    if (result != null) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      userProvider.setUserId(result['id']);
      userProvider.setUserGoal(result['goal']);

      Navigator.of(context).pushNamedAndRemoveUntil("daily_plan_loading", (_) => false);
    } else {
      setState(() => _error = "Error al registrar el usuario.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
                top: 40,
                bottom: 20,
              ),
              decoration: const BoxDecoration(
                color: Color(0xFF003A79),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.menu),
                        color: Colors.white,
                        onPressed: () {},
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Buenos Días",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        "Farid Hinostroza",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const CircleAvatar(
                    radius: 25,
                    backgroundImage: AssetImage("assets/images/user_mock.png"),
                  ),
                ],
              ),
            ),

            const Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "¡Bienvenidos a HabitsGo!",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Tu camino hacia hábitos más saludables comienza aquí",
                    style: TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.shade400),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _pesoController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: "Peso (kg)",
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: _tallaController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: "Talla (cm)",
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    ElevatedButton(
                      onPressed: calcularImc,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF003A79),
                        foregroundColor: Colors.white,
                      ),
                      child: const Text("Calcular IMC"),
                    ),
                    const SizedBox(height: 15),
                    if (imcCalculated)
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: Column(
                          children: [
                            const Text("IMC", style: TextStyle(fontSize: 18)),
                            Text(
                              imc!.toStringAsFixed(1),
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                            Text(
                              "Tu IMC es de estado: ${obtenerEstadoImc(imc!)}",
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.shade400),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Selecciona tu objetivo",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Column(
                      children: [
                        RadioListTile<String>(
                          title: const Text("Perder peso"),
                          value: "Perder peso",
                          groupValue: selectedGoal,
                          onChanged: (value) {
                            setState(() {
                              selectedGoal = value;
                            });
                          },
                        ),
                        RadioListTile<String>(
                          title: const Text("Ganar masa muscular"),
                          value: "Ganar masa muscular",
                          groupValue: selectedGoal,
                          onChanged: (value) {
                            setState(() {
                              selectedGoal = value;
                            });
                          },
                        ),
                        RadioListTile<String>(
                          title: const Text("Mejorar alimentación"),
                          value: "Mejorar la alimentacion",
                          groupValue: selectedGoal,
                          onChanged: (value) {
                            setState(() {
                              selectedGoal = value;
                            });
                          },
                        ),
                      ],
                    ),
                    if (_error != null) ...[
                      Text(_error!, style: TextStyle(color: Colors.red)),
                      const SizedBox(height: 8),
                    ],
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _loading ? null : _submitRegistration,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF003A79),
                          foregroundColor: Colors.white,
                        ),
                        child: _loading
                            ? const SizedBox(
                                height: 20, width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2, color: Colors.white,
                                ),
                              )
                            : const Text("Plan personalizado"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}