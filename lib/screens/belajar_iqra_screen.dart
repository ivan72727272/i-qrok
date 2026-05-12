import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_constants.dart';
import '../widgets/islamic_decor.dart';
import '../data/iqra_data.dart';
import 'interactive_iqra_screen.dart';

class BelajarIqraScreen extends StatefulWidget {
  const BelajarIqraScreen({super.key});

  @override
  State<BelajarIqraScreen> createState() => _BelajarIqraScreenState();
}

class _BelajarIqraScreenState extends State<BelajarIqraScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _entryCtrl;

  @override
  void initState() {
    super.initState();
    _entryCtrl = AnimationController(
        duration: const Duration(milliseconds: 800), vsync: this)
      ..forward();
  }

  @override
  void dispose() {
    _entryCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Soft background blobs
          Positioned(top: -50, right: -50,
            child: Container(width: 200, height: 200,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.07), shape: BoxShape.circle))),
          Positioned(bottom: 120, left: -60,
            child: Container(width: 180, height: 180,
              decoration: BoxDecoration(
                color: AppColors.skyBlue.withOpacity(0.06), shape: BoxShape.circle))),
          // Mosque silhouette
          Positioned(
            bottom: -20, right: -20,
            child: Opacity(
              opacity: 0.06,
              child: Icon(Icons.mosque_rounded, size: 200, color: AppColors.primary),
            ),
          ),
          const FloatingStars(),
          Column(
            children: [
              _buildHeader(context),
              Expanded(
                child: FadeTransition(
                  opacity: CurvedAnimation(parent: _entryCtrl, curve: Curves.easeOut),
                  child: GridView.builder(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(
                        AppSpacing.lg, AppSpacing.md, AppSpacing.lg, AppSpacing.xxl),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 14,
                      childAspectRatio: 0.88,
                    ),
                    itemCount: IqraData.levels.length,
                    itemBuilder: (context, index) => _IqraLevelCard(
                      level: IqraData.levels[index],
                      index: index,
                    ),
                  ),
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
          colors: [Color(0xFF6BCB77), Color(0xFF4D96FF)],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(AppRadius.xl),
          bottomRight: Radius.circular(AppRadius.xl),
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0x446BCB77),
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Positioned(top: -10, right: -10,
              child: Container(width: 80, height: 80,
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), shape: BoxShape.circle))),
            const Positioned(top: 10, right: 20,
              child: FloatingStarSingle(size: 16, color: Colors.white)),
            const Positioned(top: 35, right: 55,
              child: FloatingStarSingle(size: 11, color: Colors.white)),
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
                      child: const Padding(
                        padding: EdgeInsets.all(10),
                        child: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('📖  Level Iqra',
                          style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.w900, color: Colors.white,
                            shadows: [Shadow(color: Colors.black26, blurRadius: 4)],
                          )),
                        SizedBox(height: 2),
                        Text('Pilih level untuk mulai belajar 🌟',
                          style: TextStyle(
                            fontSize: 13, color: Colors.white,
                            fontWeight: FontWeight.w600,
                          )),
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
}

// ─── Individual level card ─────────────────────────────────────────────────────
class _IqraLevelCard extends StatefulWidget {
  final dynamic level;
  final int index;
  const _IqraLevelCard({required this.level, required this.index});

  @override
  State<_IqraLevelCard> createState() => _IqraLevelCardState();
}

class _IqraLevelCardState extends State<_IqraLevelCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;
  late Animation<double> _opacity;
  bool _pressed = false;

  // Pastel gradient palettes for each level
  static const List<List<Color>> _palettes = [
    [Color(0xFFC8E6C9), Color(0xFF6BCB77)],
    [Color(0xFFB3E5FC), Color(0xFF4D96FF)],
    [Color(0xFFFFE0B2), Color(0xFFFF9F45)],
    [Color(0xFFE1BEE7), Color(0xFFC77DFF)],
    [Color(0xFFFFCDD2), Color(0xFFEF5350)],
    [Color(0xFFFFF9C4), Color(0xFFFFD93D)],
  ];

  static const List<Color> _shadows = [
    Color(0xFF6BCB77), Color(0xFF4D96FF), Color(0xFFFF9F45),
    Color(0xFFC77DFF), Color(0xFFEF5350), Color(0xFFFFD93D),
  ];

  // Fun number emojis
  static const List<String> _numberEmoji = ['1️⃣', '2️⃣', '3️⃣', '4️⃣', '5️⃣', '6️⃣'];

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(duration: const Duration(milliseconds: 550), vsync: this);
    _scale = Tween<double>(begin: 0.7, end: 1.0)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutBack));
    _opacity = Tween<double>(begin: 0, end: 1)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeIn));
    Future.delayed(Duration(milliseconds: 80 + widget.index * 80), () {
      if (mounted) _ctrl.forward();
    });
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  void _onTap() {
    HapticFeedback.lightImpact();
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, anim, __) => InteractiveIqraScreen(level: widget.level),
        transitionsBuilder: (_, anim, __, child) => FadeTransition(
          opacity: anim,
          child: SlideTransition(
            position: Tween<Offset>(begin: const Offset(0, 0.06), end: Offset.zero).animate(anim),
            child: child,
          ),
        ),
        transitionDuration: const Duration(milliseconds: 350),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final idx = widget.index % _palettes.length;
    final colors = _palettes[idx];
    final shadow = _shadows[idx];
    final numEmoji = _numberEmoji[widget.index % _numberEmoji.length];

    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, child) => FadeTransition(
        opacity: _opacity,
        child: ScaleTransition(scale: _scale, child: child),
      ),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) { setState(() => _pressed = false); _onTap(); },
        onTapCancel: () => setState(() => _pressed = false),
        child: AnimatedScale(
          scale: _pressed ? 0.95 : 1.0,
          duration: const Duration(milliseconds: 120),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadius.xl),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: colors,
              ),
              boxShadow: [
                BoxShadow(
                  color: shadow.withOpacity(0.0),
                  blurRadius: 0,
                  offset: const Offset(0, 5),
                ),
                BoxShadow(
                  color: shadow.withOpacity(_pressed ? 0.35 : 0.22),
                  blurRadius: _pressed ? 20 : 12,
                  offset: const Offset(0, 6),
                ),
              ],
              border: Border.all(color: Colors.white.withOpacity(0.55), width: 2),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.xl),
              child: Stack(
                children: [
                  // Decorative bubble
                  Positioned(top: -20, right: -20,
                    child: Container(width: 70, height: 70,
                      decoration: BoxDecoration(color: Colors.white.withOpacity(0.18), shape: BoxShape.circle))),
                  Positioned(bottom: -10, left: -10,
                    child: Container(width: 50, height: 50,
                      decoration: BoxDecoration(color: Colors.white.withOpacity(0.12), shape: BoxShape.circle))),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Level badge
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(AppRadius.full),
                          ),
                          child: Text(
                            'Level $numEmoji',
                            style: const TextStyle(
                              fontSize: 10, fontWeight: FontWeight.w800, color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        // Big level number with glow
                        Center(
                          child: Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.25),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(color: shadow.withOpacity(0.2), blurRadius: 8),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                '${widget.level.level}',
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const Spacer(),
                        // Title & Desc
                        Text(
                          widget.level.title,
                          style: const TextStyle(
                            fontSize: 16, // Slightly smaller to be safe
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            shadows: [Shadow(color: Colors.black26, blurRadius: 4)],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          widget.level.description,
                          style: TextStyle(
                            fontSize: 10, // Slightly smaller to be safe
                            color: Colors.white.withOpacity(0.95),
                            fontWeight: FontWeight.w600,
                            height: 1.1,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(AppRadius.full),
                            border: Border.all(color: Colors.white.withOpacity(0.5)),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.play_circle_fill_rounded, size: 14, color: Colors.white),
                              SizedBox(width: 4),
                              Text('Mulai',
                                style: TextStyle(
                                  fontSize: 10, fontWeight: FontWeight.w800,
                                  color: Colors.white)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Mascot - Moved to Positioned to avoid overflow
                  Positioned(
                    bottom: 35,
                    right: 4,
                    child: IgnorePointer(
                      child: Opacity(
                        opacity: 0.8,
                        child: SizedBox(
                          height: 55,
                          child: Image.asset(
                            widget.index % 2 == 0 
                              ? 'assets/images/mascot_muslim_boy.png' 
                              : 'assets/images/mascot_muslim_girl.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
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
