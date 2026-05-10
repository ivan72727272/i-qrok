import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../widgets/menu_card.dart';
import '../widgets/custom_app_bar.dart';
import 'detail_huruf_screen.dart';

class BelajarHurufScreen extends StatelessWidget {
  const BelajarHurufScreen({super.key});

  final List<Map<String, dynamic>> _hurufList = const [
    {'char': 'أ', 'name': 'Alif', 'color': Color(0xFFEF9A9A)},
    {'char': 'ب', 'name': 'Ba', 'color': Color(0xFFF48FB1)},
    {'char': 'ت', 'name': 'Ta', 'color': Color(0xFFCE93D8)},
    {'char': 'ث', 'name': 'Tha', 'color': Color(0xFFB39DDB)},
    {'char': 'ج', 'name': 'Jim', 'color': Color(0xFF9FA8DA)},
    {'char': 'ح', 'name': 'Ha', 'color': Color(0xFF90CAF9)},
    {'char': 'خ', 'name': 'Kha', 'color': Color(0xFF81D4FA)},
    {'char': 'د', 'name': 'Dal', 'color': Color(0xFF80DEEA)},
    {'char': 'ذ', 'name': 'Dhal', 'color': Color(0xFF80CBC4)},
    {'char': 'ر', 'name': 'Ra', 'color': Color(0xFFA5D6A7)},
    {'char': 'ز', 'name': 'Zay', 'color': Color(0xFFC5E1A5)},
    {'char': 'س', 'name': 'Sin', 'color': Color(0xFFE6EE9C)},
    {'char': 'ش', 'name': 'Shin', 'color': Color(0xFFFFF59D)},
    {'char': 'ص', 'name': 'Sad', 'color': Color(0xFFFFE082)},
    {'char': 'ض', 'name': 'Dad', 'color': Color(0xFFFFCC80)},
    {'char': 'ط', 'name': 'Tha', 'color': Color(0xFFFFAB91)},
    {'char': 'ظ', 'name': 'Zha', 'color': Color(0xFFBCAAA4)},
    {'char': 'ع', 'name': 'Ain', 'color': Color(0xFFB0BEC5)},
    {'char': 'غ', 'name': 'Ghain', 'color': Color(0xFFCFD8DC)},
    {'char': 'ف', 'name': 'Fa', 'color': Color(0xFFFF8A80)},
    {'char': 'ق', 'name': 'Qaf', 'color': Color(0xFFFF80AB)},
    {'char': 'ك', 'name': 'Kaf', 'color': Color(0xFFEA80FC)},
    {'char': 'ل', 'name': 'Lam', 'color': Color(0xFFB388FF)},
    {'char': 'م', 'name': 'Mim', 'color': Color(0xFF8C9EFF)},
    {'char': 'ن', 'name': 'Nun', 'color': Color(0xFF82B1FF)},
    {'char': 'و', 'name': 'Waw', 'color': Color(0xFF80D8FF)},
    {'char': 'هـ', 'name': 'Ha', 'color': Color(0xFF84FFFF)},
    {'char': 'ء', 'name': 'Hamzah', 'color': Color(0xFFA7FFEB)},
    {'char': 'ي', 'name': 'Ya', 'color': Color(0xFFB9F6CA)},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Belajar Huruf',
        subtitle: 'Kenali Huruf Hijaiyah',
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
              childAspectRatio: 0.9,
            ),
            itemCount: _hurufList.length,
            itemBuilder: (context, index) {
              final huruf = _hurufList[index];
              return MenuCard(
                title: huruf['name'],
                iconWidget: Hero(
                  tag: 'letter-${huruf['char']}',
                  child: Material(
                    color: Colors.transparent,
                    child: Text(
                      huruf['char'],
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: huruf['color'],
                      ),
                    ),
                  ),
                ),
                color: huruf['color'],
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailHurufScreen(
                        char: huruf['char'],
                        name: huruf['name'],
                        color: huruf['color'],
                      ),
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
