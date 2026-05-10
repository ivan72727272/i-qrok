import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import 'primary_button.dart';

class AudioButton extends StatelessWidget {
  final bool isPlaying;
  final bool isLoading;
  final VoidCallback onTap;
  final String label;
  final Color color;

  const AudioButton({
    super.key,
    required this.isPlaying,
    required this.isLoading,
    required this.onTap,
    this.label = 'Putar Suara',
    this.color = AppColors.primary,
  });

  @override
  Widget build(BuildContext context) {
    return PrimaryButton(
      label: isLoading ? 'Memuat...' : (isPlaying ? 'Mendengarkan' : label),
      onTap: onTap,
      icon: isPlaying ? Icons.pause_rounded : Icons.volume_up_rounded,
      color: color,
      isLoading: isLoading,
    );
  }
}
