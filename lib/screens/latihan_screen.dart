import 'package:flutter/material.dart';

class LatihanScreen extends StatefulWidget {
  const LatihanScreen({super.key});

  @override
  State<LatihanScreen> createState() => _LatihanScreenState();
}

class _LatihanScreenState extends State<LatihanScreen> {
  // Data statis untuk soal (5 Soal)
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
    {
      'question': 'ث',
      'options': ['Sa', 'Tha', 'Dal'],
      'answer': 'Tha',
    },
    {
      'question': 'ح',
      'options': ['Ha', 'Kha', 'Jim'],
      'answer': 'Ha',
    },
  ];

  int _currentIndex = 0;
  int _score = 0;
  bool _hasAnswered = false;
  bool _isCorrect = false;
  bool _isFirstAttempt = true;
  bool _isFinished = false;

  void _checkAnswer(String selectedAnswer) {
    if (_hasAnswered && _isCorrect) return; // Jika sudah benar, jangan ubah jawaban

    String correctAnswer = _quizData[_currentIndex]['answer'];
    bool isAnswerCorrect = selectedAnswer == correctAnswer;
    
    setState(() {
      _hasAnswered = true;
      _isCorrect = isAnswerCorrect;
      
      // Tambah skor hanya jika benar pada percobaan pertama
      if (isAnswerCorrect && _isFirstAttempt) {
        _score += 20; // 5 soal x 20 = 100
      }
      
      if (!isAnswerCorrect) {
        _isFirstAttempt = false; // Percobaan pertama gagal
      }
    });
  }

  void _nextQuestion() {
    setState(() {
      _hasAnswered = false;
      _isCorrect = false;
      _isFirstAttempt = true;
      
      if (_currentIndex < _quizData.length - 1) {
        _currentIndex++;
      } else {
        // Latihan selesai
        _isFinished = true;
      }
    });
  }

  void _resetQuiz() {
    setState(() {
      _currentIndex = 0;
      _score = 0;
      _hasAnswered = false;
      _isCorrect = false;
      _isFirstAttempt = true;
      _isFinished = false;
    });
  }

  Widget _buildResultScreen() {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F8E9),
      appBar: AppBar(
        title: const Text('Hasil Latihan', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF81C784),
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Latihan Selesai! 🎉',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF388E3C),
                ),
              ),
              const SizedBox(height: 40),
              Container(
                padding: const EdgeInsets.all(40),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.green.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                  border: Border.all(color: const Color(0xFFFFB74D), width: 5),
                ),
                child: Column(
                  children: [
                    const Text(
                      'Skor Kamu',
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '$_score',
                      style: const TextStyle(
                        fontSize: 80,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFFF9800), // Oranye
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 60),
              ElevatedButton.icon(
                onPressed: _resetQuiz,
                icon: const Icon(Icons.refresh, size: 30),
                label: const Text(
                  'Ulangi Latihan',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4FC3F7),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isFinished) {
      return _buildResultScreen();
    }

    final currentQuestion = _quizData[_currentIndex];

    return Scaffold(
      backgroundColor: const Color(0xFFF1F8E9), // Warna hijau pastel terang yang lembut
      appBar: AppBar(
        title: const Text('Latihan', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF81C784), // Hijau E-Cro
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        actions: [
          // Tampilan Skor di Pojok Kanan Atas
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '⭐ $_score',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFFB74D),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Indikator Soal
              Text(
                'Soal ${_currentIndex + 1} / ${_quizData.length}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 10),

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
              const SizedBox(height: 30),
              
              // Kartu Soal Huruf Hijaiyah
              Container(
                height: 180,
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
                    fontSize: 100,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E7D32), // Hijau teks hijaiyah
                  ),
                ),
              ),
              
              const SizedBox(height: 30),
              
              // Tombol-tombol Pilihan Jawaban
              ...(currentQuestion['options'] as List<String>).map((option) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: ElevatedButton(
                    onPressed: () => _checkAnswer(option),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4FC3F7), // Biru cerah, disukai anak-anak
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 18),
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

              // Pesan Benar/Salah dan Tombol Soal Berikutnya
              if (_hasAnswered) ...[
                const SizedBox(height: 10),
                Text(
                  _isCorrect ? 'Benar! 🎉' : 'Coba lagi 🤔',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: _isCorrect ? Colors.green.shade700 : Colors.red.shade600,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _nextQuestion,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFB74D), // Oranye cerah
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 5,
                  ),
                  child: const Text(
                    'Soal Berikutnya',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
