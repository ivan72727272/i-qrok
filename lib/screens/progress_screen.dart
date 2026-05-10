import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/islamic_decor.dart';
import '../data/iqra_data.dart';
import 'iqra_reader_screen.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  final Map<int, int> _bookmarks = {};
  final Map<int, int> _totalPages = {
    1: 10,
    2: 20,
    3: 25,
    4: 30,
    5: 35,
    6: 40,
  };
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    final prefs = await SharedPreferences.getInstance();
    for (int i = 1; i <= 6; i++) {
      _bookmarks[i] = prefs.getInt('iqra_bookmark_$i') ?? 0;
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(
        title: 'Progress Belajar',
        subtitle: 'Pantau perkembangan belajarmu',
      ),
      body: Stack(
        children: [
          const FloatingStars(),
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  physics: const BouncingScrollPhysics(),
                  itemCount: IqraData.levels.length,
                  itemBuilder: (context, index) {
                    final level = IqraData.levels[index];
                    final currentPage = _bookmarks[level.level] ?? 0;
                    final total = _totalPages[level.level] ?? 10;
                    final progress = (currentPage) / total;
                    final isCompleted = currentPage >= total - 1 && currentPage > 0;

                    return _buildProgressCard(
                      context,
                      level: level,
                      currentPage: currentPage,
                      total: total,
                      progress: progress,
                      isCompleted: isCompleted,
                    );
                  },
                ),
        ],
      ),
    );
  }

  Widget _buildProgressCard(
    BuildContext context, {
    required dynamic level,
    required int currentPage,
    required int total,
    required double progress,
    required bool isCompleted,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: [
          BoxShadow(
            color: level.color.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: isCompleted ? AppColors.success.withOpacity(0.5) : Colors.white, width: 2),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          onTap: () {
             Navigator.push(
               context,
               MaterialPageRoute(builder: (context) => IqraReaderScreen(level: level)),
             ).then((_) => _loadProgress());
          },
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: level.color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  child: Center(
                    child: Text(
                      '${level.level}',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        color: level.color,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            level.title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textMain,
                            ),
                          ),
                          if (isCompleted)
                            const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 20)
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Halaman ${(currentPage + 1).clamp(1, total)} dari $total',
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textDim,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: progress.clamp(0.0, 1.0),
                          backgroundColor: Colors.grey.shade200,
                          valueColor: AlwaysStoppedAnimation<Color>(isCompleted ? AppColors.success : level.color),
                          minHeight: 8,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Icon(Icons.chevron_right_rounded, color: Colors.grey.shade400),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
