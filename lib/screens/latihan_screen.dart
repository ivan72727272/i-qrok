import 'package:flutter/material.dart';

class LatihanScreen extends StatefulWidget {
  const LatihanScreen({super.key});

  @override
  State<LatihanScreen> createState() => _LatihanScreenState();
}

class _LatihanScreenState extends State<LatihanScreen> {
  // Data statis untuk soal
  final List<Map<String, dynamic>> _quizData = [
    {
      'question': 'ب',
      'options': ['Ta', 'Ba', 'Jim'],
      'answer': 'Ba',
    },
    {
      'question': 'ت',
      'options': ['Ta', 'Sa', 'Alif'],
      'answer': 'Ta',
    },
    {
      'question': 'ج',
      'options': ['Kha', 'Ha', 'Jim'],
      'answer': 'Jim',
    },
  ];

  int _currentIndex = 0;

  void _checkAnswer(String selectedAnswer) {
    String correctAnswer = _quizData[_currentIndex]['answer'];
    
    if (selectedAnswer == correctAnswer) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Hebat! Jawabanmu Benar 🎉', style: TextStyle(fontSize: 18)),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 1),
        ),
      );
      
      // Pindah ke soal berikutnya setelah delay singkat
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          setState(() {
            if (_currentIndex < _quizData.length - 1) {
              _currentIndex++;
            } else {
              // Jika soal habis, kembali ke awal
              _currentIndex = 0;
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Latihan Selesai! Mengulang dari awal.', style: TextStyle(fontSize: 18)),
                  backgroundColor: Colors.blueAccent,
                  duration: Duration(seconds: 2),
                ),
              );
            }
          });
        }
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ups, Coba Lagi! 🤔', style: TextStyle(fontSize: 18)),
          backgroundColor: Colors.redAccent,
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentQuestion = _quizData[_currentIndex];

    return Scaffold(
      backgroundColor: const Color(0xFFF1F8E9), // Warna hijau pastel terang yang lembut
      appBar: AppBar(
        title: const Text('Latihan', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF81C784), // Hijau E-Cro
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Judul Soal
              const Text(
                'Tebak Huruf Berikut',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF388E3C), // Hijau gelap
                ),
              ),
              const SizedBox(height: 40),
              
              // Kartu Soal Huruf Hijaiyah
              Container(
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.green.withOpacity(0.2),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                  border: Border.all(color: const Color(0xFFAED581), width: 4),
                ),
                alignment: Alignment.center,
                child: Text(
                  currentQuestion['question'],
                  style: const TextStyle(
                    fontSize: 120,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E7D32), // Hijau teks hijaiyah
                  ),
                ),
              ),
              
              const SizedBox(height: 50),
              
              // Tombol-tombol Pilihan Jawaban
              ...(currentQuestion['options'] as List<String>).map((option) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: ElevatedButton(
                    onPressed: () => _checkAnswer(option),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4FC3F7), // Biru cerah, disukai anak-anak
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 5,
                    ),
                    child: Text(
                      option,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
