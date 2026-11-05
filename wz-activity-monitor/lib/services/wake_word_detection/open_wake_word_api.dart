import 'dart:async';
import 'package:flutter/services.dart';

/// Callback type for wake word detection
typedef WakeWordCallback = void Function(String wakeWord, double score);

/// Main class for OpenWakeWord functionality
class FlutterOpenwakeword {
  static const MethodChannel _channel = MethodChannel('flutter_openwakeword');
  static WakeWordCallback? _callback;

  /// Initialize the wake word detector with model paths
  /// 
  /// [melspectrogramModelPath] - Path to melspectrogram model
  /// [embeddingModelPath] - Path to embedding model  
  /// [wakeWordModelPath] - Path to wake word model
  /// [threshold] - Detection threshold (0.0 to 1.0), default 0.5
  static Future<bool> initialize({
    required String melspectrogramModelPath,
    required String embeddingModelPath,
    required String wakeWordModelPath,
    double threshold = 0.5,
  }) async {
    try {
      final bool result = await _channel.invokeMethod('initialize', {
        'melspectrogramModelPath': melspectrogramModelPath,
        'embeddingModelPath': embeddingModelPath,
        'wakeWordModelPath': wakeWordModelPath,
        'threshold': threshold,
      });
      
      // Set up the callback handler
      _channel.setMethodCallHandler(_handleMethodCall);
      
      return result;
    } catch (e) {
      throw Exception('Failed to initialize OpenWakeWord: $e');
    }
  }

  /// Handle method calls from platform
  static Future<dynamic> _handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'onWakeWordDetected':
        if (_callback != null) {
          final String wakeWord = call.arguments['wakeWord'];
          final double score = call.arguments['score'];
          _callback!(wakeWord, score);
        }
        break;
      default:
        throw MissingPluginException('Unknown method ${call.method}');
    }
  }

  /// Set the callback for wake word detection
  static void setWakeWordCallback(WakeWordCallback callback) {
    _callback = callback;
  }

  /// Start listening for wake words
  static Future<bool> startListening() async {
    try {
      final bool result = await _channel.invokeMethod('startListening');
      return result;
    } catch (e) {
      throw Exception('Failed to start listening: $e');
    }
  }

  /// Stop listening for wake words
  static Future<bool> stopListening() async {
    try {
      final bool result = await _channel.invokeMethod('stopListening');
      return result;
    } catch (e) {
      throw Exception('Failed to stop listening: $e');
    }
  }

  /// Check if currently listening
  static Future<bool> isListening() async {
    try {
      final bool result = await _channel.invokeMethod('isListening');
      return result;
    } catch (e) {
      throw Exception('Failed to check listening state: $e');
    }
  }

  /// Release resources and cleanup
  static Future<void> dispose() async {
    try {
      await _channel.invokeMethod('dispose');
      _callback = null;
    } catch (e) {
      throw Exception('Failed to dispose: $e');
    }
  }

  /// Update the detection threshold
  static Future<bool> setThreshold(double threshold) async {
    try {
      final bool result = await _channel.invokeMethod('setThreshold', {
        'threshold': threshold,
      });
      return result;
    } catch (e) {
      throw Exception('Failed to set threshold: $e');
    }
  }
}