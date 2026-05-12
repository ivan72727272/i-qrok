import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_constants.dart';
import '../widgets/islamic_decor.dart';

class PremiumPraktikDetailScreen extends StatefulWidget {
  final String title;
  final String imagePath;
  final Color accentColor;

  const PremiumPraktikDetailScreen({
    super.key,
    required this.title,
    required this.imagePath,
    required this.accentColor,
  });

  @override
  State<PremiumPraktikDetailScreen> createState() => _PremiumPraktikDetailScreenState();
}

class _PremiumPraktikDetailScreenState extends State<PremiumPraktikDetailScreen> with TickerProviderStateMixin {
  late AnimationController _entryCtrl;
  late AnimationController _floatCtrl;
  
  @override
  void initState() {
    super.initState();
    _entryCtrl = AnimationController(duration: const Duration(milliseconds: 1000), vsync: this);
    _floatCtrl = AnimationController(duration: const Duration(seconds: 4), vsync: this)..repeat(reverse: true);
    
    _entryCtrl.forward();
  }

  @override
  void dispose() {
    _entryCtrl.dispose();
    _floatCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isWudhu = widget.imagePath.contains('wudhu');
    final isCerita = widget.imagePath.contains('cerita');
    final themeColor = isWudhu ? Colors.blue[300]! : widget.accentColor;
    final subtitle = isCerita ? 'Mari Membaca Cerita Seru! 📖' : 'Mari Belajar Praktik Islami ✨';

    return Scaffold(
      backgroundColor: const Color(0xFFF8FBFF),
      body: Stack(
        children: [
          // ─── Magical Background ───
          _buildMagicalBackground(themeColor),

          SafeArea(
            child: Column(
              children: [
                // Header
                _buildHeader(subtitle),

                // Main Content
                Expanded(
                  child: FadeTransition(
                    opacity: CurvedAnimation(parent: _entryCtrl, curve: const Interval(0.2, 1.0, curve: Curves.easeIn)),
                    child: SlideTransition(
                      position: Tween<Offset>(begin: const Offset(0, 0.05), end: Offset.zero)
                          .animate(CurvedAnimation(parent: _entryCtrl, curve: const Interval(0.2, 1.0, curve: Curves.easeOutBack))),
                      child: _buildMainPoster(themeColor),
                    ),
                  ),
                ),

                // Footer / Tip
                _buildFooter(themeColor),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMagicalBackground(Color themeColor) {
    return Stack(
      children: [
        // Soft Pastel Gradient
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  themeColor.withOpacity(0.05),
                  Colors.white,
                  themeColor.withOpacity(0.1),
                ],
              ),
            ),
          ),
        ),
        
        // Floating Ornaments
        const FloatingStars(),
        
        // Custom Clouds
        Positioned(top: 100, left: -20, child: _buildCloud(40, Colors.white.withOpacity(0.6))),
        Positioned(top: 250, right: -30, child: _buildCloud(60, themeColor.withOpacity(0.1))),
        Positioned(bottom: 150, left: 40, child: _buildCloud(30, themeColor.withOpacity(0.05))),

        // Mosque Silhouette
        Positioned(
          bottom: -20,
          right: -20,
          child: Opacity(
            opacity: 0.05,
            child: Icon(Icons.mosque_rounded, size: 250, color: themeColor),
          ),
        ),
      ],
    );
  }

  Widget _buildCloud(double size, Color color) {
    return Icon(Icons.cloud_rounded, size: size, color: color);
  }

  Widget _buildHeader(String subtitle) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          // Close Button
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
                ],
              ),
              child: const Icon(Icons.close_rounded, color: Color(0xFF546E7A), size: 24),
            ),
          ),
          const SizedBox(width: 16),
          // Title
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: GoogleFonts.nunito(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFF37474F),
                    shadows: [const Shadow(color: Colors.white, blurRadius: 10)],
                  ),
                ),
                Text(
                  subtitle,
                  style: GoogleFonts.nunito(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: Colors.blueGrey[300],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainPoster(Color themeColor) {
    return AnimatedBuilder(
      animation: _floatCtrl,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, 8 * _floatCtrl.value),
          child: Container(
            margin: const EdgeInsets.fromLTRB(20, 10, 20, 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(32),
              boxShadow: [
                BoxShadow(
                  color: themeColor.withOpacity(0.15),
                  blurRadius: 30,
                  offset: const Offset(0, 15),
                  spreadRadius: 2,
                ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 5,
                  offset: const Offset(0, 5),
                ),
              ],
              border: Border.all(color: Colors.white, width: 6),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(26),
              child: Stack(
                children: [
                  // The Poster Image
                  InteractiveViewer(
                    minScale: 0.5,
                    maxScale: 3.0,
                    child: Center(
                      child: Image.asset(
                        widget.imagePath,
                        fit: BoxFit.contain,
                        cacheWidth: 1000,
                      ),
                    ),
                  ),
                  
                  // Decorative Corner (Top Right)
                  Positioned(
                    top: -15,
                    right: -15,
                    child: Container(
                      padding: const EdgeInsets.all(25),
                      decoration: BoxDecoration(
                        color: themeColor.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.star_rounded, color: themeColor, size: 20),
                    ),
                  ),

                  // Decorative Corner (Bottom Left)
                  Positioned(
                    bottom: -10,
                    left: -10,
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: themeColor.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFooter(Color themeColor) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: themeColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: themeColor.withOpacity(0.2)),
            ),
            child: Row(
              children: [
                Icon(Icons.tips_and_updates_rounded, color: themeColor, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Gunakan dua jari untuk memperbesar gambar agar lebih jelas ya!',
                    style: GoogleFonts.nunito(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: themeColor.darken(0.2),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Klik gambar untuk belajar lebih detail',
            style: GoogleFonts.nunito(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: Colors.blueGrey[200],
            ),
          ),
        ],
      ),
    );
  }
}

extension ColorExtension on Color {
  Color darken([double amount = .1]) {
    assert(amount >= 0 && amount <= 1);
    final hsv = HSVColor.fromColor(this);
    final dampenedValue = (hsv.value * (1 - amount)).clamp(0.0, 1.0);
    return hsv.withValue(dampenedValue).toColor();
  }
}
