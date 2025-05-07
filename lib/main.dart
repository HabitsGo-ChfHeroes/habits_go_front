import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:habits_go_front/screens/forum_screen.dart';
import 'package:habits_go_front/screens/login_screen.dart';
import 'package:habits_go_front/screens/progress_screen.dart';
import 'package:habits_go_front/screens/register_screen.dart';
import 'package:habits_go_front/screens/splash_screen.dart';
import 'package:habits_go_front/screens/forum_coment_screen.dart';
import 'package:habits_go_front/screens/user_imc_goal_page.dart';
import 'package:habits_go_front/screens/user_settings_screen.dart';
import 'package:habits_go_front/screens/daily_plan_screen.dart';
import 'alerts.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
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
        "forum": (context) => const ForumScreen(),
        "forum_coment": (context) {
          final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
          return ForumComentScreen(
            name: args["name"]!,
            description: args["description"]!,
            email: args["email"]!,
          );
        },
        "user_imc_goal": (context) => const UserImcGoalPage(),
        "user_settings": (context) => const UserSettingsScreen(),
        "daily_plan": (context) => const DailyPlanScreen(),
        "alerts": (context) => const AlertsScreen(),
      }
    );
  }
}