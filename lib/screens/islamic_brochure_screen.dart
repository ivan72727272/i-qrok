import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import '../constants/app_constants.dart';
import '../widgets/islamic_decor.dart';
import '../widgets/empty_state.dart';
import '../widgets/loading_screen.dart';
import '../utils/asset_loader_service.dart';
import 'premium_doa_detail_screen.dart';

// ─────────────────────────────────────────────────────
//  Reusable screen for any Islamic brochure category
// ─────────────────────────────────────────────────────
class IslamicBrochureScreen extends StatefulWidget {
  final String folder;
  final String appBarTitle;
  final String appBarSubtitle;
  final String categoryIcon;
  final Color accentColor;

  const IslamicBrochureScreen({
    super.key,
    required this.folder,
    required this.appBarTitle,
    required this.appBarSubtitle,
    required this.categoryIcon,
    required this.accentColor,
  });

  @override
  State<IslamicBrochureScreen> createState() => _IslamicBrochureScreenState();
}

class _IslamicBrochureScreenState extends State<IslamicBrochureScreen>
    with SingleTickerProviderStateMixin {
  List<String> _assets = [];
  bool _isLoading = true;
  late AnimationController _entryCtrl;
  late Animation<double> _entryAnim;

  static const List<List<Color>> _cardGradients = [
    [Color(0xFFB2EBF2), Color(0xFF4DD0E1)],
    [Color(0xFFC8E6C9), Color(0xFF66BB6A)],
    [Color(0xFFFFE0B2), Color(0xFFFFB74D)],
    [Color(0xFFE1BEE7), Color(0xFFBA68C8)],
    [Color(0xFFFFCDD2), Color(0xFFEF9A9A)],
    [Color(0xFFFFF9C4), Color(0xFFFFF176)],
    [Color(0xFFB3E5FC), Color(0xFF29B6F6)],
    [Color(0xFFD7CCC8), Color(0xFF8D6E63)],
    [Color(0xFFDCEDC8), Color(0xFFAED581)],
    [Color(0xFFF8BBD0), Color(0xFFF06292)],
    [Color(0xFFCFD8DC), Color(0xFF78909C)],
    [Color(0xFFFFE0B2), Color(0xFFFF8A65)],
  ];

  static const List<Color> _shadowColors = [
    Color(0xFF4DD0E1), Color(0xFF66BB6A), Color(0xFFFFB74D),
    Color(0xFFBA68C8), Color(0xFFEF9A9A), Color(0xFFFFF176),
    Color(0xFF29B6F6), Color(0xFF8D6E63), Color(0xFFAED581),
    Color(0xFFF06292), Color(0xFF78909C), Color(0xFFFF8A65),
  ];

  @override
  void initState() {
    super.initState();
    _entryCtrl = AnimationController(duration: const Duration(milliseconds: 700), vsync: this);
    _entryAnim = CurvedAnimation(parent: _entryCtrl, curve: Curves.easeOut);
    _load();
  }

  @override
  void dispose() {
    _entryCtrl.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final found = await AssetLoaderService.loadImagesFromFolder(widget.folder);
    if (mounted) {
      setState(() {
        _assets = found;
        _isLoading = false;
      });
      _entryCtrl.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Soft background blobs
          Positioned(top: -50, left: -50,
            child: Container(width: 200, height: 200,
              decoration: BoxDecoration(color: widget.accentColor.withOpacity(0.07), shape: BoxShape.circle))),
          Positioned(bottom: 100, right: -60,
            child: Container(width: 180, height: 180,
              decoration: BoxDecoration(color: widget.accentColor.withOpacity(0.05), shape: BoxShape.circle))),
          
          // Background Illustrations (Low Opacity)
          Positioned(
            bottom: 20, left: -20,
            child: Opacity(opacity: 0.04, child: Icon(Icons.mosque_rounded, size: 180, color: widget.accentColor)),
          ),
          Positioned(
            top: 150, right: 10,
            child: Opacity(opacity: 0.05, child: Icon(Icons.wb_twilight_rounded, size: 60, color: widget.accentColor)),
          ),
          Positioned(
            bottom: 250, left: 30,
            child: Opacity(opacity: 0.03, child: Icon(Icons.menu_book_rounded, size: 80, color: widget.accentColor)),
          ),

          const FloatingStars(),
          // Header
          Column(
            children: [
              _buildHeader(context),
              Expanded(
                child: _isLoading
                    ? LittleMuslimLoading(message: 'Sedang memuat ${widget.appBarTitle}...')
                    : _assets.isEmpty
                        ? _buildEmptyState()
                        : _buildGrid(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF6BCB77), Color(0xFF4D96FF)], // Premium standard
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(AppRadius.xl),
          bottomRight: Radius.circular(AppRadius.xl),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4D96FF).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            // Decorative circles
            Positioned(top: -15, right: -15,
              child: Container(width: 90, height: 90,
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), shape: BoxShape.circle))),
            // Cloud decor
            Positioned(bottom: -10, left: 100,
              child: Opacity(opacity: 0.1, child: Icon(Icons.cloud_rounded, size: 60, color: Colors.white))),
            // Floating stars
            const Positioned(top: 8, right: 60,
              child: FloatingStarSingle(size: 16, color: Colors.white)),
            const Positioned(top: 30, right: 30,
              child: FloatingStarSingle(size: 11, color: Colors.white)),
            
            Padding(
              padding: const EdgeInsets.fromLTRB(AppSpacing.sm, AppSpacing.sm, AppSpacing.lg, 24),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Back button
                  Material(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                      onTap: () { HapticFeedback.lightImpact(); Navigator.pop(context); },
                      child: const Padding(
                        padding: EdgeInsets.all(10),
                        child: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${widget.categoryIcon}  ${widget.appBarTitle}',
                          style: const TextStyle(
                            fontSize: 22, fontWeight: FontWeight.w900,
                            color: Colors.white,
                            shadows: [Shadow(color: Colors.black26, blurRadius: 4)],
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          widget.appBarSubtitle,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white.withOpacity(0.9),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Count badge
                  if (!_isLoading && _assets.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.25),
                        borderRadius: BorderRadius.circular(AppRadius.full),
                      ),
                      child: Text(
                        '${_assets.length} Item',
                        style: const TextStyle(
                          fontSize: 11, fontWeight: FontWeight.w800, color: Colors.white),
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

  Widget _buildEmptyState() {
    return EmptyState(
      title: 'Wah, Belum Ada ${widget.appBarTitle}!',
      message: 'Sepertinya belum ada gambar yang dimasukkan ke folder ${widget.folder}. Ayo tambahkan sekarang! 😊',
      mascotType: widget.folder.contains('cerita') ? 'Cerita' : 'Doa',
    );
  }

  Widget _buildGrid() {
    return GridView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(AppSpacing.lg),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
        childAspectRatio: 0.75,
      ),
      itemCount: _assets.length,
      itemBuilder: (context, index) {
        final path = _assets[index];
        final title = AssetLoaderService.extractTitleFromPath(path);
        final gradients = _cardGradients[index % _cardGradients.length];
        final shadow = _shadowColors[index % _shadowColors.length];
        return _BrochureCard(
          assetPath: path,
          title: title,
          gradients: gradients,
          shadowColor: shadow,
          categoryIcon: widget.categoryIcon,
          accentColor: widget.accentColor,
          index: index,
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────
//  Individual animated brochure card
// ─────────────────────────────────────────────────────
class _BrochureCard extends StatefulWidget {
  final String assetPath;
  final String title;
  final List<Color> gradients;
  final Color shadowColor;
  final String categoryIcon;
  final Color accentColor;
  final int index;

  const _BrochureCard({
    required this.assetPath,
    required this.title,
    required this.gradients,
    required this.shadowColor,
    required this.categoryIcon,
    required this.accentColor,
    required this.index,
  });

  @override
  State<_BrochureCard> createState() => _BrochureCardState();
}

class _BrochureCardState extends State<_BrochureCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scaleAnim;
  late Animation<double> _entryAnim;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(duration: const Duration(milliseconds: 500), vsync: this);
    _scaleAnim = Tween<double>(begin: 0.85, end: 1.0)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutBack));
    _entryAnim = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
    Future.delayed(Duration(milliseconds: 60 + widget.index * 70), () {
      if (mounted) _ctrl.forward();
    });
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  void _navigate() {
    HapticFeedback.lightImpact();
    
    // Check if we should use the new Premium UI for Doa
    final isDoaFolder = widget.assetPath.contains('/doa/');
    
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, anim, __) {
          if (isDoaFolder) {
            return PremiumDoaDetailScreen(
              title: widget.title,
              imagePath: widget.assetPath,
            );
          }
          return IslamicBrochureDetailScreen(
            assetPath: widget.assetPath,
            title: widget.title,
            accentColor: widget.accentColor,
            categoryIcon: widget.categoryIcon,
          );
        },
        transitionsBuilder: (_, anim, __, child) => FadeTransition(
          opacity: anim,
          child: SlideTransition(
            position: Tween<Offset>(begin: const Offset(0, 0.06), end: Offset.zero).animate(anim),
            child: child,
          ),
        ),
        transitionDuration: const Duration(milliseconds: 350),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, child) => FadeTransition(
        opacity: _entryAnim,
        child: ScaleTransition(scale: _scaleAnim, child: child),
      ),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) { setState(() => _isPressed = false); _navigate(); },
        onTapCancel: () => setState(() => _isPressed = false),
        child: AnimatedScale(
          scale: _isPressed ? 0.95 : 1.0,
          duration: const Duration(milliseconds: 120),
          curve: Curves.easeOut,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadius.xl),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: widget.gradients,
              ),
              boxShadow: [
                BoxShadow(
                  color: widget.shadowColor.withOpacity(_isPressed ? 0.45 : 0.25),
                  blurRadius: _isPressed ? 20 : 12,
                  offset: const Offset(0, 6),
                  spreadRadius: _isPressed ? 2 : 0,
                ),
              ],
              border: Border.all(color: Colors.white.withOpacity(0.6), width: 1.5),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.xl),
              child: Stack(
                children: [
                  // Bubble top-right
                  Positioned(top: -18, right: -18,
                    child: Container(width: 60, height: 60,
                      decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), shape: BoxShape.circle))),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Thumbnail
                      Expanded(
                        flex: 5,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.asset(
                              widget.assetPath,
                              fit: BoxFit.cover,
                              cacheWidth: 300,
                              errorBuilder: (_, __, ___) => Container(
                                color: widget.gradients[0].withOpacity(0.3),
                                child: Center(
                                  child: Text(widget.categoryIcon,
                                    style: const TextStyle(fontSize: 48)),
                                ),
                              ),
                            ),
                            // Gradient overlay at bottom
                            Positioned(bottom: 0, left: 0, right: 0,
                              child: Container(
                                height: 40,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                    colors: [widget.gradients[1].withOpacity(0.5), Colors.transparent],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Label area
                      Container(
                        padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.85),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              widget.title,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                                color: widget.shadowColor.withOpacity(0.9),
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(colors: widget.gradients),
                                    borderRadius: BorderRadius.circular(AppRadius.full),
                                  ),
                                  child: const Text('Buka →',
                                    style: TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: Colors.white)),
                                ),
                                const Spacer(),
                                Icon(Icons.bookmark_rounded,
                                  size: 14, color: widget.shadowColor.withOpacity(0.5)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────
//  Full-screen detail with modern Islamic styling
// ─────────────────────────────────────────────────────
// ─────────────────────────────────────────────────────
//  Full-screen detail with modern Islamic styling
// ─────────────────────────────────────────────────────
class IslamicBrochureDetailScreen extends StatefulWidget {
  final String assetPath;
  final String title;
  final Color accentColor;
  final String categoryIcon;

  const IslamicBrochureDetailScreen({
    super.key,
    required this.assetPath,
    required this.title,
    required this.accentColor,
    required this.categoryIcon,
  });

  @override
  State<IslamicBrochureDetailScreen> createState() => _IslamicBrochureDetailScreenState();
}

class _IslamicBrochureDetailScreenState extends State<IslamicBrochureDetailScreen>
    with TickerProviderStateMixin {
  bool _isPressed = false;
  late AnimationController _sparkleCtrl;
  late AnimationController _floatCtrl;

  @override
  void initState() {
    super.initState();
    _sparkleCtrl = AnimationController(duration: const Duration(seconds: 3), vsync: this)..repeat();
    _floatCtrl = AnimationController(duration: const Duration(seconds: 4), vsync: this)..repeat(reverse: true);
  }

  @override
  void dispose() {
    _sparkleCtrl.dispose();
    _floatCtrl.dispose();
    super.dispose();
  }

  _PrayerDetailTheme _getTheme() {
    final t = widget.title.toLowerCase();
    if (t.contains('masjid') || t.contains('wudhu')) {
      return _PrayerDetailTheme(
        subtitle: 'Yuk, berdoa saat beribadah di masjid ✨',
        description: 'Berdoa di masjid membawa keberkahan. Jangan lupa baca doa ini agar langkahmu selalu dijaga Allah SWT.',
        gradient: [const Color(0xFFE0F7FA), const Color(0xFFB2EBF2), const Color(0xFF80DEEA)],
        bgDecor: [Icons.mosque_rounded, Icons.wb_twilight_rounded],
        themeColor: const Color(0xFF4DD0E1),
        bottomIcon: Icons.mosque_rounded,
        characterAsset: 'assets/images/mascot_muslim_boy.png',
      );
    } else if (t.contains('tidur')) {
      return _PrayerDetailTheme(
        subtitle: 'Tidur jadi lebih tenang dengan doa 🌙',
        description: 'Membaca doa sebelum tidur menjauhkan kita dari mimpi buruk dan membuat istirahat kita dijaga oleh para Malaikat.',
        gradient: [const Color(0xFFE8EAF6), const Color(0xFFC5CAE9), const Color(0xFF9FA8DA)],
        bgDecor: [Icons.brightness_3_rounded, Icons.star_rounded],
        themeColor: const Color(0xFF7986CB),
        bottomIcon: Icons.nights_stay_rounded,
        characterAsset: 'assets/images/mascot_muslim_boy.png',
      );
    } else if (t.contains('makan')) {
      return _PrayerDetailTheme(
        subtitle: 'Belajar adab makan bersama 😊',
        description: 'Makan dengan doa membuat makanan kita menjadi berkah dan tubuh kita menjadi kuat untuk beribadah.',
        gradient: [const Color(0xFFFFF3E0), const Color(0xFFFFE0B2), const Color(0xFFFFCC80)],
        bgDecor: [Icons.restaurant_rounded, Icons.fastfood_rounded],
        themeColor: const Color(0xFFFFB74D),
        bottomIcon: Icons.flatware_rounded,
        characterAsset: 'assets/images/mascot_muslim_girl.png',
      );
    } else if (t.contains('orang tua')) {
      return _PrayerDetailTheme(
        subtitle: 'Sayangi ayah dan ibu lewat doa ❤️',
        description: 'Doa untuk orang tua adalah bukti cinta kita. Semoga Allah selalu menyayangi mereka seperti mereka menyayangi kita.',
        gradient: [const Color(0xFFFFEBEE), const Color(0xFFFFCDD2), const Color(0xFFEF9A9A)],
        bgDecor: [Icons.favorite_rounded, Icons.auto_awesome_rounded],
        themeColor: const Color(0xFFE57373),
        bottomIcon: Icons.family_restroom_rounded,
        characterAsset: 'assets/images/mascot_muslim_girl.png',
      );
    }
    return _PrayerDetailTheme(
      subtitle: 'Belajar dengan penuh semangat 🌟',
      description: 'Mari amalkan doa ini dalam setiap kegiatanmu agar Allah selalu memberikan kemudahan dan pahala yang melimpah.',
      gradient: [const Color(0xFFF1F8E9), const Color(0xFFDCEDC8), const Color(0xFFC5E1A5)],
      bgDecor: [Icons.auto_awesome_rounded, Icons.wb_sunny_rounded],
      themeColor: const Color(0xFF8BC34A),
      bottomIcon: Icons.menu_book_rounded,
      characterAsset: 'assets/images/mascot_muslim_boy.png',
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = _getTheme();
    
    return Scaffold(
      backgroundColor: const Color(0xFFF9FBF9),
      body: Stack(
        children: [
          // ─── Background Pattern ───────────────────────────────────────────
          Positioned.fill(
            child: Opacity(
              opacity: 0.03,
              child: Image.asset('assets/images/cute_decorations.png', repeat: ImageRepeat.repeat, scale: 2),
            ),
          ),

          // ─── Floating Elements ────────────────────────────────────────────
          ...List.generate(8, (i) => _buildFloatingDecor(i, theme.themeColor)),

          // ─── Main Scrollable Area ─────────────────────────────────────────
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // ─── Organic Curved Header ─────────────────────────────────────
              SliverToBoxAdapter(
                child: _buildOrganicHeader(context, theme),
              ),

              // ─── Main Content Card ─────────────────────────────────────────
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    _buildMainStoryCard(theme),
                    const SizedBox(height: 30),
                    _buildInteractiveExplainer(theme),
                  ]),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOrganicHeader(BuildContext context, _PrayerDetailTheme theme) {
    return Container(
      height: 240,
      child: Stack(
        children: [
          // Curved Background
          ClipPath(
            clipper: _HeaderClipper(),
            child: Container(
              height: 220,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [theme.gradient[0], theme.gradient[2]],
                ),
                boxShadow: [
                  BoxShadow(
                    color: theme.themeColor.withOpacity(0.2),
                    blurRadius: 30,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
            ),
          ),

          // Glowing effect
          Positioned(
            top: -20, right: -20,
            child: Container(
              width: 150, height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [BoxShadow(color: Colors.white.withOpacity(0.4), blurRadius: 80)],
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
                        borderRadius: BorderRadius.circular(20),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(20),
                          onTap: () { HapticFeedback.lightImpact(); Navigator.pop(context); },
                          child: const Padding(
                            padding: EdgeInsets.all(10),
                            child: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 22),
                          ),
                        ),
                      ),
                      const Spacer(),
                      // Floating Mascot
                      AnimatedBuilder(
                        animation: _floatCtrl,
                        builder: (context, child) {
                          return Transform.translate(
                            offset: Offset(0, 5 * sin(_floatCtrl.value * 2 * pi)),
                            child: child,
                          );
                        },
                        child: Container(
                          height: 80,
                          child: Image.asset(theme.characterAsset, fit: BoxFit.contain),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Text(
                    widget.title,
                    style: const TextStyle(
                      fontSize: 28, fontWeight: FontWeight.w900,
                      color: Colors.white,
                      shadows: [
                        Shadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 2)),
                      ],
                    ),
                  ),
                  Text(
                    theme.subtitle,
                    style: TextStyle(
                      fontSize: 13, color: Colors.white.withOpacity(0.95),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Floating Mini Decor
          Positioned(
            bottom: 30, right: 80,
            child: Opacity(opacity: 0.6, child: Icon(Icons.wb_sunny_rounded, color: Colors.white, size: 32)),
          ),
          Positioned(
            bottom: 50, left: 140,
            child: Opacity(opacity: 0.4, child: Icon(Icons.cloud_rounded, color: Colors.white, size: 40)),
          ),
        ],
      ),
    );
  }

  Widget _buildMainStoryCard(_PrayerDetailTheme theme) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(40),
        boxShadow: [
          BoxShadow(
            color: theme.themeColor.withOpacity(0.1),
            blurRadius: 40,
            offset: const Offset(0, 20),
            spreadRadius: 5,
          ),
        ],
      ),
      child: CustomPaint(
        painter: _DashedPainter(color: theme.themeColor.withOpacity(0.2)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              // The Poster / Image Area
              Hero(
                tag: widget.assetPath,
                child: Container(
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(32),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: AspectRatio(
                    aspectRatio: 0.85,
                    child: Stack(
                      children: [
                        Image.asset(
                          widget.assetPath,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => _buildFallback(context),
                        ),
                        // Soft Light Overlay
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Colors.white.withOpacity(0.1), Colors.transparent],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),
              
              // Decorative Sparkle
              Icon(Icons.auto_awesome_rounded, color: theme.themeColor.withOpacity(0.3), size: 24),
              
              const SizedBox(height: 16),
              
              // Text Content Area
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    _buildTextSection('Arabic', '✨', widget.title, theme),
                    const SizedBox(height: 20),
                    _buildTextSection('Latin', '📖', 'Klik poster untuk melihat detail', theme),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextSection(String label, String icon, String content, _PrayerDetailTheme theme) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: theme.themeColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(icon, style: const TextStyle(fontSize: 12)),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11, fontWeight: FontWeight.w900,
                  color: theme.themeColor,
                  letterSpacing: 1.0,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Text(
          content,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 15, fontWeight: FontWeight.w700,
            color: theme.themeColor.withOpacity(0.8),
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildInteractiveExplainer(_PrayerDetailTheme theme) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.gradient[0].withOpacity(0.6),
        borderRadius: BorderRadius.circular(35),
        border: Border.all(color: Colors.white, width: 3),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
            child: Icon(theme.bottomIcon, color: theme.themeColor, size: 30),
          ),
          const SizedBox(height: 20),
          Text(
            'Tahukah Kamu?',
            style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.w900,
              color: theme.themeColor,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            theme.description,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14, fontWeight: FontWeight.w600,
              color: theme.themeColor.withOpacity(0.7),
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingDecor(int i, Color color) {
    final rand = Random(i);
    return AnimatedBuilder(
      animation: _sparkleCtrl,
      builder: (context, child) {
        final val = (_sparkleCtrl.value + i * 0.1) % 1.0;
        return Positioned(
          top: rand.nextDouble() * 800,
          left: rand.nextDouble() * 400,
          child: Opacity(
            opacity: sin(val * pi) * 0.4,
            child: Icon(
              i % 2 == 0 ? Icons.star_rounded : Icons.auto_awesome_rounded,
              size: 10 + rand.nextDouble() * 15,
              color: color.withOpacity(0.3),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFallback(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(widget.categoryIcon, style: const TextStyle(fontSize: 64)),
            const SizedBox(height: 12),
            const Text('Memuat poster lucu...', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black26)),
          ],
        ),
      ),
    );
  }
}

class _HeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 50);
    var firstControlPoint = Offset(size.width / 4, size.height);
    var firstEndPoint = Offset(size.width / 2, size.height - 30);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy, firstEndPoint.dx, firstEndPoint.dy);
    var secondControlPoint = Offset(size.width - (size.width / 4), size.height - 60);
    var secondEndPoint = Offset(size.width, size.height - 20);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy, secondEndPoint.dx, secondEndPoint.dy);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }
  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class _DashedPainter extends CustomPainter {
  final Color color;
  _DashedPainter({required this.color});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color..strokeWidth = 2..style = PaintingStyle.stroke;
    final path = Path()..addRRect(RRect.fromRectAndRadius(Rect.fromLTWH(0, 0, size.width, size.height), const Radius.circular(40)));
    var dashWidth = 8.0, dashSpace = 8.0, distance = 0.0;
    for (var pathMetric in path.computeMetrics()) {
      while (distance < pathMetric.length) {
        canvas.drawPath(pathMetric.extractPath(distance, distance + dashWidth), paint);
        distance += dashWidth + dashSpace;
      }
      distance = 0.0;
    }
  }
  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class _PrayerDetailTheme {
  final String subtitle;
  final String description;
  final List<Color> gradient;
  final List<IconData> bgDecor;
  final Color themeColor;
  final IconData bottomIcon;
  final String characterAsset;

  _PrayerDetailTheme({
    required this.subtitle,
    required this.description,
    required this.gradient,
    required this.bgDecor,
    required this.themeColor,
    required this.bottomIcon,
    required this.characterAsset,
  });
}

