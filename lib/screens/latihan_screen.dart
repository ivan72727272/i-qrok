import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../constants/app_constants.dart';
import '../widgets/animated_button.dart';
import '../widgets/primary_button.dart';

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
        _buttonColors[selectedAnswer] = AppColors.primaryLight;
        if (_isFirstAttempt) {
          _score += 20;
        }
      } else {
        _buttonColors[selectedAnswer] = AppColors.error;
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
      appBar: AppBar(
        title: const Text('Latihan Selesai'),
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
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Hebat! 🎉',
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: AppColors.primary),
                ),
                const SizedBox(height: AppSpacing.sm),
                const Text(
                  'Kamu sudah menyelesaikan latihan.',
                  style: TextStyle(fontSize: 16, color: AppColors.textDim),
                ),
                const SizedBox(height: AppSpacing.xxl),
                Container(
                  padding: const EdgeInsets.all(50),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: const [
                      BoxShadow(
                        color: AppColors.cardShadow,
                        blurRadius: 30,
                        offset: Offset(0, 15),
                      ),
                    ],
                    border: Border.all(color: AppColors.accent, width: 8),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'SKOR',
                        style: TextStyle(fontSize: 20, color: AppColors.textDim, fontWeight: FontWeight.w900, letterSpacing: 2),
                      ),
                      Text(
                        '$_score',
                        style: const TextStyle(fontSize: 100, fontWeight: FontWeight.w900, color: AppColors.accent),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.xxl * 1.5),
                PrimaryButton(
                  label: 'Coba Lagi',
                  onTap: _startNewQuiz,
                  icon: Icons.refresh_rounded,
                  color: AppColors.info,
                ),
                const SizedBox(height: AppSpacing.lg),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Kembali ke Beranda',
                    style: TextStyle(fontSize: 18, color: AppColors.textDim, fontWeight: FontWeight.w600),
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
      appBar: AppBar(
        title: const Text('Latihan'),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: AppSpacing.md),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppRadius.lg),
              boxShadow: const [BoxShadow(color: AppColors.cardShadow, blurRadius: 5)],
            ),
            child: Row(
              children: [
                const Icon(Icons.stars_rounded, color: AppColors.accent, size: 24),
                const SizedBox(width: 4),
                Text(
                  '$_score',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.accent),
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
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.sm),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.black.withOpacity(0.05),
                valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primaryLight),
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
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  children: [
                    const Text(
                      'Huruf apakah ini?',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: AppColors.textDim),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    // Question Card
                    Container(
                      width: double.infinity,
                      height: 220,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(AppRadius.xl),
                        boxShadow: const [
                          BoxShadow(
                            color: AppColors.cardShadow,
                            blurRadius: 20,
                            offset: Offset(0, 10),
                          ),
                        ],
                        border: Border.all(
                          color: _hasAnswered
                              ? (_isCorrect ? AppColors.primaryLight : AppColors.error)
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
                              ? (_isCorrect ? AppColors.primary : const Color(0xFFC62828))
                              : AppColors.primary,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxl),
                    // Options
                    ...(currentQuestion['options'] as List<String>).map((option) {
                      Color bgColor = _buttonColors[option] ?? Colors.white;
                      Color textColor = _buttonColors.containsKey(option) ? Colors.white : AppColors.textMain;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.md),
                        child: AnimatedButton(
                          onTap: () => _checkAnswer(option),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            decoration: BoxDecoration(
                              color: bgColor,
                              borderRadius: BorderRadius.circular(AppRadius.lg),
                              border: Border.all(
                                color: _buttonColors.containsKey(option) ? bgColor : Colors.black.withOpacity(0.05),
                                width: 2,
                              ),
                              boxShadow: [
                                if (!_buttonColors.containsKey(option))
                                  const BoxShadow(
                                    color: AppColors.cardShadow,
                                    blurRadius: 10,
                                    offset: Offset(0, 4),
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
                    const SizedBox(height: AppSpacing.md),
                    // Feedback & Next Button
                    if (_hasAnswered)
                      Column(
                        children: [
                          Text(
                            _isCorrect ? 'Hebat! Kamu Benar 🎉' : 'Ups, coba lagi ya! 😊',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: _isCorrect ? AppColors.primary : const Color(0xFFC62828),
                            ),
                          ),
                          if (_isCorrect) ...[
                            const SizedBox(height: AppSpacing.lg),
                            PrimaryButton(
                              label: 'Lanjut',
                              onTap: _nextQuestion,
                              icon: Icons.arrow_forward_rounded,
                              color: AppColors.primaryLight,
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
