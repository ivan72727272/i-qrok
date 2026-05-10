import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../widgets/animated_button.dart';

class LatihanScreen extends StatefulWidget {
  const LatihanScreen({super.key});

  @override
  State<LatihanScreen> createState() => _LatihanScreenState();
}

class _LatihanScreenState extends State<LatihanScreen> with SingleTickerProviderStateMixin {
  // Data statis utama untuk soal
  final List<Map<String, dynamic>> _masterQuizData = [
    {'question': 'ب', 'options': ['Ta', 'Ba', 'Jim'], 'answer': 'Ba'},
    {'question': 'ت', 'options': ['Ta', 'Sa', 'Alif'], 'answer': 'Ta'},
    {'question': 'ج', 'options': ['Kha', 'Ha', 'Jim'], 'answer': 'Jim'},
    {'question': 'ث', 'options': ['Sa', 'Tha', 'Dal'], 'answer': 'Tha'},
    {'question': 'ح', 'options': ['Ha', 'Kha', 'Jim'], 'answer': 'Ha'},
    {'question': 'خ', 'options': ['Jim', 'Ha', 'Kha'], 'answer': 'Kha'},
    {'question': 'د', 'options': ['Dal', 'Dhal', 'Ra'], 'answer': 'Dal'},
    {'question': 'ر', 'options': ['Zay', 'Ra', 'Waw'], 'answer': 'Ra'},
    {'question': 'س', 'options': ['Shin', 'Sin', 'Sad'], 'answer': 'Sin'},
    {'question': 'ف', 'options': ['Qaf', 'Fa', 'Kaf'], 'answer': 'Fa'},
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
  final Map<String, Color> _buttonColors = {};

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
    // Ambil 5 soal acak dari master data untuk setiap sesi
    final List<Map<String, dynamic>> tempMaster = List.from(_masterQuizData);
    tempMaster.shuffle();
    
    _activeQuizData = tempMaster.take(5).map((item) {
      List<String> options = List<String>.from(item['options']);
      options.shuffle(); 
      return {
        'question': item['question'],
        'options': options,
        'answer': item['answer'],
      };
    }).toList();

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
      body: TweenAnimationBuilder<double>(
        duration: const Duration(milliseconds: 800),
        tween: Tween(begin: 0.0, end: 1.0),
        curve: Curves.elasticOut,
        builder: (context, value, child) {
          return Opacity(
            opacity: value.clamp(0.0, 1.0),
            child: Transform.scale(
              scale: 0.8 + (0.2 * value),
              child: child,
            ),
          );
        },
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Latihan Selesai! 🎉',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF388E3C),
                  ),
                ),
                const SizedBox(height: 40),
                Container(
                  padding: const EdgeInsets.all(50),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.green.withOpacity(0.2),
                        blurRadius: 30,
                        offset: const Offset(0, 15),
                      ),
                    ],
                    border: Border.all(color: const Color(0xFFFFB74D), width: 6),
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
                          fontSize: 100,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFF9800),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 60),
                AnimatedButton(
                  onTap: _startNewQuiz,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4FC3F7),
                      borderRadius: BorderRadius.circular(40),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.refresh_rounded, color: Colors.white, size: 30),
                        SizedBox(width: 12),
                        Text(
                          'Ulangi Latihan',
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Kembali ke Beranda',
                    style: TextStyle(fontSize: 18, color: Colors.grey, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
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
      body: TweenAnimationBuilder<double>(
        duration: const Duration(milliseconds: 600),
        tween: Tween(begin: 0.0, end: 1.0),
        curve: Curves.easeOutCubic,
        builder: (context, value, child) {
          return Opacity(
            opacity: value,
            child: Transform.translate(
              offset: Offset(0, 30 * (1 - value)),
              child: child,
            ),
          );
        },
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: SingleChildScrollView(
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
                      RepaintBoundary(
                        child: AnimatedContainer(
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
                      ),
                      const SizedBox(height: 30),
                      // Tombol Pilihan Jawaban
                      ...(currentQuestion['options'] as List<String>).map((option) {
                        Color buttonColor = _buttonColors[option] ?? const Color(0xFF4FC3F7);
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: AnimatedButton(
                            onTap: () => _checkAnswer(option),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 250),
                              curve: Curves.easeInOut,
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(vertical: 22),
                              decoration: BoxDecoration(
                                color: buttonColor,
                                borderRadius: BorderRadius.circular(25),
                                boxShadow: [
                                  if (!_buttonColors.containsKey(option))
                                    const BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 8,
                                      offset: Offset(0, 4),
                                    ),
                                ],
                              ),
                              child: Text(
                                option,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
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
                          AnimatedButton(
                            onTap: _nextQuestion,
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(vertical: 18),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFB74D),
                                borderRadius: BorderRadius.circular(25),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 8,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.arrow_forward_rounded, size: 28, color: Colors.white),
                                  SizedBox(width: 8),
                                  Text(
                                    'Lanjut',
                                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ]
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
