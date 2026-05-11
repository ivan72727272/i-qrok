import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

class IslamicDecor extends StatelessWidget {
  final double size;
  final Color? color;
  final double opacity;

  const IslamicDecor({
    super.key,
    this.size = 100,
    this.color,
    this.opacity = 0.1,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacity,
      child: Icon(
        Icons.mosque_rounded,
        size: size,
        color: color ?? AppColors.primary,
      ),
    );
  }
}

/// A simple single star/icon for use in positioned decorations
class FloatingStarSingle extends StatelessWidget {
  final double size;
  final Color color;

  const FloatingStarSingle({super.key, this.size = 12, this.color = Colors.white});

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.4,
      child: Icon(Icons.auto_awesome_rounded, size: size, color: color),
    );
  }
}

class FloatingStars extends StatelessWidget {
  const FloatingStars({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 20,
          right: 30,
          child: Opacity(
            opacity: 0.3,
            child: Icon(Icons.auto_awesome_rounded, size: 24, color: AppColors.sunnyYellow),
          ),
        ),
        Positioned(
          bottom: 50,
          left: 40,
          child: Opacity(
            opacity: 0.3,
            child: Icon(Icons.brightness_2_rounded, size: 32, color: AppColors.skyBlue),
          ),
        ),
        Positioned(
          top: 150,
          left: 20,
          child: Opacity(
            opacity: 0.4,
            child: Icon(Icons.star_rounded, size: 18, color: AppColors.softPink),
          ),
        ),
        Positioned(
          bottom: 120,
          right: 20,
          child: Opacity(
            opacity: 0.3,
            child: Icon(Icons.auto_awesome_rounded, size: 20, color: AppColors.primary),
          ),
        ),
      ],
    );
  }
}
