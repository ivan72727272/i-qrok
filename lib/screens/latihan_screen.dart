import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class LatihanScreen extends StatefulWidget {
  const LatihanScreen({super.key});

  @override
  State<LatihanScreen> createState() => _LatihanScreenState();
}

class _LatihanScreenState extends State<LatihanScreen> with SingleTickerProviderStateMixin {
  // Data statis utama untuk soal
  final List<Map<String, dynamic>> _masterQuizData = [
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

  late List<Map<String, dynamic>> _activeQuizData;
  late AudioPlayer _audioPlayer;

  int _currentIndex = 0;
  int _score = 0;
  bool _hasAnswered = false;
  bool _isCorrect = false;
  bool _isFirstAttempt = true;
  bool _isFinished = false;

  // Track button colors for animation
  Map<String, Color> _buttonColors = {};

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _startNewQuiz();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  void _startNewQuiz() {
    _activeQuizData = _masterQuizData.map((item) {
      List<String> options = List<String>.from(item['options']);
      options.shuffle(); 
      return {
        'question': item['question'],
        'options': options,
        'answer': item['answer'],
      };
    }).toList();

    _activeQuizData.shuffle(); 

    setState(() {
      _currentIndex = 0;
      _score = 0;
      _resetQuestionState();
      _isFinished = false;
    });
  }

  void _resetQuestionState() {
    _hasAnswered = false;
    _isCorrect = false;
    _isFirstAttempt = true;
    _buttonColors.clear();
  }

  Future<void> _playSound(bool isCorrect) async {
    try {
      // Akan mencoba memutar suara dari folder assets/audio/
      // Pastikan ada file correct.mp3 dan wrong.mp3 di folder tersebut
      String fileName = isCorrect ? 'correct.mp3' : 'wrong.mp3';
      await _audioPlayer.play(AssetSource('audio/$fileName'));
    } catch (e) {
      // Abaikan jika file audio tidak ditemukan agar aplikasi tidak crash
      debugPrint("Audio file not found: $e");
    }
  }

  void _checkAnswer(String selectedAnswer) {
    if (_hasAnswered && _isCorrect) return; // Jika sudah benar, jangan ubah jawaban lagi

    String correctAnswer = _activeQuizData[_currentIndex]['answer'];
    bool isAnswerCorrect = selectedAnswer == correctAnswer;
    
    _playSound(isAnswerCorrect);

    setState(() {
      _hasAnswered = true;
      _isCorrect = isAnswerCorrect;
      
      // Animasi warna tombol
      if (isAnswerCorrect) {
        _buttonColors[selectedAnswer] = Colors.greenAccent.shade700;
        if (_isFirstAttempt) {
          _score += 20; // Tambah skor hanya pada percobaan pertama
        }
      } else {
        _buttonColors[selectedAnswer] = Colors.redAccent.shade700;
        _isFirstAttempt = false; 
      }
    });
  }

  void _nextQuestion() {
    setState(() {
      _resetQuestionState();
      
      if (_currentIndex < _activeQuizData.length - 1) {
        _currentIndex++;
      } else {
        _isFinished = true;
      }
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
                onPressed: _startNewQuiz,
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

    final currentQuestion = _activeQuizData[_currentIndex];

    return Scaffold(
      backgroundColor: const Color(0xFFF1F8E9), 
      appBar: AppBar(
        title: const Text('Latihan', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF81C784),
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        actions: [
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
              Text(
                'Soal ${_currentIndex + 1} / ${_activeQuizData.length}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 10),

              const Text(
                'Tebak Huruf Berikut',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF388E3C), 
                ),
              ),
              const SizedBox(height: 30),
              
              // Kartu Huruf Hijaiyah dengan efek pantulan ketika benar/salah
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: 180,
                decoration: BoxDecoration(
                  color: _hasAnswered ? (_isCorrect ? Colors.green.shade50 : Colors.red.shade50) : Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: _hasAnswered 
                        ? (_isCorrect ? Colors.green.withOpacity(0.4) : Colors.red.withOpacity(0.4))
                        : Colors.green.withOpacity(0.2),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                  border: Border.all(
                    color: _hasAnswered 
                      ? (_isCorrect ? Colors.green : Colors.redAccent) 
                      : const Color(0xFFAED581), 
                    width: 4
                  ),
                ),
                alignment: Alignment.center,
                child: AnimatedScale(
                  scale: _hasAnswered && _isCorrect ? 1.1 : 1.0,
                  duration: const Duration(milliseconds: 300),
                  child: Text(
                    currentQuestion['question'],
                    style: TextStyle(
                      fontSize: 100,
                      fontWeight: FontWeight.bold,
                      color: _hasAnswered 
                        ? (_isCorrect ? Colors.green.shade700 : Colors.red.shade700) 
                        : const Color(0xFF2E7D32),
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 30),
              
              // Tombol Pilihan Jawaban
              ...(currentQuestion['options'] as List<String>).map((option) {
                Color buttonColor = _buttonColors[option] ?? const Color(0xFF4FC3F7);
                
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeInOut,
                    child: ElevatedButton(
                      onPressed: () => _checkAnswer(option),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: buttonColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 22), // Lebih tebal
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25), // Lebih bulat
                        ),
                        elevation: _buttonColors.containsKey(option) ? 2 : 8, // Efek tertekan
                      ),
                      child: Text(
                        option,
                        style: const TextStyle(
                          fontSize: 26, // Font lebih besar
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2.0,
                        ),
                      ),
                    ),
                  ),
                );
              }),

              // Pesan & Tombol Soal Berikutnya
              if (_hasAnswered) ...[
                const SizedBox(height: 10),
                AnimatedOpacity(
                  opacity: 1.0,
                  duration: const Duration(milliseconds: 400),
                  child: Text(
                    _isCorrect ? 'Hebat! Benar! 🎉' : 'Ups, Coba Lagi! 🤔',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: _isCorrect ? Colors.green.shade700 : Colors.red.shade600,
                    ),
                  ),
                ),
                if (_isCorrect) ...[
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: _nextQuestion,
                    icon: const Icon(Icons.arrow_forward_rounded, size: 28),
                    label: const Text(
                      'Lanjut',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFB74D), 
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      elevation: 8,
                    ),
                  ),
                ]
              ],
            ],
          ),
        ),
      ),
    );
  }
}
