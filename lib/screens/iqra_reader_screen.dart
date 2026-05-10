import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/iqra_model.dart';
import '../data/iqra_data.dart';
import '../constants/app_constants.dart';
import '../widgets/animated_button.dart';
import '../widgets/custom_app_bar.dart';

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
  bool _isDataLoading = true;
  bool _isAudioAvailable = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _audioPlayer = AudioPlayer();

    _loadData();

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

  Future<void> _loadData() async {
    await IqraData.loadLevelPages(widget.level);
    
    // Load bookmark
    final prefs = await SharedPreferences.getInstance();
    final bookmarkKey = 'iqra_bookmark_${widget.level.level}';
    final savedPage = prefs.getInt(bookmarkKey) ?? 0;

    if (mounted) {
      setState(() {
        _isDataLoading = false;
        _currentPage = (savedPage < widget.level.pages.length) ? savedPage : 0;
        _pageController = PageController(initialPage: _currentPage);
      });
      _checkAudioAvailability();
    }
  }

  Future<void> _saveBookmark(int index) async {
    final prefs = await SharedPreferences.getInstance();
    final bookmarkKey = 'iqra_bookmark_${widget.level.level}';
    await prefs.setInt(bookmarkKey, index);
  }

  Future<void> _checkAudioAvailability() async {
    if (widget.level.pages.isEmpty) return;
    
    final page = widget.level.pages[_currentPage];
    final path = 'assets/audio/iqra/${page.audioPath}';
    
    bool available = false;
    try {
      await rootBundle.load(path);
      available = true;
    } catch (e) {
      available = false;
    }
    
    if (mounted) {
      setState(() {
        _isAudioAvailable = available;
      });
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _playAudio() async {
    if (!_isAudioAvailable || _isLoading || _isPlaying) return;

    setState(() => _isLoading = true);

    try {
      final page = widget.level.pages[_currentPage];
      await _audioPlayer.stop();
      await _audioPlayer.play(AssetSource('audio/iqra/${page.audioPath}'));
    } catch (e) {
      debugPrint('Audio Iqra tidak ditemukan: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Upss suara belum tersedia 😊'),
            backgroundColor: AppColors.error,
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
    if (_isDataLoading) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (widget.level.pages.isEmpty) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: CustomAppBar(title: widget.level.title, subtitle: 'Kosong'),
        body: const Center(child: Text('Data belum tersedia')),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: widget.level.title,
        subtitle: 'Belajar Membaca',
        backgroundColor: widget.level.color,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Progress Bar
          LinearProgressIndicator(
            value: (_currentPage + 1) / widget.level.pages.length,
            backgroundColor: widget.level.color.withOpacity(0.1),
            valueColor: AlwaysStoppedAnimation<Color>(widget.level.color),
            minHeight: 4,
          ),
          Expanded(
            child: Stack(
              children: [
                // Ornaments
                Positioned(
                  top: 20,
                  right: -20,
                  child: Opacity(
                    opacity: 0.1,
                    child: Icon(Icons.star_rounded, size: 100, color: widget.level.color),
                  ),
                ),
                Positioned(
                  bottom: 100,
                  left: -30,
                  child: Opacity(
                    opacity: 0.05,
                    child: Icon(Icons.nights_stay_rounded, size: 150, color: widget.level.color),
                  ),
                ),
                
                PageView.builder(
                  controller: _pageController,
                  itemCount: widget.level.pages.length,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                      _audioPlayer.stop();
                      _isPlaying = false;
                    });
                    _checkAudioAvailability();
                    _saveBookmark(index);
                  },
                  itemBuilder: (context, index) {
                    final page = widget.level.pages[index];
                    return SingleChildScrollView(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 20),
                          // Book-like Container
                          Container(
                            width: double.infinity,
                            constraints: const BoxConstraints(minHeight: 280),
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(AppRadius.xl),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.04),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                              border: Border.all(color: Colors.white, width: 4),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  page.arabic,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 64,
                                    fontWeight: FontWeight.w900,
                                    color: AppColors.textMain,
                                    height: 1.5,
                                  ),
                                ),
                                const SizedBox(height: 30),
                                Text(
                                  page.latin,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: widget.level.color.withOpacity(0.7),
                                    letterSpacing: 1.2,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 40),
                          
                          // Audio Button Section
                          Column(
                            children: [
                              AnimatedButton(
                                onTap: _isAudioAvailable ? _playAudio : () {},
                                child: Opacity(
                                  opacity: _isAudioAvailable ? 1.0 : 0.4,
                                  child: Container(
                                    width: 100,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      color: _isAudioAvailable ? widget.level.color : Colors.grey,
                                      shape: BoxShape.circle,
                                      boxShadow: _isAudioAvailable ? [
                                        BoxShadow(
                                          color: widget.level.color.withOpacity(0.3),
                                          blurRadius: 15,
                                          offset: const Offset(0, 8),
                                        ),
                                      ] : [],
                                    ),
                                    child: _isLoading
                                        ? const Padding(
                                            padding: EdgeInsets.all(28.0),
                                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 4),
                                          )
                                        : Icon(
                                            !_isAudioAvailable 
                                                ? Icons.volume_off_rounded 
                                                : (_isPlaying ? Icons.pause_rounded : Icons.volume_up_rounded),
                                            size: 50,
                                            color: Colors.white,
                                          ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                _isAudioAvailable ? 'Dengarkan' : 'Audio belum tersedia',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: _isAudioAvailable ? widget.level.color : Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          
          // Navigation Bar
          Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: SafeArea(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildNavButton(
                    icon: Icons.chevron_left_rounded,
                    onPressed: _currentPage > 0
                        ? () => _pageController.previousPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            )
                        : null,
                  ),
                  
                  // Mascot & Page Indicator
                  Row(
                    children: [
                      Image.asset('assets/images/mascot_muslim_boy.png', width: 40),
                      const SizedBox(width: 12),
                      Column(
                        children: [
                          Text(
                            'Halaman',
                            style: TextStyle(fontSize: 12, color: AppColors.textDim, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '${_currentPage + 1} / ${widget.level.pages.length}',
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: AppColors.textMain),
                          ),
                        ],
                      ),
                    ],
                  ),

                  _buildNavButton(
                    icon: Icons.chevron_right_rounded,
                    onPressed: _currentPage < widget.level.pages.length - 1
                        ? () => _pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            )
                        : null,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavButton({
    required IconData icon,
    VoidCallback? onPressed,
  }) {
    return AnimatedButton(
      onTap: onPressed ?? () {},
      child: Opacity(
        opacity: onPressed == null ? 0.3 : 1.0,
        child: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: widget.level.color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(icon, size: 32, color: widget.level.color),
        ),
      ),
    );
  }
}


