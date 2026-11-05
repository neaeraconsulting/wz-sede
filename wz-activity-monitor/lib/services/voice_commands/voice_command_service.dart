import 'dart:async';

import 'package:get/get.dart';
import 'package:wzam/controllers/settings_controller.dart';
import 'package:wzam/models/stt_commands.dart';
import 'package:wzam/models/voice_command_status.dart';
import 'package:wzam/models/wake_word_commands.dart';
import 'package:wzam/services/audio_service.dart';
import 'package:wzam/services/voice_commands/speech_service.dart';
import 'package:wzam/services/wake_word_detection/wake_word_service.dart';

class VoiceCommandService extends GetxService {
  // Static variables
  final SettingsController settingsController = Get.find<SettingsController>();
  final AudioService audioService = Get.find<AudioService>();
  final SpeechService speechService = Get.find<SpeechService>();
  final WakeWordService wakeWordService = Get.find<WakeWordService>();

  final List<StreamSubscription> subscriptions = [];

  final Rx<VoiceCommandStatus> status =
      Rx<VoiceCommandStatus>(VoiceCommandStatus.notInitialized);

  // Command Stream
  final StreamController<SttCommand> _commandController =
      StreamController<SttCommand>.broadcast();
  Stream<SttCommand> get commandStream => _commandController.stream;

  void initialize() async {
    if (subscriptions.isNotEmpty) {
      await deinit();
    }
    subscriptions
        .add(wakeWordService.wakeWordStream.listen((WakeWordCommand command) {
      startVoiceCommand();
    }));
    await wakeWordService.initialize();
    status.value = VoiceCommandStatus.listeningForWakeWord;
    wakeWordService.startListening();
    await speechService.initializeSpeech();
    subscriptions.add(speechService.isListening.stream
        .distinct()
        .listen((bool isListening) async {
      if (!isListening) {
        await speechService.stopListening();
        status.value = VoiceCommandStatus.listeningForWakeWord;
        await wakeWordService.startListening();
      }
    }));
    subscriptions
        .add(speechService.commandStream.listen((SttCommand command) async {
      _commandController.add(command);
      await speechService.stopListening();
      status.value = VoiceCommandStatus.listeningForWakeWord;
      wakeWordService.startListening();
    }));
  }

  Future<void> deinit() async {
    for (var sub in subscriptions) {
      sub.cancel();
    }
    subscriptions.clear();
    await wakeWordService.stopListening();
    await speechService.stopListening();
    status.value = VoiceCommandStatus.notInitialized;
  }

  void startVoiceCommand() async {
    await wakeWordService.stopListening();
    speechService.startListening();
    status.value = VoiceCommandStatus.listeningForCommand;
  }

  void updateAllowedCommands(List<SttCommand> allowedCommands) {
    speechService.updateAllowedCommands(allowedCommands);
  }
}
