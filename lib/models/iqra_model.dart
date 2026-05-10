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
}

class IqraLevel {
  final int level;
  final String title;
  final String description;
  final Color color;
  final List<IqraPage> pages;

  IqraLevel({
    required this.level,
    required this.title,
    required this.description,
    required this.color,
    required this.pages,
  });
}
