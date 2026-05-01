import 'package:flutter/material.dart';

class BelajarIqraScreen extends StatelessWidget {
  const BelajarIqraScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Belajar Iqra'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: const Center(
        child: Text(
          'Halaman Belajar Iqra',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
