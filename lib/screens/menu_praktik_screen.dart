import 'package:flutter/material.dart';
import 'islamic_brochure_screen.dart';

class MenuPraktikScreen extends StatelessWidget {
  const MenuPraktikScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const IslamicBrochureScreen(
      folder: 'assets/images/praktik/',
      appBarTitle: 'Praktik Islami',
      appBarSubtitle: 'Panduan tata cara ibadah 🕌',
      categoryIcon: '🕌',
      accentColor: Color(0xFF66BB6A),
    );
  }
}
