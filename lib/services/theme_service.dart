import 'package:flutter/material.dart';

class ThemeService extends ChangeNotifier {
  static final ThemeService _instance = ThemeService._internal();
  factory ThemeService() => _instance;
  ThemeService._internal();

  bool _isNightMode = false;
  bool get isNightMode => _isNightMode;

  void toggleNightMode() {
    _isNightMode = !_isNightMode;
    notifyListeners();
  }
}
