import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';
import '../constants/app_constants.dart';
import '../widgets/islamic_decor.dart';
import '../widgets/reward_animation.dart';
import '../services/sound_service.dart';

class LatihanScreen extends StatefulWidget {
  const LatihanScreen({super.key});

  @override
  State<LatihanScreen> createState() => _LatihanScreenState();
}

class _LatihanScreenState extends State<LatihanScreen> with TickerProviderStateMixin {
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
  late AnimationController _entryCtrl;

  int _currentIndex = 0;
  int _score = 0;
  bool _hasAnswered = false;
  bool _isCorrect = false;
  bool _isFirstAttempt = true;
  bool _isFinished = false;
  bool _showReward = false;

  final Map<String, Color> _buttonColors = {};

  @override
  void initState() {
    super.initState();
    _entryCtrl = AnimationController(duration: const Duration(milliseconds: 600), vsync: this);
    _startNewQuiz();
  }

  @override
  void dispose() {
    _entryCtrl.dispose();
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
    _isFirstAttempt = true;
    _buttonColors.clear();
  }

  Future<void> _playSound(bool isCorrect) async {
    if (isCorrect) {
      await SoundService.playCorrect();
      if (mounted) {
        setState(() => _showReward = true);
      }
    } else {
      await SoundService.playWrong();
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
        _buttonColors[selectedAnswer] = AppColors.primary;
        if (_isFirstAttempt) _score += 20;
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
        SoundService.playSuccess();
      }
    });
    _entryCtrl.reset();
    _entryCtrl.forward();
  }

  @override
  Widget build(BuildContext context) {
    if (_isFinished) return _buildResultScreen();

    final q = _activeQuizData[_currentIndex];
    final progress = (_currentIndex + 1) / _activeQuizData.length;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          const FloatingStars(),
          Column(
            children: [
              _buildHeader(context),
              _buildProgressBar(progress),
              Expanded(
                child: FadeTransition(
                  opacity: CurvedAnimation(parent: _entryCtrl, curve: Curves.easeIn),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    child: Column(
                      children: [
                        _buildQuestionCard(q['question']),
                        const SizedBox(height: 24),
                        const Text('Huruf apakah ini?',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.textDim)),
                        const SizedBox(height: 16),
                        ... (q['options'] as List<String>).map((opt) => _buildOption(opt)),
                        if (_hasAnswered && _isCorrect) ...[
                          const SizedBox(height: 32),
                          _buildNextButton(),
                        ],
                        if (_hasAnswered && !_isCorrect) ...[
                          const SizedBox(height: 16),
                          const Text('Ups! Coba lagi ya... 😊',
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.error)),
                        ]
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

  Widget _buildHeader(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft, end: Alignment.bottomRight,
          colors: [Color(0xFF4D96FF), Color(0xFFC77DFF)],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(AppRadius.xl),
          bottomRight: Radius.circular(AppRadius.xl),
        ),
        boxShadow: [BoxShadow(color: Color(0x444D96FF), blurRadius: 20, offset: Offset(0, 8))],
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(AppSpacing.sm, AppSpacing.sm, AppSpacing.lg, AppSpacing.lg),
          child: Row(
            children: [
              Material(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(AppRadius.lg),
                child: InkWell(
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  onTap: () => Navigator.pop(context),
                  child: const Padding(padding: EdgeInsets.all(10),
                    child: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20)),
                ),
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('🎮  Kuis Seru',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.white,
                        shadows: [Shadow(color: Colors.black26, blurRadius: 4)])),
                    Text('Uji kemampuan ngajimu!',
                      style: TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.25),
                  borderRadius: BorderRadius.circular(AppRadius.full),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.stars_rounded, color: Colors.white, size: 20),
                    const SizedBox(width: 6),
                    Text('$_score',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.white)),
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
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Pertanyaan ${_currentIndex + 1}/5',
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: AppColors.textDim)),
              Text('${(val * 100).toInt()}%',
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: AppColors.primary)),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.full),
            child: LinearProgressIndicator(
              value: val,
              minHeight: 10,
              backgroundColor: AppColors.primary.withOpacity(0.1),
              valueColor: const AlwaysStoppedAnimation(AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionCard(String char) {
    return Container(
      width: double.infinity,
      height: 180,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        boxShadow: [
          BoxShadow(color: AppColors.primary.withOpacity(0.15), blurRadius: 24, offset: const Offset(0, 10)),
        ],
        border: Border.all(color: AppColors.primary.withOpacity(0.2), width: 2),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(top: -30, left: -30,
            child: Container(width: 100, height: 100,
              decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.05), shape: BoxShape.circle))),
          Text(char,
            style: const TextStyle(fontSize: 100, fontWeight: FontWeight.w900, color: AppColors.primary, fontFamily: 'Amiri')),
        ],
      ),
    );
  }

  Widget _buildOption(String text) {
    final color = _buttonColors[text] ?? Colors.white;
    final isSelected = _buttonColors.containsKey(text);
    final textColor = isSelected ? Colors.white : AppColors.textMain;
    final borderColor = isSelected ? color : Colors.grey.shade200;

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: GestureDetector(
        onTap: () => _checkAnswer(text),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 18),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(color: borderColor, width: 2.5),
            boxShadow: [
              if (!isSelected)
                BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 10, offset: const Offset(0, 4)),
              if (isSelected)
                BoxShadow(color: color.withOpacity(0.4), blurRadius: 12, offset: const Offset(0, 6)),
            ],
          ),
          child: Text(text,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: textColor)),
        ),
      ),
    );
  }

  Widget _buildNextButton() {
    return GestureDetector(
      onTap: _nextQuestion,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [Color(0xFF6BCB77), Color(0xFF4D96FF)]),
          borderRadius: BorderRadius.circular(AppRadius.full),
          boxShadow: [BoxShadow(color: AppColors.primary.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 6))],
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Lanjut', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.white)),
            SizedBox(width: 10),
            Icon(Icons.arrow_forward_rounded, color: Colors.white),
          ],
        ),
      ),
    );
  }

  Widget _buildResultScreen() {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFDF7),
      body: Stack(
        children: [
          const FloatingStars(),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(32),
              child: Column(
                children: [
                  // Celebrating Mascot
                  SizedBox(
                    width: 180,
                    height: 180,
                    child: MenuCharacter(name: 'Ana', color: AppColors.primary),
                  ),
                  const SizedBox(height: 16),
                  const Text('MASYA ALLAH!',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: AppColors.primary, letterSpacing: 2)),
                  const Text('Kamu sudah menyelesaikan kuis dengan hebat!',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textDim)),
                  const SizedBox(height: 40),
                  // Score Card
                  Container(
                    width: 220, height: 220,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(color: AppColors.primary.withOpacity(0.2), blurRadius: 40, spreadRadius: 10),
                      ],
                      border: Border.all(color: AppColors.primary.withOpacity(0.1), width: 10),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('SKOR KAMU', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: AppColors.textDim, letterSpacing: 2)),
                        Text('$_score',
                          style: const TextStyle(fontSize: 80, fontWeight: FontWeight.w900, color: AppColors.primary)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 48),
                  // Buttons
                  GestureDetector(
                    onTap: () {
                      HapticFeedback.mediumImpact();
                      _startNewQuiz();
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(colors: [Color(0xFF4D96FF), Color(0xFFC77DFF)]),
                        borderRadius: BorderRadius.circular(AppRadius.full),
                        boxShadow: [BoxShadow(color: const Color(0xFF4D96FF).withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 6))],
                      ),
                      child: const Center(
                        child: Text('Main Lagi Yuk! 🎮',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.white)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Kembali ke Beranda',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.textDim)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
