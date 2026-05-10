import 'package:flutter/material.dart';
import '../models/iqra_model.dart';

class IqraData {
  static final List<IqraLevel> levels = [
    IqraLevel(
      level: 1,
      title: 'Iqra 1',
      description: 'Pengenalan huruf Hijaiyah berharakat Fathah.',
      color: Colors.redAccent,
      pages: [
        IqraPage(arabic: 'اَ بَ', latin: 'A - Ba', audioPath: 'iqra1_p1.mp3'),
        IqraPage(arabic: 'بَ اَ تَ', latin: 'Ba - A - Ta', audioPath: 'iqra1_p2.mp3'),
        IqraPage(arabic: 'تَ بَ اَ', latin: 'Ta - Ba - A', audioPath: 'iqra1_p3.mp3'),
      ],
    ),
    IqraLevel(
      level: 2,
      title: 'Iqra 2',
      description: 'Huruf sambung dan Mad (bacaan panjang).',
      color: Colors.orangeAccent,
      pages: [
        IqraPage(arabic: 'بَا تَا ثَا', latin: 'Baa - Taa - Thaa', audioPath: 'iqra2_p1.mp3'),
        IqraPage(arabic: 'جَا حَا خَا', latin: 'Jaa - Haa - Khaa', audioPath: 'iqra2_p2.mp3'),
      ],
    ),
    IqraLevel(
      level: 3,
      title: 'Iqra 3',
      description: 'Pengenalan harakat Kasrah dan Dhammah.',
      color: Colors.yellow.shade800,
      pages: [
        IqraPage(arabic: 'اِ بِي تِ', latin: 'I - Bii - Ti', audioPath: 'iqra3_p1.mp3'),
        IqraPage(arabic: 'اُ بُو تُ', latin: 'U - Buu - Tu', audioPath: 'iqra3_p2.mp3'),
      ],
    ),
    IqraLevel(
      level: 4,
      title: 'Iqra 4',
      description: 'Tanwin dan huruf mati (Sukun).',
      color: Colors.greenAccent.shade700,
      pages: [
        IqraPage(arabic: 'اَنْ اِنْ اُنْ', latin: 'An - In - Un', audioPath: 'iqra4_p1.mp3'),
      ],
    ),
    IqraLevel(
      level: 5,
      title: 'Iqra 5',
      description: 'Bacaan Al (Alif Lam) dan Tasydid.',
      color: Colors.blueAccent,
      pages: [
        IqraPage(arabic: 'اَلْحَمْدُ', latin: 'Al-hamdu', audioPath: 'iqra5_p1.mp3'),
      ],
    ),
    IqraLevel(
      level: 6,
      title: 'Iqra 6',
      description: 'Hukum Tajwid dasar dan Waqaf.',
      color: Colors.purpleAccent,
      pages: [
        IqraPage(arabic: 'فَسَبِّحْ بِحَمْدِ', latin: 'Fasabbih bihamdi', audioPath: 'iqra6_p1.mp3'),
      ],
    ),
  ];
}
