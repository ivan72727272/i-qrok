import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../widgets/animated_button.dart';

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

class _DetailHurufScreenState extends State<DetailHurufScreen> with SingleTickerProviderStateMixin {
  late AudioPlayer _audioPlayer;
  bool _isPlaying = false;
  bool _isLoading = false;
  late AnimationController _pulseController;

  final Map<String, String> _audioMapping = {
    'أ': 'alif.mp3', 'ب': 'ba.mp3', 'ت': 'ta.mp3', 'ث': 'tha.mp3', 'ج': 'jim.mp3',
    'ح': 'ha.mp3', 'خ': 'kha.mp3', 'د': 'dal.mp3', 'ذ': 'dhal.mp3', 'ر': 'ra.mp3',
    'ز': 'zay.mp3', 'س': 'sin.mp3', 'ش': 'shin.mp3', 'ص': 'sad.mp3', 'ض': 'dad.mp3',
    'ط': 'tta.mp3', 'ظ': 'za.mp3', 'ع': 'ain.mp3', 'غ': 'ghain.mp3', 'ف': 'fa.mp3',
    'ق': 'qaf.mp3', 'ك': 'kaf.mp3', 'ل': 'lam.mp3', 'م': 'mim.mp3', 'ن': 'nun.mp3',
    'و': 'waw.mp3', 'هـ': 'hha.mp3', 'ء': 'hamzah.mp3', 'ي': 'ya.mp3',
  };

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _audioPlayer.onPlayerStateChanged.listen((state) {
      if (mounted) {
        setState(() {
          _isPlaying = state == PlayerState.playing;
          if (_isPlaying) {
            _pulseController.repeat(reverse: true);
          } else {
            _pulseController.stop();
            _pulseController.reset();
          }
        });
      }
    });

    _audioPlayer.onPlayerComplete.listen((event) {
      if (mounted) {
        setState(() {
          _isPlaying = false;
          _isLoading = false;
          _pulseController.stop();
          _pulseController.reset();
        });
      }
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _playSound() async {
    if (_isLoading || _isPlaying) return;
    setState(() => _isLoading = true);
    try {
      String? fileName = _audioMapping[widget.char];
      if (fileName != null) {
        await _audioPlayer.stop();
        await _audioPlayer.play(AssetSource('audio/huruf/$fileName'));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Suara ${widget.name} belum tersedia')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              widget.color.withOpacity(0.08),
              const Color(0xFFF6F8F2),
              widget.color.withOpacity(0.05),
            ],
          ),
        ),
        child: SafeArea(
          child: TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 1000),
            tween: Tween(begin: 0.0, end: 1.0),
            curve: Curves.easeOutQuart,
            builder: (context, value, child) {
              return Opacity(opacity: value, child: child);
            },
            child: Column(
              children: [
                // Custom App Bar
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back_ios_new_rounded, color: widget.color.withOpacity(0.7), size: 28),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 20),
                        // Letter Container (Glassmorphism inspired)
                        Hero(
                          tag: 'letter-${widget.char}',
                          child: Container(
                            width: 280,
                            height: 280,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.8),
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                              boxShadow: [
                                BoxShadow(
                                  color: widget.color.withOpacity(0.15),
                                  blurRadius: 40,
                                  spreadRadius: 5,
                                ),
                              ],
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: Text(
                                widget.char,
                                style: TextStyle(
                                  fontSize: 160,
                                  fontWeight: FontWeight.bold,
                                  color: widget.color,
                                  shadows: [
                                    Shadow(
                                      color: widget.color.withOpacity(0.3),
                                      blurRadius: 20,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),
                        // Letter Name
                        Text(
                          widget.name,
                          style: TextStyle(
                            fontSize: 54,
                            fontWeight: FontWeight.bold,
                            color: widget.color.withOpacity(0.8),
                            letterSpacing: 1.5,
                          ),
                        ),
                        const SizedBox(height: 80),
                        // Action Button
                        AnimatedButton(
                          onTap: _playSound,
                          child: RepaintBoundary(
                            child: ScaleTransition(
                              scale: Tween(begin: 1.0, end: 1.08).animate(_pulseController),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 24),
                                decoration: BoxDecoration(
                                  color: widget.color,
                                  borderRadius: BorderRadius.circular(100),
                                  boxShadow: [
                                    BoxShadow(
                                      color: widget.color.withOpacity(0.3),
                                      blurRadius: 15,
                                      offset: const Offset(0, 8),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    _isLoading
                                        ? const SizedBox(
                                            width: 28,
                                            height: 28,
                                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
                                          )
                                        : Icon(
                                            _isPlaying ? Icons.pause_rounded : Icons.volume_up_rounded,
                                            color: Colors.white,
                                            size: 32,
                                          ),
                                    const SizedBox(width: 16),
                                    Text(
                                      _isLoading ? 'Memuat...' : (_isPlaying ? 'Mendengarkan' : 'Putar Suara'),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
