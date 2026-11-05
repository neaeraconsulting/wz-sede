// Speech to text commands
import 'package:flutter/material.dart';

enum VoiceCommandStatus {
  notInitialized,
  notListening,
  listeningForWakeWord,
  listeningForCommand,
}

extension VoiceCommandStatusExtension on VoiceCommandStatus {
  Icon get icon {
    switch (this) {
      case VoiceCommandStatus.notInitialized:
        return const Icon(Icons.mic_off);
      case VoiceCommandStatus.notListening:
        return const Icon(Icons.mic_off);
      case VoiceCommandStatus.listeningForWakeWord:
        return const Icon(Icons.mic_off);
      case VoiceCommandStatus.listeningForCommand:
        return const Icon(Icons.mic);
    }
  }
}
