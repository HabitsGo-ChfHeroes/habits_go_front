import 'package:flutter/material.dart';

class AlertsScreen extends StatefulWidget {
  const AlertsScreen({super.key});

  @override
  State<AlertsScreen> createState() => _AlertsScreenState();
}

class _AlertsScreenState extends State<AlertsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Encabezado
              const Row(
                children: [
                  Icon(Icons.check_box_outline_blank),
                  SizedBox(width: 10),
                  Text(
                    'Notificaciones',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Lista de notificaciones
              _buildNotificationTile(
                icon: Icons.calendar_today,
                text: "Recuerda registrar tu desayuno",
              ),
              _buildNotificationTile(
                icon: Icons.warning,
                text: "Tu ingesta calórica estuvo por debajo del plan ¿Todo bien?",
              ),
              _buildNotificationTile(
                icon: Icons.celebration,
                text: "¡Subiste un 1kg de masa muscular en 3 semanas!",
              ),
              _buildNotificationTile(
                icon: Icons.star,
                text: "5 días seguidos cumpliendo tu plan. ¡Vas genial!",
              ),

              const Spacer(),

              // Botón inferior
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0D7377),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text("Ver foros", style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget reutilizable para notificaciones
  Widget _buildNotificationTile({required IconData icon, required String text}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.black54),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }
}
