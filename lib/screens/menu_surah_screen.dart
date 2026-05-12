import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';
import '../widgets/islamic_decor.dart';
import '../data/juz_amma_data.dart';

class MenuSurahScreen extends StatefulWidget {
  const MenuSurahScreen({super.key});

  @override
  State<MenuSurahScreen> createState() => _MenuSurahScreenState();
}

class _MenuSurahScreenState extends State<MenuSurahScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  String? _playingSurah;
  Set<String> _favorites = {};

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favList = prefs.getStringList('juz_amma_favorites') ?? [];
    setState(() {
      _favorites = favList.toSet();
    });
  }

  Future<void> _toggleFavorite(String surahName) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      if (_favorites.contains(surahName)) {
        _favorites.remove(surahName);
      } else {
        _favorites.add(surahName);
      }
    });
    await prefs.setStringList('juz_amma_favorites', _favorites.toList());
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _playAudio(String audioPath, String surahName) async {
    if (_playingSurah == surahName) {
      await _audioPlayer.stop();
      setState(() => _playingSurah = null);
      return;
    }
    
    // Stop any currently playing audio
    if (_playingSurah != null) {
      await _audioPlayer.stop();
    }
    
    setState(() => _playingSurah = surahName);
    try {
      await rootBundle.load('assets/$audioPath');
      await _audioPlayer.play(AssetSource(audioPath));
      _audioPlayer.onPlayerComplete.listen((_) {
        if (mounted && _playingSurah == surahName) {
          setState(() => _playingSurah = null);
        }
      });
    } catch (_) {
      if (mounted) {
        setState(() => _playingSurah = null);
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Background blobs
          Positioned(top: -50, right: -50,
            child: Container(width: 200, height: 200,
              decoration: BoxDecoration(color: AppColors.sunnyYellow.withOpacity(0.07), shape: BoxShape.circle))),
          Positioned(bottom: 100, left: -60,
            child: Container(width: 180, height: 180,
              decoration: BoxDecoration(color: AppColors.skyBlue.withOpacity(0.06), shape: BoxShape.circle))),
          const FloatingStars(),
          Column(
            children: [
              _buildHeader(context),
              Expanded(
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.md, AppSpacing.lg, 32),
                  itemCount: JuzAmmaData.surahs.length,
                  itemBuilder: (context, index) => _buildSurahCard(JuzAmmaData.surahs[index]),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFFD93D), Color(0xFFC77DFF)],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(AppRadius.xl),
          bottomRight: Radius.circular(AppRadius.xl),
        ),
        boxShadow: [BoxShadow(color: Color(0x44FFD93D), blurRadius: 20, offset: Offset(0, 8))],
      ),
      child: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Positioned(top: -10, right: -10,
              child: Container(width: 80, height: 80,
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), shape: BoxShape.circle))),
            const Positioned(top: 10, right: 22, child: FloatingStarSingle(size: 16, color: Colors.white)),
            const Positioned(top: 34, right: 50, child: FloatingStarSingle(size: 11, color: Colors.white)),
            Padding(
              padding: const EdgeInsets.fromLTRB(AppSpacing.sm, AppSpacing.sm, AppSpacing.lg, AppSpacing.lg),
              child: Row(
                children: [
                  Material(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                      onTap: () { HapticFeedback.lightImpact(); Navigator.pop(context); },
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
                        Text('🌙  Juz Amma',
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Colors.white,
                            shadows: [Shadow(color: Colors.black26, blurRadius: 4)])),
                        SizedBox(height: 2),
                        Text('Surah pilihan untuk belajar & hafalan ⭐',
                          style: TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSurahCard(Map<String, dynamic> surah) {
    final color = surah['color'] as Color;
    final isPlaying = _playingSurah == surah['name'];
    final isFavorite = _favorites.contains(surah['name']);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isPlaying ? color.withOpacity(0.06) : Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        boxShadow: [
          BoxShadow(
            color: isPlaying ? color.withOpacity(0.35) : color.withOpacity(0.13),
            blurRadius: isPlaying ? 20 : 12,
            spreadRadius: isPlaying ? 2 : 0,
            offset: const Offset(0, 5),
          )
        ],
        border: Border.all(
          color: isPlaying ? color.withOpacity(0.5) : color.withOpacity(0.12),
          width: isPlaying ? 2 : 1.5,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppRadius.xl),
          splashColor: color.withOpacity(0.2),
          highlightColor: color.withOpacity(0.1),
          onTap: () => _showSurahDetail(surah),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Row(
              children: [
                // Number badge with gradient
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [color.withOpacity(0.2), color.withOpacity(0.4)],
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [BoxShadow(color: color.withOpacity(0.2), blurRadius: 8, offset: const Offset(0, 3))],
                  ),
                  child: Center(
                    child: Text('${surah['number']}',
                      style: TextStyle(fontWeight: FontWeight.w900, color: color, fontSize: 18,
                        shadows: [Shadow(color: color.withOpacity(0.3), blurRadius: 4)])),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                // Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    surah['name'],
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.textMain),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                GestureDetector(
                                  onTap: () => _toggleFavorite(surah['name']),
                                  child: Icon(
                                    isFavorite ? Icons.star_rounded : Icons.star_border_rounded,
                                    color: isFavorite ? const Color(0xFFFFCA28) : AppColors.textDim.withOpacity(0.3),
                                    size: 20,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(surah['arabic'], style: TextStyle(fontSize: 24, color: color, fontWeight: FontWeight.w600, fontFamily: 'Amiri')),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Text('${surah['ayat']} ayat', style: const TextStyle(fontSize: 13, color: AppColors.textDim)),
                          if (isPlaying) ...[
                            const SizedBox(width: 12),
                            EqualizerAnimation(color: color, size: 14),
                            const SizedBox(width: 6),
                            Text('Memutar...', style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.w900)),
                          ]
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                // Play button with glow
                GestureDetector(
                  onTap: () => _playAudio(surah['audio'], surah['name']),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: isPlaying ? color : color.withOpacity(0.15),
                      shape: BoxShape.circle,
                      boxShadow: [
                        if (isPlaying) BoxShadow(color: color.withOpacity(0.4), blurRadius: 12, spreadRadius: 2),
                      ],
                    ),
                    child: Icon(
                      isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                      color: isPlaying ? Colors.white : color,
                      size: 28,
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

  void _showSurahDetail(Map<String, dynamic> surah) {
    final color = surah['color'] as Color;
    final verses = surah['verses'] as List;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.85,
        maxChildSize: 0.95,
        minChildSize: 0.5,
        builder: (_, scrollController) => Container(
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
            boxShadow: [BoxShadow(color: color.withOpacity(0.2), blurRadius: 24, offset: const Offset(0, -4))],
          ),
          child: Column(
            children: [
              // Handle
              Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)),
              ),
              // Header with gradient
              Container(
                margin: const EdgeInsets.fromLTRB(AppSpacing.lg, 0, AppSpacing.lg, AppSpacing.md),
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [color.withOpacity(0.15), color.withOpacity(0.05)],
                  ),
                  borderRadius: BorderRadius.circular(AppRadius.xl),
                  border: Border.all(color: color.withOpacity(0.2)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(surah['name'],
                            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: color)),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: color.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(AppRadius.full),
                            ),
                            child: Text('${surah['ayat']} Ayat',
                              style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w700)),
                          ),
                        ],
                      ),
                    ),
                    Text(surah['arabic'],
                      style: TextStyle(fontSize: 34, color: color, fontWeight: FontWeight.w600, fontFamily: 'Amiri')),
                  ],
                ),
              ),
              // Verses
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                  itemCount: verses.length,
                  itemBuilder: (_, i) {
                    final verse = verses[i] as Map;
                    return Container(
                      margin: const EdgeInsets.only(bottom: AppSpacing.md),
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(AppRadius.xl),
                        border: Border.all(color: color.withOpacity(0.15), width: 1.5),
                        boxShadow: [BoxShadow(color: color.withOpacity(0.08), blurRadius: 10, offset: const Offset(0, 4))],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(AppRadius.full)),
                                child: Text('${i + 1}', style: TextStyle(fontWeight: FontWeight.bold, color: color, fontSize: 12)),
                              ),
                              Flexible(
                                child: Text(
                                  verse['arabic'],
                                  textAlign: TextAlign.right,
                                  textDirection: TextDirection.rtl,
                                  style: TextStyle(fontSize: 26, color: color, fontFamily: 'Amiri', height: 1.8),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(verse['latin'], style: TextStyle(fontSize: 14, color: color, fontStyle: FontStyle.italic)),
                          const SizedBox(height: 6),
                          Text(verse['arti'], style: const TextStyle(fontSize: 13, color: AppColors.textDim, height: 1.4)),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
