import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/islamic_decor.dart';
import '../utils/asset_loader_service.dart';

class MenuDoaScreen extends StatefulWidget {
  const MenuDoaScreen({super.key});

  @override
  State<MenuDoaScreen> createState() => _MenuDoaScreenState();
}

class _MenuDoaScreenState extends State<MenuDoaScreen> {
  List<String> _doaImages = [];
  bool _isLoading = true;

  // Static fallback data when no images are in folder
  final List<Map<String, String>> _staticDoas = [
    {'title': 'Doa Makan', 'subtitle': 'Sebelum makan', 'icon': '🍽️'},
    {'title': 'Doa Tidur', 'subtitle': 'Sebelum tidur', 'icon': '🌙'},
    {'title': 'Doa Bangun Tidur', 'subtitle': 'Setelah bangun tidur', 'icon': '☀️'},
    {'title': 'Doa Masuk WC', 'subtitle': 'Masuk kamar mandi', 'icon': '🚿'},
    {'title': 'Doa Keluar WC', 'subtitle': 'Keluar kamar mandi', 'icon': '✨'},
    {'title': 'Doa Masuk Rumah', 'subtitle': 'Memasuki rumah', 'icon': '🏠'},
    {'title': 'Doa Keluar Rumah', 'subtitle': 'Keluar dari rumah', 'icon': '🚶'},
    {'title': 'Doa Wudhu', 'subtitle': 'Sebelum berwudhu', 'icon': '💧'},
    {'title': 'Doa Belajar', 'subtitle': 'Sebelum belajar', 'icon': '📚'},
    {'title': 'Doa Naik Kendaraan', 'subtitle': 'Saat naik kendaraan', 'icon': '🚗'},
    {'title': 'Doa Setelah Makan', 'subtitle': 'Setelah selesai makan', 'icon': '🙏'},
    {'title': 'Doa Orang Tua', 'subtitle': 'Mendoakan orang tua', 'icon': '❤️'},
  ];

  @override
  void initState() {
    super.initState();
    _loadDoas();
  }

  Future<void> _loadDoas() async {
    final images = await AssetLoaderService.loadImagesFromFolder('assets/images/doa/');
    setState(() {
      _doaImages = images;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(
        title: 'Doa Harian',
        subtitle: 'Doa untuk kehidupan sehari-hari',
      ),
      body: Stack(
        children: [
          const FloatingStars(),
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _doaImages.isNotEmpty
                  ? _buildImageList()
                  : _buildStaticList(),
        ],
      ),
    );
  }

  Widget _buildImageList() {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(AppSpacing.lg),
      itemCount: _doaImages.length,
      itemBuilder: (context, index) {
        final path = _doaImages[index];
        final title = AssetLoaderService.extractTitleFromPath(path);
        return _buildImageCard(path, title, index);
      },
    );
  }

  Widget _buildImageCard(String imagePath, String title, int index) {
    final colors = [
      const Color(0xFF42A5F5),
      const Color(0xFF66BB6A),
      const Color(0xFFFFA726),
      const Color(0xFFAB47BC),
      const Color(0xFFEF5350),
      const Color(0xFF26C6DA),
    ];
    final color = colors[index % colors.length];

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.12),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppRadius.xl),
          onTap: () => _showDoaDetail(context, imagePath, title),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  child: Image.asset(
                    imagePath,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 80,
                      height: 80,
                      color: color.withOpacity(0.1),
                      child: Icon(Icons.image_not_supported_rounded, color: color, size: 36),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: AppColors.textMain)),
                      const SizedBox(height: 4),
                      Text('Tekan untuk membuka', style: TextStyle(fontSize: 13, color: AppColors.textDim)),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right_rounded, color: color, size: 28),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStaticList() {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(AppSpacing.lg),
      itemCount: _staticDoas.length,
      itemBuilder: (context, index) {
        final doa = _staticDoas[index];
        final colors = [
          const Color(0xFF42A5F5), const Color(0xFF66BB6A), const Color(0xFFFFA726),
          const Color(0xFFAB47BC), const Color(0xFFEF5350), const Color(0xFF26C6DA),
        ];
        final color = colors[index % colors.length];
        return Container(
          margin: const EdgeInsets.only(bottom: AppSpacing.md),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppRadius.xl),
            boxShadow: [BoxShadow(color: color.withOpacity(0.12), blurRadius: 12, offset: const Offset(0, 4))],
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
            leading: Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(AppRadius.md)),
              child: Center(child: Text(doa['icon']!, style: const TextStyle(fontSize: 28))),
            ),
            title: Text(doa['title']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            subtitle: Text(doa['subtitle']!, style: const TextStyle(color: AppColors.textDim, fontSize: 13)),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(AppRadius.full)),
              child: Text('Buka', style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12)),
            ),
          ),
        );
      },
    );
  }

  void _showDoaDetail(BuildContext context, String imagePath, String title) {
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
                      backgroundColor: AppColors.primary,
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
