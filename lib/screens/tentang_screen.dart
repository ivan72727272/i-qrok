import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_constants.dart';
import '../widgets/islamic_decor.dart';

class TentangScreen extends StatefulWidget {
  const TentangScreen({super.key});

  @override
  State<TentangScreen> createState() => _TentangScreenState();
}

class _TentangScreenState extends State<TentangScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _entry;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(duration: const Duration(milliseconds: 800), vsync: this)
      ..forward();
    _entry = CurvedAnimation(parent: _ctrl, curve: Curves.easeOutBack);
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Background blobs
          Positioned(top: -50, right: -50,
            child: Container(width: 200, height: 200,
              decoration: BoxDecoration(color: AppColors.softPink.withOpacity(0.07), shape: BoxShape.circle))),
          Positioned(bottom: 80, left: -60,
            child: Container(width: 180, height: 180,
              decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.06), shape: BoxShape.circle))),
          const FloatingStars(),
          Column(
            children: [
              _buildHeader(context),
              Expanded(
                child: FadeTransition(
                  opacity: CurvedAnimation(parent: _ctrl, curve: Curves.easeOut),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(
                        AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, 40),
                    child: Column(
                      children: [
                        // Logo card
                        ScaleTransition(
                          scale: _entry,
                          child: _buildLogoCard(),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        // Features
                        _buildFeaturesCard(),
                        const SizedBox(height: AppSpacing.lg),
                        // Credit card
                        _buildCreditCard(),
                      ],
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
          colors: [Color(0xFFC77DFF), Color(0xFF4D96FF)],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(AppRadius.xl),
          bottomRight: Radius.circular(AppRadius.xl),
        ),
        boxShadow: [
          BoxShadow(color: Color(0x44C77DFF), blurRadius: 20, offset: Offset(0, 8)),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Positioned(top: -10, right: -10,
              child: Container(width: 80, height: 80,
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), shape: BoxShape.circle))),
            const Positioned(top: 10, right: 22,
              child: FloatingStarSingle(size: 16, color: Colors.white)),
            const Positioned(top: 34, right: 50,
              child: FloatingStarSingle(size: 11, color: Colors.white)),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                  AppSpacing.sm, AppSpacing.sm, AppSpacing.lg, AppSpacing.lg),
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
                        Text('💡  Tentang Aplikasi',
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900,
                            color: Colors.white,
                            shadows: [Shadow(color: Colors.black26, blurRadius: 4)])),
                        SizedBox(height: 2),
                        Text('Little Muslim — Belajar Islami Seru! 🌙',
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

  Widget _buildLogoCard() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        boxShadow: [
          BoxShadow(color: AppColors.softPink.withOpacity(0.15), blurRadius: 20, offset: const Offset(0, 8)),
        ],
        border: Border.all(color: AppColors.softPink.withOpacity(0.2), width: 1.5),
      ),
      child: Column(
        children: [
          // Logo circle
          Container(
            width: 120, height: 120,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF6BCB77), Color(0xFF4D96FF)],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(color: AppColors.primary.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 8)),
              ],
            ),
            child: Center(
              child: Image.asset('assets/images/logo.png',
                width: 70, height: 70,
                errorBuilder: (_, __, ___) => const Text('🕌', style: TextStyle(fontSize: 52))),
            ),
          ),
          const SizedBox(height: 20),
          // App name
          const Text('Little Muslim',
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900,
              color: AppColors.textMain, letterSpacing: -0.5)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFF6BCB77), Color(0xFF4D96FF)]),
              borderRadius: BorderRadius.circular(AppRadius.full),
            ),
            child: const Text('Versi 2.0.0',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: Colors.white)),
          ),
          const SizedBox(height: 20),
          const Text(
            'Aplikasi edukasi Islami interaktif yang dirancang khusus untuk membantu anak-anak belajar Al-Qur\'an dan ibadah harian dengan cara yang menyenangkan, mudah, dan sepenuhnya offline.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, height: 1.7, color: AppColors.textDim, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturesCard() {
    final features = [
      ('📖', 'Belajar Ngaji', 'Hijaiyah, Harakat & Iqra', AppColors.error),
      ('🤲', 'Doa Harian', 'Doa untuk kehidupan sehari-hari', AppColors.skyBlue),
      ('🕌', 'Praktik Islami', 'Panduan wudhu & sholat', AppColors.primary),
      ('📚', 'Cerita Islami', 'Kisah penuh hikmah & teladan', AppColors.softPink),
      ('🎮', 'Latihan Interaktif', 'Quiz & kuis yang seru', AppColors.accent),
      ('🌙', 'Juz Amma', 'Surah-surah pendek Al-Qur\'an', AppColors.sunnyYellow),
    ];

    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        boxShadow: [
          BoxShadow(color: AppColors.primary.withOpacity(0.1), blurRadius: 20, offset: const Offset(0, 8)),
        ],
        border: Border.all(color: AppColors.primary.withOpacity(0.15), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 4, height: 20,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(AppRadius.full),
                ),
              ),
              const SizedBox(width: 10),
              const Text('Fitur Lengkap 🌟',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900, color: AppColors.textMain)),
            ],
          ),
          const SizedBox(height: 16),
          ...features.map((f) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                Container(
                  width: 44, height: 44,
                  decoration: BoxDecoration(
                    color: f.$4.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  child: Center(child: Text(f.$1, style: const TextStyle(fontSize: 20))),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(f.$2,
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: f.$4)),
                      Text(f.$3,
                        style: const TextStyle(fontSize: 11, color: AppColors.textDim, fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
                Icon(Icons.check_circle_rounded, size: 18, color: f.$4.withOpacity(0.7)),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildCreditCard() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF6BCB77), Color(0xFF4D96FF)],
        ),
        borderRadius: BorderRadius.circular(AppRadius.xl),
        boxShadow: [
          BoxShadow(color: AppColors.skyBlue.withOpacity(0.3), blurRadius: 18, offset: const Offset(0, 8)),
        ],
      ),
      child: Stack(
        children: [
          Positioned(top: -15, right: -15,
            child: Container(width: 70, height: 70,
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), shape: BoxShape.circle))),
          Column(
            children: [
              const Text('❤️', style: TextStyle(fontSize: 36)),
              const SizedBox(height: 12),
              const Text(
                'Dikembangkan dengan cinta\nuntuk Generasi Qur\'ani',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white,
                  height: 1.5, shadows: [Shadow(color: Colors.black26, blurRadius: 4)]),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.25),
                  borderRadius: BorderRadius.circular(AppRadius.full),
                ),
                child: const Text('© 2026 Little Muslim Team',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
