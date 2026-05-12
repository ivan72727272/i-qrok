import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';
import '../widgets/islamic_decor.dart';
import '../data/iqra_data.dart';
import 'interactive_iqra_screen.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen>
    with SingleTickerProviderStateMixin {
  final Map<int, int> _clickedCounts = {};
  final Map<int, int> _totalCounts = {};
  bool _isLoading = true;
  late AnimationController _entryCtrl;

  static const List<List<Color>> _palettes = [
    [Color(0xFFC8E6C9), Color(0xFF6BCB77)],
    [Color(0xFFB3E5FC), Color(0xFF4D96FF)],
    [Color(0xFFFFE0B2), Color(0xFFFF9F45)],
    [Color(0xFFE1BEE7), Color(0xFFC77DFF)],
    [Color(0xFFFFCDD2), Color(0xFFEF5350)],
    [Color(0xFFFFF9C4), Color(0xFFFFD93D)],
  ];

  @override
  void initState() {
    super.initState();
    _entryCtrl = AnimationController(duration: const Duration(milliseconds: 700), vsync: this);
    _loadProgress();
  }

  @override
  void dispose() { _entryCtrl.dispose(); super.dispose(); }

  Future<void> _loadProgress() async {
    final prefs = await SharedPreferences.getInstance();

    int iqra1Count = 0;
    for (var letter in IqraData.hijaiyahDasar) {
      if (prefs.getBool('iqra1_clicked_${letter.char}') ?? false) iqra1Count++;
    }
    _clickedCounts[1] = iqra1Count;
    _totalCounts[1] = IqraData.hijaiyahDasar.length;

    int iqra2Count = 0;
    final allHarakat = [
      ...IqraData.getHarakatList('fathah'),
      ...IqraData.getHarakatList('kasrah'),
      ...IqraData.getHarakatList('dhammah'),
    ];
    for (var letter in allHarakat) {
      if (prefs.getBool('iqra2_clicked_${letter.char}') ?? false) iqra2Count++;
    }
    _clickedCounts[2] = iqra2Count;
    _totalCounts[2] = allHarakat.length;

    if (mounted) {
      setState(() => _isLoading = false);
      _entryCtrl.forward();
    }
  }

  int get _totalProgress {
    int done = 0;
    for (final v in _clickedCounts.values) done += v;
    return done;
  }

  int get _totalItems {
    int t = 0;
    for (final v in _totalCounts.values) t += v;
    return t;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          Positioned(top: -50, right: -50,
            child: Container(width: 200, height: 200,
              decoration: BoxDecoration(color: AppColors.sunnyYellow.withOpacity(0.07), shape: BoxShape.circle))),
          Positioned(bottom: 100, left: -60,
            child: Container(width: 180, height: 180,
              decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.06), shape: BoxShape.circle))),
          const FloatingStars(),
          Column(
            children: [
              _buildHeader(context),
              if (_isLoading)
                const Expanded(child: Center(child: CircularProgressIndicator(color: AppColors.primary)))
              else
                Expanded(
                  child: FadeTransition(
                    opacity: CurvedAnimation(parent: _entryCtrl, curve: Curves.easeOut),
                    child: ListView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(
                          AppSpacing.lg, AppSpacing.md, AppSpacing.lg, 32),
                      children: [
                        _buildSummaryCard(),
                        const SizedBox(height: AppSpacing.lg),
                        const Padding(
                          padding: EdgeInsets.only(bottom: AppSpacing.sm, left: 4),
                          child: Text('Detail Per Level',
                            style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w900,
                              color: AppColors.textMain)),
                        ),
                        ...IqraData.levels.asMap().entries.map((e) {
                          final level = e.value;
                          final current = _clickedCounts[level.level] ?? 0;
                          final total = _totalCounts[level.level] ?? 1;
                          final progress = current / total;
                          final done = current == total;
                          return _buildProgressCard(level, current, total, progress, done, e.key);
                        }),
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

  Widget _buildHeader(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFFD93D), Color(0xFFFF9F45)],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(AppRadius.xl),
          bottomRight: Radius.circular(AppRadius.xl),
        ),
        boxShadow: [BoxShadow(color: Color(0x44FF9F45), blurRadius: 20, offset: Offset(0, 8))],
      ),
      child: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            Positioned(top: -10, right: -10,
              child: Container(width: 80, height: 80,
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), shape: BoxShape.circle))),
            const Positioned(top: 10, right: 22, child: FloatingStarSingle(size: 16, color: Colors.white)),
            const Positioned(top: 34, right: 50, child: FloatingStarSingle(size: 11, color: Colors.white)),
            Padding(
              padding: const EdgeInsets.fromLTRB(AppSpacing.sm, AppSpacing.sm, AppSpacing.lg, AppSpacing.lg),
              child: Row(
                children: [
                  Material(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                      onTap: () { HapticFeedback.lightImpact(); Navigator.pop(context); },
                      child: const Padding(padding: EdgeInsets.all(10),
                        child: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20)),
                    ),
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('⭐  Progress Belajar',
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Colors.white,
                            shadows: [Shadow(color: Colors.black26, blurRadius: 4)])),
                        SizedBox(height: 2),
                        Text('Pantau perkembangan belajarmu 📊',
                          style: TextStyle(fontSize: 13, color: Colors.white, fontWeight: FontWeight.w600)),
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

  Widget _buildSummaryCard() {
    final pct = _totalItems > 0 ? (_totalProgress / _totalItems) : 0.0;
    final pctStr = '${(pct * 100).toStringAsFixed(0)}%';
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF6BCB77), Color(0xFF4D96FF)],
        ),
        borderRadius: BorderRadius.circular(AppRadius.xl),
        boxShadow: [BoxShadow(color: AppColors.skyBlue.withOpacity(0.3), blurRadius: 18, offset: const Offset(0, 8))],
      ),
      child: Stack(
        children: [
          Positioned(top: -16, right: -16,
            child: Container(width: 70, height: 70,
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.12), shape: BoxShape.circle))),
          Row(
            children: [
              // Circular progress
              SizedBox(
                width: 80, height: 80,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CircularProgressIndicator(
                      value: pct.clamp(0.0, 1.0),
                      strokeWidth: 8,
                      backgroundColor: Colors.white.withOpacity(0.25),
                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                    Center(
                      child: Text(pctStr,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Colors.white)),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.xl),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Total Progress', style: TextStyle(fontSize: 13, color: Colors.white, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    Text('$_totalProgress / $_totalItems',
                      style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: Colors.white,
                        shadows: [Shadow(color: Colors.black26, blurRadius: 4)])),
                    const SizedBox(height: 4),
                    Text('Huruf dipelajari 🌟',
                      style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.85), fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProgressCard(dynamic level, int current, int total, double progress, bool isCompleted, int idx) {
    final colors = _palettes[idx % _palettes.length];

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(
          color: isCompleted ? AppColors.primary.withOpacity(0.5) : colors[1].withOpacity(0.25),
          width: 1.5,
        ),
        boxShadow: [BoxShadow(color: colors[1].withOpacity(0.12), blurRadius: 12, offset: const Offset(0, 5))],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppRadius.xl),
          onTap: () {
            HapticFeedback.lightImpact();
            Navigator.push(context,
              PageRouteBuilder(
                pageBuilder: (_, a, __) => InteractiveIqraScreen(level: level),
                transitionsBuilder: (_, a, __, child) => FadeTransition(opacity: a, child: child),
                transitionDuration: const Duration(milliseconds: 350),
              ),
            ).then((_) { _clickedCounts.clear(); _totalCounts.clear(); _loadProgress(); });
          },
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Row(
              children: [
                // Level circle with gradient
                Container(
                  width: 56, height: 56,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: colors),
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                    boxShadow: [BoxShadow(color: colors[1].withOpacity(0.35), blurRadius: 8, offset: const Offset(0, 4))],
                  ),
                  child: Center(
                    child: Text('${level.level}',
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Colors.white,
                        shadows: [Shadow(color: Colors.black26, blurRadius: 3)])),
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
                          Text(level.title,
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.textMain)),
                          if (isCompleted)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(AppRadius.full),
                              ),
                              child: const Row(mainAxisSize: MainAxisSize.min, children: [
                                Icon(Icons.check_rounded, size: 12, color: AppColors.primary),
                                SizedBox(width: 3),
                                Text('Selesai', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: AppColors.primary)),
                              ]),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text('$current dari $total huruf',
                        style: const TextStyle(fontSize: 12, color: AppColors.textDim, fontWeight: FontWeight.w600)),
                      const SizedBox(height: 8),
                      // Progress bar
                      ClipRRect(
                        borderRadius: BorderRadius.circular(AppRadius.full),
                        child: LinearProgressIndicator(
                          value: progress.clamp(0.0, 1.0),
                          backgroundColor: colors[0].withOpacity(0.3),
                          valueColor: AlwaysStoppedAnimation<Color>(colors[1]),
                          minHeight: 8,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Icon(Icons.chevron_right_rounded, color: colors[1].withOpacity(0.6)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
