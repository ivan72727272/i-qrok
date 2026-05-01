import 'package:flutter/material.dart';
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
    final List<HijaiyahLetter> letters = [
      HijaiyahLetter(char: 'أ', name: 'Alif', color: Colors.redAccent),
      HijaiyahLetter(char: 'ب', name: 'Ba', color: Colors.blueAccent),
      HijaiyahLetter(char: 'ت', name: 'Ta', color: Colors.greenAccent.shade700),
      HijaiyahLetter(char: 'ث', name: 'Tha', color: Colors.orangeAccent),
      HijaiyahLetter(char: 'ج', name: 'Jim', color: Colors.purpleAccent),
      HijaiyahLetter(char: 'ح', name: 'Ha', color: Colors.tealAccent.shade700),
      HijaiyahLetter(char: 'خ', name: 'Kha', color: Colors.pinkAccent),
      HijaiyahLetter(char: 'د', name: 'Dal', color: Colors.indigoAccent),
      HijaiyahLetter(char: 'ذ', name: 'Dhal', color: Colors.amberAccent.shade700),
      HijaiyahLetter(char: 'ر', name: 'Ra', color: Colors.cyanAccent.shade700),
      HijaiyahLetter(char: 'ز', name: 'Zay', color: Colors.deepOrangeAccent),
      HijaiyahLetter(char: 'س', name: 'Sin', color: Colors.lightGreenAccent.shade700),
      HijaiyahLetter(char: 'ش', name: 'Shin', color: Colors.blueGrey),
      HijaiyahLetter(char: 'ص', name: 'Sad', color: Colors.brown.shade400),
      HijaiyahLetter(char: 'ض', name: 'Dad', color: Colors.deepPurpleAccent),
      HijaiyahLetter(char: 'ط', name: 'Ta', color: Colors.red.shade400),
      HijaiyahLetter(char: 'ظ', name: 'Za', color: Colors.blue.shade700),
      HijaiyahLetter(char: 'ع', name: '‘Ain', color: Colors.green.shade600),
      HijaiyahLetter(char: 'غ', name: 'Ghain', color: Colors.orange.shade800),
      HijaiyahLetter(char: 'ف', name: 'Fa', color: Colors.pink.shade700),
      HijaiyahLetter(char: 'ق', name: 'Qaf', color: Colors.purple.shade700),
      HijaiyahLetter(char: 'ك', name: 'Kaf', color: Colors.teal.shade800),
      HijaiyahLetter(char: 'ل', name: 'Lam', color: Colors.indigo.shade800),
      HijaiyahLetter(char: 'م', name: 'Mim', color: Colors.lime.shade900),
      HijaiyahLetter(char: 'ن', name: 'Nun', color: Colors.amber.shade900),
      HijaiyahLetter(char: 'و', name: 'Waw', color: Colors.cyan.shade900),
      HijaiyahLetter(char: 'هـ', name: 'Ha', color: Colors.deepOrange.shade900),
      HijaiyahLetter(char: 'ء', name: 'Hamzah', color: Colors.blueGrey.shade800),
      HijaiyahLetter(char: 'ي', name: 'Ya', color: Colors.green.shade900),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF1F8E9),
      appBar: AppBar(
        title: const Text('Belajar Huruf Hijaiyah'),
        centerTitle: true,
        backgroundColor: const Color(0xFF81C784),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 15,
            mainAxisSpacing: 15,
            childAspectRatio: 0.85,
          ),
          itemCount: letters.length,
          itemBuilder: (context, index) {
            final letter = letters[index];
            return Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      transitionDuration: const Duration(milliseconds: 500),
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
                borderRadius: BorderRadius.circular(24),
                child: Ink(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: letter.color.withOpacity(0.15),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                    border: Border.all(
                      color: letter.color.withOpacity(0.4),
                      width: 2.5,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Hero(
                        tag: 'letter-${letter.char}',
                        child: Text(
                          letter.char,
                          style: TextStyle(
                            fontSize: 52,
                            fontWeight: FontWeight.bold,
                            color: letter.color,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        letter.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black45,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
