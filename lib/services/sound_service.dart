import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

class SoundService {
  static final AudioPlayer _uiPlayer = AudioPlayer();
  static final AudioPlayer _feedbackPlayer = AudioPlayer();

  static Future<void> playPop() async {
    try {
      await _uiPlayer.stop();
      await _uiPlayer.play(AssetSource('audio/pop.mp3'));
    } catch (e) {
      debugPrint('Pop sound error: $e');
    }
  }

  static Future<void> playClick() async {
    try {
      await _uiPlayer.stop();
      await _uiPlayer.play(AssetSource('audio/click.mp3'));
    } catch (e) {
      debugPrint('Click sound error: $e');
    }
  }

  static Future<void> playCorrect() async {
    try {
      await _feedbackPlayer.stop();
      await _feedbackPlayer.play(AssetSource('audio/correct.mp3'));
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
      await _feedbackPlayer.play(AssetSource('audio/success_jingle.mp3'));
    } catch (e) {
      debugPrint('Success sound error: $e');
    }
  }
}
