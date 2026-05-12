import 'dart:math';
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

/// Animated floating background decoration with stars/moon/clouds
class FloatingStars extends StatefulWidget {
  final Color? color;
  const FloatingStars({super.key, this.color});

  @override
  State<FloatingStars> createState() => _FloatingStarsState();
}

class _FloatingStarsState extends State<FloatingStars> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(duration: const Duration(seconds: 4), vsync: this)
      ..repeat(reverse: true);
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeInOutSine);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) => Stack(
        children: [
          // Top-right star
          Positioned(
            top: 20 + _anim.value * 6,
            right: 30,
            child: Opacity(
              opacity: 0.25 + _anim.value * 0.15,
              child: Icon(Icons.auto_awesome_rounded, size: 22, color: widget.color ?? AppColors.sunnyYellow),
            ),
          ),
          // Moon left
          Positioned(
            bottom: 55 + _anim.value * 8,
            left: 40,
            child: Opacity(
              opacity: 0.18 + _anim.value * 0.1,
              child: Icon(Icons.brightness_2_rounded, size: 30, color: AppColors.skyBlue),
            ),
          ),
          // Small star mid-left
          Positioned(
            top: 145 + _anim.value * 5,
            left: 22,
            child: Opacity(
              opacity: 0.3 + _anim.value * 0.1,
              child: Icon(Icons.star_rounded, size: 16, color: AppColors.softPink),
            ),
          ),
          // Star bottom-right
          Positioned(
            bottom: 115 + _anim.value * 7,
            right: 22,
            child: Opacity(
              opacity: 0.2 + _anim.value * 0.12,
              child: Icon(Icons.auto_awesome_rounded, size: 18, color: AppColors.primary),
            ),
          ),
          // Extra cloud top-left
          Positioned(
            top: 80 + _anim.value * 4,
            left: -10,
            child: Opacity(
              opacity: 0.06,
              child: Icon(Icons.cloud_rounded, size: 90, color: AppColors.skyBlue),
            ),
          ),
          // Extra star
          Positioned(
            top: 200 + _anim.value * 6,
            right: 60,
            child: Opacity(
              opacity: 0.15 + _anim.value * 0.08,
              child: Icon(Icons.star_rounded, size: 12, color: AppColors.accent),
            ),
          ),
        ],
      ),
    );
  }
}

/// Cute SVG-style drawn character using Canvas for each menu type
class MenuCharacterPainter extends CustomPainter {
  final String type; // 'ngaji','doa','praktik','cerita','latihan','surah'
  final Animation<double> animation;

  const MenuCharacterPainter({required this.type, required this.animation});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final wobble = sin(animation.value * 2 * pi) * 3;
    final wave = sin(animation.value * 4 * pi) * 8; // Faster for waving
    final isBlinking = animation.value > 0.45 && animation.value < 0.55;

    switch (type) {
      case 'ngaji':
        _drawNgaji(canvas, cx, cy, wobble, wave, isBlinking, size);
        break;
      case 'doa':
        _drawDoa(canvas, cx, cy, wobble, wave, isBlinking, size);
        break;
      case 'praktik':
        _drawPraktik(canvas, cx, cy, wobble, wave, isBlinking, size);
        break;
      case 'cerita':
        _drawCerita(canvas, cx, cy, wobble, wave, isBlinking, size);
        break;
      case 'latihan':
        _drawLatihan(canvas, cx, cy, wobble, wave, isBlinking, size);
        break;
      case 'surah':
        _drawSurah(canvas, cx, cy, wobble, wave, isBlinking, size);
        break;
      default:
        _drawNgaji(canvas, cx, cy, wobble, wave, isBlinking, size);
    }
  }

  void _drawNgaji(Canvas canvas, double cx, double cy, double wobble, double wave, bool isBlinking, Size size) {
    final skin = Paint()..color = const Color(0xFFFFD5B4);
    final clothes = Paint()..color = const Color(0xFF4D96FF);
    final white = Paint()..color = Colors.white;
    final dark = Paint()..color = const Color(0xFF37474F);
    final bookCover = Paint()..color = const Color(0xFF6BCB77);
    final bookPage = Paint()..color = const Color(0xFFFFFDF7);

    // Body
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromCenter(center: Offset(cx, cy + 18), width: 42, height: 36), const Radius.circular(15)),
      clothes,
    );
    // Head wobble
    canvas.drawCircle(Offset(cx, cy - 15 + wobble * 0.5), 24, skin);
    // Peci
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(cx - 15, cy - 36 + wobble * 0.5, 30, 14), const Radius.circular(6)),
      Paint()..color = const Color(0xFF37474F),
    );
    // Eyes
    if (isBlinking) {
      canvas.drawLine(Offset(cx - 10, cy - 12 + wobble * 0.5), Offset(cx - 4, cy - 12 + wobble * 0.5), dark..strokeWidth = 2..strokeCap = StrokeCap.round);
      canvas.drawLine(Offset(cx + 4, cy - 12 + wobble * 0.5), Offset(cx + 10, cy - 12 + wobble * 0.5), dark..strokeWidth = 2..strokeCap = StrokeCap.round);
    } else {
      canvas.drawCircle(Offset(cx - 7, cy - 12 + wobble * 0.5), 3.5, dark);
      canvas.drawCircle(Offset(cx + 7, cy - 12 + wobble * 0.5), 3.5, dark);
      canvas.drawCircle(Offset(cx - 8, cy - 13 + wobble * 0.5), 1.2, white);
      canvas.drawCircle(Offset(cx + 6, cy - 13 + wobble * 0.5), 1.2, white);
    }
    // Smile
    final smilePath = Path()
      ..moveTo(cx - 6, cy - 4 + wobble * 0.5)
      ..quadraticBezierTo(cx, cy + wobble * 0.5, cx + 6, cy - 4 + wobble * 0.5);
    canvas.drawPath(smilePath, Paint()..color = const Color(0xFFF48FB1)..style = PaintingStyle.stroke..strokeWidth = 2.5..strokeCap = StrokeCap.round);
    
    // Waving Hand
    final handX = cx + 22;
    final handY = cy + 10 + wave;
    canvas.drawCircle(Offset(handX, handY), 6, skin);
    
    // Book in other hand
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromCenter(center: Offset(cx - 12, cy + 34), width: 30, height: 20), const Radius.circular(4)),
      bookCover,
    );
  }

  void _drawDoa(Canvas canvas, double cx, double cy, double wobble, double wave, bool isBlinking, Size size) {
    final skin = Paint()..color = const Color(0xFFFFD5B4);
    final clothes = Paint()..color = const Color(0xFFAB47BC);
    final dark = Paint()..color = const Color(0xFF37474F);

    // Body
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromCenter(center: Offset(cx, cy + 18), width: 40, height: 34), const Radius.circular(15)),
      clothes,
    );
    // Hijab
    canvas.drawCircle(Offset(cx, cy - 12 + wobble * 0.5), 24, Paint()..color = const Color(0xFF7B1FA2));
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromCenter(center: Offset(cx, cy + 10), width: 46, height: 24), const Radius.circular(12)),
      Paint()..color = const Color(0xFF7B1FA2),
    );
    // Face
    canvas.drawCircle(Offset(cx, cy - 12 + wobble * 0.5), 18, skin);
    // Eyes (Praying/Blinking)
    if (isBlinking) {
       canvas.drawLine(Offset(cx - 8, cy - 10 + wobble * 0.5), Offset(cx - 2, cy - 10 + wobble * 0.5), dark..strokeWidth = 2..strokeCap = StrokeCap.round);
       canvas.drawLine(Offset(cx + 2, cy - 10 + wobble * 0.5), Offset(cx + 8, cy - 10 + wobble * 0.5), dark..strokeWidth = 2..strokeCap = StrokeCap.round);
    } else {
      final eyePath = Path()
        ..moveTo(cx - 8, cy - 10 + wobble * 0.5)
        ..quadraticBezierTo(cx - 5, cy - 7 + wobble * 0.5, cx - 2, cy - 10 + wobble * 0.5);
      canvas.drawPath(eyePath, dark..style = PaintingStyle.stroke..strokeWidth = 2..strokeCap = StrokeCap.round);
      final eyePathR = Path()
        ..moveTo(cx + 2, cy - 10 + wobble * 0.5)
        ..quadraticBezierTo(cx + 5, cy - 7 + wobble * 0.5, cx + 8, cy - 10 + wobble * 0.5);
      canvas.drawPath(eyePathR, dark..style = PaintingStyle.stroke..strokeWidth = 2..strokeCap = StrokeCap.round);
    }
    // Hands in Doa
    canvas.drawCircle(Offset(cx - 8, cy + 28 + wobble * 0.5), 6, skin);
    canvas.drawCircle(Offset(cx + 8, cy + 28 + wobble * 0.5), 6, skin);
  }

  // Fallbacks for other types to avoid errors, reusing common styles
  void _drawPraktik(Canvas canvas, double cx, double cy, double wobble, double wave, bool isBlinking, Size size) => _drawNgaji(canvas, cx, cy, wobble, wave, isBlinking, size);
  void _drawCerita(Canvas canvas, double cx, double cy, double wobble, double wave, bool isBlinking, Size size) => _drawNgaji(canvas, cx, cy, wobble, wave, isBlinking, size);
  void _drawLatihan(Canvas canvas, double cx, double cy, double wobble, double wave, bool isBlinking, Size size) => _drawNgaji(canvas, cx, cy, wobble, wave, isBlinking, size);
  void _drawSurah(Canvas canvas, double cx, double cy, double wobble, double wave, bool isBlinking, Size size) => _drawDoa(canvas, cx, cy, wobble, wave, isBlinking, size);

  @override
  bool shouldRepaint(MenuCharacterPainter oldDelegate) => true;
}

/// Animated character widget for menu cards
class MenuCharacter extends StatefulWidget {
  final String type;
  final String? name; // Added for compatibility with other screens
  final Color? color; // Added for compatibility with other screens

  const MenuCharacter({super.key, this.type = 'ngaji', this.name, this.color});

  @override
  State<MenuCharacter> createState() => _MenuCharacterState();
}

class _MenuCharacterState extends State<MenuCharacter> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(duration: const Duration(seconds: 2), vsync: this)
      ..repeat(reverse: true);
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeInOutSine);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) => CustomPaint(
        painter: MenuCharacterPainter(type: widget.name?.toLowerCase() ?? widget.type, animation: _anim),
      ),
    );
  }
}

/// Animated Equalizer for audio playback
class EqualizerAnimation extends StatefulWidget {
  final Color color;
  final double size;

  const EqualizerAnimation({super.key, required this.color, this.size = 20});

  @override
  State<EqualizerAnimation> createState() => _EqualizerAnimationState();
}

class _EqualizerAnimationState extends State<EqualizerAnimation> with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(4, (index) => 
      AnimationController(
        duration: Duration(milliseconds: 400 + (index * 100)),
        vsync: this,
      )..repeat(reverse: true)
    );
    _animations = _controllers.map((c) => Tween<double>(begin: 0.2, end: 1.0).animate(c)).toList();
  }

  @override
  void dispose() {
    for (var c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.size,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(4, (index) => 
          AnimatedBuilder(
            animation: _animations[index],
            builder: (context, child) => Container(
              margin: const EdgeInsets.symmetric(horizontal: 1.5),
              width: 3,
              height: widget.size * _animations[index].value,
              decoration: BoxDecoration(
                color: widget.color,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

