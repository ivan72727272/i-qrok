import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/islamic_decor.dart';
import '../utils/asset_loader_service.dart';

// ─────────────────────────────────────────────────────
//  Reusable screen for any Islamic brochure category
//  Usage: IslamicBrochureScreen(folder, title, subtitle, icon, color)
// ─────────────────────────────────────────────────────
class IslamicBrochureScreen extends StatefulWidget {
  final String folder;          // e.g. 'assets/images/doa/'
  final String appBarTitle;
  final String appBarSubtitle;
  final String categoryIcon;    // emoji
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

class _IslamicBrochureScreenState extends State<IslamicBrochureScreen> {
  List<String> _assets = [];
  bool _isLoading = true;

  // Pastel color palette cycling
  static const List<Color> _palette = [
    Color(0xFF66BB6A), Color(0xFF42A5F5), Color(0xFFFFA726),
    Color(0xFFAB47BC), Color(0xFFEF5350), Color(0xFF26C6DA),
    Color(0xFF7E57C2), Color(0xFF8D6E63), Color(0xFFEC407A),
    Color(0xFF43A047), Color(0xFF29B6F6), Color(0xFFE91E63),
  ];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final found = await AssetLoaderService.loadImagesFromFolder(widget.folder);
    if (mounted) {
      setState(() {
        _assets = found;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: widget.appBarTitle,
        subtitle: widget.appBarSubtitle,
      ),
      body: Stack(
        children: [
          const FloatingStars(),
          if (_isLoading)
            const Center(child: CircularProgressIndicator())
          else if (_assets.isEmpty)
            _buildEmptyState()
          else
            _buildGrid(),
        ],
      ),
    );
  }

  // ── Empty state ──────────────────────────────────────
  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(widget.categoryIcon, style: const TextStyle(fontSize: 72)),
            const SizedBox(height: 20),
            Text(
              widget.appBarTitle,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                color: widget.accentColor,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppRadius.xl),
                boxShadow: [
                  BoxShadow(
                    color: widget.accentColor.withValues(alpha: 0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Icon(Icons.add_photo_alternate_rounded,
                      size: 48, color: widget.accentColor),
                  const SizedBox(height: 12),
                  const Text(
                    'Belum ada konten 😊',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textMain,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tambahkan gambar brosur ke:\n${widget.folder}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textDim,
                      fontFamily: 'monospace',
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Contoh:\ndoa_makan.png\ndoa_tidur.png',
                    style: TextStyle(
                      fontSize: 11,
                      color: widget.accentColor,
                      fontStyle: FontStyle.italic,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Grid of brochure cards ────────────────────────────
  Widget _buildGrid() {
    return GridView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(AppSpacing.lg),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
        childAspectRatio: 0.72,
      ),
      itemCount: _assets.length,
      itemBuilder: (context, index) {
        final path = _assets[index];
        final title = AssetLoaderService.extractTitleFromPath(path);
        final color = _palette[index % _palette.length];
        return _BrochureCard(
          assetPath: path,
          title: title,
          color: color,
          categoryIcon: widget.categoryIcon,
          accentColor: widget.accentColor,
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────
//  Individual brochure card widget
// ─────────────────────────────────────────────────────
class _BrochureCard extends StatelessWidget {
  final String assetPath;
  final String title;
  final Color color;
  final String categoryIcon;
  final Color accentColor;

  const _BrochureCard({
    required this.assetPath,
    required this.title,
    required this.color,
    required this.categoryIcon,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(AppRadius.xl),
      elevation: 0,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.xl),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => IslamicBrochureDetailScreen(
              assetPath: assetPath,
              title: title,
              accentColor: accentColor,
              categoryIcon: categoryIcon,
            ),
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.xl),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.13),
                blurRadius: 14,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.xl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ── Thumbnail ────────────────────────
                Expanded(
                  child: Image.asset(
                    assetPath,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: color.withValues(alpha: 0.1),
                      child: Center(
                        child: Text(
                          categoryIcon,
                          style: const TextStyle(fontSize: 48),
                        ),
                      ),
                    ),
                  ),
                ),
                // ── Label bar ────────────────────────
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm, vertical: AppSpacing.sm),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textMain,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.12),
                          borderRadius:
                              BorderRadius.circular(AppRadius.full),
                        ),
                        child: Text(
                          '📖 Buka',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: color,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────
//  Full-screen detail with zoom + fallback
// ─────────────────────────────────────────────────────
class IslamicBrochureDetailScreen extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: accentColor,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.fullscreen_rounded),
            tooltip: 'Perbesar',
            onPressed: () {},
          ),
        ],
      ),
      body: InteractiveViewer(
        minScale: 0.5,
        maxScale: 5.0,
        child: Center(
          child: Image.asset(
            assetPath,
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) => _buildFallback(context),
          ),
        ),
      ),
    );
  }

  Widget _buildFallback(BuildContext context) {
    return Container(
      color: AppColors.background,
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(categoryIcon, style: const TextStyle(fontSize: 80)),
          const SizedBox(height: 24),
          Text(
            title,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: accentColor,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 40),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(AppRadius.xl),
            ),
            child: Column(
              children: [
                Icon(Icons.broken_image_rounded, size: 48, color: accentColor),
                const SizedBox(height: 12),
                const Text(
                  'Brosur belum tersedia 😊',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textMain,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  assetPath,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textDim,
                    fontFamily: 'monospace',
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
