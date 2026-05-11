import 'package:flutter/material.dart';

class InteractiveLetter {
  final String char;
  final String name;
  final String audioPath;

  const InteractiveLetter({
    required this.char,
    required this.name,
    required this.audioPath,
  });
}

class IqraLevel {
  final int level;
  final String title;
  final String description;
  final Color color;

  const IqraLevel({
    required this.level,
    required this.title,
    required this.description,
    required this.color,
  });
}

class IqraData {
  static final List<IqraLevel> levels = [
    const IqraLevel(
      level: 1,
      title: 'Iqra 1',
      description: 'Mengenal huruf Hijaiyah dasar.',
      color: Color(0xFFEF5350),
    ),
    const IqraLevel(
      level: 2,
      title: 'Iqra 2',
      description: 'Mengenal huruf dengan Harakat.',
      color: Color(0xFFFFA726),
    ),
  ];

  static const List<InteractiveLetter> hijaiyahDasar = [
    InteractiveLetter(char: 'أ', name: 'Alif', audioPath: 'audio/huruf/alif.mp3'),
    InteractiveLetter(char: 'ب', name: 'Ba', audioPath: 'audio/huruf/ba.mp3'),
    InteractiveLetter(char: 'ت', name: 'Ta', audioPath: 'audio/huruf/ta.mp3'),
    InteractiveLetter(char: 'ث', name: 'Tha', audioPath: 'audio/huruf/tha.mp3'),
    InteractiveLetter(char: 'ج', name: 'Jim', audioPath: 'audio/huruf/jim.mp3'),
    InteractiveLetter(char: 'ح', name: 'Ha', audioPath: 'audio/huruf/hha.mp3'),
    InteractiveLetter(char: 'خ', name: 'Kha', audioPath: 'audio/huruf/kha.mp3'),
    InteractiveLetter(char: 'د', name: 'Dal', audioPath: 'audio/huruf/dal.mp3'),
    InteractiveLetter(char: 'ذ', name: 'Dhal', audioPath: 'audio/huruf/dhal.mp3'),
    InteractiveLetter(char: 'ر', name: 'Ra', audioPath: 'audio/huruf/ra.mp3'),
    InteractiveLetter(char: 'ز', name: 'Zay', audioPath: 'audio/huruf/zay.mp3'),
    InteractiveLetter(char: 'س', name: 'Sin', audioPath: 'audio/huruf/sin.mp3'),
    InteractiveLetter(char: 'ش', name: 'Shin', audioPath: 'audio/huruf/shin.mp3'),
    InteractiveLetter(char: 'ص', name: 'Sad', audioPath: 'audio/huruf/sad.mp3'),
    InteractiveLetter(char: 'ض', name: 'Dad', audioPath: 'audio/huruf/dad.mp3'),
    InteractiveLetter(char: 'ط', name: 'Tha', audioPath: 'audio/huruf/tta.mp3'),
    InteractiveLetter(char: 'ظ', name: 'Zha', audioPath: 'audio/huruf/za.mp3'),
    InteractiveLetter(char: 'ع', name: 'Ain', audioPath: 'audio/huruf/ain.mp3'),
    InteractiveLetter(char: 'غ', name: 'Ghain', audioPath: 'audio/huruf/ghain.mp3'),
    InteractiveLetter(char: 'ف', name: 'Fa', audioPath: 'audio/huruf/fa.mp3'),
    InteractiveLetter(char: 'ق', name: 'Qaf', audioPath: 'audio/huruf/qaf.mp3'),
    InteractiveLetter(char: 'ك', name: 'Kaf', audioPath: 'audio/huruf/kaf.mp3'),
    InteractiveLetter(char: 'ل', name: 'Lam', audioPath: 'audio/huruf/lam.mp3'),
    InteractiveLetter(char: 'م', name: 'Mim', audioPath: 'audio/huruf/mim.mp3'),
    InteractiveLetter(char: 'ن', name: 'Nun', audioPath: 'audio/huruf/nun.mp3'),
    InteractiveLetter(char: 'و', name: 'Waw', audioPath: 'audio/huruf/waw.mp3'),
    InteractiveLetter(char: 'هـ', name: 'Ha', audioPath: 'audio/huruf/ha.mp3'),
    InteractiveLetter(char: 'ء', name: 'Hamzah', audioPath: 'audio/huruf/hamzah.mp3'),
    InteractiveLetter(char: 'ي', name: 'Ya', audioPath: 'audio/huruf/ya.mp3'),
  ];

  static List<InteractiveLetter> getHarakatList(String harakatType) {
    // harakatType: 'fathah', 'kasrah', 'dhammah'
    return hijaiyahDasar.map((base) {
      String newChar = base.char;
      String audioSuffix = '';
      String nameSuffix = '';
      
      switch (harakatType) {
        case 'fathah':
          newChar = '$newCharَ'; // Add Fathah
          audioSuffix = '_fathah';
          nameSuffix = ' (Fathah)';
          break;
        case 'kasrah':
          newChar = '$newCharِ'; // Add Kasrah
          audioSuffix = '_kasrah';
          nameSuffix = ' (Kasrah)';
          break;
        case 'dhammah':
          newChar = '$newCharُ'; // Add Dhammah
          audioSuffix = '_dhammah';
          nameSuffix = ' (Dhammah)';
          break;
      }
      
      final baseFileName = base.audioPath.split('/').last.replaceAll('.mp3', '');
      return InteractiveLetter(
        char: newChar,
        name: '${base.name}$nameSuffix',
        audioPath: 'audio/$harakatType/${baseFileName}$audioSuffix.mp3',
      );
    }).toList();
  }
}
