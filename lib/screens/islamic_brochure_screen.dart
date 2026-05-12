import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_constants.dart';
import '../widgets/islamic_decor.dart';
import '../widgets/empty_state.dart';
import '../widgets/loading_screen.dart';
import '../utils/asset_loader_service.dart';

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
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, anim, __) => IslamicBrochureDetailScreen(
          assetPath: widget.assetPath,
          title: widget.title,
          accentColor: widget.accentColor,
          categoryIcon: widget.categoryIcon,
        ),
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

  @override
  void initState() {
    super.initState();
    _sparkleCtrl = AnimationController(duration: const Duration(seconds: 3), vsync: this)..repeat();
  }

  @override
  void dispose() {
    _sparkleCtrl.dispose();
    super.dispose();
  }

  // ─── Dynamic Theme Logic ──────────────────────────────────────────────────
  _PrayerDetailTheme _getTheme() {
    final t = widget.title.toLowerCase();
    if (t.contains('masjid') || t.contains('wudhu')) {
      return _PrayerDetailTheme(
        subtitle: 'Yuk, berdoa saat beribadah di masjid ✨',
        description: 'Berdoa di masjid membawa keberkahan. Jangan lupa baca doa ini agar langkahmu selalu dijaga Allah SWT.',
        gradient: [const Color(0xFF6BCB77), const Color(0xFF4D96FF)],
        bgDecor: [Icons.mosque_rounded, Icons.wb_twilight_rounded],
        themeColor: const Color(0xFF4D96FF),
        bottomIcon: Icons.mosque_rounded,
      );
    } else if (t.contains('tidur')) {
      return _PrayerDetailTheme(
        subtitle: 'Tidur jadi lebih tenang dengan doa 🌙',
        description: 'Membaca doa sebelum tidur menjauhkan kita dari mimpi buruk dan membuat istirahat kita dijaga oleh para Malaikat.',
        gradient: [const Color(0xFF7B61FF), const Color(0xFF1A1C2E)],
        bgDecor: [Icons.brightness_3_rounded, Icons.star_rounded],
        themeColor: const Color(0xFF7B61FF),
        bottomIcon: Icons.nights_stay_rounded,
      );
    } else if (t.contains('makan')) {
      return _PrayerDetailTheme(
        subtitle: 'Belajar adab makan bersama 😊',
        description: 'Makan dengan doa membuat makanan kita menjadi berkah dan tubuh kita menjadi kuat untuk beribadah.',
        gradient: [const Color(0xFFFF9F45), const Color(0xFFFFD93D)],
        bgDecor: [Icons.restaurant_rounded, Icons.fastfood_rounded],
        themeColor: const Color(0xFFFF9F45),
        bottomIcon: Icons.flatware_rounded,
      );
    } else if (t.contains('orang tua')) {
      return _PrayerDetailTheme(
        subtitle: 'Sayangi ayah dan ibu lewat doa ❤️',
        description: 'Doa untuk orang tua adalah bukti cinta kita. Semoga Allah selalu menyayangi mereka seperti mereka menyayangi kita.',
        gradient: [const Color(0xFFFF8A80), const Color(0xFFC77DFF)],
        bgDecor: [Icons.favorite_rounded, Icons.auto_awesome_rounded],
        themeColor: const Color(0xFFFF8A80),
        bottomIcon: Icons.family_restroom_rounded,
      );
    }
    // Default
    return _PrayerDetailTheme(
      subtitle: 'Belajar dengan penuh semangat 🌟',
      description: 'Mari amalkan doa ini dalam setiap kegiatanmu agar Allah selalu memberikan kemudahan dan pahala yang melimpah.',
      gradient: [const Color(0xFF6BCB77), const Color(0xFFFFD93D)],
      bgDecor: [Icons.auto_awesome_rounded, Icons.wb_sunny_rounded],
      themeColor: widget.accentColor,
      bottomIcon: Icons.menu_book_rounded,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = _getTheme();
    
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // ─── Background Decor ──────────────────────────────────────────────
          Positioned(top: -40, left: -40,
            child: Container(width: 250, height: 250,
              decoration: BoxDecoration(color: theme.themeColor.withOpacity(0.06), shape: BoxShape.circle))),
          Positioned(bottom: 50, right: -60,
            child: Container(width: 200, height: 200,
              decoration: BoxDecoration(color: theme.themeColor.withOpacity(0.04), shape: BoxShape.circle))),
          
          // Background Dynamic Icons
          Positioned(top: 150, right: 20, 
            child: Opacity(opacity: 0.05, child: Icon(theme.bgDecor[0], size: 60, color: theme.themeColor))),
          Positioned(bottom: 150, left: 20, 
            child: Opacity(opacity: 0.04, child: Icon(theme.bgDecor[1], size: 100, color: theme.themeColor))),
          
          FloatingStars(color: theme.themeColor.withOpacity(0.3)),
          
          // Floating Sparkles
          ...List.generate(5, (i) => _buildSparkle(i)),

          // ─── Main Content ──────────────────────────────────────────────────
          Column(
            children: [
              _buildDetailHeader(context, theme),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 40),
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      // Poster with Interaction
                      GestureDetector(
                        onTapDown: (_) => setState(() => _isPressed = true),
                        onTapUp: (_) => setState(() => _isPressed = false),
                        onTapCancel: () => setState(() => _isPressed = false),
                        child: AnimatedScale(
                          scale: _isPressed ? 0.98 : 1.0,
                          duration: const Duration(milliseconds: 200),
                          child: Hero(
                            tag: widget.assetPath,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(32),
                                border: Border.all(color: Colors.white, width: 10), // Frame Putih Creamy
                                boxShadow: [
                                  BoxShadow(
                                    color: theme.themeColor.withOpacity(0.15),
                                    blurRadius: 40,
                                    offset: const Offset(0, 15),
                                    spreadRadius: 2,
                                  ),
                                  if (_isPressed)
                                    BoxShadow(
                                      color: theme.themeColor.withOpacity(0.2),
                                      blurRadius: 20,
                                      spreadRadius: 5,
                                    ),
                                ],
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(22),
                                child: Image.asset(
                                  widget.assetPath,
                                  fit: BoxFit.contain,
                                  errorBuilder: (_, __, ___) => _buildFallback(context),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 32),
                      
                      // Hint Label
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(AppRadius.full),
                          boxShadow: [
                            BoxShadow(color: theme.themeColor.withOpacity(0.05), blurRadius: 10),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.auto_awesome_rounded, size: 14, color: theme.themeColor.withOpacity(0.5)),
                            const SizedBox(width: 8),
                            Text(
                              'MasyaAllah! Ayo Diamalkan ✨',
                              style: TextStyle(
                                fontSize: 12, 
                                fontWeight: FontWeight.w800, 
                                color: theme.themeColor.withOpacity(0.7),
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Bottom Explanation Card
                      _buildBottomCard(theme),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSparkle(int index) {
    final rand = Random(index);
    final top = 100.0 + rand.nextDouble() * 500;
    final left = rand.nextDouble() * 300;
    
    return AnimatedBuilder(
      animation: _sparkleCtrl,
      builder: (context, child) {
        final offset = sin((_sparkleCtrl.value * 2 * pi) + (index * 0.5)) * 10;
        return Positioned(
          top: top + offset,
          left: left,
          child: Opacity(
            opacity: (0.3 + sin(_sparkleCtrl.value * pi) * 0.4).clamp(0, 1),
            child: Icon(Icons.auto_awesome_rounded, size: 12 + rand.nextDouble() * 10, color: Colors.white.withOpacity(0.5)),
          ),
        );
      },
    );
  }

  Widget _buildBottomCard(_PrayerDetailTheme theme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: theme.themeColor.withOpacity(0.1), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: theme.themeColor.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.themeColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(theme.bottomIcon, color: theme.themeColor, size: 28),
          ),
          const SizedBox(height: 16),
          Text(
            widget.title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: theme.themeColor.withOpacity(0.9),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            theme.description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textDim,
              fontWeight: FontWeight.w600,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailHeader(BuildContext context, _PrayerDetailTheme theme) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: theme.gradient,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
        boxShadow: [
          BoxShadow(
            color: theme.themeColor.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            // Decor Sparkles
            Positioned(top: -10, right: 20, child: FloatingStarSingle(size: 20, color: Colors.white)),
            Positioned(top: 30, right: 60, child: FloatingStarSingle(size: 14, color: Colors.white)),
            Positioned(bottom: -15, left: 40, child: Opacity(opacity: 0.1, child: Icon(Icons.cloud_rounded, size: 70, color: Colors.white))),
            
            Padding(
              padding: const EdgeInsets.fromLTRB(AppSpacing.sm, AppSpacing.sm, AppSpacing.lg, 24),
              child: Row(
                children: [
                  // Back Button
                  Material(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () { HapticFeedback.lightImpact(); Navigator.pop(context); },
                      child: const Padding(
                        padding: EdgeInsets.all(12),
                        child: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          widget.title,
                          style: const TextStyle(
                            fontSize: 20, 
                            fontWeight: FontWeight.w900, 
                            color: Colors.white,
                            shadows: [Shadow(color: Colors.black26, blurRadius: 4)],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          theme.subtitle,
                          style: TextStyle(
                            fontSize: 11, 
                            color: Colors.white.withOpacity(0.9), 
                            fontWeight: FontWeight.w600,
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

  Widget _buildFallback(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 300,
      color: widget.accentColor.withOpacity(0.1),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(widget.categoryIcon, style: const TextStyle(fontSize: 64)),
            const SizedBox(height: 12),
            const Text('Gambar tidak tersedia', 
              style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textDim)),
          ],
        ),
      ),
    );
  }
}

class _PrayerDetailTheme {
  final String subtitle;
  final String description;
  final List<Color> gradient;
  final List<IconData> bgDecor;
  final Color themeColor;
  final IconData bottomIcon;

  _PrayerDetailTheme({
    required this.subtitle,
    required this.description,
    required this.gradient,
    required this.bgDecor,
    required this.themeColor,
    required this.bottomIcon,
  });
}

