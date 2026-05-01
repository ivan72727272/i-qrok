import 'package:flutter/material.dart';

class BelajarHurufScreen extends StatelessWidget {
  const BelajarHurufScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Belajar Huruf'),
        backgroundColor: Colors.orangeAccent,
      ),
      body: const Center(
        child: Text(
          'Halaman Belajar Huruf Hijaiyah',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
