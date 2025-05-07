import 'package:flutter/material.dart';
import 'package:habits_go_front/screens/daily-plan.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      // Use this section to set the screen while you are developing the app
      // after you are done, comment this section, discard the changes here and uncomment the section below
      /*
      initialRoute: "splash",
      routes: {
        "splash": (context) => const SplashScreen()
      }
      */

      // Comment this section when you are done developing the app
            // Comment this section when you are done developing the app
      home: const Scaffold(
        body: Center(
          child: Text("Hello World")
        )
      )
    );
  }
}
