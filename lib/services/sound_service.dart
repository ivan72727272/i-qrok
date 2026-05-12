import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'dart:math';

class SoundService {
  static final AudioPlayer _uiPlayer = AudioPlayer();
  static final AudioPlayer _feedbackPlayer = AudioPlayer();
  static final Random _random = Random();

  static Future<void> playPop() async {
    try {
      await _uiPlayer.stop();
      // Using click.mp3 from sapaan as a fallback for pop
      await _uiPlayer.play(AssetSource('audio/sapaan/click.mp3'));
    } catch (e) {
      debugPrint('Pop sound error: $e');
    }
  }

  static Future<void> playClick() async {
    try {
      await _uiPlayer.stop();
      await _uiPlayer.play(AssetSource('audio/sapaan/click.mp3'));
    } catch (e) {
      debugPrint('Click sound error: $e');
    }
  }

  static Future<void> playCorrect() async {
    try {
      await _feedbackPlayer.stop();
      // Randomized motivational voices
      final voices = ['audio/sapaan/hebat.mp3', 'audio/sapaan/masyaallah.mp3'];
      await _feedbackPlayer.play(AssetSource(voices[_random.nextInt(voices.length)]));
    } catch (e) {
      debugPrint('Correct sound error: $e');
    }
  }

  static Future<void> playWrong() async {
    try {
      await _feedbackPlayer.stop();
      await _feedbackPlayer.play(AssetSource('audio/wrong.mp3'));
    } catch (e) {
      debugPrint('Wrong sound error: $e');
    }
  }

  static Future<void> playSuccess() async {
    try {
      await _feedbackPlayer.stop();
      // Using masyaallah as success jingle fallback
      await _feedbackPlayer.play(AssetSource('audio/sapaan/masyaallah.mp3'));
    } catch (e) {
      debugPrint('Success sound error: $e');
    }
  }
}
