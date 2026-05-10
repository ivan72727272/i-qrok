import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/islamic_decor.dart';

class MenuPraktikScreen extends StatefulWidget {
  const MenuPraktikScreen({super.key});

  @override
  State<MenuPraktikScreen> createState() => _MenuPraktikScreenState();
}

class _MenuPraktikScreenState extends State<MenuPraktikScreen> {
  bool _isLoading = true;
  int _selectedCategory = 0;

  final List<Map<String, dynamic>> _categories = [
    {'title': 'Wudhu', 'icon': '💧', 'color': const Color(0xFF42A5F5)},
    {'title': 'Sholat', 'icon': '🕌', 'color': const Color(0xFF66BB6A)},
    {'title': 'Adab', 'icon': '🤝', 'color': const Color(0xFFFFA726)},
  ];

  // Static step data
  final List<List<Map<String, String>>> _staticSteps = [
    // Wudhu steps
    [
      {'step': '1', 'title': 'Niat Wudhu', 'desc': 'Niat di dalam hati untuk berwudhu karena Allah'},
      {'step': '2', 'title': 'Bismillah', 'desc': 'Membaca Bismillahirrahmanirrahim'},
      {'step': '3', 'title': 'Cuci Tangan', 'desc': 'Mencuci kedua telapak tangan 3 kali'},
      {'step': '4', 'title': 'Kumur-kumur', 'desc': 'Berkumur-kumur 3 kali'},
      {'step': '5', 'title': 'Cuci Muka', 'desc': 'Membasuh muka 3 kali dari dahi sampai dagu'},
      {'step': '6', 'title': 'Cuci Tangan s/d Siku', 'desc': 'Membasuh tangan hingga siku 3 kali'},
      {'step': '7', 'title': 'Usap Kepala', 'desc': 'Mengusap kepala sekali'},
      {'step': '8', 'title': 'Cuci Kaki', 'desc': 'Membasuh kaki hingga mata kaki 3 kali'},
    ],
    // Sholat steps
    [
      {'step': '1', 'title': 'Niat Sholat', 'desc': 'Niat sholat di dalam hati'},
      {'step': '2', 'title': 'Takbiratul Ihram', 'desc': 'Mengangkat kedua tangan setinggi telinga sambil membaca Allahu Akbar'},
      {'step': '3', 'title': 'Berdiri Tegak', 'desc': 'Berdiri tegak dan membaca Al-Fatihah'},
      {'step': '4', 'title': 'Ruku\'', 'desc': 'Membungkukkan badan dan membaca tasbih'},
      {'step': '5', 'title': 'I\'tidal', 'desc': 'Berdiri tegak kembali setelah ruku\''},
      {'step': '6', 'title': 'Sujud', 'desc': 'Sujud dengan 7 anggota badan menyentuh lantai'},
      {'step': '7', 'title': 'Duduk di Antara Dua Sujud', 'desc': 'Duduk sejenak di antara dua sujud'},
      {'step': '8', 'title': 'Salam', 'desc': 'Menoleh ke kanan dan kiri membaca salam'},
    ],
    // Adab steps
    [
      {'step': '1', 'title': 'Adab Makan', 'desc': 'Membaca Bismillah sebelum makan'},
      {'step': '2', 'title': 'Adab Salam', 'desc': 'Mengucapkan Assalamualaikum saat bertemu'},
      {'step': '3', 'title': 'Adab Tidur', 'desc': 'Membaca doa sebelum tidur'},
      {'step': '4', 'title': 'Adab kepada Orang Tua', 'desc': 'Menghormati dan mendoakan orang tua'},
    ],
  ];

  @override
  void initState() {
    super.initState();
    _loadPraktik();
  }

  Future<void> _loadPraktik() async {
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(
        title: 'Praktik Islami',
        subtitle: 'Panduan tata cara ibadah',
      ),
      body: Column(
        children: [
          // Category tabs
          Container(
            height: 60,
            color: Colors.white,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final cat = _categories[index];
                final isSelected = _selectedCategory == index;
                return GestureDetector(
                  onTap: () => setState(() => _selectedCategory = index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.only(right: AppSpacing.sm),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? cat['color'] : Colors.transparent,
                      borderRadius: BorderRadius.circular(AppRadius.full),
                      border: Border.all(color: isSelected ? cat['color'] : Colors.grey.shade300, width: 1.5),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(cat['icon'], style: const TextStyle(fontSize: 16)),
                        const SizedBox(width: 6),
                        Text(
                          cat['title'],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isSelected ? Colors.white : AppColors.textDim,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          // Steps
          Expanded(
            child: Stack(
              children: [
                const FloatingStars(),
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _buildStepList(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepList() {
    final steps = _staticSteps[_selectedCategory];
    final color = _categories[_selectedCategory]['color'] as Color;

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(AppSpacing.lg),
      itemCount: steps.length,
      itemBuilder: (context, index) {
        final step = steps[index];
        return Container(
          margin: const EdgeInsets.only(bottom: AppSpacing.md),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppRadius.xl),
            boxShadow: [BoxShadow(color: color.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4))],
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                  child: Center(
                    child: Text(step['step']!, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 18)),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(step['title']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textMain)),
                      const SizedBox(height: 4),
                      Text(step['desc']!, style: const TextStyle(fontSize: 13, color: AppColors.textDim, height: 1.4)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
