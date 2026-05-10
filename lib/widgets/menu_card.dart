import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    return AnimatedButton(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.xl),
          boxShadow: const [
            BoxShadow(
              color: AppColors.cardShadow,
              blurRadius: 20,
              offset: Offset(0, 10),
            ),
          ],
          border: Border.all(
            color: Colors.black.withOpacity(0.03),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: iconWidget ?? Icon(icon, size: 40, color: iconColor ?? color),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textMain,
              ),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: AppSpacing.xs),
              Text(
                subtitle!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textDim,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
