import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../models/iqra_model.dart';

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
        title: Text(widget.level.title),
        backgroundColor: widget.level.color,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Progress Bar
          LinearProgressIndicator(
            value: (widget.level.pages.isEmpty) ? 0 : (_currentPage + 1) / widget.level.pages.length,
            backgroundColor: widget.level.color.withOpacity(0.1),
            valueColor: AlwaysStoppedAnimation<Color>(widget.level.color),
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
                return Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Arabic Text
                      Container(
                        padding: const EdgeInsets.all(40),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: widget.level.color.withOpacity(0.2), width: 2),
                        ),
                        child: Text(
                          page.arabic,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 72,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                            fontFamily: 'Regular', // Use default or specific Arabic font if available
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      // Latin Transliteration
                      Text(
                        page.latin,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w500,
                          color: widget.level.color,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 60),
                      // Play Audio Button
                      GestureDetector(
                        onTap: _playAudio,
                        child: Container(
                          width: 100,
                          height: 100,
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
                                  padding: EdgeInsets.all(25.0),
                                  child: CircularProgressIndicator(color: Colors.white),
                                )
                              : Icon(
                                  _isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                                  size: 60,
                                  color: Colors.white,
                                ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          // Navigation Buttons
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildNavButton(
                  icon: Icons.arrow_back_ios_new_rounded,
                  label: 'Sebelumnya',
                  onPressed: _currentPage > 0
                      ? () => _pageController.previousPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          )
                      : null,
                ),
                Text(
                  'Halaman ${_currentPage + 1} / ${widget.level.pages.length}',
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black54),
                ),
                _buildNavButton(
                  icon: Icons.arrow_forward_ios_rounded,
                  label: 'Selanjutnya',
                  onPressed: _currentPage < widget.level.pages.length - 1
                      ? () => _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          )
                      : null,
                  isForward: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavButton({
    required IconData icon,
    required String label,
    VoidCallback? onPressed,
    bool isForward = false,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: widget.level.color,
        elevation: 2,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: BorderSide(color: onPressed != null ? widget.level.color : Colors.grey.shade300),
        ),
      ),
      child: Row(
        children: isForward
            ? [
                Text(label),
                const SizedBox(width: 8),
                Icon(icon, size: 18),
              ]
            : [
                Icon(icon, size: 18),
                const SizedBox(width: 8),
                Text(label),
              ],
      ),
    );
  }
}
