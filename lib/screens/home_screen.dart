import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_constants.dart';
import '../widgets/menu_card.dart';
import 'belajar_huruf_screen.dart';
import 'belajar_iqra_screen.dart';
import 'latihan_screen.dart';
import 'tentang_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final bool shouldPop = await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.lg)),
            title: const Text('Keluar Aplikasi?', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary)),
            content: const Text('Apakah kamu yakin ingin keluar dari E-Cro?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Batal', style: TextStyle(fontSize: 16, color: Colors.grey)),
              ),
              Container(
                margin: const EdgeInsets.only(right: 8, bottom: 8),
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.error,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
                  ),
                  child: const Text('Keluar', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ) ?? false;
        
        if (shouldPop) {
          SystemNavigator.pop();
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 1000),
            tween: Tween(begin: 0.0, end: 1.0),
            curve: Curves.easeOutQuart,
            builder: (context, value, child) {
              return Opacity(
                opacity: value,
                child: Transform.translate(
                  offset: Offset(0, 30 * (1 - value)),
                  child: child,
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: AppSpacing.xxl),
                  // Header dengan Greeting
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Text(
                                'Assalamu\'alaikum,',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: AppColors.textDim,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(width: AppSpacing.sm),
                              Icon(Icons.auto_awesome_rounded, size: 18, color: AppColors.accent),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          const Text(
                            'Adik Sholeh! 👋',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                              letterSpacing: -0.5,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.all(AppSpacing.sm + 4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: const [
                            BoxShadow(
                              color: AppColors.cardShadow,
                              blurRadius: 10,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Icon(Icons.person_rounded, color: AppColors.primaryLight, size: 30),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  // Banner Kecil / Subtitle
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(AppSpacing.md + 4),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.primaryLight, AppColors.primary],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.3),
                          blurRadius: 15,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.lightbulb_rounded, color: Colors.white, size: 40),
                        SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Ayo Belajar!',
                                style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'Membaca Iqra jadi lebih seru.',
                                style: TextStyle(color: Colors.white70, fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  const Text(
                    'Pilih Menu',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textMain),
                  ),
                  const SizedBox(height: AppSpacing.md + 4),
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: AppSpacing.lg,
                      mainAxisSpacing: AppSpacing.lg,
                      childAspectRatio: 0.9,
                      physics: const BouncingScrollPhysics(),
                      children: [
                        MenuCard(
                          title: 'Belajar Huruf',
                          subtitle: 'Kenali Hijaiyah',
                          icon: Icons.abc_rounded,
                          color: AppColors.accent,
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const BelajarHurufScreen())),
                        ),
                        MenuCard(
                          title: 'Belajar Iqra',
                          subtitle: 'Membaca Lancar',
                          icon: Icons.menu_book_rounded,
                          color: AppColors.info,
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const BelajarIqraScreen())),
                        ),
                        MenuCard(
                          title: 'Latihan',
                          subtitle: 'Asah Kemampuan',
                          icon: Icons.create_rounded,
                          color: AppColors.primaryLight,
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const LatihanScreen())),
                        ),
                        MenuCard(
                          title: 'Tentang',
                          subtitle: 'Info Aplikasi',
                          icon: Icons.favorite_rounded,
                          color: AppColors.error,
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const TentangScreen())),
                        ),
                      ],
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
