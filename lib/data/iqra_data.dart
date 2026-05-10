import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/iqra_model.dart';

class IqraData {
  static final List<IqraLevel> levels = [
    IqraLevel(
      level: 1,
      title: 'Iqra 1',
      description: 'Pengenalan huruf Hijaiyah berharakat Fathah.',
      color: const Color(0xFFEF5350),
    ),
    IqraLevel(
      level: 2,
      title: 'Iqra 2',
      description: 'Huruf sambung dan Mad (bacaan panjang).',
      color: const Color(0xFFFFA726),
    ),
    IqraLevel(
      level: 3,
      title: 'Iqra 3',
      description: 'Pengenalan harakat Kasrah dan Dhammah.',
      color: const Color(0xFFFBC02D),
    ),
    IqraLevel(
      level: 4,
      title: 'Iqra 4',
      description: 'Tanwin dan huruf mati (Sukun).',
      color: const Color(0xFF66BB6A),
    ),
    IqraLevel(
      level: 5,
      title: 'Iqra 5',
      description: 'Bacaan Al (Alif Lam) dan Tasydid.',
      color: const Color(0xFF42A5F5),
    ),
    IqraLevel(
      level: 6,
      title: 'Iqra 6',
      description: 'Hukum Tajwid dasar dan Waqaf.',
      color: const Color(0xFFAB47BC),
    ),
  ];

  static Future<void> loadLevelPages(IqraLevel level) async {
    try {
      final String jsonString = await rootBundle.loadString('assets/data/iqra/iqra${level.level}.json');
      final Map<String, dynamic> data = jsonDecode(jsonString);
      final List<dynamic> pagesJson = data['pages'];
      level.pages = pagesJson.map((page) => IqraPage.fromJson(page)).toList();
    } catch (e) {
      debugPrint('Error loading Iqra data for level ${level.level}: $e');
      level.pages = [];
    }
  }
}

