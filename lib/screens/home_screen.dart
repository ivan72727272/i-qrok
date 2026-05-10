import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_constants.dart';
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
    _floatAnim = Tween<double>(begin: 0, end: 8).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
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
            content: const Text('Apakah kamu ingin keluar dari Muslim Kids?'),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Tidak')),
              ElevatedButton(
                onPressed: () => SystemNavigator.pop(),
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
                child: const Text('Ya, Keluar'),
              ),
            ],
          ),
        );
        return shouldExit ?? false;
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // ── Header ────────────────────────────────────────────────────
              SliverToBoxAdapter(child: _buildHeader()),
              // ── Grid Menus ────────────────────────────────────────────────
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
                sliver: SliverGrid.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                  childAspectRatio: 0.9,
                  children: _buildMenuCards(context),
                ),
              ),
              // ── Bottom Actions ─────────────────────────────────────────────
              SliverToBoxAdapter(child: _buildBottomActions(context)),
              const SliverToBoxAdapter(child: SizedBox(height: 24)),
            ],
          ),
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
          colors: [AppColors.primary, Color(0xFF43A047)],
        ),
        borderRadius: BorderRadius.circular(AppRadius.xl),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.35),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Decorative stars
          const Positioned(top: 8, right: 8, child: FloatingStarSingle(size: 16, color: Colors.white)),
          const Positioned(top: 40, right: 40, child: FloatingStarSingle(size: 10, color: Colors.white)),
          const Positioned(bottom: 12, left: 50, child: FloatingStarSingle(size: 12, color: Colors.white)),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Text
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Assalamualaikum! 😊',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Muslim Kids',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(AppRadius.full),
                      ),
                      child: const Text(
                        '🌙 Belajar Islami Setiap Hari',
                        style: TextStyle(fontSize: 11, color: Colors.white, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
              // Mascot
              AnimatedBuilder(
                animation: _floatAnim,
                builder: (context, child) => Transform.translate(
                  offset: Offset(0, -_floatAnim.value),
                  child: child,
                ),
                child: Image.asset(
                  'assets/images/mascot_muslim_boy.png',
                  width: 90,
                  height: 90,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => const SizedBox(width: 90, height: 90),
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
        color: const Color(0xFFEF5350),
        gradColors: const [Color(0xFFEF5350), Color(0xFFE53935)],
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const BelajarIqraScreen())),
      ),
      _MenuData(
        icon: '🤲',
        title: 'Doa\nHarian',
        subtitle: 'Doa sehari-hari',
        color: const Color(0xFF42A5F5),
        gradColors: const [Color(0xFF42A5F5), Color(0xFF1E88E5)],
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MenuDoaScreen())),
      ),
      _MenuData(
        icon: '🕌',
        title: 'Praktik\nIslami',
        subtitle: 'Wudhu & Sholat',
        color: const Color(0xFF66BB6A),
        gradColors: const [Color(0xFF66BB6A), Color(0xFF43A047)],
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MenuPraktikScreen())),
      ),
      _MenuData(
        icon: '📚',
        title: 'Cerita\nIslami',
        subtitle: 'Kisah penuh hikmah',
        color: const Color(0xFFAB47BC),
        gradColors: const [Color(0xFFAB47BC), Color(0xFF8E24AA)],
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MenuCeritaScreen())),
      ),
      _MenuData(
        icon: '🎮',
        title: 'Latihan\nInteraktif',
        subtitle: 'Quiz & kuis seru',
        color: const Color(0xFFFFA726),
        gradColors: const [Color(0xFFFFA726), Color(0xFFFB8C00)],
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LatihanScreen())),
      ),
      _MenuData(
        icon: '🌙',
        title: 'Surah\nPendek',
        subtitle: 'Al-Fatihah & lainnya',
        color: const Color(0xFF26C6DA),
        gradColors: const [Color(0xFF26C6DA), Color(0xFF00ACC1)],
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MenuSurahScreen())),
      ),
    ];

    return menus.map((m) => _buildMenuCard(m)).toList();
  }

  Widget _buildMenuCard(_MenuData menu) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: menu.onTap,
        borderRadius: BorderRadius.circular(AppRadius.xl),
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
                color: menu.color.withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(menu.icon, style: const TextStyle(fontSize: 36)),
                const Spacer(),
                Text(
                  menu.title,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  menu.subtitle,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.white.withOpacity(0.8),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
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
              icon: Icons.bar_chart_rounded,
              label: 'Progress',
              color: AppColors.info,
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProgressScreen())),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: _buildSmallAction(
              context,
              icon: Icons.info_rounded,
              label: 'Tentang',
              color: AppColors.textDim,
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TentangScreen())),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSmallAction(BuildContext context, {required IconData icon, required String label, required Color color, required VoidCallback onTap}) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.lg),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 3))],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Text(label, style: TextStyle(fontWeight: FontWeight.bold, color: color, fontSize: 14)),
            ],
          ),
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
