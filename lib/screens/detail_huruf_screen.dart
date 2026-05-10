import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../constants/app_constants.dart';
import '../widgets/audio_button.dart';
import '../widgets/custom_app_bar.dart';

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

    _audioPlayer.onPlayerStateChanged.listen((state) {
      if (mounted) {
        setState(() {
          _isPlaying = state == PlayerState.playing;
        });
      }
    });

    _audioPlayer.onPlayerComplete.listen((event) {
      if (mounted) {
        setState(() {
          _isPlaying = false;
          _isLoading = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
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
      } else {
        throw Exception('Audio not mapped');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.sentiment_dissatisfied_rounded, color: Colors.white),
                SizedBox(width: 12),
                Text('Upss suara belum tersedia 😊'),
              ],
            ),
            backgroundColor: AppColors.primary,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
            duration: const Duration(seconds: 2),
          ),
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
              AppColors.background,
              widget.color.withOpacity(0.05),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              CustomAppBar(
                title: 'Detail Huruf',
                subtitle: 'Suara dan Detail',
                backgroundColor: Colors.transparent,
                foregroundColor: widget.color,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: AppSpacing.lg),
                      // Letter Container
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
                      const SizedBox(height: AppSpacing.xxl),
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
                      const SizedBox(height: AppSpacing.xxl * 1.5),
                      // Action Button
                      AudioButton(
                        isPlaying: _isPlaying,
                        isLoading: _isLoading,
                        onTap: _playSound,
                        color: widget.color,
                      ),
                      const SizedBox(height: AppSpacing.xxl),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
