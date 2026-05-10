import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../widgets/animated_button.dart';

class LatihanScreen extends StatefulWidget {
  const LatihanScreen({super.key});

  @override
  State<LatihanScreen> createState() => _LatihanScreenState();
}

class _LatihanScreenState extends State<LatihanScreen> with SingleTickerProviderStateMixin {
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
      String fileName = isCorrect ? 'correct.mp3' : 'wrong.mp3';
      await _audioPlayer.stop();
      await _audioPlayer.play(AssetSource('audio/$fileName'));
    } catch (e) {
      debugPrint("Audio file not found: $e");
    }
  }

  void _checkAnswer(String selectedAnswer) {
    if (_hasAnswered && _isCorrect) return;

    String correctAnswer = _activeQuizData[_currentIndex]['answer'];
    bool isAnswerCorrect = selectedAnswer == correctAnswer;
    
    _playSound(isAnswerCorrect);

    setState(() {
      _hasAnswered = true;
      _isCorrect = isAnswerCorrect;
      
      if (isAnswerCorrect) {
        _buttonColors[selectedAnswer] = const Color(0xFFA5D6A7); // Pastel Green
        if (_isFirstAttempt) {
          _score += 20;
        }
      } else {
        _buttonColors[selectedAnswer] = const Color(0xFFEF9A9A); // Pastel Red
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
      backgroundColor: const Color(0xFFF6F8F2),
      appBar: AppBar(
        title: const Text('Latihan Selesai', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFFF6F8F2),
        foregroundColor: const Color(0xFF2E7D32),
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
                  'Hebat! 🎉',
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Color(0xFF2E7D32)),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Kamu sudah menyelesaikan latihan.',
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
                const SizedBox(height: 40),
                Container(
                  padding: const EdgeInsets.all(50),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 30,
                        offset: const Offset(0, 15),
                      ),
                    ],
                    border: Border.all(color: const Color(0xFFFFCC80), width: 8),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'SKOR',
                        style: TextStyle(fontSize: 20, color: Colors.grey, fontWeight: FontWeight.w900, letterSpacing: 2),
                      ),
                      Text(
                        '$_score',
                        style: const TextStyle(fontSize: 100, fontWeight: FontWeight.w900, color: Color(0xFFFFB74D)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 60),
                AnimatedButton(
                  onTap: _startNewQuiz,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 20),
                    decoration: BoxDecoration(
                      color: const Color(0xFF81D4FA),
                      borderRadius: BorderRadius.circular(100),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF81D4FA).withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.refresh_rounded, color: Colors.white, size: 28),
                        SizedBox(width: 12),
                        Text(
                          'Coba Lagi',
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
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
    if (_isFinished) return _buildResultScreen();

    final currentQuestion = _activeQuizData[_currentIndex];
    double progress = (_currentIndex + 1) / _activeQuizData.length;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F8F2),
      appBar: AppBar(
        title: const Text('Latihan', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFFF6F8F2),
        foregroundColor: const Color(0xFF2E7D32),
        elevation: 0,
        centerTitle: true,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5)],
            ),
            child: Row(
              children: [
                const Icon(Icons.stars_rounded, color: Color(0xFFFFB74D), size: 24),
                const SizedBox(width: 4),
                Text(
                  '$_score',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFFFFB74D)),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Progress Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.black.withOpacity(0.05),
                valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF81C784)),
                minHeight: 10,
              ),
            ),
          ),
          Expanded(
            child: TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 800),
              tween: Tween(begin: 0.0, end: 1.0),
              curve: Curves.easeOutQuart,
              builder: (context, value, child) {
                return Opacity(
                  opacity: value,
                  child: Transform.translate(
                    offset: Offset(0, 30 * (1 - value)),
                    child: child,
                  ),
                );
              },
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    const Text(
                      'Huruf apakah ini?',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: Colors.black54),
                    ),
                    const SizedBox(height: 30),
                    // Question Card
                    Container(
                      width: double.infinity,
                      height: 220,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(32),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                        border: Border.all(
                          color: _hasAnswered
                              ? (_isCorrect ? const Color(0xFF81C784) : const Color(0xFFEF9A9A))
                              : Colors.white,
                          width: 3,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        currentQuestion['question'],
                        style: TextStyle(
                          fontSize: 120,
                          fontWeight: FontWeight.bold,
                          color: _hasAnswered
                              ? (_isCorrect ? const Color(0xFF2E7D32) : const Color(0xFFC62828))
                              : const Color(0xFF2E7D32),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    // Options
                    ...(currentQuestion['options'] as List<String>).map((option) {
                      Color bgColor = _buttonColors[option] ?? Colors.white;
                      Color textColor = _buttonColors.containsKey(option) ? Colors.white : Colors.black87;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: AnimatedButton(
                          onTap: () => _checkAnswer(option),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            decoration: BoxDecoration(
                              color: bgColor,
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(
                                color: _buttonColors.containsKey(option) ? bgColor : Colors.black.withOpacity(0.05),
                                width: 2,
                              ),
                              boxShadow: [
                                if (!_buttonColors.containsKey(option))
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.03),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                              ],
                            ),
                            child: Text(
                              option,
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: textColor),
                            ),
                          ),
                        ),
                      );
                    }),
                    const SizedBox(height: 20),
                    // Feedback & Next Button
                    if (_hasAnswered)
                      Column(
                        children: [
                          Text(
                            _isCorrect ? 'Hebat! Kamu Benar 🎉' : 'Ups, coba lagi ya! 😊',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: _isCorrect ? const Color(0xFF2E7D32) : const Color(0xFFC62828),
                            ),
                          ),
                          if (_isCorrect) ...[
                            const SizedBox(height: 20),
                            AnimatedButton(
                              onTap: _nextQuestion,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF81C784),
                                  borderRadius: BorderRadius.circular(100),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFF81C784).withOpacity(0.3),
                                      blurRadius: 10,
                                      offset: const Offset(0, 5),
                                    ),
                                  ],
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Lanjut',
                                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                                    ),
                                    SizedBox(width: 8),
                                    Icon(Icons.arrow_forward_rounded, color: Colors.white),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
