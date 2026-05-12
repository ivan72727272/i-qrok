import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
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
    
    if (_playingSurah != null) {
      await _audioPlayer.stop();
    }
    
    setState(() => _playingSurah = surahName);
    try {
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
            content: const Text('Audio belum tersedia 🕌'),
            backgroundColor: AppColors.primary,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFDFF),
      body: Stack(
        children: [
          _buildBackgroundDecor(),
          Column(
            children: [
              _buildHeader(context),
              Expanded(
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
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

  Widget _buildBackgroundDecor() {
    return Stack(
      children: [
        Positioned(top: -50, right: -50,
          child: Container(width: 250, height: 250,
            decoration: BoxDecoration(color: const Color(0xFFFFD93D).withOpacity(0.05), shape: BoxShape.circle))),
        Positioned(bottom: 100, left: -60,
          child: Container(width: 200, height: 200,
            decoration: BoxDecoration(color: const Color(0xFF4D96FF).withOpacity(0.04), shape: BoxShape.circle))),
        const FloatingStars(),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft, end: Alignment.bottomRight,
          colors: [Color(0xFF6BCB77), Color(0xFF4D96FF)],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(36),
          bottomRight: Radius.circular(36),
        ),
        boxShadow: [
          BoxShadow(color: const Color(0xFF4D96FF).withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 8)),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 24, 24),
          child: Row(
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 24),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('🌙 Juz Amma',
                      style: GoogleFonts.nunito(fontSize: 26, fontWeight: FontWeight.w900, color: Colors.white,
                        shadows: [const Shadow(color: Colors.black12, blurRadius: 4)])),
                    Text('Mari menghafal Surah-surah pendek ✨',
                      style: GoogleFonts.nunito(fontSize: 13, color: Colors.white.withOpacity(0.9), fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSurahCard(Map<String, dynamic> surah) {
    final color = surah['color'] as Color;
    final isPlaying = _playingSurah == surah['name'];
    final isFavorite = _favorites.contains(surah['name']);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: color.withOpacity(0.1), blurRadius: 15, offset: const Offset(0, 8)),
        ],
        border: Border.all(color: color.withOpacity(0.05), width: 1.5),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: () => _showSurahDetail(surah),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Surah Number
                Container(
                  width: 50, height: 50,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text('${surah['number']}',
                      style: GoogleFonts.nunito(fontSize: 18, fontWeight: FontWeight.w900, color: color)),
                  ),
                ),
                const SizedBox(width: 16),
                // Surah Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(surah['name'],
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.nunito(fontSize: 18, fontWeight: FontWeight.w800, color: const Color(0xFF2C3E50))),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () => _toggleFavorite(surah['name']),
                            child: Icon(
                              isFavorite ? Icons.star_rounded : Icons.star_border_rounded,
                              color: isFavorite ? const Color(0xFFFFCA28) : Colors.grey[300],
                              size: 18,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text('${surah['ayat']} Ayat',
                        style: GoogleFonts.nunito(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.blueGrey[300])),
                    ],
                  ),
                ),
                // Arabic Name
                Text(surah['arabic'],
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Color(0xFF2C3E50), fontFamily: 'Amiri')),
                const SizedBox(width: 12),
                // Play Button
                GestureDetector(
                  onTap: () => _playAudio(surah['audio'], surah['name']),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isPlaying ? color : color.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                      color: isPlaying ? Colors.white : color,
                      size: 24,
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
        initialChildSize: 0.9,
        maxChildSize: 0.95,
        minChildSize: 0.6,
        builder: (_, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Color(0xFFFBFDFF),
            borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
          ),
          child: Column(
            children: [
              // Top Bar
              Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                width: 50, height: 5,
                decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10)),
              ),
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(surah['name'],
                          style: GoogleFonts.nunito(fontSize: 24, fontWeight: FontWeight.w900, color: color)),
                        Text('Membaca Juz Amma ✨',
                          style: GoogleFonts.nunito(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.blueGrey[300])),
                      ],
                    ),
                    Text(surah['arabic'],
                      style: TextStyle(fontSize: 38, fontWeight: FontWeight.w900, color: color, fontFamily: 'Amiri')),
                  ],
                ),
              ),
              // Verses List
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: verses.length,
                  itemBuilder: (_, i) {
                    final verse = verses[i] as Map;
                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(color: color.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
                        ],
                        border: Border.all(color: color.withOpacity(0.1), width: 1.5),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Verse Number Badge
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: color.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text('Ayat ${i + 1}',
                                  style: GoogleFonts.nunito(fontSize: 11, fontWeight: FontWeight.w900, color: color)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          // Arabic Text (Premium Mushaf Style)
                          Text(
                            verse['arabic'],
                            textAlign: TextAlign.right,
                            textDirection: TextDirection.rtl,
                            style: const TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF2C3E50),
                              fontFamily: 'Amiri',
                              height: 2.2, // Spacing for Mushaf style
                              shadows: [Shadow(color: Colors.black12, blurRadius: 1, offset: Offset(0, 1))],
                            ),
                          ),
                          const SizedBox(height: 20),
                          // Latin
                          Text(
                            verse['latin'],
                            style: GoogleFonts.nunito(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: color,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                          const SizedBox(height: 8),
                          // Meaning
                          Text(
                            verse['arti'],
                            style: GoogleFonts.nunito(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.blueGrey[600],
                              height: 1.5,
                            ),
                          ),
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
