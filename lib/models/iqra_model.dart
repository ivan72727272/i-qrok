import 'package:flutter/material.dart';

class IqraPage {
  final String arabic;
  final String latin;
  final String audioPath;

  IqraPage({
    required this.arabic,
    required this.latin,
    required this.audioPath,
  });

  factory IqraPage.fromJson(Map<String, dynamic> json) {
    return IqraPage(
      arabic: json['arabic'],
      latin: json['latin'],
      audioPath: json['audio'],
    );
  }
}

class IqraLevel {
  final int level;
  final String title;
  final String description;
  final Color color;
  List<IqraPage> pages;

  IqraLevel({
    required this.level,
    required this.title,
    required this.description,
    required this.color,
    this.pages = const [],
  });
}

