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
      HijaiyahLetter(char: 'ل', name: 'Lam', color: const Color(0xFF7986CB)),
      HijaiyahLetter(char: 'م', name: 'Mim', color: const Color(0xFFAED581)),
      HijaiyahLetter(char: 'ن', name: 'Nun', color: const Color(0xFFFFD54F)),
      HijaiyahLetter(char: 'و', name: 'Waw', color: const Color(0xFF4DD0E1)),
      HijaiyahLetter(char: 'هـ', name: 'Ha', color: const Color(0xFFFF8A65)),
      HijaiyahLetter(char: 'ء', name: 'Hamzah', color: const Color(0xFF90A4AE)),
      HijaiyahLetter(char: 'ي', name: 'Ya', color: const Color(0xFFDCE775)),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF6F8F2),
      appBar: AppBar(
        title: const Text('Belajar Hijaiyah', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: const Color(0xFFF6F8F2),
        foregroundColor: const Color(0xFF2E7D32),
        elevation: 0,
      ),
      body: TweenAnimationBuilder<double>(
        duration: const Duration(milliseconds: 800),
        tween: Tween(begin: 0.0, end: 1.0),
        curve: Curves.easeOutQuart,
        builder: (context, value, child) {
          return Opacity(
            opacity: value,
            child: Transform.translate(
              offset: Offset(0, 40 * (1 - value)),
              child: child,
            ),
          );
        },
        child: GridView.builder(
          padding: const EdgeInsets.fromLTRB(24, 10, 24, 40),
          physics: const BouncingScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 160,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            childAspectRatio: 0.85,
          ),
          itemCount: letters.length,
          itemBuilder: (context, index) {
            final letter = letters[index];
            return AnimatedButton(
              onTap: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    transitionDuration: const Duration(milliseconds: 400),
                    pageBuilder: (context, animation, secondaryAnimation) => DetailHurufScreen(
                      char: letter.char,
                      name: letter.name,
                      color: letter.color,
                    ),
                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                      return FadeTransition(opacity: animation, child: child);
                    },
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(32),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                  border: Border.all(
                    color: Colors.black.withOpacity(0.05),
                    width: 1,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Hero(
                      tag: 'letter-${letter.char}',
                      child: Material(
                        color: Colors.transparent,
                        child: Text(
                          letter.char,
                          style: TextStyle(
                            fontSize: 60,
                            fontWeight: FontWeight.bold,
                            color: letter.color,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      letter.name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade400,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
