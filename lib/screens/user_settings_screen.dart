import 'package:flutter/material.dart';

class UserSettingsScreen extends StatefulWidget {
  const UserSettingsScreen({super.key});

  @override
  State<UserSettingsScreen> createState() => _UserSettingsScreenState();
}

class _UserSettingsScreenState extends State<UserSettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        title: const Text("Edit Profile"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            // Profile section
            const SizedBox(height: 10),
            Center(
              child: Column(
                children: [
                  Stack(
                    children: [
                      const CircleAvatar(
                        radius: 50,
                        backgroundImage: AssetImage('assets/profile.png'), // Cambiar por tu imagen local o de red
                      ),
                      Positioned(
                        bottom: 0,
                        right: 4,
                        child: CircleAvatar(
                          radius: 15,
                          backgroundColor: Colors.white,
                          child: Icon(Icons.edit, size: 18, color: Colors.blue),
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

            // IMC Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 2)),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text("IMC", style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 4),
                      Text(
                        "23,4   Tu IMC esta en un estado saludable",
                        style: TextStyle(fontSize: 16, color: Colors.blueAccent),
                      ),
                      Divider(height: 24),
                      Text("Objetivo Actual", style: TextStyle(color: Colors.grey)),
                      Text("Ganar masa muscular", style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 16),
                      Text("Gráfica de progreso", style: TextStyle(fontWeight: FontWeight.w500)),
                      SizedBox(height: 8),
                      ProgressChart(),
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
                  label: const Text("Editar Perfil"),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: Colors.blue,
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

  static const Map<String, double> progressData = {  // static const
    'Lun': 0.3, 'Mar': 0.5, 'Mié': 0.7, 'Jue': 0.9, 'Vie': 0.6
  };

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text("Gráfica de progreso", style: TextStyle(fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        SizedBox(
          height: 100,
          child: CustomPaint(painter: const _BarChartPainter(progressData)),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            for (final day in progressData.keys)
              Text(day, style: const TextStyle(fontSize: 12))
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
              const Radius.circular(4)),
          paint);
      x += barWidth + spacing;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
