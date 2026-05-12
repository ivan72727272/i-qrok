import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';
import '../widgets/islamic_decor.dart';
import 'home_screen.dart';
import 'onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _floatCtrl;
  late AnimationController _entryCtrl;
  late Animation<double> _floatAnim;
  late Animation<double> _scaleAnim;
  late Animation<double> _fadeAnim;
  late Animation<double> _slideAnim;
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();

    _floatCtrl = AnimationController(duration: const Duration(seconds: 2), vsync: this)
      ..repeat(reverse: true);
    _floatAnim = Tween<double>(begin: 0, end: 14).animate(
      CurvedAnimation(parent: _floatCtrl, curve: Curves.easeInOutSine));

    _entryCtrl = AnimationController(duration: const Duration(milliseconds: 1200), vsync: this);
    _scaleAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _entryCtrl, curve: const Interval(0.0, 0.7, curve: Curves.elasticOut)));
    _fadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _entryCtrl, curve: const Interval(0.4, 1.0, curve: Curves.easeOut)));
    _slideAnim = Tween<double>(begin: 30.0, end: 0.0).animate(
      CurvedAnimation(parent: _entryCtrl, curve: const Interval(0.4, 1.0, curve: Curves.easeOut)));

    _entryCtrl.forward();
    _playGreeting();
    _checkFirstTime();
  }

  Future<void> _checkFirstTime() async {
    final prefs = await SharedPreferences.getInstance();
    final hasSeenOnboarding = prefs.getBool('hasSeenOnboarding') ?? false;
    Timer(const Duration(seconds: 4), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(PageRouteBuilder(
          pageBuilder: (_, __, ___) =>
              hasSeenOnboarding ? const HomeScreen() : const OnboardingScreen(),
          transitionsBuilder: (_, anim, __, child) =>
              FadeTransition(opacity: anim, child: child),
          transitionDuration: const Duration(milliseconds: 800),
        ));
      }
    });
  }

  Future<void> _playGreeting() async {
    try {
      await Future.delayed(const Duration(milliseconds: 800));
      await _audioPlayer.play(AssetSource('audio/sapaan/assalamualaikum.mp3'));
    } catch (e) {
      debugPrint('Error playing greeting: $e');
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _floatCtrl.dispose();
    _entryCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFF0FFF4), Color(0xFFE3F2FD), Color(0xFFF3E5F5)],
          ),
        ),
        child: Stack(
          children: [
            // Animated background blobs
            _AnimatedBlob(color: AppColors.primary.withOpacity(0.08), size: 250, x: -60, y: -60, delay: 0),
            _AnimatedBlob(color: AppColors.skyBlue.withOpacity(0.07), size: 200, x: null, y: -40, rightX: -50, delay: 500),
            _AnimatedBlob(color: AppColors.softPink.withOpacity(0.07), size: 180, x: -40, y: null, bottomY: 80, delay: 300),
            _AnimatedBlob(color: AppColors.accent.withOpacity(0.07), size: 160, x: null, y: null, rightX: -30, bottomY: 120, delay: 700),
            // Mosque silhouette
            Positioned(
              bottom: -30, left: 0, right: 0,
              child: Opacity(
                opacity: 0.05,
                child: Icon(Icons.mosque_rounded, size: 220, color: AppColors.primary),
              ),
            ),
            // Floating stars
            const FloatingStars(),
            // Stars at corners
            const Positioned(top: 60, left: 30, child: FloatingStarSingle(size: 18, color: Color(0xFFFFD93D))),
            const Positioned(top: 90, right: 40, child: FloatingStarSingle(size: 14, color: Color(0xFF6BCB77))),
            const Positioned(bottom: 180, left: 50, child: FloatingStarSingle(size: 16, color: Color(0xFF4D96FF))),
            const Positioned(bottom: 200, right: 35, child: FloatingStarSingle(size: 12, color: Color(0xFFC77DFF))),
            // Main content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo circle with floating animation
                  AnimatedBuilder(
                    animation: _floatAnim,
                    builder: (_, child) => Transform.translate(
                      offset: Offset(0, -_floatAnim.value),
                      child: child,
                    ),
                    child: ScaleTransition(
                      scale: _scaleAnim,
                      child: Container(
                        width: 240, height: 240,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Color(0xFF6BCB77), Color(0xFF4D96FF)],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withOpacity(0.35),
                              blurRadius: 40,
                              spreadRadius: 10,
                              offset: const Offset(0, 15),
                            ),
                          ],
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Inner white circle
                            Container(
                              width: 215, height: 215,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                            ),
                            // Mascot
                            const SizedBox(
                              width: 150,
                              height: 150,
                              child: MenuCharacter(type: 'ngaji'),
                            ),
                            // Floating moon/stars inside circle
                            const Positioned(top: 30, right: 40, child: FloatingStarSingle(size: 14, color: Color(0xFFFFD93D))),
                            const Positioned(bottom: 40, left: 30, child: Icon(Icons.brightness_2_rounded, size: 24, color: Color(0xFF81D4FA))),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  // App name + tagline with fade+slide
                  AnimatedBuilder(
                    animation: _entryCtrl,
                    builder: (_, child) => Opacity(
                      opacity: _fadeAnim.value,
                      child: Transform.translate(
                        offset: Offset(0, _slideAnim.value),
                        child: child,
                      ),
                    ),
                    child: Column(
                      children: [
                        // Name with shadow
                        const Text(
                          'LITTLE MUSLIM',
                          style: TextStyle(
                            fontSize: 42,
                            fontWeight: FontWeight.w900,
                            color: AppColors.primary,
                            letterSpacing: -0.5,
                            shadows: [
                              Shadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4)),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Belajar Islami untuk Anak Hebat',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textDim,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 40),
                        // Loading section
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(AppRadius.full),
                            boxShadow: [
                              BoxShadow(color: AppColors.primary.withOpacity(0.1), blurRadius: 20),
                            ],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              _LoadingDots(),
                              const SizedBox(height: 6),
                              const Text('Tunggu ya 😊', 
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: AppColors.primary)),
                            ],
                          ),
                        ),
                      ],
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

// ─── Animated blob ─────────────────────────────────────────────────────────────
class _AnimatedBlob extends StatefulWidget {
  final Color color;
  final double size;
  final double? x, y, rightX, bottomY;
  final int delay;

  const _AnimatedBlob({
    required this.color, required this.size,
    this.x, this.y, this.rightX, this.bottomY, required this.delay,
  });

  @override
  State<_AnimatedBlob> createState() => _AnimatedBlobState();
}

class _AnimatedBlobState extends State<_AnimatedBlob> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(duration: const Duration(milliseconds: 3500), vsync: this)..repeat(reverse: true);
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeInOutSine);
    if (widget.delay > 0) {
      _ctrl.stop();
      Future.delayed(Duration(milliseconds: widget.delay), () { if (mounted) _ctrl.forward(); });
    }
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) => Positioned(
        left: widget.x,
        top: widget.y != null ? widget.y! + _anim.value * 8 : null,
        right: widget.rightX,
        bottom: widget.bottomY != null ? widget.bottomY! + _anim.value * 6 : null,
        child: Container(
          width: widget.size, height: widget.size,
          decoration: BoxDecoration(color: widget.color, shape: BoxShape.circle),
        ),
      ),
    );
  }
}

// ─── Loading dots ──────────────────────────────────────────────────────────────
class _LoadingDots extends StatefulWidget {
  @override
  State<_LoadingDots> createState() => _LoadingDotsState();
}

class _LoadingDotsState extends State<_LoadingDots> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(duration: const Duration(milliseconds: 1200), vsync: this)..repeat();
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, __) => Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(3, (i) {
          final offset = sin((_ctrl.value * 2 * pi) - (i * pi / 3));
          final y = offset * 6;
          final opacity = (offset + 1) / 2 * 0.7 + 0.3;
          return Transform.translate(
            offset: Offset(0, y),
            child: Container(
              width: 10, height: 10,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: [AppColors.primary, AppColors.skyBlue, AppColors.softPink][i]
                    .withOpacity(opacity),
                shape: BoxShape.circle,
              ),
            ),
          );
        }),
      ),
    );
  }
}
