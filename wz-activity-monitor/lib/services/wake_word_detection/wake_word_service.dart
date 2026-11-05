import 'dart:async';

import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wzam/models/wake_word_commands.dart';
import 'package:wzam/services/wake_word_detection/open_wake_word_api.dart';

class WakeWordService extends GetxService {
  // Observable state
  final RxBool isInitialized = false.obs;
  final RxBool isListening = false.obs;
  final Rx<String> lastDetection = Rx<String>('Not initialized');
  final RxDouble threshold = 0.5.obs;

  // Wake word detection stream
  final StreamController<WakeWordCommand> _wakeWordController =
      StreamController<WakeWordCommand>.broadcast();
  Stream<WakeWordCommand> get wakeWordStream => _wakeWordController.stream;

  // Map wake word model names to WakeWordCommand enum
  final Map<String, WakeWordCommand> _wakeWordMapping = {
    'wake_word': WakeWordCommand.heyWorkZone,
    'hey_work_zone': WakeWordCommand.heyWorkZone,
    'Hey_Work_Zone': WakeWordCommand.heyWorkZone,
  };

  /// Initialize the wake word detector
  Future<bool> initialize({
    String melspectrogramModelPath = 'assets/tflite_models/melspectrogram.tflite',
    String embeddingModelPath = 'assets/tflite_models/embedding_model.tflite',
    String wakeWordModelPath = 'assets/tflite_models/Hey_Work_Zone.tflite',
    double detectionThreshold = 0.5,
  }) async {
    try {
      // Request microphone permission
      final status = await Permission.microphone.request();
      if (!status.isGranted) {
        lastDetection.value = 'Microphone permission denied';
        return false;
      }

      // Set up the callback to handle wake word detections
      FlutterOpenwakeword.setWakeWordCallback(_onWakeWordDetected);

      // Initialize with model paths
      final result = await FlutterOpenwakeword.initialize(
        melspectrogramModelPath: melspectrogramModelPath,
        embeddingModelPath: embeddingModelPath,
        wakeWordModelPath: wakeWordModelPath,
        threshold: detectionThreshold,
      );

      isInitialized.value = result;
      threshold.value = detectionThreshold;
      lastDetection.value = result
          ? 'Initialized successfully'
          : 'Initialization failed';

      return result;
    } catch (e) {
      lastDetection.value = 'Error: $e';
      isInitialized.value = false;
      return false;
    }
  }

  /// Handle wake word detection callback
  void _onWakeWordDetected(String wakeWord, double score) {
    print('Wake word detected: $wakeWord (score: $score)');
    lastDetection.value = 'Detected "$wakeWord" with score: ${score.toStringAsFixed(3)}';

    // Convert the detected wake word string to WakeWordCommand enum
    final command = _wakeWordMapping[wakeWord] ?? 
                    _wakeWordMapping[wakeWord.toLowerCase()] ??
                    WakeWordCommand.heyWorkZone;

    // Emit the wake word command to the stream
    _wakeWordController.add(command);
  }

  /// Start listening for wake words
  Future<bool> startListening() async {
    if (!isInitialized.value) {
      lastDetection.value = 'Please initialize first';
      return false;
    }

    try {
      final result = await FlutterOpenwakeword.startListening();
      final listening = await FlutterOpenwakeword.isListening();
      isListening.value = listening;
      return result;
    } catch (e) {
      lastDetection.value = 'Error starting listening: $e';
      return false;
    }
  }

  /// Stop listening for wake words
  Future<bool> stopListening() async {
    try {
      final result = await FlutterOpenwakeword.stopListening();
      final listening = await FlutterOpenwakeword.isListening();
      isListening.value = listening;
      return result;
    } catch (e) {
      lastDetection.value = 'Error stopping listening: $e';
      return false;
    }
  }

  /// Update the detection threshold
  Future<void> setThreshold(double newThreshold) async {
    threshold.value = newThreshold;

    if (isInitialized.value) {
      try {
        await FlutterOpenwakeword.setThreshold(newThreshold);
      } catch (e) {
        lastDetection.value = 'Error setting threshold: $e';
      }
    }
  }

  /// Add a custom wake word mapping
  void addWakeWordMapping(String wakeWordKey, WakeWordCommand command) {
    _wakeWordMapping[wakeWordKey] = command;
  }

  /// Remove a wake word mapping
  void removeWakeWordMapping(String wakeWordKey) {
    _wakeWordMapping.remove(wakeWordKey);
  }

  /// Deinitialize and clean up
  void deinit() {
    stopListening();
    FlutterOpenwakeword.dispose();
    isInitialized.value = false;
    isListening.value = false;
    lastDetection.value = 'Not initialized';
  }

  @override
  void onClose() {
    _wakeWordController.close();
    deinit();
    super.onClose();
  }
}
