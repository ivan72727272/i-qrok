import 'package:flutter/material.dart';

class TentangScreen extends StatelessWidget {
  const TentangScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tentang'),
        backgroundColor: Colors.pinkAccent.shade100,
      ),
      body: const Center(
        child: Text(
          'Tentang Aplikasi E-Cro',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
