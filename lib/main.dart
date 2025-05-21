// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import for SystemChrome
import 'package:oracle_unbound_app/screens/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure bindings are initialized

  // --- ADD THIS FOR ORIENTATION LOCK ---
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    // Ensure orientation is set before running the app
    runApp(const MyApp());
  });
  // --- END ORIENTATION LOCK ---
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chaos Sigil Generator', // Updated title
      theme: ThemeData(
        primarySwatch: Colors.red,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black, // Default scaffold background
        // fontFamily: 'YourCustomFont', // If you have one
      ),
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}
