import 'dart:async';
import 'package:flutter/material.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Delay selama 3 detik sebelum pindah ke HomeScreen
    Timer(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => const HomeScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 800),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          // Background gradasi hijau ke biru muda yang lembut
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF81C784), // Hijau lembut
              Color(0xFF64B5F6), // Biru muda lembut
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo Utama
            TweenAnimationBuilder<double>(
              duration: const Duration(seconds: 1),
              tween: Tween(begin: 0.0, end: 1.0),
              curve: Curves.elasticOut,
              builder: (context, value, child) {
                return Transform.scale(
                  scale: value,
                  child: child,
                );
              },
              child: Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(20),
                child: Image.asset('assets/images/logo.png'),
              ),
            ),
            const SizedBox(height: 30),
            // Teks besar "E-Cro"
            const Text(
              'E-Cro',
              style: TextStyle(
                fontSize: 64,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 10),
            // Teks kecil "Belajar Iqra untuk Anak"
            const Text(
              'Belajar Iqra untuk Anak',
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
