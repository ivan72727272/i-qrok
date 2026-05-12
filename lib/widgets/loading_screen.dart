import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../widgets/islamic_decor.dart';

class LittleMuslimLoading extends StatefulWidget {
  final String message;
  const LittleMuslimLoading({super.key, this.message = 'Sedang menyiapkan pelajaran...'});

  @override
  State<LittleMuslimLoading> createState() => _LittleMuslimLoadingState();
}

class _LittleMuslimLoadingState extends State<LittleMuslimLoading> with TickerProviderStateMixin {
  late AnimationController _walkCtrl;
  late Animation<double> _walkAnim;
  late AnimationController _floatCtrl;

  @override
  void initState() {
    super.initState();
    _walkCtrl = AnimationController(duration: const Duration(seconds: 4), vsync: this)..repeat();
    _walkAnim = Tween<double>(begin: -150, end: 400).animate(_walkCtrl);
    _floatCtrl = AnimationController(duration: const Duration(seconds: 2), vsync: this)..repeat(reverse: true);
  }

  @override
  void dispose() {
    _walkCtrl.dispose();
    _floatCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: AppColors.background,
      child: Stack(
        children: [
          const FloatingStars(),
          // Floating Clouds
          Positioned(
            top: 100,
            left: 50,
            child: _FloatingCloud(size: 80, delay: 0),
          ),
          Positioned(
            top: 180,
            right: 40,
            child: _FloatingCloud(size: 60, delay: 500),
          ),
          
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Walking Mascot Container
                SizedBox(
                  height: 180,
                  width: double.infinity,
                  child: Stack(
                    children: [
                      AnimatedBuilder(
                        animation: _walkAnim,
                        builder: (context, child) => Positioned(
                          left: _walkAnim.value,
                          bottom: 0,
                          child: const SizedBox(
                            width: 120,
                            height: 120,
                            child: MenuCharacter(type: 'ngaji'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                // Message
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(AppRadius.full),
                    boxShadow: [
                      BoxShadow(color: AppColors.primary.withOpacity(0.1), blurRadius: 20),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2.5),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        widget.message,
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.textMain),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FloatingCloud extends StatelessWidget {
  final double size;
  final int delay;
  const _FloatingCloud({required this.size, required this.delay});

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.1,
      child: Icon(Icons.cloud_rounded, size: size, color: AppColors.skyBlue),
    );
  }
}
