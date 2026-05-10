import 'package:flutter/material.dart';
import '../widgets/animated_button.dart';
import 'detail_huruf_screen.dart';

class HijaiyahLetter {
  final String char;
  final String name;
  final Color color;

  HijaiyahLetter({required this.char, required this.name, required this.color});
}

class BelajarHurufScreen extends StatelessWidget {
  const BelajarHurufScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Pastel-inspired color palette for consistency
    final List<HijaiyahLetter> letters = [
      HijaiyahLetter(char: 'أ', name: 'Alif', color: const Color(0xFFFF8A80)),
      HijaiyahLetter(char: 'ب', name: 'Ba', color: const Color(0xFF81D4FA)),
      HijaiyahLetter(char: 'ت', name: 'Ta', color: const Color(0xFFA5D6A7)),
      HijaiyahLetter(char: 'ث', name: 'Tha', color: const Color(0xFFFFCC80)),
      HijaiyahLetter(char: 'ج', name: 'Jim', color: const Color(0xFFCE93D8)),
      HijaiyahLetter(char: 'ح', name: 'Ha', color: const Color(0xFF80CBC4)),
      HijaiyahLetter(char: 'خ', name: 'Kha', color: const Color(0xFFF48FB1)),
      HijaiyahLetter(char: 'د', name: 'Dal', color: const Color(0xFF9FA8DA)),
      HijaiyahLetter(char: 'ذ', name: 'Dhal', color: const Color(0xFFFFE082)),
      HijaiyahLetter(char: 'ر', name: 'Ra', color: const Color(0xFF80DEEA)),
      HijaiyahLetter(char: 'ز', name: 'Zay', color: const Color(0xFFFFAB91)),
      HijaiyahLetter(char: 'س', name: 'Sin', color: const Color(0xFFC5E1A5)),
      HijaiyahLetter(char: 'ش', name: 'Shin', color: const Color(0xFFB0BEC5)),
      HijaiyahLetter(char: 'ص', name: 'Sad', color: const Color(0xFFBCAAA4)),
      HijaiyahLetter(char: 'ض', name: 'Dad', color: const Color(0xFFB39DDB)),
      HijaiyahLetter(char: 'ط', name: 'Ta', color: const Color(0xFFEF9A9A)),
      HijaiyahLetter(char: 'ظ', name: 'Za', color: const Color(0xFF90CAF9)),
      HijaiyahLetter(char: 'ع', name: '‘Ain', color: const Color(0xFF81C784)),
      HijaiyahLetter(char: 'غ', name: 'Ghain', color: const Color(0xFFFFB74D)),
      HijaiyahLetter(char: 'ف', name: 'Fa', color: const Color(0xFFF06292)),
      HijaiyahLetter(char: 'ق', name: 'Qaf', color: const Color(0xFFBA68C8)),
      HijaiyahLetter(char: 'ك', name: 'Kaf', color: const Color(0xFF4DB6AC)),
    return Scaffold(
      appBar: AppBar(
        title: const Text('Belajar Huruf'),
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
