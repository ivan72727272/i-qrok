import 'package:flutter/material.dart';

class AppConstants {
  static const String appName = 'Little Muslim';
  static const String appVersion = '2.0.0';
}

class AppColors {
  static const Color background = Color(0xFFFFFDF7); // Krem cerah hangat
  static const Color primary = Color(0xFF6BCB77); // Mint Green
  static const Color primaryLight = Color(0xFFA5D6A7);
  static const Color accent = Color(0xFFFF9F45); // Orange Soft
  static const Color accentLight = Color(0xFFFFE0B2);
  static const Color skyBlue = Color(0xFF4D96FF); // Biru Langit
  static const Color sunnyYellow = Color(0xFFFFD93D); // Kuning Ceria
  static const Color softPink = Color(0xFFC77DFF); // Pink Ungu Soft
  static const Color success = Color(0xFF6BCB77);
  static const Color warning = Color(0xFFFF9F45);
  static const Color info = Color(0xFF4D96FF);
  static const Color infoLight = Color(0xFFE1F5FE);
  static const Color error = Color(0xFFEF5350);
  static const Color errorLight = Color(0xFFFCE4EC);
  static const Color textMain = Color(0xFF37474F);
  static const Color textDim = Color(0xFF78909C);
  static const Color cardShadow = Color(0x15000000); // Shadow sedikit lebih pekat tapi transparan

  // Night Mode Colors
  static const Color nightBackground = Color(0xFF1A1C2E); // Navy malam
  static const Color nightCard = Color(0xFF262940); // Card malam
  static const Color nightPrimary = Color(0xFF7B61FF); // Ungu malam
  static const Color nightAccent = Color(0xFFC77DFF); // Pink malam
  static const Color nightText = Color(0xFFE0E0E0);
}

class AppSpacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 24.0;
  static const double xxl = 32.0;
}

class AppRadius {
  static const double sm = 12.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0; // Playful besar
  static const double bubble = 28.0;
  static const double full = 100.0;
}
