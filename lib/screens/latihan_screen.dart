import 'package:flutter/material.dart';

class LatihanScreen extends StatelessWidget {
  const LatihanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Latihan'),
        backgroundColor: Colors.lightGreenAccent.shade700,
      ),
      body: const Center(
        child: Text(
          'Halaman Latihan',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
