import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_constants.dart';
import '../widgets/islamic_decor.dart';
import '../widgets/reward_animation.dart';
import '../services/sound_service.dart';
import '../screens/home_screen.dart'; // To use MenuCharacter

class LatihanScreen extends StatefulWidget {
  const LatihanScreen({super.key});

  @override
  State<LatihanScreen> createState() => _LatihanScreenState();
}

class _LatihanScreenState extends State<LatihanScreen> with TickerProviderStateMixin {
  final List<Map<String, dynamic>> _masterQuizData = [
    {'question': 'أ', 'options': ['Alif', 'Ba', 'Ta'], 'answer': 'Alif'},
    {'question': 'ب', 'options': ['Ta', 'Ba', 'Jim'], 'answer': 'Ba'},
    {'question': 'ت', 'options': ['Ta', 'Sa', 'Alif'], 'answer': 'Ta'},
    {'question': 'ج', 'options': ['Kha', 'Ha', 'Jim'], 'answer': 'Jim'},
    {'question': 'ث', 'options': ['Sa', 'Tha', 'Dal'], 'answer': 'Tha'},
    {'question': 'ح', 'options': ['Ha', 'Kha', 'Jim'], 'answer': 'Ha'},
    {'question': 'خ', 'options': ['Jim', 'Ha', 'Kha'], 'answer': 'Kha'},
    {'question': 'د', 'options': ['Dal', 'Dhal', 'Ra'], 'answer': 'Dal'},
    {'question': 'ر', 'options': ['Zay', 'Ra', 'Waw'], 'answer': 'Ra'},
    {'question': 'س', 'options': ['Shin', 'Sin', 'Sad'], 'answer': 'Sin'},
  ];

  late List<Map<String, dynamic>> _activeQuizData;
  late AnimationController _entryCtrl;
  late AnimationController _shakeCtrl;
  late AnimationController _bounceCtrl;

  int _currentIndex = 0;
  int _score = 0;
  bool _hasAnswered = false;
  bool _isCorrect = false;
  bool _isFinished = false;
  bool _showReward = false;
  String _feedbackMessage = '';

  final Map<String, Color> _buttonColors = {};
  final Random _random = Random();

  final List<String> _correctVoices = [
    'Yeay, benar! ✨',
    'MasyaAllah, pintar sekali! ❤️',
    'Hebat! 🌟',
    'Kamu luar biasa! 🚀',
    'Bagus banget! 👏',
  ];

  final List<String> _wrongVoices = [
    'Yuk coba lagi 😊',
    'Sedikit lagi benar! 💪',
    'Ayo semangat! ✨',
    'Coba lagi ya sayang... ❤️',
  ];

  @override
  void initState() {
    super.initState();
    _entryCtrl = AnimationController(duration: const Duration(milliseconds: 600), vsync: this);
    _shakeCtrl = AnimationController(duration: const Duration(milliseconds: 400), vsync: this);
    _bounceCtrl = AnimationController(duration: const Duration(milliseconds: 500), vsync: this);
    _startNewQuiz();
  }

  @override
  void dispose() {
    _entryCtrl.dispose();
    _shakeCtrl.dispose();
    _bounceCtrl.dispose();
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
    _entryCtrl.reset();
    _entryCtrl.forward();
  }

  void _resetQuestionState() {
    _hasAnswered = false;
    _isCorrect = false;
    _buttonColors.clear();
    _feedbackMessage = '';
  }

  Future<void> _handleFeedback(bool isCorrect) async {
    if (isCorrect) {
      _bounceCtrl.forward(from: 0);
      SoundService.playCorrect();
      setState(() {
        _showReward = true;
        _feedbackMessage = _correctVoices[_random.nextInt(_correctVoices.length)];
      });
    } else {
      _shakeCtrl.forward(from: 0);
      SoundService.playWrong();
      setState(() {
        _feedbackMessage = _wrongVoices[_random.nextInt(_wrongVoices.length)];
      });
    }
    HapticFeedback.lightImpact();
  }

  void _checkAnswer(String selectedAnswer) {
    if (_hasAnswered && _isCorrect) return;

    String correctAnswer = _activeQuizData[_currentIndex]['answer'];
    bool isAnswerCorrect = selectedAnswer == correctAnswer;
    
    _handleFeedback(isAnswerCorrect);

    setState(() {
      _hasAnswered = true;
      _isCorrect = isAnswerCorrect;
      
      if (isAnswerCorrect) {
        _buttonColors[selectedAnswer] = const Color(0xFF6BCB77);
        _score += 20;
      } else {
        _buttonColors[selectedAnswer] = const Color(0xFFFF6B6B);
      }
    });
  }

  void _nextQuestion() {
    if (_currentIndex < _activeQuizData.length - 1) {
      setState(() {
        _currentIndex++;
        _resetQuestionState();
      });
      _entryCtrl.reset();
      _entryCtrl.forward();
    } else {
      setState(() => _isFinished = true);
      SoundService.playSuccess();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isFinished) return _buildResultScreen();

    final q = _activeQuizData[_currentIndex];
    final progress = (_currentIndex + 1) / _activeQuizData.length;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FBFF),
      body: Stack(
        children: [
          _buildMagicalBackground(),
          Column(
            children: [
              _buildHeader(context),
              _buildProgressBar(progress),
              Expanded(
                child: FadeTransition(
                  opacity: _entryCtrl,
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    child: Column(
                      children: [
                        _buildQuestionCard(q['question']),
                        const SizedBox(height: 32),
                        Text('HURUF APAKAH INI?',
                          style: GoogleFonts.nunito(fontSize: 16, fontWeight: FontWeight.w900, color: Colors.blueGrey[300], letterSpacing: 2)),
                        const SizedBox(height: 24),
                        ... (q['options'] as List<String>).map((opt) => _buildOption(opt)),
                        
                        // Animated Feedback Text
                        AnimatedOpacity(
                          duration: const Duration(milliseconds: 300),
                          opacity: _hasAnswered ? 1.0 : 0.0,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: Text(
                              _feedbackMessage,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.nunito(
                                fontSize: 18, 
                                fontWeight: FontWeight.w900, 
                                color: _isCorrect ? const Color(0xFF4CAF50) : const Color(0xFFFF5252),
                              ),
                            ),
                          ),
                        ),
                        
                        if (_hasAnswered && _isCorrect) _buildNextButton(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          RewardAnimation(
            show: _showReward,
            onComplete: () => setState(() => _showReward = false),
          ),
        ],
      ),
    );
  }

  Widget _buildMagicalBackground() {
    return Stack(
      children: [
        const FloatingStars(),
        Positioned(top: 150, left: -20, child: Opacity(opacity: 0.1, child: Icon(Icons.cloud_rounded, size: 100, color: Colors.blue[200]))),
        Positioned(bottom: 100, right: -20, child: Opacity(opacity: 0.1, child: Icon(Icons.wb_sunny_rounded, size: 150, color: Colors.amber[200]))),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft, end: Alignment.bottomRight,
          colors: [Color(0xFF4FACFE), Color(0xFF00F2FE)],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
        boxShadow: [BoxShadow(color: Colors.blue.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 8))],
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 24, 20),
          child: Row(
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 22),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('✨ Kuis Ceria',
                      style: GoogleFonts.nunito(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.white)),
                    Text('Ayo buktikan kepintaranmu!',
                      style: GoogleFonts.nunito(fontSize: 12, color: Colors.white.withOpacity(0.9), fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.25),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.stars_rounded, color: Colors.amber, size: 22),
                    const SizedBox(width: 6),
                    Text('$_score',
                      style: GoogleFonts.nunito(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.white)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressBar(double val) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Pertanyaan ${_currentIndex + 1} dari 5',
                style: GoogleFonts.nunito(fontSize: 13, fontWeight: FontWeight.w800, color: Colors.blueGrey[300])),
              Text('${(val * 100).toInt()}% Selesai',
                style: GoogleFonts.nunito(fontSize: 13, fontWeight: FontWeight.w900, color: const Color(0xFF4FACFE))),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: val,
              minHeight: 12,
              backgroundColor: Colors.blue.withOpacity(0.1),
              valueColor: const AlwaysStoppedAnimation(Color(0xFF4FACFE)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionCard(String char) {
    return AnimatedBuilder(
      animation: Listenable.merge([_shakeCtrl, _bounceCtrl]),
      builder: (context, child) {
        // Shake logic
        double shake = 0;
        if (_shakeCtrl.value > 0) {
          shake = sin(_shakeCtrl.value * pi * 8) * 10 * (1 - _shakeCtrl.value);
        }
        
        // Bounce logic
        double bounce = 1.0;
        if (_bounceCtrl.value > 0) {
          bounce = 1.0 + (0.15 * sin(_bounceCtrl.value * pi));
        }

        return Transform.translate(
          offset: Offset(shake, 0),
          child: Transform.scale(
            scale: bounce,
            child: Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(32),
                boxShadow: [
                  BoxShadow(color: const Color(0xFF4FACFE).withOpacity(0.1), blurRadius: 30, offset: const Offset(0, 15)),
                ],
                border: Border.all(color: Colors.blue[50]!, width: 2),
              ),
              child: Center(
                child: Text(
                  char,
                  style: const TextStyle(
                    fontSize: 120, 
                    fontWeight: FontWeight.w900, 
                    color: Color(0xFF4FACFE), 
                    fontFamily: 'Amiri',
                    shadows: [Shadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4))],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildOption(String text) {
    final color = _buttonColors[text] ?? Colors.white;
    final isSelected = _buttonColors.containsKey(text);
    final isOptionCorrect = isSelected && text == _activeQuizData[_currentIndex]['answer'];
    final textColor = isSelected ? Colors.white : const Color(0xFF37474F);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: GestureDetector(
        onTap: () => _checkAnswer(text),
        child: Stack(
          alignment: Alignment.centerRight,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: isSelected ? color.withOpacity(0.4) : Colors.black.withOpacity(0.04),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                  if (isOptionCorrect)
                    BoxShadow(color: Colors.green.withOpacity(0.5), blurRadius: 20, spreadRadius: 5),
                ],
                border: Border.all(
                  color: isSelected ? Colors.white : Colors.blue[50]!,
                  width: 3,
                ),
              ),
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: GoogleFonts.nunito(
                  fontSize: 26, 
                  fontWeight: FontWeight.w900, 
                  color: textColor,
                ),
              ),
            ),
            if (isOptionCorrect)
              const Positioned(
                right: 20,
                child: Icon(Icons.stars_rounded, color: Colors.white, size: 32),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildNextButton() {
    return SlideTransition(
      position: Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero)
          .animate(CurvedAnimation(parent: _bounceCtrl, curve: Curves.easeOutBack)),
      child: GestureDetector(
        onTap: _nextQuestion,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [Color(0xFF6BCB77), Color(0xFF4D96FF)]),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(color: Colors.green.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 8)),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('LANJUTKAN ✨', style: GoogleFonts.nunito(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.white)),
              const SizedBox(width: 12),
              const Icon(Icons.arrow_forward_rounded, color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultScreen() {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFCFB),
      body: Stack(
        children: [
          const FloatingStars(),
          // Confetti-like decoration (Simplified for performance)
          ...List.generate(15, (index) => Positioned(
            top: _random.nextDouble() * 500,
            left: _random.nextDouble() * 400,
            child: Icon(Icons.star_rounded, color: Colors.amber.withOpacity(0.3), size: 10 + _random.nextDouble() * 20),
          )),
          
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(32),
              child: Column(
                children: [
                  // Celebrating Mascot
                  Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blue[50],
                    ),
                    child: MenuCharacter(name: 'Ana', color: const Color(0xFF4FACFE)),
                  ),
                  const SizedBox(height: 24),
                  Text('MASYA ALLAH!',
                    style: GoogleFonts.nunito(fontSize: 36, fontWeight: FontWeight.w900, color: const Color(0xFF4FACFE), letterSpacing: 2)),
                  const SizedBox(height: 8),
                  Text('Kamu anak yang pintar dan hebat! ❤️',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.nunito(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.blueGrey[400])),
                  
                  const SizedBox(height: 48),
                  
                  // Score Medal
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 220, height: 220,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(color: Colors.amber.withOpacity(0.2), blurRadius: 40, spreadRadius: 10),
                          ],
                          border: Border.all(color: Colors.amber[100]!, width: 8),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('SKOR KAMU', style: GoogleFonts.nunito(fontSize: 12, fontWeight: FontWeight.w900, color: Colors.blueGrey[300], letterSpacing: 2)),
                            Text('$_score',
                              style: GoogleFonts.nunito(fontSize: 85, fontWeight: FontWeight.w900, color: const Color(0xFFFFB300))),
                          ],
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFD54F),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
                          ),
                          child: const Icon(Icons.emoji_events_rounded, color: Colors.white, size: 30),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 60),
                  
                  // Buttons
                  _buildResultButton(
                    'Main Lagi Yuk! 🎮', 
                    [const Color(0xFF4FACFE), const Color(0xFF00F2FE)],
                    () => _startNewQuiz(),
                  ),
                  const SizedBox(height: 16),
                  _buildResultButton(
                    'Kembali ke Beranda', 
                    [const Color(0xFFB0BEC5), const Color(0xFF90A4AE)],
                    () => Navigator.pop(context),
                    small: true,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultButton(String text, List<Color> colors, VoidCallback onTap, {bool small = false}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: small ? 16 : 20),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: colors),
          borderRadius: BorderRadius.circular(small ? 20 : 32),
          boxShadow: [BoxShadow(color: colors[0].withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 8))],
        ),
        child: Center(
          child: Text(text,
            style: GoogleFonts.nunito(fontSize: small ? 16 : 20, fontWeight: FontWeight.w900, color: Colors.white)),
        ),
      ),
    );
  }
}
