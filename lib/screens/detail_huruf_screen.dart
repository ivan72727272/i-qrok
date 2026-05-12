import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';
import '../constants/app_constants.dart';
import '../widgets/islamic_decor.dart';
import '../screens/home_screen.dart'; // To use MenuCharacter

class DetailHurufScreen extends StatefulWidget {
  final String char;
  final String name;
  final Color color;

  const DetailHurufScreen({
    super.key,
    required this.char,
    required this.name,
    required this.color,
  });

  @override
  State<DetailHurufScreen> createState() => _DetailHurufScreenState();
}

class _DetailHurufScreenState extends State<DetailHurufScreen> with TickerProviderStateMixin {
  late AudioPlayer _audioPlayer;
  bool _isPlaying = false;
  late AnimationController _pulseCtrl;
  late AnimationController _floatCtrl;
  late AnimationController _bounceCtrl;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _pulseCtrl = AnimationController(duration: const Duration(seconds: 2), vsync: this)..repeat();
    _floatCtrl = AnimationController(duration: const Duration(seconds: 3), vsync: this)..repeat(reverse: true);
    _bounceCtrl = AnimationController(duration: const Duration(milliseconds: 600), vsync: this);

    _audioPlayer.onPlayerStateChanged.listen((state) {
      if (mounted) setState(() => _isPlaying = state == PlayerState.playing);
    });

    Future.delayed(const Duration(milliseconds: 300), _playSound);
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _pulseCtrl.dispose();
    _floatCtrl.dispose();
    _bounceCtrl.dispose();
    super.dispose();
  }

  Future<void> _playSound() async {
    _bounceCtrl.forward(from: 0);
    HapticFeedback.mediumImpact();
    try {
      final fileName = _getFileName(widget.char);
      if (fileName != null) {
        await _audioPlayer.stop();
        await _audioPlayer.play(AssetSource('audio/huruf/$fileName'));
      }
    } catch (e) {
      debugPrint("Audio error: $e");
    }
  }

  String? _getFileName(String char) {
    const mapping = {
      'أ': 'alif.mp3', 'ب': 'ba.mp3', 'ت': 'ta.mp3', 'ث': 'tha.mp3', 'ج': 'jim.mp3',
      'ح': 'ha.mp3', 'خ': 'kha.mp3', 'د': 'dal.mp3', 'ذ': 'dhal.mp3', 'ر': 'ra.mp3',
      'ز': 'zay.mp3', 'س': 'sin.mp3', 'ش': 'shin.mp3', 'ص': 'sad.mp3', 'ض': 'dad.mp3',
      'ط': 'tta.mp3', 'ظ': 'za.mp3', 'ع': 'ain.mp3', 'غ': 'ghain.mp3', 'ف': 'fa.mp3',
      'ق': 'qaf.mp3', 'ك': 'kaf.mp3', 'ل': 'lam.mp3', 'م': 'mim.mp3', 'ن': 'nun.mp3',
      'و': 'waw.mp3', 'هـ': 'hha.mp3', 'ء': 'hamzah.mp3', 'ي': 'ya.mp3',
    };
    return mapping[char];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFDF7),
      body: Stack(
        children: [
          // Background soft blobs
          Positioned(top: -50, right: -50,
            child: Container(width: 250, height: 250,
              decoration: BoxDecoration(color: widget.color.withOpacity(0.08), shape: BoxShape.circle))),
          Positioned(bottom: 100, left: -60,
            child: Container(width: 200, height: 200,
              decoration: BoxDecoration(color: widget.color.withOpacity(0.06), shape: BoxShape.circle))),
          const FloatingStars(),

          Column(
            children: [
              _buildHeader(context),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      const SizedBox(height: 40),
                      _buildLargeLetterCard(),
                      const SizedBox(height: 32),
                      _buildLetterName(),
                      const SizedBox(height: 40),
                      _buildAudioControls(),
                    ],
                  ),
                ),
              ),
            ],
          ),
          
          // Mascot in bottom corner
          Positioned(
            bottom: -20,
            right: -20,
            child: SizedBox(
              width: 150,
              height: 150,
              child: Opacity(
                opacity: 0.9,
                child: MenuCharacter(name: 'Ahmad', color: widget.color),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft, end: Alignment.bottomRight,
          colors: [widget.color, widget.color.withOpacity(0.7)],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(AppRadius.xl),
          bottomRight: Radius.circular(AppRadius.xl),
        ),
        boxShadow: [BoxShadow(color: widget.color.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 8))],
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(AppSpacing.sm, AppSpacing.sm, AppSpacing.lg, 24),
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
                    Text('✨ Belajar Huruf',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.white,
                        shadows: [Shadow(color: Colors.black26, blurRadius: 4)])),
                    Text('Mari mengenal huruf Hijaiyah!',
                      style: TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLargeLetterCard() {
    return AnimatedBuilder(
      animation: Listenable.merge([_floatCtrl, _bounceCtrl]),
      builder: (context, child) {
        final floatOffset = 10 * _floatCtrl.value;
        final bounceScale = 1.0 + (0.1 * (1.0 - (1.0 - _bounceCtrl.value).abs()));
        
        return Transform.translate(
          offset: Offset(0, floatOffset),
          child: Transform.scale(
            scale: bounceScale,
            child: GestureDetector(
              onTap: _playSound,
              child: Container(
                width: 260,
                height: 260,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: widget.color.withOpacity(0.2),
                      blurRadius: 40,
                      spreadRadius: 5,
                    ),
                    BoxShadow(
                      color: Colors.white,
                      blurRadius: 2,
                      inset: true,
                    ),
                  ],
                  border: Border.all(color: widget.color.withOpacity(0.2), width: 3),
                ),
                child: Center(
                  child: Text(
                    widget.char,
                    style: TextStyle(
                      fontSize: 140,
                      fontWeight: FontWeight.w900,
                      color: widget.color,
                      fontFamily: 'Amiri',
                      shadows: [Shadow(color: widget.color.withOpacity(0.3), blurRadius: 20)],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLetterName() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
      decoration: BoxDecoration(
        color: widget.color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Text(
        widget.name.toUpperCase(),
        style: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w900,
          color: widget.color,
          letterSpacing: 4,
        ),
      ),
    );
  }

  Widget _buildAudioControls() {
    return Column(
      children: [
        GestureDetector(
          onTap: _playSound,
          child: AnimatedBuilder(
            animation: _pulseCtrl,
            builder: (context, child) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 70 + (20 * _pulseCtrl.value),
                    height: 70 + (20 * _pulseCtrl.value),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: widget.color.withOpacity(0.2 * (1 - _pulseCtrl.value)),
                    ),
                  ),
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [widget.color, widget.color.withOpacity(0.7)],
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(color: widget.color.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 5)),
                      ],
                    ),
                    child: Icon(
                      _isPlaying ? Icons.volume_up_rounded : Icons.play_arrow_rounded,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        Text(
          _isPlaying ? 'Sedang Diputar...' : 'Ketuk untuk Mendengar',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: widget.color.withOpacity(0.7),
          ),
        ),
      ],
    );
  }
}
