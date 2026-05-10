import 'dart:math';
import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

class RewardAnimation extends StatefulWidget {
  final bool show;
  final VoidCallback onComplete;

  const RewardAnimation({super.key, required this.show, required this.onComplete});

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
      duration: const Duration(milliseconds: 1500),
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
    for (int i = 0; i < 30; i++) {
      _particles.add(Particle(
        color: _getRandomColor(),
        angle: _random.nextDouble() * 2 * pi,
        speed: _random.nextDouble() * 5 + 2,
        size: _random.nextDouble() * 15 + 5,
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
    ];
    return colors[_random.nextInt(colors.length)];
  }

  IconData _getRandomIcon() {
    final icons = [
      Icons.star_rounded,
      Icons.favorite_rounded,
      Icons.auto_awesome_rounded,
      Icons.celebration_rounded,
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
        return Stack(
          children: _particles.map((p) {
            double progress = _controller.value;
            double x = cos(p.angle) * p.speed * progress * 150;
            double y = sin(p.angle) * p.speed * progress * 150 + (progress * progress * 200);
            
            return Positioned(
              left: MediaQuery.of(context).size.width / 2 + x,
              top: MediaQuery.of(context).size.height / 2 + y - 100,
              child: Opacity(
                opacity: 1.0 - progress,
                child: Transform.rotate(
                  angle: progress * 5,
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
