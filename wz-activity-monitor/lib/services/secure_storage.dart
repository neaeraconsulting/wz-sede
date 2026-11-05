import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/services.dart' show PlatformException;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SecureStorage {
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
      resetOnError: true,
    ),
  );

  static const _keyUsername = 'username';
  static const _keyPassword = 'password';
  static const _keyAccessToken = 'accessToken';
  static const _keyRefreshToken = 'refreshToken';
  static const _keyProfiles = 'profiles';
  static const _keyCurrentProfile = 'currentProfile';

  // Web fallback using SharedPreferences
  Future<String?> _read(String key) async {
    if (kIsWeb) {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(key);
    }
    try {
      return await _storage.read(key: key);
    } on PlatformException {
      // Keystore keys are invalid (e.g. after reinstall or signing-key change).
      // Wipe all encrypted storage so the app can recover gracefully.
      await _storage.deleteAll();
      return null;
    }
  }

  Future<void> _write(String key, String value) async {
    if (kIsWeb) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(key, value);
    } else {
      await _storage.write(key: key, value: value);
    }
  }

  Future<void> _delete(String key) async {
    if (kIsWeb) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(key);
    } else {
      await _storage.delete(key: key);
    }
  }

  Future<String> getUsername() async => await _read(_keyUsername) ?? '';
  Future<String> getPassword() async => await _read(_keyPassword) ?? '';
  Future<String?> getAccessToken() async => await _read(_keyAccessToken);
  Future<String?> getRefreshToken() async => await _read(_keyRefreshToken);

  Future setUsername(String username) async =>
      await _write(_keyUsername, username);
  Future setPassword(String password) async =>
      await _write(_keyPassword, password);
  Future setAccessToken(String accessToken) async =>
      await _write(_keyAccessToken, accessToken);
  Future setRefreshToken(String refreshToken) async =>
      await _write(_keyRefreshToken, refreshToken);

  Future loadSecureStorageData() async {
    if (await _read(_keyUsername) == null) {
      await setUsername('');
    }
    if (await _read(_keyPassword) == null) {
      await setPassword('');
    }
  }

  Future clear() async {
    await _delete(_keyUsername);
    await _delete(_keyPassword);
    await _delete(_keyAccessToken);
    await _delete(_keyRefreshToken);
    await _delete(_keyCurrentProfile);
  }

  Future clearProfiles() async {
    await _delete(_keyProfiles);
    await _delete(_keyCurrentProfile);
  }
}
