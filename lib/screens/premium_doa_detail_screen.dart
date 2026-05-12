import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_constants.dart';

class PremiumDoaDetailScreen extends StatefulWidget {
  final String title;
  final String arabic;
  final String latin;
  final String translation;
  final String imagePath;

  const PremiumDoaDetailScreen({
    super.key,
    this.title = 'Doa Untuk Orang Tua',
    this.arabic = 'رَبِّ اغْفِرْ لِي وَلِوَالِدَيَّ وَارْحَمْهُمَا كَمَا رَبَّيَانِي صَغِيرًا',
    this.latin = 'Rabbighfir lii wa liwaalidayya warhamhumaa kamaa rabbayaanii shaghiiraa.',
    this.translation = 'Ya Tuhanku, ampunilah aku dan kedua orang tuaku, dan sayangilah mereka sebagaimana mereka telah mendidik aku di waktu kecil.',
    this.imagePath = 'assets/images/doa/doa_orang_tua.png', // Fallback path
  });

  @override
  State<PremiumDoaDetailScreen> createState() => _PremiumDoaDetailScreenState();
}

class _PremiumDoaDetailScreenState extends State<PremiumDoaDetailScreen> with TickerProviderStateMixin {
  late AnimationController _floatController;
  late AnimationController _sparkleController;

  @override
  void initState() {
    super.initState();
    _floatController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    _sparkleController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _floatController.dispose();
    _sparkleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFDF7), // Warm cream background
      body: Stack(
        children: [
          // ─── Background Patterns ───
          Positioned.fill(
            child: Opacity(
              opacity: 0.05,
              child: CustomPaint(painter: _PatternPainter()),
            ),
          ),

          // ─── Floating Decorations ───
          ...List.generate(10, (index) => _buildFloatingElement(index)),

          // ─── Main Content ───
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // ─── Organic Curved Header ───
              SliverToBoxAdapter(
                child: _buildOrganicHeader(context),
              ),

              // ─── Main Doa Card ───
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    _buildMainStoryCard(),
                    const SizedBox(height: 30),
                    _buildTextArea(),
                    const SizedBox(height: 40),
                  ]),
                ),
              ),
            ],
          ),

          // ─── Screen Corners Decorations ───
          Positioned(
            top: 40,
            left: -10,
            child: _buildCornerDecor(Icons.spa_rounded, const Color(0xFFC8E6C9)),
          ),
          Positioned(
            bottom: 20,
            right: -10,
            child: _buildCornerDecor(Icons.auto_awesome_rounded, const Color(0xFFFFF9C4)),
          ),
        ],
      ),
    );
  }

  Widget _buildOrganicHeader(BuildContext context) {
    return Container(
      height: 260,
      child: Stack(
        children: [
          // Curved Background Container
          ClipPath(
            clipper: _OrganicHeaderClipper(),
            child: Container(
              height: 240,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFB3E5FC), // Soft Sky Blue
                    Color(0xFFE0F2F1), // Mint Green
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFB3E5FC).withOpacity(0.3),
                    blurRadius: 30,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Glow Effect
                  Positioned(
                    top: -50,
                    right: -50,
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withOpacity(0.5),
                            blurRadius: 100,
                            spreadRadius: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Background Mosque/Clouds Decor
                  Positioned(
                    bottom: 40,
                    left: 60,
                    child: Opacity(
                      opacity: 0.1,
                      child: Icon(Icons.mosque_rounded, size: 80, color: Colors.blue[900]),
                    ),
                  ),
                  Positioned(
                    top: 60,
                    right: 80,
                    child: Opacity(
                      opacity: 0.15,
                      child: Icon(Icons.cloud_rounded, size: 60, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Header Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      // Soft Back Button
                      Material(
                        color: Colors.white.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(100),
                        child: InkWell(
                          onTap: () => Navigator.pop(context),
                          borderRadius: BorderRadius.circular(100),
                          child: const Padding(
                            padding: EdgeInsets.all(12),
                            child: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
                          ),
                        ),
                      ),
                      const Spacer(),
                      // Floating Mascot
                      _buildFloatingMascot(),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Doa Harian',
                    style: GoogleFonts.nunito(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                  Text(
                    widget.title,
                    style: GoogleFonts.nunito(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      height: 1.1,
                      shadows: [
                        const Shadow(
                          color: Colors.black12,
                          offset: Offset(0, 2),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingMascot() {
    return AnimatedBuilder(
      animation: _floatController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, 8 * sin(_floatController.value * 2 * pi)),
          child: Container(
            height: 100,
            width: 100,
            decoration: const BoxDecoration(
              // Using generated mascot image if available, else placeholder
              image: DecorationImage(
                image: AssetImage('assets/images/premium_muslim_mascot.png'),
                fit: BoxFit.contain,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMainStoryCard() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFFF9EE), // Soft cream
        borderRadius: BorderRadius.circular(40),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: CustomPaint(
        painter: _DashedBorderPainter(),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // 3D Bubble Title
              _buildBubbleTitle(),
              const SizedBox(height: 20),
              // Illustration Area
              Container(
                height: 320,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Main Illustration
                      Image.asset(
                        'assets/images/doa_orang_tua_illustration.png',
                        fit: BoxFit.cover,
                      ),
                      // Soft Light Overlay
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.white.withOpacity(0.2),
                              Colors.transparent,
                              Colors.black.withOpacity(0.1),
                            ],
                          ),
                        ),
                      ),
                      // Decorative elements on card
                      Positioned(
                        top: 10, left: 10,
                        child: _buildSmallDecor(Icons.wb_sunny_rounded, Colors.yellow[300]!),
                      ),
                      Positioned(
                        bottom: 15, right: 15,
                        child: _buildSmallDecor(Icons.favorite_rounded, Colors.pink[200]!),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Storybook footer decor
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.star_rounded, color: Colors.amber[200], size: 16),
                  const SizedBox(width: 8),
                  Text(
                    'Magical Prayer Time',
                    style: GoogleFonts.nunito(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.brown[300],
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(Icons.star_rounded, color: Colors.amber[200], size: 16),
                ],
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBubbleTitle() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.blue[100]!.withOpacity(0.5),
            offset: const Offset(0, 4),
            blurRadius: 0,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, 6),
            blurRadius: 10,
          ),
        ],
      ),
      child: Text(
        widget.title,
        style: GoogleFonts.nunito(
          fontSize: 20,
          fontWeight: FontWeight.w900,
          foreground: Paint()
            ..shader = const LinearGradient(
              colors: [Color(0xFF4D96FF), Color(0xFF6BCB77)],
            ).createShader(const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
        ),
      ),
    );
  }

  Widget _buildTextArea() {
    return Column(
      children: [
        _buildTextSection('Arabic', widget.arabic, true),
        const SizedBox(height: 24),
        _buildTextSection('Latin', widget.latin, false),
        const SizedBox(height: 24),
        _buildTextSection('Arti', widget.translation, false),
      ],
    );
  }

  Widget _buildTextSection(String label, String content, bool isArabic) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: _getLabelColor(label),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            label,
            style: GoogleFonts.nunito(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: _getLabelColor(label).withOpacity(0.1), width: 2),
            boxShadow: [
              BoxShadow(
                color: _getLabelColor(label).withOpacity(0.05),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Text(
            content,
            textAlign: isArabic ? TextAlign.right : TextAlign.left,
            style: isArabic
                ? const TextStyle(
                    fontSize: 28,
                    fontFamily: 'Traditional Arabic', // Fallback
                    fontWeight: FontWeight.bold,
                    height: 1.8,
                    color: Color(0xFF37474F),
                  )
                : GoogleFonts.nunito(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    height: 1.6,
                    color: Colors.blueGrey[800],
                    fontStyle: label == 'Latin' ? FontStyle.italic : FontStyle.normal,
                  ),
          ),
        ),
      ],
    );
  }

  Color _getLabelColor(String label) {
    switch (label) {
      case 'Arabic': return const Color(0xFF6BCB77);
      case 'Latin': return const Color(0xFF4D96FF);
      case 'Arti': return const Color(0xFFFF9F45);
      default: return Colors.grey;
    }
  }

  Widget _buildFloatingElement(int index) {
    final random = Random(index);
    final size = 20.0 + random.nextInt(30);
    final top = random.nextDouble() * 800;
    final left = random.nextDouble() * 400;
    
    return Positioned(
      top: top,
      left: left,
      child: AnimatedBuilder(
        animation: _floatController,
        builder: (context, child) {
          return Transform.rotate(
            angle: _floatController.value * 2 * pi * (index % 2 == 0 ? 1 : -1),
            child: Opacity(
              opacity: 0.1,
              child: Icon(
                _getDecorIcon(index),
                size: size,
                color: Colors.primaries[index % Colors.primaries.length].withOpacity(0.3),
              ),
            ),
          );
        },
      ),
    );
  }

  IconData _getDecorIcon(int index) {
    final icons = [Icons.cloud_rounded, Icons.star_rounded, Icons.spa_rounded, Icons.favorite_rounded, Icons.wb_sunny_rounded];
    return icons[index % icons.length];
  }

  Widget _buildSmallDecor(IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: color, size: 18),
    );
  }

  Widget _buildCornerDecor(IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withOpacity(0.3),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: color, size: 40),
    );
  }
}

class _OrganicHeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 40);
    path.quadraticBezierTo(size.width / 4, size.height, size.width / 2, size.height - 20);
    path.quadraticBezierTo(size.width * 3 / 4, size.height - 40, size.width, size.height);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class _DashedBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFFFCC80).withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    const dashWidth = 8.0;
    const dashSpace = 6.0;
    final rRect = RRect.fromLTRBR(0, 0, size.width, size.height, const Radius.circular(40));
    final path = Path()..addRRect(rRect);

    final dashPath = Path();
    for (final metric in path.computeMetrics()) {
      double distance = 0;
      while (distance < metric.length) {
        dashPath.addPath(
          metric.extractPath(distance, distance + dashWidth),
          Offset.zero,
        );
        distance += dashWidth + dashSpace;
      }
    }
    canvas.drawPath(dashPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _PatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blueGrey[100]!
      ..style = PaintingStyle.fill;

    for (double i = 0; i < size.width; i += 40) {
      for (double j = 0; j < size.height; j += 40) {
        canvas.drawCircle(Offset(i, j), 1.5, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
