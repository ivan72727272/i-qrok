import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_constants.dart';
import '../widgets/animated_button.dart';
import '../widgets/islamic_decor.dart';
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

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _floatAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);
    _floatAnim = Tween<double>(begin: 0, end: 12).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOutSine),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final shouldExit = await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.xl)),
            title: const Text('Keluar?', style: TextStyle(fontWeight: FontWeight.bold)),
            content: const Text('Apakah kamu ingin keluar dari Little Muslim?'),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Tidak', style: TextStyle(fontWeight: FontWeight.bold))),
              ElevatedButton(
                onPressed: () => SystemNavigator.pop(),
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.error, foregroundColor: Colors.white),
                child: const Text('Ya, Keluar'),
              ),
            ],
          ),
        );
        return shouldExit ?? false;
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Stack(
          children: [
            // Background Dekorasi
            Positioned(top: -50, left: -50, child: Opacity(opacity: 0.05, child: Icon(Icons.cloud_rounded, size: 200, color: AppColors.primary))),
            Positioned(top: 250, right: -80, child: Opacity(opacity: 0.05, child: Icon(Icons.cloud_rounded, size: 300, color: AppColors.skyBlue))),
            Positioned(bottom: 100, left: -30, child: Opacity(opacity: 0.05, child: Icon(Icons.cloud_rounded, size: 150, color: AppColors.accent))),
            const FloatingStars(),
            
            SafeArea(
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  // ── Header ────────────────────────────────────────────────────
                  SliverToBoxAdapter(child: _buildHeader()),
                  
                  // ── Title "Mau Belajar Apa Hari Ini?" ────────────────────────
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: AppSpacing.xl, vertical: AppSpacing.sm),
                      child: Text(
                        'Mau Belajar Apa Hari Ini? 🤔',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          color: AppColors.textMain,
                        ),
                      ),
                    ),
                  ),

                  // ── Grid Menus ────────────────────────────────────────────────
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
                    sliver: SliverGrid.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.85,
                      children: _buildMenuCards(context),
                    ),
                  ),
                  
                  // ── Bottom Actions ─────────────────────────────────────────────
                  SliverToBoxAdapter(child: const SizedBox(height: AppSpacing.lg)),
                  SliverToBoxAdapter(child: _buildBottomActions(context)),
                  const SliverToBoxAdapter(child: SizedBox(height: 32)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      margin: const EdgeInsets.all(AppSpacing.lg),
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF81D4FA), AppColors.skyBlue],
        ),
        borderRadius: BorderRadius.circular(AppRadius.xl),
        boxShadow: [
          BoxShadow(
            color: AppColors.skyBlue.withOpacity(0.4),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Decorative stars
          const Positioned(top: 8, right: 8, child: FloatingStarSingle(size: 20, color: Colors.white)),
          const Positioned(top: 40, right: 50, child: FloatingStarSingle(size: 14, color: Colors.white)),
          const Positioned(bottom: 12, left: 50, child: FloatingStarSingle(size: 16, color: Colors.white)),
          
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Text
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Assalamualaikum! 👋',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Little Muslim',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: -0.5,
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.25),
                        borderRadius: BorderRadius.circular(AppRadius.full),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 14),
                          SizedBox(width: 4),
                          Text(
                            'Belajar Islami Setiap Hari',
                            style: TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Mascot Character
              Expanded(
                flex: 2,
                child: AnimatedBuilder(
                  animation: _floatAnim,
                  builder: (context, child) => Transform.translate(
                    offset: Offset(0, -_floatAnim.value),
                    child: child,
                  ),
                  child: Image.asset(
                    'assets/images/characters/boy.png',
                    fit: BoxFit.contain,
                    height: 120,
                    errorBuilder: (_, __, ___) => const Icon(Icons.sentiment_very_satisfied_rounded, size: 80, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<Widget> _buildMenuCards(BuildContext context) {
    final menus = [
      _MenuData(
        icon: '📖',
        title: 'Belajar\nNgaji',
        subtitle: 'Hijaiyah & Harakat',
        color: AppColors.error,
        gradColors: const [Color(0xFFFF8A80), Color(0xFFEF5350)],
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const BelajarIqraScreen())),
      ),
      _MenuData(
        icon: '🤲',
        title: 'Doa\nHarian',
        subtitle: 'Doa sehari-hari',
        color: AppColors.skyBlue,
        gradColors: const [Color(0xFF81D4FA), Color(0xFF4D96FF)],
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MenuDoaScreen())),
      ),
      _MenuData(
        icon: '🕌',
        title: 'Praktik\nIslami',
        subtitle: 'Wudhu & Sholat',
        color: AppColors.primary,
        gradColors: const [Color(0xFFA5D6A7), Color(0xFF6BCB77)],
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MenuPraktikScreen())),
      ),
      _MenuData(
        icon: '📚',
        title: 'Cerita\nIslami',
        subtitle: 'Kisah penuh hikmah',
        color: AppColors.softPink,
        gradColors: const [Color(0xFFE1BEE7), Color(0xFFC77DFF)],
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MenuCeritaScreen())),
      ),
      _MenuData(
        icon: '🎮',
        title: 'Latihan\nInteraktif',
        subtitle: 'Quiz & kuis seru',
        color: AppColors.accent,
        gradColors: const [Color(0xFFFFCC80), Color(0xFFFF9F45)],
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LatihanScreen())),
      ),
      _MenuData(
        icon: '🌙',
        title: 'Juz\nAmma',
        subtitle: 'Al-Fatihah & lainnya',
        color: AppColors.sunnyYellow,
        gradColors: const [Color(0xFFFFF59D), Color(0xFFFFD93D)],
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MenuSurahScreen())),
      ),
    ];

    return menus.map((m) => _buildMenuCard(m)).toList();
  }

  Widget _buildMenuCard(_MenuData menu) {
    return AnimatedButton(
      onTap: () {
        HapticFeedback.lightImpact();
        menu.onTap();
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.xl),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: menu.gradColors,
          ),
          boxShadow: [
            BoxShadow(
              color: menu.color.withOpacity(0.4),
              blurRadius: 0,
              offset: const Offset(0, 6), // Solid 3D bottom border effect
            ),
          ],
          border: Border.all(
            color: Colors.white.withOpacity(0.3),
            width: 2,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                ),
                child: Text(menu.icon, style: const TextStyle(fontSize: 32)),
              ),
              const Spacer(),
              Text(
                menu.title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  height: 1.1,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                menu.subtitle,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.white.withOpacity(0.9),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomActions(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Row(
        children: [
          Expanded(
            child: _buildSmallAction(
              context,
              icon: Icons.star_rounded,
              label: 'Progress',
              color: AppColors.sunnyYellow,
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProgressScreen())),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: _buildSmallAction(
              context,
              icon: Icons.face_retouching_natural_rounded,
              label: 'Tentang',
              color: AppColors.softPink,
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TentangScreen())),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSmallAction(BuildContext context, {required IconData icon, required String label, required Color color, required VoidCallback onTap}) {
    return AnimatedButton(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.xl),
          boxShadow: [
            BoxShadow(color: AppColors.cardShadow, blurRadius: 16, offset: const Offset(0, 8)),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 8),
            Text(label, style: TextStyle(fontWeight: FontWeight.w800, color: AppColors.textMain, fontSize: 16)),
          ],
        ),
      ),
    );
  }
}

class _MenuData {
  final String icon;
  final String title;
  final String subtitle;
  final Color color;
  final List<Color> gradColors;
  final VoidCallback onTap;

  const _MenuData({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.gradColors,
    required this.onTap,
  });
}
