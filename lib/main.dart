import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'theme/app_theme.dart';
import 'services/theme_service.dart';

void main() {
  runApp(const ECroApp());
}

class ECroApp extends StatelessWidget {
  const ECroApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: ThemeService(),
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Little Muslim',
          theme: ThemeService().isNightMode ? AppTheme.dark : AppTheme.light,
          home: const SplashScreen(),
        );
      },
    );
  }
}
