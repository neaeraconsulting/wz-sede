import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AudioService extends GetxService {
  final AudioPlayer audioPlayer = AudioPlayer();
  // Static variables
  // final RxBool _listeningSettings = SettingsController().listeningEnabled;

  Future<void> _configureAudioSession(AudioPlayer player) async {
    await player.setPlayerMode(PlayerMode.lowLatency);

    if (GetPlatform.isAndroid) {
      await player.setAudioContext(AudioContext(
        android: const AudioContextAndroid(
          isSpeakerphoneOn: false,
          stayAwake: false,
          contentType: AndroidContentType.speech,
          usageType: AndroidUsageType.voiceCommunication,
          audioFocus: AndroidAudioFocus.none,
        ),
      ));
    }
  }

  Future<void> playFeedback(String fileName, {double volume = 0.5}) async {
    try {
      // Create a new player for each sound
      final AudioPlayer player = AudioPlayer();
      await _configureAudioSession(player);

      await player.play(
        AssetSource('sounds/$fileName'),
        volume: volume,
      );
      
      // Wait for completion and dispose
      await player.onPlayerComplete.first;
      await player.dispose();
    } catch (e) {
      debugPrint('Error playing sound: $e');
    }
  }

  Future<void> playSuccessSound() async {
    await playFeedback('success.mp3', volume: 1.0);
  }

  Future<void> playErrorSound() async {
    await playFeedback('error.mp3', volume: 0.7);
  }

  Future<void> playBeginSound() async {
    await playFeedback('speak_now.mp3', volume: 0.7);
  }
}
