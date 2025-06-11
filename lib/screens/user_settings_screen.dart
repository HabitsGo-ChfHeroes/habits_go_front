import 'package:flutter/material.dart';

class UserSettingsScreen extends StatefulWidget {
  const UserSettingsScreen({super.key});

  @override
  State<UserSettingsScreen> createState() => _UserSettingsScreenState();
}

class _UserSettingsScreenState extends State<UserSettingsScreen> {
  @override
  Widget build(BuildContext context) {
    double imc = 23.4;
    String estadoIMC = "saludable";
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        title: const Text("Profile"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Color(0xFF226980),
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            // Profile section
            const SizedBox(height: 25),
            Center(
              child: Column(
                children: [
                  Stack(
                    children: [
                      const CircleAvatar(
                        radius: 50,
                        backgroundImage: AssetImage(
                          'assets/profile.png',
                        ), // Cambiar por tu imagen local o de red
                      ),
                      Positioned(
                        bottom: 0,
                        right: 4,
                        child: CircleAvatar(
                          radius: 15,
                          backgroundColor: Colors.white,
                          child: Icon(
                            Icons.edit,
                            size: 18,
                            color: Color(0xFF226980),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Farid Hinostroza",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // IMC Card mejorada
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.monitor_weight,
                            color: Color(0xFF226980),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            "Índice de Masa Corporal (IMC)",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const Spacer(),
                          IconButton(
                            icon: const Icon(
                              Icons.help_outline,
                              color: Color(0xFF226980),
                            ),
                            onPressed: () => showIMCModal(context),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Text(
                            imc.toStringAsFixed(1),
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF226980),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "Tu IMC está en un estado $estadoIMC",
                            style: const TextStyle(
                              fontSize: 16,
                              color: Color(0xFF226980),
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 24),
                      const Text(
                        "Objetivo Actual",
                        style: TextStyle(color: Colors.grey),
                      ),
                      const Text(
                        "Ganar masa muscular",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        "Gráfica de progreso",
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 8),
                      const ProgressChart(),
                    ],
                  ),
                ),
              ),
            ),

            const Spacer(),

            // Botón editar perfil
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.edit),
                  label: const Text(
                    "Editar Perfil",
                    style: TextStyle(fontSize: 18),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: Color(0xFF226980),
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Al final de user_settings.dart:
class ProgressChart extends StatelessWidget {
  const ProgressChart({super.key});

  static const Map<String, double> progressData = {
    // static const
    'Lun': 0.3, 'Mar': 0.5, 'Mié': 0.7, 'Jue': 0.9, 'Vie': 0.6,
  };

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          "Gráfica de progreso",
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 100,
          child: CustomPaint(painter: const _BarChartPainter(progressData)),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            for (final day in progressData.keys)
              Text(day, style: const TextStyle(fontSize: 12)),
          ],
        ),
      ],
    );
  }
}

class _BarChartPainter extends CustomPainter {
  final Map<String, double> data;

  const _BarChartPainter(this.data);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.blue[400]!;
    final barWidth = size.width / data.length * 0.6;
    final spacing = size.width / data.length * 0.4;

    var x = spacing / 2;
    for (final value in data.values) {
      final height = size.height * value;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(x, size.height - height, barWidth, height),
          const Radius.circular(4),
        ),
        paint,
      );
      x += barWidth + spacing;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

void showIMCModal(BuildContext context) {
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: "IMC Info",
    transitionDuration: const Duration(milliseconds: 300),
    pageBuilder: (context, animation, secondaryAnimation) {
      return Center(
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Stack(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.info_outline,
                      size: 48,
                      color: Color(0xFF226980),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "¿Qué es el IMC?",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "El IMC (Índice de Masa Corporal) es un indicador que evalúa si tu peso es adecuado en relación a tu altura.",
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Table(
                      columnWidths: const {
                        0: FlexColumnWidth(2),
                        1: FlexColumnWidth(3),
                      },
                      border: TableBorder.all(color: Colors.grey.shade300),
                      children: const [
                        TableRow(
                          decoration: BoxDecoration(color: Colors.blueAccent),
                          children: [
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                "IMC",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                "Clasificación",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        TableRow(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(8),
                              child: Text("< 18.5"),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8),
                              child: Text("Bajo peso"),
                            ),
                          ],
                        ),
                        TableRow(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(8),
                              child: Text("18.5 - 24.9"),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8),
                              child: Text("Peso saludable"),
                            ),
                          ],
                        ),
                        TableRow(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(8),
                              child: Text("25.0 - 29.9"),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8),
                              child: Text("Sobrepeso"),
                            ),
                          ],
                        ),
                        TableRow(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(8),
                              child: Text("30.0 o más"),
                            ),
                            Padding(
                              padding: EdgeInsets.all(8),
                              child: Text("Obesidad"),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: const CircleAvatar(
                      radius: 14,
                      backgroundColor: Colors.redAccent,
                      child: Icon(Icons.close, size: 16, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      return ScaleTransition(
        scale: CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
        child: child,
      );
    },
  );
}
