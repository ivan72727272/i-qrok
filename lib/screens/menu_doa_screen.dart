import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/islamic_decor.dart';
import '../utils/asset_loader_service.dart';

// ─────────────────────────────────────────────
//  Data model for each doa entry
// ─────────────────────────────────────────────
class _DoaItem {
  final String title;
  final String subtitle;
  final String icon;
  final String assetPath; // auto-mapped from title
  final Color color;

  const _DoaItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.assetPath,
    required this.color,
  });
}

// ─────────────────────────────────────────────
//  Helper: title → snake_case asset filename
// ─────────────────────────────────────────────
String _titleToAsset(String title) {
  final slug = title
      .toLowerCase()
      .replaceAll(RegExp(r'\s+'), '_')
      .replaceAll(RegExp(r'[^a-z0-9_]'), '');
  return 'assets/images/doa/$slug.png';
}

// ─────────────────────────────────────────────
//  Static doa list
// ─────────────────────────────────────────────
final List<_DoaItem> _doaList = [
  _DoaItem(title: 'Doa Makan',         subtitle: 'Sebelum makan',          icon: '🍽️', color: const Color(0xFF66BB6A), assetPath: _titleToAsset('Doa Makan')),
  _DoaItem(title: 'Doa Setelah Makan', subtitle: 'Sesudah makan',          icon: '🙏', color: const Color(0xFF43A047), assetPath: _titleToAsset('Doa Setelah Makan')),
  _DoaItem(title: 'Doa Tidur',         subtitle: 'Sebelum tidur',          icon: '🌙', color: const Color(0xFF7E57C2), assetPath: _titleToAsset('Doa Tidur')),
  _DoaItem(title: 'Doa Bangun Tidur',  subtitle: 'Setelah bangun tidur',   icon: '☀️', color: const Color(0xFFFFA726), assetPath: _titleToAsset('Doa Bangun Tidur')),
  _DoaItem(title: 'Doa Masuk WC',      subtitle: 'Masuk kamar mandi',      icon: '🚿', color: const Color(0xFF42A5F5), assetPath: _titleToAsset('Doa Masuk WC')),
  _DoaItem(title: 'Doa Keluar WC',     subtitle: 'Keluar kamar mandi',     icon: '✨', color: const Color(0xFF26C6DA), assetPath: _titleToAsset('Doa Keluar WC')),
  _DoaItem(title: 'Doa Masuk Rumah',   subtitle: 'Memasuki rumah',         icon: '🏠', color: const Color(0xFF8D6E63), assetPath: _titleToAsset('Doa Masuk Rumah')),
  _DoaItem(title: 'Doa Keluar Rumah',  subtitle: 'Keluar dari rumah',      icon: '🚶', color: const Color(0xFFEC407A), assetPath: _titleToAsset('Doa Keluar Rumah')),
  _DoaItem(title: 'Doa Wudhu',         subtitle: 'Sebelum berwudhu',       icon: '💧', color: const Color(0xFF29B6F6), assetPath: _titleToAsset('Doa Wudhu')),
  _DoaItem(title: 'Doa Belajar',       subtitle: 'Sebelum belajar',        icon: '📚', color: const Color(0xFFAB47BC), assetPath: _titleToAsset('Doa Belajar')),
  _DoaItem(title: 'Doa Naik Kendaraan',subtitle: 'Saat naik kendaraan',    icon: '🚗', color: const Color(0xFFEF5350), assetPath: _titleToAsset('Doa Naik Kendaraan')),
  _DoaItem(title: 'Doa Orang Tua',     subtitle: 'Mendoakan orang tua',    icon: '❤️', color: const Color(0xFFE91E63), assetPath: _titleToAsset('Doa Orang Tua')),
];

// ─────────────────────────────────────────────
//  Main Screen
// ─────────────────────────────────────────────
class MenuDoaScreen extends StatefulWidget {
  const MenuDoaScreen({super.key});

  @override
  State<MenuDoaScreen> createState() => _MenuDoaScreenState();
}

class _MenuDoaScreenState extends State<MenuDoaScreen> {
  /// Tracks which asset paths actually exist in the bundle
  final Set<String> _availableAssets = {};
  bool _isChecking = true;

  @override
  void initState() {
    super.initState();
    _checkAvailableAssets();
  }

  Future<void> _checkAvailableAssets() async {
    // Use AssetManifest to know which files exist
    final loaded = await AssetLoaderService.loadImagesFromFolder('assets/images/doa/');
    setState(() {
      _availableAssets.addAll(loaded);
      _isChecking = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(
        title: 'Doa Harian',
        subtitle: 'Doa untuk kehidupan sehari-hari 🤲',
      ),
      body: Stack(
        children: [
          const FloatingStars(),
          _isChecking
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(
                      AppSpacing.lg, AppSpacing.md, AppSpacing.lg, 32),
                  itemCount: _doaList.length,
                  itemBuilder: (context, index) =>
                      _buildDoaCard(_doaList[index]),
                ),
        ],
      ),
    );
  }

  Widget _buildDoaCard(_DoaItem doa) {
    final hasImage = _availableAssets.contains(doa.assetPath);

    return GestureDetector(
      onTap: () => _openDetail(doa, hasImage),
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.md),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.xl),
          boxShadow: [
            BoxShadow(
              color: doa.color.withValues(alpha: 0.13),
              blurRadius: 14,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.xl),
          child: Row(
            children: [
              // ── Thumbnail / icon ───────────────────
              SizedBox(
                width: 90,
                height: 90,
                child: hasImage
                    ? Image.asset(
                        doa.assetPath,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _iconFallback(doa),
                      )
                    : _iconFallback(doa),
              ),
              // ── Info ──────────────────────────────
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md, vertical: AppSpacing.sm),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        doa.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textMain,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        doa.subtitle,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textDim,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 3),
                            decoration: BoxDecoration(
                              color: doa.color.withValues(alpha: 0.12),
                              borderRadius:
                                  BorderRadius.circular(AppRadius.full),
                            ),
                            child: Text(
                              hasImage ? '📖 Buka Brosur' : '📋 Lihat',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: doa.color,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              // ── Arrow ─────────────────────────────
              Padding(
                padding: const EdgeInsets.only(right: AppSpacing.md),
                child:
                    Icon(Icons.chevron_right_rounded, color: doa.color, size: 26),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _iconFallback(_DoaItem doa) {
    return Container(
      color: doa.color.withValues(alpha: 0.1),
      child: Center(
        child: Text(doa.icon, style: const TextStyle(fontSize: 38)),
      ),
    );
  }

  void _openDetail(_DoaItem doa, bool hasImage) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => _DoaDetailScreen(doa: doa, hasImage: hasImage),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  Detail Screen
// ─────────────────────────────────────────────
class _DoaDetailScreen extends StatelessWidget {
  final _DoaItem doa;
  final bool hasImage;

  const _DoaDetailScreen({required this.doa, required this.hasImage});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: doa.color,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(doa.title,
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold)),
            Text(doa.subtitle,
                style:
                    const TextStyle(fontSize: 12, color: Colors.white70)),
          ],
        ),
        actions: [
          // Share / Save placeholder
          IconButton(
            icon: const Icon(Icons.share_rounded),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Fitur share akan segera hadir 😊',
                      textAlign: TextAlign.center),
                  backgroundColor: doa.color,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                ),
              );
            },
          ),
        ],
      ),
      body: hasImage ? _buildImageView(context) : _buildFallbackView(context),
    );
  }

  Widget _buildImageView(BuildContext context) {
    return InteractiveViewer(
      minScale: 0.5,
      maxScale: 4.0,
      child: Center(
        child: Image.asset(
          doa.assetPath,
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) => _buildFallbackView(context),
        ),
      ),
    );
  }

  Widget _buildFallbackView(BuildContext context) {
    return Container(
      color: AppColors.background,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(doa.icon, style: const TextStyle(fontSize: 80)),
            const SizedBox(height: 24),
            Text(
              doa.title,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w900,
                color: doa.color,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 40),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppRadius.xl),
                boxShadow: [
                  BoxShadow(
                    color: doa.color.withValues(alpha: 0.12),
                    blurRadius: 20,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Icon(Icons.image_search_rounded, size: 48, color: doa.color),
                  const SizedBox(height: 12),
                  const Text(
                    'Brosur belum tersedia 😊',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textMain,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tambahkan file ke:\nassets/images/doa/${doa.assetPath.split('/').last}',
                    style: const TextStyle(
                      fontSize: 12,
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
      ),
    );
  }
}
