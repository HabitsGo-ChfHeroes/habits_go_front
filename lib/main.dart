import 'package:flutter/material.dart';
import 'user_settings.dart'; // Asegúrate de que la ruta sea correcta
import 'alerts.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      //home: const UserSettingsScreen(), // Pantalla inicial
      home : const AlertsScreen(),
    );
  }
}