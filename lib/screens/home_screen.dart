import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../widgets/animated_button.dart';
import 'belajar_huruf_screen.dart';
import 'belajar_iqra_screen.dart';
import 'latihan_screen.dart';
import 'tentang_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final bool shouldPop = await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: const Text('Keluar Aplikasi?', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF2E7D32))),
            content: const Text('Apakah kamu yakin ingin keluar dari E-Cro?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Batal', style: TextStyle(fontSize: 16)),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Keluar', style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ) ?? false;
        
        if (shouldPop) {
          SystemNavigator.pop();
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF1F8E9),
        appBar: AppBar(
          title: const Text(
            'E-Cro',
            style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2),
          ),
          centerTitle: true,
          backgroundColor: const Color(0xFF81C784),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        body: TweenAnimationBuilder<double>(
          duration: const Duration(milliseconds: 800),
          tween: Tween(begin: 0.0, end: 1.0),
          curve: Curves.easeOutCubic,
          builder: (context, value, child) {
            return Opacity(
              opacity: value,
              child: Transform.translate(
                offset: Offset(0, 20 * (1 - value)),
                child: child,
              ),
            );
          },
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    const Text(
                      'Belajar Iqra',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2E7D32),
                      ),
                    ),
                    const Text(
                      'Pilih menu di bawah',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 40),
                    // Menu Grid 2x2
                    Expanded(
                      child: GridView.count(
                        crossAxisCount: 2,
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 20,
                        childAspectRatio: 1.0,
                        children: [
                          AnimatedButton(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const BelajarHurufScreen()),
                              );
                            },
                            child: _buildMenuButtonContent(
                              title: 'Belajar\nHuruf',
                              icon: Icons.abc_rounded,
                              color: Colors.orangeAccent,
                            ),
                          ),
                          AnimatedButton(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const BelajarIqraScreen()),
                              );
                            },
                            child: _buildMenuButtonContent(
                              title: 'Belajar\nIqra',
                              icon: Icons.menu_book_rounded,
                              color: Colors.lightBlueAccent,
                            ),
                          ),
                          AnimatedButton(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const LatihanScreen()),
                              );
                            },
                            child: _buildMenuButtonContent(
                              title: 'Latihan',
                              icon: Icons.edit_note_rounded,
                              color: Colors.lightGreenAccent.shade700,
                            ),
                          ),
                          AnimatedButton(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const TentangScreen()),
                              );
                            },
                            child: _buildMenuButtonContent(
                              title: 'Tentang',
                              icon: Icons.info_outline_rounded,
                              color: Colors.pinkAccent.shade100,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuButtonContent({
    required String title,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 50,
            color: Colors.white,
          ),
          const SizedBox(height: 10),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
