import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_constants.dart';
import '../widgets/menu_card.dart';
import '../widgets/islamic_decor.dart';
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
        backgroundColor: AppColors.background,
        body: Stack(
          children: [
            // Decorative Background Elements
            Positioned(
              top: -50,
              right: -50,
              child: Opacity(
                opacity: 0.1,
                child: Image.asset('assets/images/cute_decorations.png', width: 250),
              ),
            ),
            const FloatingStars(),
            
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: AppSpacing.xl),
                    // Kid-Friendly Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Assalamualaikum Adik! 😊',
                                style: TextStyle(
                                  fontSize: 22,
                                  color: AppColors.textDim,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: AppSpacing.xs),
                              const Text(
                                'Yuk Belajar Iqra!',
                                style: TextStyle(
                                  fontSize: 34,
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.primary,
                                  letterSpacing: -1,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Mascot Boy Floating Animation
                        TweenAnimationBuilder<double>(
                          duration: const Duration(seconds: 2),
                          tween: Tween(begin: 0, end: 1),
                          curve: Curves.easeInOut,
                          builder: (context, value, child) {
                            return Transform.translate(
                              offset: Offset(0, 10 * (1 - (value - 0.5).abs() * 2)),
                              child: child,
                            );
                          },
                          onEnd: () {}, // Handled by standard loop if needed, but for simple floating it's fine
                          child: Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.primary.withOpacity(0.1),
                              border: Border.all(color: Colors.white, width: 3),
                            ),
                            child: ClipOval(
                              child: Image.asset('assets/images/mascot_muslim_boy.png', fit: BoxFit.cover),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    // Playful Banner
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppColors.skyBlue, AppColors.primary],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(AppRadius.bubble),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.skyBlue.withOpacity(0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'MasyaAllah Hebat!',
                                  style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900),
                                ),
                                const Text(
                                  'Ayo semangat belajarnya!',
                                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ),
                          Image.asset('assets/images/mascot_muslim_girl.png', width: 70),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    const Text(
                      'Pilih Permainan',
                      style: TextStyle(
                        fontSize: 26, 
                        fontWeight: FontWeight.w900, 
                        color: AppColors.textMain,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Expanded(
                      child: GridView.count(
                        crossAxisCount: 2,
                        crossAxisSpacing: AppSpacing.lg,
                        mainAxisSpacing: AppSpacing.lg,
                        childAspectRatio: 0.85,
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.only(bottom: AppSpacing.xl),
                        children: [
                          _buildBubbleCard(
                            context,
                            title: 'Belajar\nHuruf',
                            icon: Icons.abc_rounded,
                            color: AppColors.accent,
                            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const BelajarHurufScreen())),
                          ),
                          _buildBubbleCard(
                            context,
                            title: 'Belajar\nIqra',
                            icon: Icons.auto_stories_rounded,
                            color: AppColors.skyBlue,
                            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const BelajarIqraScreen())),
                          ),
                          _buildBubbleCard(
                            context,
                            title: 'Kuis\nSeru',
                            icon: Icons.videogame_asset_rounded,
                            color: AppColors.softPink,
                            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const LatihanScreen())),
                          ),
                          _buildBubbleCard(
                            context,
                            title: 'Tentang\nE-Cro',
                            icon: Icons.stars_rounded,
                            color: AppColors.sunnyYellow,
                            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const TentangScreen())),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBubbleCard(BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return MenuCard(
      title: title,
      icon: icon,
      color: color,
      onTap: onTap,
    );
  }
}
