import 'dart:ui';
import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? subtitle;
  final List<Widget>? actions;
  final bool showBackButton;
  final VoidCallback? onBackTap;
  final Color? backgroundColor;
  final Color? foregroundColor;

  final PreferredSizeWidget? bottom;

  const CustomAppBar({
    super.key,
    required this.title,
    this.subtitle,
    this.actions,
    this.showBackButton = true,
    this.onBackTap,
    this.backgroundColor,
    this.foregroundColor,
    this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: (backgroundColor ?? Colors.white).withOpacity(0.9),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(AppRadius.xl),
              bottomRight: Radius.circular(AppRadius.xl),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.cardShadow,
                blurRadius: 30,
                offset: const Offset(0, 10),
                spreadRadius: -5,
              ),
            ],
            gradient: backgroundColor == null ? LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white,
                AppColors.background.withOpacity(0.5),
              ],
            ) : null,
          ),
          child: SafeArea(
            bottom: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(AppSpacing.sm, AppSpacing.sm, AppSpacing.sm, AppSpacing.md),
                  child: Row(
                    children: [
                      if (showBackButton)
                        IconButton(
                          icon: Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: foregroundColor ?? AppColors.primary,
                            size: 24,
                          ),
                          onPressed: onBackTap ?? () => Navigator.pop(context),
                        )
                      else
                        const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: showBackButton ? CrossAxisAlignment.start : CrossAxisAlignment.center,
                          children: [
                            Text(
                              title,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: foregroundColor ?? AppColors.primary,
                                letterSpacing: 0.5,
                              ),
                            ),
                            if (subtitle != null)
                              Text(
                                subtitle!,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: (foregroundColor ?? AppColors.textDim).withOpacity(0.7),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                          ],
                        ),
                      ),
                      if (actions != null) ...actions!,
                      if (actions == null && !showBackButton) const SizedBox(width: 48),
                    ],
                  ),
                ),
                if (bottom != null) bottom!,
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(100 + (bottom?.preferredSize.height ?? 0));
}
