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
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.bubble)),
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
            // Background Mosque Illustration
            Positioned(
              bottom: -20,
              right: -30,
              child: Opacity(
                opacity: 0.15,
                child: Image.asset('assets/images/cute_mosque.png', width: 350),
              ),
            ),
            
            // Decorative Clouds
            Positioned(
              top: 40,
              left: -50,
              child: Opacity(
                opacity: 0.1,
                child: Image.asset('assets/images/cute_decorations.png', width: 250),
              ),
            ),

            const FloatingStars(),
            
            SafeArea(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: AppSpacing.xl),
                    // Cartoon Islamic Greeting Card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(AppRadius.bubble),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.1),
                            blurRadius: 30,
                            offset: const Offset(0, 15),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          // Mascot Girl (Greeting)
                          TweenAnimationBuilder<double>(
                            duration: const Duration(seconds: 2),
                            tween: Tween(begin: 0, end: 1),
                            curve: Curves.easeInOut,
                            builder: (context, value, child) {
                              return Transform.translate(
                                offset: Offset(0, 8 * (1 - (value - 0.5).abs() * 2)),
                                child: child,
                              );
                            },
                            child: Image.asset('assets/images/mascot_muslim_girl.png', width: 80),
                          ),
                          const SizedBox(width: AppSpacing.md),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Assalamualaikum Adik!',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: AppColors.textDim,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: AppSpacing.xs),
                                Text(
                                  'Mari belajar iqra bersama 😊',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w900,
                                    color: AppColors.primary,
                                    height: 1.1,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxl),
                    
                    // Main Mascot Display
                    Center(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Circle Background
                          Container(
                            width: 160,
                            height: 160,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary.withOpacity(0.2),
                                  blurRadius: 40,
                                  spreadRadius: 5,
                                ),
                              ],
                            ),
                          ),
                          // Floating Boy Mascot
                          TweenAnimationBuilder<double>(
                            duration: const Duration(seconds: 3),
                            tween: Tween(begin: 0, end: 1),
                            curve: Curves.easeInOut,
                            builder: (context, value, child) {
                              return Transform.translate(
                                offset: Offset(0, -15 * (1 - (value - 0.5).abs() * 2)),
                                child: child,
                              );
                            },
                            child: Image.asset('assets/images/mascot_muslim_boy.png', width: 140),
                          ),
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
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    
                    // Bubble Menus
                    GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: AppSpacing.lg,
                      mainAxisSpacing: AppSpacing.lg,
                      childAspectRatio: 0.85,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        _buildBubbleCard(
                          context,
                          title: 'Iqra 1-6',
                          icon: Icons.menu_book_rounded,
                          color: AppColors.skyBlue,
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const BelajarIqraScreen())),
                        ),
                        _buildBubbleCard(
                          context,
                          title: 'Huruf',
                          icon: Icons.grid_view_rounded,
                          color: AppColors.accent,
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const BelajarHurufScreen())),
                        ),
                        _buildBubbleCard(
                          context,
                          title: 'Kuis',
                          icon: Icons.stars_rounded,
                          color: AppColors.softPink,
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const LatihanScreen())),
                        ),
                        _buildBubbleCard(
                          context,
                          title: 'Speaker',
                          icon: Icons.volume_up_rounded,
                          color: AppColors.sunnyYellow,
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const TentangScreen())),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xxl),
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
