import 'dart:async';

import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:wzam/controllers/settings_controller.dart';
import 'package:wzam/models/stt_commands.dart';
import 'package:wzam/services/audio_service.dart';

class SpeechService extends GetxService {
  // Static variables
  final Logger _logger = Logger();
  final SpeechToText _sttEngine = SpeechToText();
  final SettingsController settingsController = Get.find<SettingsController>();
  final AudioService audioService = Get.find<AudioService>();
  final RxList<SttCommand> allowedCommands = <SttCommand>[].obs;

  Rx<bool> hasSpeech = Rx<bool>(false);
  Rx<bool> isListening = Rx<bool>(false);
  Rx<String?> errorMessage = Rx<String?>(null);
  Rx<String?> textReceived = Rx<String?>(null);

  // Command Stream
  final StreamController<SttCommand> _commandController =
      StreamController<SttCommand>.broadcast();
  Stream<SttCommand> get commandStream => _commandController.stream;

  Future<void> initializeSpeech({bool reinitialize = false}) async {
    if (isListening.value && !reinitialize) {
      _logger.d("Exiting initializeSpeech: ${isListening.value} $reinitialize");
      return;
    }
    try {
      hasSpeech.value = await _sttEngine.initialize(
        onStatus: (status) {
          _logger.d("Speech status: $status");
          if (status == "listening") {
            isListening.value = true;
            errorMessage.value = null;
          } else if (status == "notListening" || status == "done") {
            isListening.value = false;
            errorMessage.value = null;
          }
        },
        onError: (error) {
          _logger.e("Speech error: $error");
          errorMessage.value = error.errorMsg;
        },
      );
    } catch (e) {
      _logger.e("Error initializing speech: $e");
      hasSpeech.value = false;
      errorMessage.value = "Error initializing speech: $e";
    }
  }

  // Method to listen for voice commands
  Future<void> _listen() async {
    _logger.d("Listening for voice commands... ${isListening.value}");
    if (!isListening.value) {
      isListening.value = true;
      _sttEngine.listen(
          onResult: (result) async {
            _logger.i("Received speech: ${result.recognizedWords}");
            textReceived.value = result.recognizedWords;
            SttCommand? command =
                await parseCommandText(result.recognizedWords);
            if (command != null) {
              _commandController.add(command);
            }
          },
          listenOptions: SpeechListenOptions(
            listenMode: ListenMode.confirmation,
            partialResults: true,
          ));
    }
  }

  Future<SttCommand?> parseCommandText(String text) async {
    List<SttCommand> allowedCommands = this.allowedCommands;
    text = text
        .toLowerCase(); // Normalize the input text for case-insensitive matching
    SttCommand? matchedCommand;
    int matchLength = 0;
    for (final command in allowedCommands) {
      for (final comparisonString in command.comparisonStrings) {
        if (text.contains(comparisonString.toLowerCase())) {
          if (comparisonString.length > matchLength) {
            matchedCommand = command;
            matchLength = comparisonString.length;
          }
        }
      }
    }
    return matchedCommand; // Return the first matching command
  }

  Future<void> startListening() async {
    await _listen();
  }

  Future<void> stopListening() async {
    isListening.value = false;
    await _sttEngine.stop();
  }

  void updateAllowedCommands(List<SttCommand> allowedCommands) {
    this.allowedCommands.value = allowedCommands;
  }
}
