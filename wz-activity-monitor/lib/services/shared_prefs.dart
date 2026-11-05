import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  SharedPrefs();
  SharedPreferences? _prefs;
  static const String _keyDarkTheme = "darkTheme";
  static const String _keyVoiceCommandsEnabled = "voiceCommandsEnabled";
  static const String _keyVoiceCommandFeedback = "voiceCommandFeedback";
  static const String _keyShowRecordingMapEnabled = "showRecordingMapEnabled";
  static const String _keyLastSeenUpdateVersion = "lastSeenUpdateVersion";

  Future initPrefs() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  Future saveDarkModeToPrefs(bool darkMode) async {
    await initPrefs();
    _prefs?.setBool(_keyDarkTheme, darkMode);
  }

  Future<bool?> getDarkModeFromPrefs() async {
    await initPrefs();
    return _prefs?.getBool(_keyDarkTheme);
  }

  Future saveVoiceCommandsEnabled(bool enabled) async {
    await initPrefs();
    _prefs?.setBool(_keyVoiceCommandsEnabled, enabled);
  }

  Future<bool?> getVoiceCommandsEnabled() async {
    await initPrefs();
    return _prefs?.getBool(_keyVoiceCommandsEnabled);
  }

  Future saveVoiceCommandFeedback(bool enabled) async {
    await initPrefs();
    _prefs?.setBool(_keyVoiceCommandFeedback, enabled);
  }

  Future<bool?> getVoiceCommandFeedback() async {
    await initPrefs();
    return _prefs?.getBool(_keyVoiceCommandFeedback);
  }

  Future saveShowRecordingMapEnabled(bool enabled) async {
    await initPrefs();
    _prefs?.setBool(_keyShowRecordingMapEnabled, enabled);
  }

  Future<bool?> getShowRecordingMapEnabled() async {
    await initPrefs();
    return _prefs?.getBool(_keyShowRecordingMapEnabled);
  }

  Future<String?> getLastSeenUpdateVersion() async {
    await initPrefs();
    return _prefs?.getString(_keyLastSeenUpdateVersion);
  }

  Future saveLastSeenUpdateVersion(String version) async {
    await initPrefs();
    await _prefs?.setString(_keyLastSeenUpdateVersion, version);
  }

  Future setPrefs() async {
    await initPrefs();
    bool? darkMode = await getDarkModeFromPrefs();
    if (darkMode != null) {
      if (darkMode) {
        Get.changeThemeMode(ThemeMode.dark);
      } else {
        Get.changeThemeMode(ThemeMode.light);
      }
    } else {
      Get.changeThemeMode(ThemeMode.system);
    }
  }
}
