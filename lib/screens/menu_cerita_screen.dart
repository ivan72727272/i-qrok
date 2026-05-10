import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/islamic_decor.dart';
import '../utils/asset_loader_service.dart';

class MenuCeritaScreen extends StatefulWidget {
  const MenuCeritaScreen({super.key});

  @override
  State<MenuCeritaScreen> createState() => _MenuCeritaScreenState();
}

class _MenuCeritaScreenState extends State<MenuCeritaScreen> {
  List<String> _ceritaImages = [];
  bool _isLoading = true;

  final List<Map<String, String>> _staticCeritas = [
    {'title': 'Anak yang Jujur', 'desc': 'Kisah anak yang selalu berkata jujur meskipun berat.', 'icon': '🌟'},
    {'title': 'Rajin Sholat', 'desc': 'Kisah anak yang tidak pernah meninggalkan sholat.', 'icon': '🕌'},
    {'title': 'Suka Berbagi', 'desc': 'Kisah anak yang senang berbagi dengan teman-temannya.', 'icon': '🎁'},
    {'title': 'Berkata Baik', 'desc': 'Kisah anak yang selalu menjaga lisannya dari kata-kata buruk.', 'icon': '💬'},
    {'title': 'Sayang kepada Orang Tua', 'desc': 'Kisah seorang anak yang sangat berbakti kepada orang tuanya.', 'icon': '❤️'},
    {'title': 'Anak yang Dermawan', 'desc': 'Kisah anak yang senang bersedekah kepada yang membutuhkan.', 'icon': '🤲'},
  ];

  @override
  void initState() {
    super.initState();
    _loadCeritas();
  }

  Future<void> _loadCeritas() async {
    final images = await AssetLoaderService.loadImagesFromFolder('assets/images/cerita/');
    setState(() {
      _ceritaImages = images;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(
        title: 'Cerita Islami',
        subtitle: 'Kisah penuh hikmah untuk anak',
      ),
      body: Stack(
        children: [
          const FloatingStars(),
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _ceritaImages.isNotEmpty
                  ? _buildImageGrid()
                  : _buildStaticGrid(),
        ],
      ),
    );
  }

  Widget _buildImageGrid() {
    return GridView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(AppSpacing.lg),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
        childAspectRatio: 0.75,
      ),
      itemCount: _ceritaImages.length,
      itemBuilder: (context, index) {
        final path = _ceritaImages[index];
        final title = AssetLoaderService.extractTitleFromPath(path);
        return _buildImageBookCard(path, title, index);
      },
    );
  }

  Widget _buildImageBookCard(String imagePath, String title, int index) {
    final colors = [
      const Color(0xFFAB47BC), const Color(0xFF42A5F5), const Color(0xFF66BB6A),
      const Color(0xFFFFA726), const Color(0xFFEF5350), const Color(0xFF26C6DA),
    ];
    final color = colors[index % colors.length];

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(AppRadius.xl),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.xl),
        onTap: () => _showCeritaDetail(context, imagePath, title),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
                child: Image.asset(imagePath, fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(color: color.withOpacity(0.1),
                        child: Icon(Icons.auto_stories_rounded, size: 48, color: color))),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.sm),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.textMain), maxLines: 2, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(AppRadius.full)),
                    child: Text('📖 Baca', style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 11)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStaticGrid() {
    return GridView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(AppSpacing.lg),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
        childAspectRatio: 0.85,
      ),
      itemCount: _staticCeritas.length,
      itemBuilder: (context, index) {
        final cerita = _staticCeritas[index];
        final colors = [
          const Color(0xFFAB47BC), const Color(0xFF42A5F5), const Color(0xFF66BB6A),
          const Color(0xFFFFA726), const Color(0xFFEF5350), const Color(0xFF26C6DA),
        ];
        final color = colors[index % colors.length];
        return Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.xl),
          child: InkWell(
            borderRadius: BorderRadius.circular(AppRadius.xl),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    height: 80,
                    decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(AppRadius.lg)),
                    child: Center(child: Text(cerita['icon']!, style: const TextStyle(fontSize: 42))),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(cerita['title']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.textMain), maxLines: 2, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  Text(cerita['desc']!, style: const TextStyle(fontSize: 11, color: AppColors.textDim, height: 1.3), maxLines: 2, overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showCeritaDetail(BuildContext context, String imagePath, String title) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.xl)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
              child: Image.asset(imagePath, fit: BoxFit.fitWidth, width: double.infinity),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                children: [
                  Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textMain)),
                  const SizedBox(height: AppSpacing.md),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(ctx),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFAB47BC),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.full)),
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    ),
                    child: const Text('Tutup', style: TextStyle(fontWeight: FontWeight.bold)),
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
