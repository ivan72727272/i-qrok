import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_constants.dart';
import '../widgets/menu_card.dart';
import '../widgets/islamic_decor.dart';
import '../data/iqra_data.dart';
import 'belajar_iqra_screen.dart';
import 'latihan_screen.dart';
import 'tentang_screen.dart';
import 'progress_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> _startLearning(BuildContext context) async {
    if (context.mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const BelajarIqraScreen()),
      );
    }
  }

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
                    // Greeting Section
                    Row(
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withOpacity(0.15),
                                blurRadius: 20,
                              ),
                            ],
                            border: Border.all(color: Colors.white, width: 3),
                          ),
                          child: ClipOval(
                            child: Image.asset(
                              'assets/images/mascot_muslim_boy.png', 
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Assalamualaikum Adik 😊',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.primary,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Mari kita mulai mengaji hari ini!',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.textMain,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: AppSpacing.xxl),
                    
                    // Main "Mulai Belajar" Button
                    GestureDetector(
                      onTap: () => _startLearning(context),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [AppColors.primaryLight, AppColors.primary],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(AppRadius.bubble),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withOpacity(0.3),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Mulai Belajar',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Lanjutkan bacaan terakhirmu',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white70,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 40),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: AppSpacing.xl),
                    const Text(
                      'Menu Pembelajaran',
                      style: TextStyle(
                        fontSize: 20, 
                        fontWeight: FontWeight.w900, 
                        color: AppColors.textMain,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    
                    // Menu Grid
                    GridView(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        mainAxisExtent: 130, // Fixed compact height
                      ),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        _buildBubbleCard(
                          context,
                          title: 'Level Iqra',
                          icon: Icons.menu_book_rounded,
                          color: AppColors.skyBlue,
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const BelajarIqraScreen())),
                        ),
                        _buildBubbleCard(
                          context,
                          title: 'Latihan',
                          icon: Icons.stars_rounded,
                          color: AppColors.softPink,
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const LatihanScreen())),
                        ),
                        _buildBubbleCard(
                          context,
                          title: 'Progress',
                          icon: Icons.auto_graph_rounded,
                          color: const Color(0xFF66BB6A),
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ProgressScreen())),
                        ),
                        _buildBubbleCard(
                          context,
                          title: 'Tentang',
                          icon: Icons.info_rounded,
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
