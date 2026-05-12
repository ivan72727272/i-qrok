import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_constants.dart';
import '../widgets/animated_button.dart';
import '../widgets/islamic_decor.dart';
import '../services/theme_service.dart';
import 'belajar_iqra_screen.dart';
import 'menu_doa_screen.dart';
import 'menu_praktik_screen.dart';
import 'menu_cerita_screen.dart';
import 'menu_surah_screen.dart';
import 'latihan_screen.dart';
import 'progress_screen.dart';
import 'tentang_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _floatCtrl;
  late Animation<double> _floatAnim;
  late AnimationController _entryCtrl;
  late Animation<double> _entryAnim;

  @override
  void initState() {
    super.initState();
    _floatCtrl = AnimationController(duration: const Duration(seconds: 3), vsync: this)
      ..repeat(reverse: true);
    _floatAnim = Tween<double>(begin: 0, end: 12).animate(
      CurvedAnimation(parent: _floatCtrl, curve: Curves.easeInOutSine),
    );
    _entryCtrl = AnimationController(duration: const Duration(milliseconds: 900), vsync: this);
    _entryAnim = CurvedAnimation(parent: _entryCtrl, curve: Curves.easeOutBack);
    _entryCtrl.forward();
  }

  @override
  void dispose() {
    _floatCtrl.dispose();
    _entryCtrl.dispose();
    super.dispose();
  }

  void _toggleNightMode() {
    ThemeService().toggleNightMode();
    HapticFeedback.mediumImpact();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: ThemeService(),
      builder: (context, child) {
        final isNightMode = ThemeService().isNightMode;
        final bgColor = isNightMode ? AppColors.nightBackground : AppColors.background;
        final cardColor = isNightMode ? AppColors.nightCard : Colors.white;
        final textColor = isNightMode ? AppColors.nightText : AppColors.textMain;

        return WillPopScope(
          onWillPop: () async {
            final shouldExit = await showDialog<bool>(
              context: context,
              builder: (ctx) => AlertDialog(
                backgroundColor: cardColor,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.xl)),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 10),
                    const SizedBox(height: 100, child: MenuCharacter(type: 'latihan')),
                    const SizedBox(height: 20),
                    Text('Keluar? 🥺', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 22, color: textColor)),
                    const SizedBox(height: 12),
                    Text('Apakah kamu ingin keluar dari Little Muslim? Ayo belajar lagi nanti!', 
                      textAlign: TextAlign.center,
                      style: TextStyle(color: isNightMode ? Colors.white70 : AppColors.textDim, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: () => Navigator.pop(ctx, false), 
                            child: const Text('Nanti Saja', style: TextStyle(fontWeight: FontWeight.w900))),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => SystemNavigator.pop(),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.error, 
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.full)),
                            ),
                            child: const Text('Keluar', style: TextStyle(fontWeight: FontWeight.w900)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
            return shouldExit ?? false;
          },
          child: Scaffold(
            backgroundColor: bgColor,
            body: Stack(
              children: [
                Positioned(top: -60, left: -60,
                  child: _Blob(color: (isNightMode ? AppColors.nightPrimary : AppColors.skyBlue).withOpacity(0.08), size: 220)),
                Positioned(top: 250, right: -80,
                  child: _Blob(color: (isNightMode ? AppColors.nightAccent : AppColors.primary).withOpacity(0.07), size: 280)),
                Positioned(
                  bottom: -10, left: 0, right: 0,
                  child: Opacity(
                    opacity: isNightMode ? 0.08 : 0.04,
                    child: Icon(Icons.mosque_rounded, size: 160, color: isNightMode ? AppColors.nightPrimary : AppColors.primary),
                  ),
                ),
                FloatingStars(color: isNightMode ? Colors.white.withOpacity(0.4) : null),
                SafeArea(
                  child: FadeTransition(
                    opacity: _entryAnim,
                    child: CustomScrollView(
                      physics: const BouncingScrollPhysics(),
                      slivers: [
                        SliverToBoxAdapter(child: _buildHeader(isNightMode)),
                        SliverToBoxAdapter(child: _buildSectionTitle(cardColor, textColor, isNightMode)),
                        SliverPadding(
                          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
                          sliver: SliverGrid.count(
                            crossAxisCount: 2,
                            crossAxisSpacing: 14,
                            mainAxisSpacing: 14,
                            childAspectRatio: 0.78,
                            children: _buildMenuCards(context, cardColor, textColor, isNightMode),
                          ),
                        ),
                        SliverToBoxAdapter(child: const SizedBox(height: AppSpacing.lg)),
                        SliverToBoxAdapter(child: _buildBottomActions(context, cardColor, textColor)),
                        const SliverToBoxAdapter(child: SizedBox(height: 32)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(bool isNightMode) {
    return Container(
      margin: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, AppSpacing.sm),
      padding: const EdgeInsets.fromLTRB(AppSpacing.xl, AppSpacing.xl, AppSpacing.sm, AppSpacing.xl),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isNightMode 
            ? [const Color(0xFF3F51B5), const Color(0xFF1A1C2E)]
            : [const Color(0xFF6BCB77), const Color(0xFF4D96FF)],
        ),
        borderRadius: BorderRadius.circular(AppRadius.xl),
        boxShadow: [
          BoxShadow(
            color: (isNightMode ? Colors.black : AppColors.skyBlue).withOpacity(0.3),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(top: -10, right: 80, child: _SmallCircle(color: Colors.white.withOpacity(0.1), size: 60)),
          const Positioned(top: 6, right: 12, child: FloatingStarSingle(size: 18, color: Colors.white)),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(AppRadius.full),
                          ),
                          child: Text(
                            isNightMode ? '🌙 Selamat Malam!' : '☀️ Assalamualaikum!',
                            style: const TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.w700),
                          ),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: _toggleNightMode,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              isNightMode ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Little\nMuslim',
                      style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: -0.5,
                        height: 1.05,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: AnimatedBuilder(
                  animation: _floatAnim,
                  builder: (context, child) => Transform.translate(
                    offset: Offset(0, -_floatAnim.value),
                    child: child,
                  ),
                  child: const SizedBox(
                    height: 140,
                    child: MenuCharacter(type: 'ngaji'),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(Color cardColor, Color textColor, bool isNightMode) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, AppSpacing.xs),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildProgressCard(cardColor, textColor, isNightMode),
          const SizedBox(height: 24),
          Row(
            children: [
              Container(
                width: 5, height: 24,
                decoration: BoxDecoration(
                  color: isNightMode ? AppColors.nightPrimary : AppColors.primary,
                  borderRadius: BorderRadius.circular(AppRadius.full),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                'Mau Belajar Apa Hari Ini? 🤔',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: textColor),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProgressCard(Color cardColor, Color textColor, bool isNightMode) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isNightMode ? 0.2 : 0.04),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Belajar Hari Ini 📖',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: textColor),
                  ),
                  Text(
                    'Selesaikan 2 materi lagi!',
                    style: TextStyle(fontSize: 11, color: isNightMode ? Colors.white60 : AppColors.textDim, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: isNightMode ? const Color(0xFF3F51B5).withOpacity(0.3) : const Color(0xFFFFF1F1),
                  borderRadius: BorderRadius.circular(AppRadius.full),
                ),
                child: Row(
                  children: [
                    Text('🔥 3 Hari', 
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, 
                        color: isNightMode ? const Color(0xFFB39DDB) : const Color(0xFFFF5252))),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Stack(
            children: [
              Container(
                height: 14,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: isNightMode ? Colors.white.withOpacity(0.05) : const Color(0xFFF0F4F8),
                  borderRadius: BorderRadius.circular(AppRadius.full),
                ),
              ),
              FractionallySizedBox(
                widthFactor: 0.6,
                child: Container(
                  height: 14,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: isNightMode 
                        ? [const Color(0xFF7B61FF), const Color(0xFFC77DFF)]
                        : [const Color(0xFF6BCB77), const Color(0xFFB2FF59)]
                    ),
                    borderRadius: BorderRadius.circular(AppRadius.full),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<Widget> _buildMenuCards(BuildContext context, Color cardColor, Color textColor, bool isNightMode) {
    final menus = [
      _MenuData(
        characterType: 'ngaji',
        title: 'Belajar\nNgaji',
        subtitle: 'Hijaiyah & Harakat',
        emoji: '📖',
        gradColors: const [Color(0xFFFF8A80), Color(0xFFEF5350)],
        shadowColor: const Color(0xFFEF5350),
        onTap: () => Navigator.push(context, _route(const BelajarIqraScreen())),
      ),
      _MenuData(
        characterType: 'doa',
        title: 'Doa\nHarian',
        subtitle: 'Doa sehari-hari',
        emoji: '🤲',
        gradColors: const [Color(0xFF81D4FA), Color(0xFF4D96FF)],
        shadowColor: const Color(0xFF4D96FF),
        onTap: () => Navigator.push(context, _route(const MenuDoaScreen())),
      ),
      _MenuData(
        characterType: 'praktik',
        title: 'Praktik\nIslami',
        subtitle: 'Wudhu & Sholat',
        emoji: '🕌',
        gradColors: const [Color(0xFFA5D6A7), Color(0xFF6BCB77)],
        shadowColor: const Color(0xFF6BCB77),
        onTap: () => Navigator.push(context, _route(const MenuPraktikScreen())),
      ),
      _MenuData(
        characterType: 'cerita',
        title: 'Cerita\nIslami',
        subtitle: 'Kisah penuh hikmah',
        emoji: '📚',
        gradColors: const [Color(0xFFE1BEE7), Color(0xFFC77DFF)],
        shadowColor: const Color(0xFFC77DFF),
        onTap: () => Navigator.push(context, _route(const MenuCeritaScreen())),
      ),
      _MenuData(
        characterType: 'latihan',
        title: 'Latihan\nInteraktif',
        subtitle: 'Kuis & Tantangan',
        emoji: '🎮',
        gradColors: const [Color(0xFFFFD93D), Color(0xFFFF9F45)],
        shadowColor: const Color(0xFFFF9F45),
        onTap: () => Navigator.push(context, _route(const LatihanScreen())),
      ),
      _MenuData(
        characterType: 'surah',
        title: 'Juz\nAmma',
        subtitle: 'Al-Fatihah & Juz 30',
        emoji: '🌙',
        gradColors: const [Color(0xFFE1BEE7), Color(0xFF4D96FF)],
        shadowColor: const Color(0xFF4D96FF),
        onTap: () => Navigator.push(context, _route(const MenuSurahScreen())),
      ),
    ];

    return menus.asMap().entries.map((e) {
      final delay = e.key * 80;
      return _AnimatedMenuCard(menu: e.value, delayMs: delay, cardColor: cardColor, textColor: textColor, isNightMode: isNightMode);
    }).toList();
  }

  PageRouteBuilder _route(Widget screen) => PageRouteBuilder(
        pageBuilder: (_, anim, __) => screen,
        transitionsBuilder: (_, anim, __, child) => FadeTransition(
          opacity: anim,
          child: SlideTransition(
            position: Tween<Offset>(begin: const Offset(0, 0.05), end: Offset.zero).animate(anim),
            child: child,
          ),
        ),
        transitionDuration: const Duration(milliseconds: 350),
      );

  Widget _buildBottomActions(BuildContext context, Color cardColor, Color textColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Row(
        children: [
          Expanded(child: _buildSmallAction(context,
            icon: Icons.star_rounded, label: 'Progress',
            color: AppColors.sunnyYellow, emoji: '⭐',
            cardColor: cardColor, textColor: textColor,
            onTap: () => Navigator.push(context, _route(const ProgressScreen())),
          )),
          const SizedBox(width: AppSpacing.md),
          Expanded(child: _buildSmallAction(context,
            icon: Icons.info_outline_rounded, label: 'Tentang',
            color: AppColors.softPink, emoji: '💡',
            cardColor: cardColor, textColor: textColor,
            onTap: () => Navigator.push(context, _route(const TentangScreen())),
          )),
        ],
      ),
    );
  }

  Widget _buildSmallAction(BuildContext context, {
    required IconData icon, required String label,
    required Color color, required String emoji, required VoidCallback onTap,
    required Color cardColor, required Color textColor}) {
    return AnimatedButton(
      onTap: () { HapticFeedback.lightImpact(); onTap(); },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(AppRadius.xl),
          border: Border.all(color: color.withOpacity(0.3), width: 1.5),
          boxShadow: [
            BoxShadow(color: color.withOpacity(0.15), blurRadius: 16, offset: const Offset(0, 6)),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 20)),
            const SizedBox(width: 8),
            Text(label, style: TextStyle(fontWeight: FontWeight.w800, color: textColor, fontSize: 15)),
          ],
        ),
      ),
    );
  }
}

class _AnimatedMenuCard extends StatefulWidget {
  final _MenuData menu;
  final int delayMs;
  final Color cardColor;
  final Color textColor;
  final bool isNightMode;
  const _AnimatedMenuCard({required this.menu, required this.delayMs, required this.cardColor, required this.textColor, required this.isNightMode});

  @override
  State<_AnimatedMenuCard> createState() => _AnimatedMenuCardState();
}

class _AnimatedMenuCardState extends State<_AnimatedMenuCard> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;
  late Animation<Offset> _slide;
  late Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(duration: const Duration(milliseconds: 600), vsync: this);
    _scale = Tween<double>(begin: 0.7, end: 1.0).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutBack));
    _slide = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
    _opacity = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeIn));
    Future.delayed(Duration(milliseconds: widget.delayMs), () {
      if (mounted) _ctrl.forward();
    });
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, child) => FadeTransition(
        opacity: _opacity,
        child: SlideTransition(
          position: _slide,
          child: ScaleTransition(scale: _scale, child: child),
        ),
      ),
      child: _MenuCardContent(menu: widget.menu, cardColor: widget.cardColor, textColor: widget.textColor, isNightMode: widget.isNightMode),
    );
  }
}

class _MenuCardContent extends StatelessWidget {
  final _MenuData menu;
  final Color cardColor;
  final Color textColor;
  final bool isNightMode;
  const _MenuCardContent({required this.menu, required this.cardColor, required this.textColor, required this.isNightMode});

  @override
  Widget build(BuildContext context) {
    return AnimatedButton(
      onTap: () { HapticFeedback.lightImpact(); menu.onTap(); },
      child: Container(
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(AppRadius.xl),
          boxShadow: [
            BoxShadow(
              color: menu.shadowColor.withOpacity(isNightMode ? 0.15 : 0.12),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(top: -10, right: -10,
              child: Opacity(opacity: 0.05, child: Text(menu.emoji, style: const TextStyle(fontSize: 80)))),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Center(
                      child: MenuCharacter(type: menu.characterType),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(menu.title,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: textColor, height: 1.1)),
                  const SizedBox(height: 4),
                  Text(menu.subtitle,
                    style: TextStyle(fontSize: 11, color: isNightMode ? Colors.white60 : AppColors.textDim, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuData {
  final String characterType;
  final String title;
  final String subtitle;
  final String emoji;
  final List<Color> gradColors;
  final Color shadowColor;
  final VoidCallback onTap;

  const _MenuData({
    required this.characterType,
    required this.title,
    required this.subtitle,
    required this.emoji,
    required this.gradColors,
    required this.shadowColor,
    required this.onTap,
  });
}

class _Blob extends StatelessWidget {
  final Color color;
  final double size;
  const _Blob({required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

class _SmallCircle extends StatelessWidget {
  final Color color;
  final double size;
  const _SmallCircle({required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}
