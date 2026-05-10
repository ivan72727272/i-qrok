import 'package:flutter/material.dart';
import 'islamic_brochure_screen.dart';

class MenuCeritaScreen extends StatelessWidget {
  const MenuCeritaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const IslamicBrochureScreen(
      folder: 'assets/images/cerita/',
      appBarTitle: 'Cerita Islami',
      appBarSubtitle: 'Kisah penuh hikmah untuk anak 📚',
      categoryIcon: '📚',
      accentColor: Color(0xFFAB47BC),
    );
  }
}
