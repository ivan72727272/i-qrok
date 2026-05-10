import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';
import '../widgets/primary_button.dart';
import '../widgets/islamic_decor.dart';
import 'home_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _onboardingData = [
    {
      'title': 'Belajar Mengaji & Doa',
      'description': 'Mari mulai mengenal huruf dasar Al-Qur\'an dan menghafal doa sehari-hari.',
      'image': 'assets/images/mascot_muslim_boy.png',
    },
    {
      'title': 'Belajar Praktik Islami',
      'description': 'Belajar tata cara wudhu dan sholat dengan panduan visual yang menarik.',
      'image': 'assets/images/mascot_muslim_girl.png',
    },
    {
      'title': 'Membaca Cerita Islami',
      'description': 'Kumpulan cerita penuh hikmah untuk membentuk akhlak mulia sejak dini.',
      'image': 'assets/images/cute_mosque.png',
    },
  ];

  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasSeenOnboarding', true);
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          const FloatingStars(),
          Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (int page) {
                    setState(() {
                      _currentPage = page;
                    });
                  },
                  itemCount: _onboardingData.length,
                  itemBuilder: (context, index) {
                    return _buildPageContent(
                      title: _onboardingData[index]['title']!,
                      description: _onboardingData[index]['description']!,
                      imagePath: _onboardingData[index]['image']!,
                    );
                  },
                ),
              ),
              _buildBottomControls(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPageContent({required String title, required String description, required String imagePath}) {
    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: TweenAnimationBuilder<double>(
              duration: const Duration(seconds: 1),
              tween: Tween(begin: 0.8, end: 1.0),
              curve: Curves.elasticOut,
              builder: (context, value, child) {
                return Transform.scale(
                  scale: value,
                  child: child,
                );
              },
              child: Image.asset(imagePath, fit: BoxFit.contain),
            ),
          ),
          const SizedBox(height: 40),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w900,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.textMain,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildBottomControls() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Page Indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _onboardingData.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  height: 10,
                  width: _currentPage == index ? 30 : 10,
                  decoration: BoxDecoration(
                    color: _currentPage == index ? AppColors.primary : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (_currentPage < _onboardingData.length - 1)
                  TextButton(
                    onPressed: _completeOnboarding,
                    child: const Text('Lewati', style: TextStyle(fontSize: 16, color: Colors.grey, fontWeight: FontWeight.bold)),
                  )
                else
                  const SizedBox(width: 80), // Placeholder to keep alignment
                  
                if (_currentPage < _onboardingData.length - 1)
                  PrimaryButton(
                    label: 'Lanjut',
                    icon: Icons.arrow_forward_rounded,
                    onTap: () {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                      );
                    },
                  )
                else
                  PrimaryButton(
                    label: 'Mulai Belajar',
                    icon: Icons.check_circle_rounded,
                    color: AppColors.success,
                    onTap: _completeOnboarding,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
