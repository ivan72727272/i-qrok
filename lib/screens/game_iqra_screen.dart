import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_constants.dart';
import '../widgets/animated_button.dart';
import '../widgets/islamic_decor.dart';

class GameIqraScreen extends StatefulWidget {
  const GameIqraScreen({super.key});

  @override
  State<GameIqraScreen> createState() => _GameIqraScreenState();
}

class _GameIqraScreenState extends State<GameIqraScreen> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F8E9), // Light mint
      body: Stack(
        children: [
          // Background Decor
          const _GameBackground(),
          
          SafeArea(
            child: Row(
              children: [
                // LEFT: Character
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Image.asset(
                        'assets/images/mascot_muslim_girl.png',
                        height: MediaQuery.of(context).size.height * 0.6,
                      ),
                    ],
                  ),
                ),
                
                // RIGHT: Game Area
                Expanded(
                  flex: 2,
                  child: Container(
                    margin: const EdgeInsets.all(20),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(32),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 20,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Tebak Bunyi Iqra',
                              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF33691E)),
                            ),
                            IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: const Icon(Icons.close_rounded, color: Colors.grey),
                            ),
                          ],
                        ),
                        const Divider(),
                        Expanded(
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'اَ بَ تَ',
                                  style: TextStyle(fontSize: 80, fontWeight: FontWeight.bold, color: AppColors.textMain),
                                ),
                                const SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    _buildChoiceCard('A Ba Ta'),
                                    const SizedBox(width: 12),
                                    _buildChoiceCard('Ba Ta Sa'),
                                    const SizedBox(width: 12),
                                    _buildChoiceCard('Alif Ba'),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChoiceCard(String text) {
    return AnimatedButton(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFF81C784), width: 2),
        ),
        child: Text(
          text,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF33691E)),
        ),
      ),
    );
  }
}

class _GameBackground extends StatelessWidget {
  const _GameBackground();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Positioned(top: 30, right: 50, child: Opacity(opacity: 0.6, child: Icon(Icons.wb_sunny_rounded, size: 80, color: Colors.orangeAccent))),
        const FloatingStars(),
        Positioned(
          bottom: -20,
          left: 0,
          right: 0,
          child: Container(
            height: 60,
            color: const Color(0xFFDCEDC8),
          ),
        ),
      ],
    );
  }
}
