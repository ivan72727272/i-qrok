import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';
import '../data/iqra_data.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/islamic_decor.dart';

class InteractiveIqraScreen extends StatefulWidget {
  final IqraLevel level;

  const InteractiveIqraScreen({super.key, required this.level});

  @override
  State<InteractiveIqraScreen> createState() => _InteractiveIqraScreenState();
}

class _InteractiveIqraScreenState extends State<InteractiveIqraScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  String? _playingChar;

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _playSound(InteractiveLetter letter) async {
    if (_playingChar == letter.char) return;
    
    setState(() {
      _playingChar = letter.char;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final key = 'iqra${widget.level.level}_clicked_${letter.char}';
      if (!(prefs.getBool(key) ?? false)) {
        await prefs.setBool(key, true);
      }
      
      // Validate file exists before playing
      await rootBundle.load('assets/${letter.audioPath}');
      await _audioPlayer.play(AssetSource(letter.audioPath)).timeout(const Duration(seconds: 3));
    } catch (e) {
      debugPrint('Audio Error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.volume_off_rounded, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                const Text('Audio belum tersedia', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
              ],
            ),
            backgroundColor: AppColors.textDim.withOpacity(0.8),
            duration: const Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            margin: const EdgeInsets.only(bottom: 24, left: 40, right: 40),
            elevation: 0,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _playingChar = null;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.level.level == 1) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: CustomAppBar(
          title: widget.level.title,
          subtitle: widget.level.description,
        ),
        body: Stack(
          children: [
            const FloatingStars(),
            _buildGrid(IqraData.hijaiyahDasar),
          ],
        ),
      );
    } else {
      return DefaultTabController(
        length: 3,
        child: Scaffold(
          backgroundColor: AppColors.background,
          appBar: CustomAppBar(
            title: widget.level.title,
            subtitle: widget.level.description,
            bottom: const TabBar(
              indicatorColor: AppColors.primary,
              labelColor: AppColors.primary,
              unselectedLabelColor: AppColors.textDim,
              labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              tabs: [
                Tab(text: 'Fathah (A)'),
                Tab(text: 'Kasrah (I)'),
                Tab(text: 'Dhammah (U)'),
              ],
            ),
          ),
          body: Stack(
            children: [
              const FloatingStars(),
              TabBarView(
                children: [
                  _buildGrid(IqraData.getHarakatList('fathah')),
                  _buildGrid(IqraData.getHarakatList('kasrah')),
                  _buildGrid(IqraData.getHarakatList('dhammah')),
                ],
              ),
            ],
          ),
        ),
      );
    }
  }

  Widget _buildGrid(List<InteractiveLetter> letters) {
    return GridView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(AppSpacing.lg),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.85,
      ),
      itemCount: letters.length,
      itemBuilder: (context, index) {
        final letter = letters[index];
        final isPlaying = _playingChar == letter.char;

        return TweenAnimationBuilder<double>(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutBack,
          tween: Tween(begin: 1.0, end: isPlaying ? 1.05 : 1.0),
          builder: (context, scale, child) {
            return Transform.scale(
              scale: scale,
              child: child,
            );
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            decoration: BoxDecoration(
              color: isPlaying ? const Color(0xFFE8F5E9) : Colors.white,
              borderRadius: BorderRadius.circular(AppRadius.lg),
              boxShadow: [
                BoxShadow(
                  color: isPlaying ? const Color(0xFF81C784).withOpacity(0.4) : widget.level.color.withOpacity(0.1),
                  blurRadius: isPlaying ? 15 : 8,
                  spreadRadius: isPlaying ? 2 : 0,
                  offset: const Offset(0, 4),
                ),
              ],
              border: Border.all(
                color: isPlaying ? const Color(0xFFA5D6A7) : Colors.transparent,
                width: 2,
              ),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(AppRadius.lg),
                splashColor: const Color(0xFF81C784).withOpacity(0.3),
                highlightColor: const Color(0xFF81C784).withOpacity(0.1),
                onTap: () => _playSound(letter),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          letter.char,
                          style: TextStyle(
                            fontSize: 42,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Amiri',
                            color: isPlaying ? const Color(0xFF2E7D32) : AppColors.textMain,
                            height: 1.2,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: isPlaying ? const Color(0xFFC8E6C9) : widget.level.color.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(AppRadius.bubble),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                isPlaying ? Icons.volume_up_rounded : Icons.volume_down_rounded,
                                size: 14,
                                color: isPlaying ? const Color(0xFF2E7D32) : widget.level.color,
                              ),
                              const SizedBox(width: 4),
                              Flexible(
                                child: Text(
                                  letter.name,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: isPlaying ? const Color(0xFF2E7D32) : widget.level.color,
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    if (isPlaying)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Icon(
                          Icons.graphic_eq_rounded,
                          size: 16,
                          color: const Color(0xFF4CAF50).withOpacity(0.7),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
