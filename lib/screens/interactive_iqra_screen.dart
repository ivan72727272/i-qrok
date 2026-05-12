import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';
import '../data/iqra_data.dart';
import '../widgets/islamic_decor.dart';

class InteractiveIqraScreen extends StatefulWidget {
  final IqraLevel level;

  const InteractiveIqraScreen({super.key, required this.level});

  @override
  State<InteractiveIqraScreen> createState() => _InteractiveIqraScreenState();
}

class _InteractiveIqraScreenState extends State<InteractiveIqraScreen> with TickerProviderStateMixin {
  final AudioPlayer _audioPlayer = AudioPlayer();
  String? _playingChar;
  late AnimationController _entryCtrl;

  @override
  void initState() {
    super.initState();
    _entryCtrl = AnimationController(duration: const Duration(milliseconds: 600), vsync: this);
    _entryCtrl.forward();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _entryCtrl.dispose();
    super.dispose();
  }

  Future<void> _playSound(InteractiveLetter letter) async {
    if (_playingChar == letter.char) return;
    
    setState(() => _playingChar = letter.char);

    try {
      final prefs = await SharedPreferences.getInstance();
      final key = 'iqra${widget.level.level}_clicked_${letter.char}';
      if (!(prefs.getBool(key) ?? false)) await prefs.setBool(key, true);
      
      await _audioPlayer.stop();
      await _audioPlayer.play(AssetSource(letter.audioPath)).timeout(const Duration(seconds: 3));
    } catch (e) {
      debugPrint('Audio Error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(Icons.volume_off_rounded, color: Colors.white, size: 20),
              SizedBox(width: 8),
              Text('Audio belum tersedia', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
            ]),
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
      if (mounted) setState(() => _playingChar = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.level.level == 1) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: Stack(
          children: [
            const FloatingStars(),
            Column(
              children: [
                _buildHeader(context),
                Expanded(child: _buildGrid(IqraData.hijaiyahDasar)),
              ],
            ),
          ],
        ),
      );
    } else {
      return DefaultTabController(
        length: 3,
        child: Scaffold(
          backgroundColor: AppColors.background,
          body: Stack(
            children: [
              const FloatingStars(),
              Column(
                children: [
                  _buildHeader(context, hasTabs: true),
                  _buildTabBar(),
                  Expanded(
                    child: TabBarView(
                      children: [
                        _buildGrid(IqraData.getHarakatList('fathah')),
                        _buildGrid(IqraData.getHarakatList('kasrah')),
                        _buildGrid(IqraData.getHarakatList('dhammah')),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }
  }

  Widget _buildHeader(BuildContext context, {bool hasTabs = false}) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft, end: Alignment.bottomRight,
          colors: [widget.level.color, widget.level.color.withOpacity(0.7)],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(hasTabs ? 0 : AppRadius.xl),
          bottomRight: Radius.circular(hasTabs ? 0 : AppRadius.xl),
        ),
        boxShadow: [BoxShadow(color: widget.level.color.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 8))],
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(AppSpacing.sm, AppSpacing.sm, AppSpacing.lg, AppSpacing.lg),
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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('📖  ${widget.level.title}',
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.white,
                        shadows: [Shadow(color: Colors.black26, blurRadius: 4)])),
                    Text(widget.level.description,
                      style: const TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      decoration: BoxDecoration(
        color: widget.level.color.withOpacity(0.7),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(AppRadius.xl),
          bottomRight: Radius.circular(AppRadius.xl),
        ),
      ),
      child: const TabBar(
        indicatorColor: Colors.white,
        indicatorWeight: 4,
        indicatorSize: TabBarIndicatorSize.label,
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white70,
        labelStyle: TextStyle(fontWeight: FontWeight.w900, fontSize: 14),
        tabs: [
          Tab(text: 'Fathah (A)'),
          Tab(text: 'Kasrah (I)'),
          Tab(text: 'Dhammah (U)'),
        ],
      ),
    );
  }

  Widget _buildGrid(List<InteractiveLetter> letters) {
    return GridView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.82,
      ),
      itemCount: letters.length,
      itemBuilder: (context, index) {
        final letter = letters[index];
        final isPlaying = _playingChar == letter.char;

        return FadeTransition(
          opacity: CurvedAnimation(parent: _entryCtrl, curve: Interval(index * 0.02, 1.0, curve: Curves.easeIn)),
          child: ScaleTransition(
            scale: CurvedAnimation(parent: _entryCtrl, curve: Interval(index * 0.02, 1.0, curve: Curves.easeOutBack)),
            child: _buildLetterCard(letter, isPlaying),
          ),
        );
      },
    );
  }

  Widget _buildLetterCard(InteractiveLetter letter, bool isPlaying) {
    return AnimatedScale(
      scale: isPlaying ? 1.05 : 1.0,
      duration: const Duration(milliseconds: 200),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          color: isPlaying ? widget.level.color.withOpacity(0.15) : Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.xl),
          boxShadow: [
            BoxShadow(
              color: isPlaying ? widget.level.color.withOpacity(0.5) : widget.level.color.withOpacity(0.12),
              blurRadius: isPlaying ? 20 : 10,
              spreadRadius: isPlaying ? 2 : 0,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(
            color: isPlaying ? widget.level.color : Colors.white,
            width: 2.5,
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(AppRadius.xl),
            onTap: () {
              HapticFeedback.selectionClick();
              _playSound(letter);
              // Navigate to detail
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (_, __, ___) => DetailHurufScreen(
                    char: letter.char,
                    name: letter.name,
                    color: widget.level.color,
                  ),
                  transitionsBuilder: (_, anim, __, child) => FadeTransition(opacity: anim, child: child),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    letter.char,
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.w900,
                      fontFamily: 'Amiri',
                      color: isPlaying ? widget.level.color : AppColors.textMain,
                      height: 1.1,
                      shadows: [
                        if (isPlaying) Shadow(color: widget.level.color.withOpacity(0.3), blurRadius: 10),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: isPlaying ? widget.level.color.withOpacity(0.2) : widget.level.color.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(AppRadius.full),
                    ),
                    child: Text(
                      letter.name,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: isPlaying ? widget.level.color : widget.level.color.withOpacity(0.8),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Simple Detail Screen wrapper if not imported
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
                    BoxShadow(color: widget.color.withOpacity(0.2), blurRadius: 40, spreadRadius: 5),
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
        style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: widget.color, letterSpacing: 4),
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
                      gradient: LinearGradient(colors: [widget.color, widget.color.withOpacity(0.7)]),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.play_arrow_rounded, color: Colors.white, size: 32),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}

