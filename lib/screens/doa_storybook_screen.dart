import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_constants.dart';
import '../utils/asset_loader_service.dart';

class DoaStorybookScreen extends StatefulWidget {
  const DoaStorybookScreen({super.key});

  @override
  State<DoaStorybookScreen> createState() => _DoaStorybookScreenState();
}

class _DoaStorybookScreenState extends State<DoaStorybookScreen> {
  final PageController _pageController = PageController();
  double _currentPage = 0;
  List<DoaContent> _doas = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDoas();
    _pageController.addListener(() {
      if (mounted) {
        setState(() {
          _currentPage = _pageController.page!;
        });
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_doas.isNotEmpty) {
      _precacheAdjacentPages(_currentPage.round());
    }
  }

  void _precacheAdjacentPages(int index) {
    if (index >= 0 && index < _doas.length) {
      precacheImage(AssetImage(_doas[index].image), context);
      if (index + 1 < _doas.length) {
        precacheImage(AssetImage(_doas[index + 1].image), context);
      }
      if (index - 1 >= 0) {
        precacheImage(AssetImage(_doas[index - 1].image), context);
      }
    }
  }

  Future<void> _loadDoas() async {
    final imagePaths = await AssetLoaderService.loadImagesFromFolder('assets/images/doa/');
    
    final List<DoaContent> loadedDoas = imagePaths.map((path) {
      final title = AssetLoaderService.extractTitleFromPath(path);
      
      String tip = 'Ayo amalkan doa ini setiap hari ya! ✨';
      String arabic = '';
      String latin = '';
      String translation = '';

      if (path.contains('doa_makan')) {
        arabic = 'اَللّٰهُمَّ بَارِكْ لَنَا فِيْمَا رَزَقْتَنَا وَقِنَا عَذَابَ النَّارِ';
        latin = 'Allahumma barik lana fima razaqtana waqina adzaban nar.';
        translation = 'Ya Allah, berkahilah rezeki yang Engkau berikan kepada kami dan peliharalah kami dari siksa api neraka.';
        tip = 'Gunakan tangan kanan ya sayang! 🍴';
      } else if (path.contains('doa_tidur')) {
        arabic = 'بِاسْمِكَ اللّٰهُمَّ اَحْيَا وَاَمُوْتُ';
        latin = 'Bismika allahumma ahya wa amutu.';
        translation = 'Dengan nama-Mu ya Allah, aku hidup dan aku mati.';
        tip = 'Jangan lupa berwudhu sebelum tidur 🌙';
      } else if (path.contains('doa_bangun_tidur')) {
        arabic = 'اَلْحَمْدُ لِلهِ الَّذِيْ اَحْيَانَا بَعْدَ مَا اَمَاتَنَا وَاِلَيْهِ النُّشُوْرُ';
        latin = 'Alhamdulillahil ladzi ahyana ba\'da ma amatana wa ilaihin nusyur.';
        translation = 'Segala puji bagi Allah yang telah menghidupkan kami setelah mematikan kami, dan kepada-Nya lah kami kembali.';
        tip = 'Bangun tidur langsung senyum ya! 😊';
      } else if (path.contains('doa_orang_tua')) {
        arabic = 'رَبِّ اغْفِرْ لِي وَلِوَالِدَيَّ وَارْحَمْهُمَا كَمَا رَبَّيَانِي صَغِيرًا';
        latin = 'Rabbighfir lii wa liwaalidayya warhamhumaa kamaa rabbayaanii shaghiiraa.';
        translation = 'Ya Tuhanku, ampunilah aku dan kedua orang tuaku, dan sayangilah mereka sebagaimana mereka telah mendidik aku di waktu kecil.';
        tip = 'Sayangi ayah dan ibu setiap hari ❤️';
      }

      if (tip.contains('Ayo amalkan')) {
        if (title.toLowerCase().contains('masjid')) tip = 'Masuk masjid dahulukan kaki kanan ya! 🕌';
        if (title.toLowerCase().contains('belajar')) tip = 'Semangat belajarnya ya anak sholeh! 📚';
        if (title.toLowerCase().contains('kendaraan')) tip = 'Hati-hati di jalan, baca doa dulu 🚗';
      }

      return DoaContent(
        title: title,
        image: path,
        tip: tip,
        arabic: arabic, 
        latin: latin,
        translation: translation,
      );
    }).toList();

    if (mounted) {
      setState(() {
        _doas = loadedDoas;
        _isLoading = false;
      });
      _precacheAdjacentPages(0);
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFFFDFCFB),
        body: Center(child: CircularProgressIndicator(color: AppColors.primary, strokeWidth: 3)),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7), 
      body: Stack(
        children: [
          // ─── The Storybook Pages ───
          PageView.builder(
            controller: _pageController,
            itemCount: _doas.length,
            onPageChanged: (index) => _precacheAdjacentPages(index),
            itemBuilder: (context, index) {
              return _buildOptimizedPage(index);
            },
          ),

          // ─── Header Overlay (Always Visible) ───
          _buildHeaderOverlay(),

          // ─── Simple Navigation Controls ───
          _buildNavigationControls(),
        ],
      ),
    );
  }

  Widget _buildOptimizedPage(int index) {
    final doa = _doas[index];
    
    // Lightweight parallax/scale effect
    double delta = index - _currentPage;
    double scale = 1.0 - (delta.abs() * 0.1);
    double opacity = (1.0 - delta.abs()).clamp(0.0, 1.0);

    return RepaintBoundary(
      child: Opacity(
        opacity: opacity,
        child: Transform.scale(
          scale: scale,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 40),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(28),
              child: Stack(
                children: [
                  // ─── Main Content Column ───
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Illustration Area
                      Expanded(
                        flex: 6,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.asset(
                              doa.image, 
                              fit: BoxFit.contain, 
                              cacheWidth: 600, 
                              filterQuality: FilterQuality.low,
                            ),
                            // Top Readability Overlay (for Title)
                            Positioned(
                              top: 0, left: 0, right: 0,
                              child: Container(
                                height: 100,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.white.withOpacity(0.85),
                                      Colors.white.withOpacity(0.0),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Text Area
                      Expanded(
                        flex: 4,
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 80),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (doa.arabic.isNotEmpty) ...[
                                Text(
                                  doa.arabic,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF2C3E50),
                                    fontFamily: 'Amiri',
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  doa.latin,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.nunito(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.primary,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  doa.translation,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.nunito(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.blueGrey[600],
                                    height: 1.3,
                                  ),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ] else ...[
                                // If it's a pamphlet, just show a friendly tip to avoid empty space
                                Icon(Icons.auto_awesome_rounded, color: Colors.amber[300], size: 40),
                                const SizedBox(height: 10),
                                Text(
                                  "Ayo amalkan adab-adab\ndoa ini ya sayang!",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.nunito(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  // ─── Floating Elements (Always Visible & Readable) ───
                  
                  // Premium Title Badge (Top Center)
                  Positioned(
                    top: 20,
                    left: 20,
                    right: 20,
                    child: Center(child: _buildPremiumTitle(doa.title)),
                  ),

                  // Tip Badge (Bottom Area)
                  Positioned(
                    bottom: 90,
                    left: 20,
                    right: 20,
                    child: _buildTipBadge(doa.tip),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPremiumTitle(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: Text(
        title.toUpperCase(),
        style: GoogleFonts.nunito(
          fontSize: 16,
          fontWeight: FontWeight.w900,
          color: AppColors.primary,
          letterSpacing: 1.5,
          shadows: [
            const Shadow(color: Colors.black12, blurRadius: 2, offset: Offset(0, 1)),
          ],
        ),
      ),
    );
  }

  Widget _buildTipBadge(String tip) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.amber[100]!),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.lightbulb_rounded, color: Colors.amber[600], size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              tip,
              style: GoogleFonts.nunito(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                color: Colors.amber[900],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderOverlay() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
          children: [
            // Instant Back Button
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close_rounded, color: Color(0xFF455A64), size: 24),
              ),
            ),
            const Spacer(),
            // Progress Indicator
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${(_currentPage + 1).toInt()} / ${_doas.length}',
                style: GoogleFonts.nunito(
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationControls() {
    return Positioned(
      bottom: 25,
      left: 30,
      right: 30,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Previous
          _buildNavBtn(
            icon: Icons.arrow_back_ios_new_rounded,
            onTap: () {
              if (_currentPage > 0) {
                _pageController.previousPage(duration: const Duration(milliseconds: 250), curve: Curves.easeOut);
              }
            },
            visible: _currentPage > 0,
          ),
          
          // Page Dots
          Row(
            children: List.generate(_doas.length, (index) {
              bool active = index == _currentPage.round();
              return AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: active ? 16 : 6,
                height: 6,
                decoration: BoxDecoration(
                  color: active ? AppColors.primary : Colors.black12,
                  borderRadius: BorderRadius.circular(10),
                ),
              );
            }),
          ),

          // Next
          _buildNavBtn(
            icon: Icons.arrow_forward_ios_rounded,
            onTap: () {
              if (_currentPage < _doas.length - 1) {
                _pageController.nextPage(duration: const Duration(milliseconds: 250), curve: Curves.easeOut);
              }
            },
            visible: _currentPage < _doas.length - 1,
          ),
        ],
      ),
    );
  }

  Widget _buildNavBtn({required IconData icon, required VoidCallback onTap, required bool visible}) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 200),
      opacity: visible ? 1.0 : 0.0,
      child: GestureDetector(
        onTap: visible ? onTap : null,
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4)),
            ],
          ),
          child: Icon(icon, color: AppColors.primary, size: 20),
        ),
      ),
    );
  }
}

class DoaContent {
  final String title;
  final String arabic;
  final String latin;
  final String translation;
  final String image;
  final String tip;

  DoaContent({
    required this.title,
    required this.arabic,
    required this.latin,
    required this.translation,
    required this.image,
    required this.tip,
  });
}
