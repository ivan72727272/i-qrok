import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F8E9), // Hijau sangat muda/putih kehijauan
      appBar: AppBar(
        title: const Text(
          'E-Cro',
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF81C784),
        foregroundColor: Colors.white,
        elevation: 4,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
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
            const Spacer(),
            // Tombol Belajar Huruf
            _buildMenuButton(
              context,
              title: 'Belajar Huruf',
              icon: Icons.abc_rounded,
              color: Colors.orangeAccent,
              onPressed: () {
                // Placeholder
              },
            ),
            const SizedBox(height: 20),
            // Tombol Belajar Iqra
            _buildMenuButton(
              context,
              title: 'Belajar Iqra',
              icon: Icons.menu_book_rounded,
              color: Colors.lightBlueAccent,
              onPressed: () {
                // Placeholder
              },
            ),
            const Spacer(flex: 2),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuButton(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 100,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 6,
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40),
            const SizedBox(width: 15),
            Text(
              title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
