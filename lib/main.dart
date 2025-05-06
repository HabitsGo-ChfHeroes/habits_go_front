import 'package:flutter/material.dart';
import 'package:habits_go_front/screens/login_screen.dart';
import 'package:habits_go_front/screens/progress_screen.dart';
import 'package:habits_go_front/screens/register_screen.dart';
import 'package:habits_go_front/screens/splash_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: "splash",
      routes: {
        "splash": (context) => const SplashScreen(),
        "login": (context) => const LoginScreen(),
        "register": (context) => const RegisterScreen(),
        "progress": (context) => const ProgressScreen(),
      }
    );
  }
}
