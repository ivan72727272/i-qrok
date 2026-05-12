import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_constants.dart';
import '../widgets/islamic_decor.dart';

class RewardAnimation extends StatefulWidget {
  final bool show;
  final VoidCallback onComplete;
  final bool isStatic; // If true, stays at center

  const RewardAnimation({
    super.key, 
    required this.show, 
    required this.onComplete,
    this.isStatic = false,
  });

  @override
  State<RewardAnimation> createState() => _RewardAnimationState();
}

class _RewardAnimationState extends State<RewardAnimation> with TickerProviderStateMixin {
  late AnimationController _controller;
  final List<Particle> _particles = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onComplete();
      }
    });

    if (widget.show) {
      _startAnimation();
    }
  }

  @override
  void didUpdateWidget(RewardAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.show && !oldWidget.show) {
      _startAnimation();
    }
  }

  void _startAnimation() {
    _particles.clear();
    for (int i = 0; i < 50; i++) { // More particles
      _particles.add(Particle(
        color: _getRandomColor(),
        angle: _random.nextDouble() * 2 * pi,
        speed: _random.nextDouble() * 6 + 3,
        size: _random.nextDouble() * 18 + 6,
        icon: _getRandomIcon(),
      ));
    }
    _controller.forward(from: 0.0);
  }

  Color _getRandomColor() {
    final colors = [
      AppColors.sunnyYellow,
      AppColors.skyBlue,
      AppColors.softPink,
      AppColors.primary,
      Colors.orangeAccent,
      const Color(0xFFB2FF59),
    ];
    return colors[_random.nextInt(colors.length)];
  }

  IconData _getRandomIcon() {
    final icons = [
      Icons.star_rounded,
      Icons.favorite_rounded,
      Icons.auto_awesome_rounded,
      Icons.celebration_rounded,
      Icons.bubble_chart_rounded,
    ];
    return icons[_random.nextInt(icons.length)];
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.show && !_controller.isAnimating) return const SizedBox.shrink();

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final screenWidth = MediaQuery.of(context).size.width;
        final screenHeight = MediaQuery.of(context).size.height;

        return Stack(
          children: _particles.map((p) {
            double progress = _controller.value;
            double x = cos(p.angle) * p.speed * progress * 180;
            double y = sin(p.angle) * p.speed * progress * 180 + (progress * progress * 250);
            
            return Positioned(
              left: screenWidth / 2 + x,
              top: screenHeight / 2 + y - 50,
              child: Opacity(
                opacity: (1.0 - progress).clamp(0.0, 1.0),
                child: Transform.rotate(
                  angle: progress * 6,
                  child: Icon(
                    p.icon,
                    color: p.color,
                    size: p.size,
                  ),
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}

class Particle {
  final Color color;
  final double angle;
  final double speed;
  final double size;
  final IconData icon;

  Particle({
    required this.color,
    required this.angle,
    required this.speed,
    required this.size,
    required this.icon,
  });
}

/// Premium Reward Popup with Mascot
void showLittleMuslimReward(BuildContext context, String message) {
  HapticFeedback.heavyImpact();
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Reward',
    transitionDuration: const Duration(milliseconds: 500),
    pageBuilder: (context, anim1, anim2) => const SizedBox.shrink(),
    transitionBuilder: (context, anim1, anim2, child) {
      final curve = CurvedAnimation(parent: anim1, curve: Curves.elasticOut);
      return ScaleTransition(
        scale: curve,
        child: FadeTransition(
          opacity: anim1,
          child: AlertDialog(
            backgroundColor: Colors.transparent,
            elevation: 0,
            contentPadding: EdgeInsets.zero,
            content: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                // Confetti Layer
                RewardAnimation(show: true, onComplete: () {}),
                
                // Content Card
                Container(
                  width: 280,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(32),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 40, offset: const Offset(0, 10)),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 50), // For mascot overlap
                      const Text(
                        'MASYA ALLAH!',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: AppColors.primary, letterSpacing: 1),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        message,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textDim),
                      ),
                      const SizedBox(height: 24),
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        style: TextButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.full)),
                        ),
                        child: const Text('Hebat! 👍', style: TextStyle(fontWeight: FontWeight.w900)),
                      ),
                    ],
                  ),
                ),
                
                // Mascot Positioned Top
                Positioned(
                  top: -80,
                  child: SizedBox(
                    width: 140,
                    height: 140,
                    child: MenuCharacter(type: 'latihan'),
                  ),
                ),
                
                // Sparkles
                const Positioned(top: -40, left: 20, child: FloatingStarSingle(size: 24, color: AppColors.sunnyYellow)),
                const Positioned(top: -20, right: 10, child: FloatingStarSingle(size: 18, color: AppColors.softPink)),
              ],
            ),
          ),
        ),
      );
    },
  );
}
