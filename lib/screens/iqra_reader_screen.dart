import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../models/iqra_model.dart';
import '../widgets/animated_button.dart';

class IqraReaderScreen extends StatefulWidget {
  final IqraLevel level;

  const IqraReaderScreen({super.key, required this.level});

  @override
  State<IqraReaderScreen> createState() => _IqraReaderScreenState();
}

class _IqraReaderScreenState extends State<IqraReaderScreen> {
  late PageController _pageController;
  late AudioPlayer _audioPlayer;
  int _currentPage = 0;
  bool _isPlaying = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
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
    _pageController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _playAudio() async {
    if (_isLoading || _isPlaying) return;

    setState(() => _isLoading = true);

    try {
      final page = widget.level.pages[_currentPage];
      await _audioPlayer.stop();
      await _audioPlayer.play(AssetSource('audio/iqra/${page.audioPath}'));
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Audio belum tersedia untuk halaman ini'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.level.title, style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: widget.level.color,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
      ),
      body: TweenAnimationBuilder<double>(
        duration: const Duration(milliseconds: 600),
        tween: Tween(begin: 0.0, end: 1.0),
        curve: Curves.easeOutCubic,
        builder: (context, value, child) {
          return Opacity(
            opacity: value,
            child: child,
          );
        },
        child: Column(
          children: [
            // Progress Bar
            LinearProgressIndicator(
              value: (widget.level.pages.isEmpty) ? 0 : (_currentPage + 1) / widget.level.pages.length,
              backgroundColor: widget.level.color.withOpacity(0.1),
              valueColor: AlwaysStoppedAnimation<Color>(widget.level.color),
              minHeight: 6,
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: widget.level.pages.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                    _audioPlayer.stop();
                    _isPlaying = false;
                  });
                },
                itemBuilder: (context, index) {
                  final page = widget.level.pages[index];
                  return SingleChildScrollView(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 20),
                        // Arabic Text Container
                        Container(
                          width: double.infinity,
                          constraints: const BoxConstraints(minHeight: 250),
                          padding: const EdgeInsets.all(30),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(color: widget.level.color.withOpacity(0.2), width: 3),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.03),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              page.arabic,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 80,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        // Latin Transliteration
                        Text(
                          page.latin,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: widget.level.color,
                            letterSpacing: 1.5,
                          ),
                        ),
                        const SizedBox(height: 40),
                        // Play Audio Button
                        AnimatedButton(
                          onTap: _playAudio,
                          child: Container(
                            width: 110,
                            height: 110,
                            decoration: BoxDecoration(
                              color: widget.level.color,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: widget.level.color.withOpacity(0.4),
                                  blurRadius: 15,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: _isLoading
                                ? const Padding(
                                    padding: EdgeInsets.all(30.0),
                                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 4),
                                  )
                                : Icon(
                                    _isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                                    size: 70,
                                    color: Colors.white,
                                  ),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  );
                },
              ),
            ),
            // Navigation Buttons
            Container(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildNavButton(
                    icon: Icons.arrow_back_ios_new_rounded,
                    label: 'Kembali',
                    onPressed: _currentPage > 0
                        ? () => _pageController.previousPage(
                              duration: const Duration(milliseconds: 400),
                              curve: Curves.easeOutCubic,
                            )
                        : null,
                  ),
                  Text(
                    '${_currentPage + 1} / ${widget.level.pages.length}',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black54),
                  ),
                  _buildNavButton(
                    icon: Icons.arrow_forward_ios_rounded,
                    label: 'Lanjut',
                    onPressed: _currentPage < widget.level.pages.length - 1
                        ? () => _pageController.nextPage(
                              duration: const Duration(milliseconds: 400),
                              curve: Curves.easeOutCubic,
                            )
                        : null,
                    isForward: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavButton({
    required IconData icon,
    required String label,
    VoidCallback? onPressed,
    bool isForward = false,
  }) {
    return AnimatedButton(
      onTap: onPressed ?? () {},
      child: Opacity(
        opacity: onPressed == null ? 0.5 : 1.0,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: onPressed != null ? widget.level.color : Colors.grey.shade300, width: 2),
          ),
          child: Row(
            children: isForward
                ? [
                    Text(label, style: TextStyle(fontWeight: FontWeight.bold, color: widget.level.color)),
                    const SizedBox(width: 8),
                    Icon(icon, size: 20, color: widget.level.color),
                  ]
                : [
                    Icon(icon, size: 20, color: widget.level.color),
                    const SizedBox(width: 8),
                    Text(label, style: TextStyle(fontWeight: FontWeight.bold, color: widget.level.color)),
                  ],
          ),
        ),
      ),
    );
  }
}
