import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import 'islamic_decor.dart';
import '../screens/home_screen.dart'; // To use MenuCharacter

class EmptyState extends StatelessWidget {
  final String title;
  final String message;
  final String? mascotType;

  const EmptyState({
    super.key,
    this.title = 'Wah, Masih Kosong! 😊',
    this.message = 'Yuk mulai belajar hari ini dan isi hari dengan kebaikan!',
    this.mascotType, // Optional mascot name from home_screen characters
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Mascot Container
            TweenAnimationBuilder<double>(
              duration: const Duration(seconds: 2),
              tween: Tween(begin: 0, end: 1),
              builder: (context, value, child) {
                return Transform.translate(
                  offset: Offset(0, 10 * (1 - (2 * (0.5 - (value % 1).abs())))), // Floating animation
                  child: child,
                );
              },
              child: Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.1),
                      blurRadius: 30,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Center(
                  child: SizedBox(
                    width: 140,
                    height: 140,
                    child: MenuCharacter(
                      name: mascotType ?? 'Ana', // Default mascot
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
            // Text Content
            ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [Color(0xFF6BCB77), Color(0xFF4D96FF)],
              ).createShader(bounds),
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
              child: Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  color: AppColors.textDim,
                  fontWeight: FontWeight.w600,
                  height: 1.6,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
            // Subtle button or hint
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppRadius.full),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.auto_awesome_rounded, size: 18, color: AppColors.primary),
                  SizedBox(width: 8),
                  Text(
                    'Semangat Belajar!',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
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
