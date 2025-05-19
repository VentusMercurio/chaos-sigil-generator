// lib/main.dart
import 'package:flutter/material.dart';
import 'package:oracle_unbound_app/screens/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized(); // Important for plugins
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Oracle Unbound',
      theme: ThemeData(
        primarySwatch: Colors.red, // You can customize this
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        fontFamily: 'Roboto', // Example font, use what you like
      ),
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(), // Start with the splash screen
    );
  }
}
