import 'package:flutter/material.dart';
import '../data/iqra_data.dart';
import '../constants/app_constants.dart';
import '../widgets/menu_card.dart';
import 'iqra_reader_screen.dart';

class BelajarIqraScreen extends StatelessWidget {
  const BelajarIqraScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final levels = IqraData.levels;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pilih Iqra'),
      ),
      body: TweenAnimationBuilder<double>(
        duration: const Duration(milliseconds: 600),
        tween: Tween(begin: 0.0, end: 1.0),
        curve: Curves.easeOutCubic,
        builder: (context, value, child) {
          return Opacity(
            opacity: value,
            child: Transform.translate(
              offset: Offset(0, 30 * (1 - value)),
              child: child,
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: AppSpacing.lg,
              mainAxisSpacing: AppSpacing.lg,
              childAspectRatio: 0.85,
            ),
            itemCount: levels.length,
            itemBuilder: (context, index) {
              final level = levels[index];
              return MenuCard(
                title: level.title,
                subtitle: level.description,
                iconWidget: Text(
                  '${level.level}',
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: level.color,
                  ),
                ),
                color: level.color,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => IqraReaderScreen(level: level),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
