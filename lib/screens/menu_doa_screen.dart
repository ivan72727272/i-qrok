import 'package:flutter/material.dart';
import 'islamic_brochure_screen.dart';

class MenuDoaScreen extends StatelessWidget {
  const MenuDoaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const IslamicBrochureScreen(
      folder: 'assets/images/doa/',
      appBarTitle: 'Doa Harian',
      appBarSubtitle: 'Doa untuk kehidupan sehari-hari 🤲',
      categoryIcon: '🤲',
      accentColor: Color(0xFF42A5F5),
    );
  }
}
