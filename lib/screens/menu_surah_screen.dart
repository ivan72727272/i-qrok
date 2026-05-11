import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';
import '../widgets/custom_app_bar.dart';
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
      appBar: const CustomAppBar(
        title: 'Juz Amma',
        subtitle: 'Kumpulan surah pilihan untuk belajar dan hafalan anak.',
      ),
      body: Stack(
        children: [
          const FloatingStars(),
          ListView.builder(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(AppSpacing.lg),
            itemCount: JuzAmmaData.surahs.length,
            itemBuilder: (context, index) => _buildSurahCard(JuzAmmaData.surahs[index]),
          ),
        ],
      ),
    );
  }

  Widget _buildSurahCard(Map<String, dynamic> surah) {
    final color = surah['color'] as Color;
    final isPlaying = _playingSurah == surah['name'];
    final isFavorite = _favorites.contains(surah['name']);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      decoration: BoxDecoration(
        color: isPlaying ? color.withOpacity(0.05) : Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        boxShadow: [
          BoxShadow(
            color: isPlaying ? color.withOpacity(0.3) : color.withOpacity(0.12),
            blurRadius: isPlaying ? 16 : 12,
            spreadRadius: isPlaying ? 2 : 0,
            offset: const Offset(0, 4),
          )
        ],
        border: Border.all(
          color: isPlaying ? color.withOpacity(0.5) : Colors.transparent,
          width: 2,
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
                // Number badge
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(color: color.withOpacity(0.15), shape: BoxShape.circle),
                  child: Center(
                    child: Text('${surah['number']}', style: TextStyle(fontWeight: FontWeight.w900, color: color, fontSize: 18)),
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
                            const SizedBox(width: 8),
                            Icon(Icons.graphic_eq_rounded, size: 14, color: color),
                            const SizedBox(width: 4),
                            Text('Memutar...', style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.bold)),
                          ]
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                // Play button
                GestureDetector(
                  onTap: () => _playAudio(surah['audio'], surah['name']),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      color: isPlaying ? color : color.withOpacity(0.15),
                      shape: BoxShape.circle,
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
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
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
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(surah['name'], style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: AppColors.textMain)),
                        Text('${surah['ayat']} Ayat', style: const TextStyle(color: AppColors.textDim, fontSize: 14)),
                      ],
                    ),
                    Text(surah['arabic'], style: TextStyle(fontSize: 32, color: color, fontWeight: FontWeight.w600, fontFamily: 'Amiri')),
                  ],
                ),
              ),
              const Divider(height: 24),
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
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.04),
                        borderRadius: BorderRadius.circular(AppRadius.lg),
                        border: Border.all(color: color.withOpacity(0.1)),
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
