import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const ECroApp());
}

class ECroApp extends StatelessWidget {
  const ECroApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'E-Cro',
      theme: ThemeData(
        primarySwatch: Colors.green,
        useMaterial3: true,
        fontFamily: 'Roboto', // Default font, simple and clean
      ),
      home: const SplashScreen(),
    );
  }
}
