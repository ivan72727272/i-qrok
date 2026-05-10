import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_constants.dart';
import '../widgets/animated_button.dart';
import '../widgets/islamic_decor.dart';
import 'game_iqra_screen.dart';

class GameSelectionScreen extends StatefulWidget {
  const GameSelectionScreen({super.key});

  @override
  State<GameSelectionScreen> createState() => _GameSelectionScreenState();
}

class _GameSelectionScreenState extends State<GameSelectionScreen> {
  @override
  void initState() {
    super.initState();
    // Lock to landscape
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    // Hide status bar for immersive feel
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  @override
  void dispose() {
    // Revert to portrait
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    // Show status bar again
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE1F5FE), // Light sky blue
      body: Stack(
        children: [
          // Background Elements
          const _LandscapeBackground(),
          
          SafeArea(
            child: Row(
              children: [
                // LEFT: Mascot Area
                Expanded(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildFloatingMascot(),
                      const SizedBox(height: 20),
                      _buildBackButton(context),
                    ],
                  ),
                ),
                
                // RIGHT: Game Cards Area
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Ayo Bermain! 🎮',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF01579B),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Expanded(
                          child: GridView.count(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 1.6,
                            children: [
                              _buildGameCard(
                                title: 'Game Iqra',
                                icon: Icons.auto_stories_rounded,
                                color: const Color(0xFF4FC3F7),
                                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const GameIqraScreen())),
                              ),

                              _buildGameCard(
                                title: 'Tebak Huruf',
                                icon: Icons.spellcheck_rounded,
                                color: const Color(0xFFFFB74D),
                                onTap: () {},
                              ),
                              _buildGameCard(
                                title: 'Angka Arab',
                                icon: Icons.format_list_numbered_rtl_rounded,
                                color: const Color(0xFF81C784),
                                onTap: () {},
                              ),
                              _buildGameCard(
                                title: 'Tebak Suara',
                                icon: Icons.record_voice_over_rounded,
                                color: const Color(0xFFBA68C8),
                                onTap: () {},
                              ),
                              _buildGameCard(
                                title: 'Puzzle Hijaiyah',
                                icon: Icons.extension_rounded,
                                color: const Color(0xFFF06292),
                                onTap: () {},
                              ),
                            ],
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

  Widget _buildFloatingMascot() {
    return TweenAnimationBuilder<double>(
      duration: const Duration(seconds: 2),
      tween: Tween(begin: 0, end: 1),
      curve: Curves.easeInOut,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, -10 * (1 - (value - 0.5).abs() * 2)),
          child: child,
        );
      },
      child: Image.asset(
        'assets/images/mascot_muslim_boy.png',
        height: MediaQuery.of(context).size.height * 0.5,
      ),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return AnimatedButton(
      onTap: () => Navigator.pop(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.arrow_back_rounded, color: Color(0xFF01579B)),
            SizedBox(width: 8),
            Text(
              'Kembali',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF01579B),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGameCard({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return AnimatedButton(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(color: Colors.white, width: 3),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 36, color: color),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF37474F),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LandscapeBackground extends StatelessWidget {
  const _LandscapeBackground();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Clouds
        const Positioned(top: 20, left: 40, child: Opacity(opacity: 0.5, child: Icon(Icons.cloud_rounded, size: 80, color: Colors.white))),
        const Positioned(top: 60, right: 100, child: Opacity(opacity: 0.3, child: Icon(Icons.cloud_rounded, size: 100, color: Colors.white))),
        const Positioned(top: 150, left: 200, child: Opacity(opacity: 0.4, child: Icon(Icons.cloud_rounded, size: 60, color: Colors.white))),
        
        // Stars
        const FloatingStars(),
        
        // Mosque in distance
        Positioned(
          bottom: 20,
          left: 50,
          child: Opacity(
            opacity: 0.1,
            child: Image.asset('assets/images/cute_mosque.png', width: 200),
          ),
        ),
        
        // Grass/Ground
        Positioned(
          bottom: -50,
          left: 0,
          right: 0,
          child: Container(
            height: 100,
            decoration: BoxDecoration(
              color: const Color(0xFFC5E1A5).withOpacity(0.5),
              borderRadius: const BorderRadius.vertical(top: Radius.elliptical(500, 100)),
            ),
          ),
        ),
      ],
    );
  }
}
