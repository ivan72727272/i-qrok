import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/islamic_decor.dart';
import '../data/iqra_data.dart';
import 'interactive_iqra_screen.dart';

class BelajarIqraScreen extends StatelessWidget {
  const BelajarIqraScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(
        title: 'Level Iqra',
        subtitle: 'Pilih level untuk mulai belajar',
      ),
      body: Stack(
        children: [
          const FloatingStars(),
          
          // Background Illustration
          Positioned(
            bottom: -30,
            right: -30,
            child: Opacity(
              opacity: 0.1,
              child: Image.asset('assets/images/cute_mosque.png', width: 350),
            ),
          ),
          
          GridView.builder(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(AppSpacing.lg),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.85,
            ),
            itemCount: IqraData.levels.length,
            itemBuilder: (context, index) {
              final level = IqraData.levels[index];
              return _buildLevelCard(context, level);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLevelCard(BuildContext context, dynamic level) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: [
          BoxShadow(
            color: level.color.withOpacity(0.15),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          splashColor: level.color.withOpacity(0.2),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => InteractiveIqraScreen(level: level),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Icon/Number Container
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: level.color.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${level.level}',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        color: level.color,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                // Title
                Text(
                  level.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textMain,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                // Description
                Text(
                  level.description,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textDim,
                    height: 1.2,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
