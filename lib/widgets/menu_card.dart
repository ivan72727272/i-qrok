import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../constants/app_constants.dart';
import 'animated_button.dart';

class MenuCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData? icon;
  final Widget? iconWidget;
  final Color color;
  final Color? iconColor;
  final VoidCallback onTap;

  static final AudioPlayer _sharedPlayer = AudioPlayer();

  const MenuCard({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
    this.iconWidget,
    required this.color,
    this.iconColor,
    required this.onTap,
  });

  Future<void> _playNavSound() async {
    try {
      await _sharedPlayer.stop();
      await _sharedPlayer.play(AssetSource('audio/sapaan/click.mp3'));
    } catch (e) {
      debugPrint('Error playing nav sound: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedButton(
      onTap: () async {
        await _playNavSound();
        onTap();
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.bubble),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.2),
              blurRadius: 25,
              offset: const Offset(0, 12),
              spreadRadius: -5,
            ),
          ],
          border: Border.all(
            color: Colors.white,
            width: 2,
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () async {
              await _playNavSound();
              onTap();
            },
            borderRadius: BorderRadius.circular(AppRadius.bubble),
            splashColor: color.withOpacity(0.2),
            highlightColor: Colors.transparent,
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.sm),
              child: Center(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(AppSpacing.sm),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.15),
                          shape: BoxShape.circle,
                        ),
                        child: iconWidget ?? Icon(icon, size: 42, color: iconColor ?? color),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          color: AppColors.textMain,
                          height: 1.1,
                        ),
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          subtitle!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textDim,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
