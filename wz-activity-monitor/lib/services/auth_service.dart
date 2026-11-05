import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:wzam/app_config.dart';
import 'package:wzam/models/forgot_password_request.dart';
import 'package:wzam/models/reset_password_request.dart';
import 'package:wzam/services/app_update_service.dart';
import 'package:wzam/services/app_version_service.dart';
import 'package:wzam/services/secure_storage.dart';
import 'package:wzam/ui/pages/login.dart';
import 'package:wzam/ui/pages/update_required_page.dart';

class AuthService {
  final SecureStorage _secureStorage = Get.put(SecureStorage());

  bool _logoutBlocked = false;
  bool _logoutDeferred = false;

  /// Prevents automatic logout from firing (e.g. during a recording session).
  /// If a logout was triggered while blocked, it will execute when [unblockLogout] is called.
  void blockLogout() {
    _logoutBlocked = true;
    _logoutDeferred = false;
  }

  /// Re-enables automatic logout. Executes a deferred logout immediately if
  /// one was queued while the block was active.
  Future<void> unblockLogout() async {
    _logoutBlocked = false;
    if (_logoutDeferred) {
      _logoutDeferred = false;
      await logoutUser();
      Get.offAll(() => LoginPage());
    }
  }

  /// Whether a logout attempt was suppressed while the block was active.
  bool get isLogoutDeferred => _logoutDeferred;

  /// Whether logout is currently blocked.
  bool get logoutBlocked => _logoutBlocked;

  /// Marks a logout as deferred (called by WzamApi when blocked).
  void deferLogout() {
    _logoutDeferred = true;
  }

  Future<String> _getAppSemver() async {
    if (Get.isRegistered<AppVersionService>()) {
      return await Get.find<AppVersionService>().getSemver();
    }
    return '0.0.0';
  }

  Future<Map<String, String>> _buildHeaders({
    bool includeJson = false,
    bool includeAuth = false,
  }) async {
    final headers = <String, String>{
      'X-App-Version': await _getAppSemver(),
    };

    if (includeJson) {
      headers['Content-Type'] = 'application/json';
    }

    if (includeAuth) {
      headers['Authorization'] = 'Bearer ${await getAccessToken()}';
    }

    return headers;
  }

  Future<void> _forceUpdateNavigation() async {
    if (Get.isRegistered<AppUpdateService>()) {
      await Get.find<AppUpdateService>().enforceHardUpdate();
      return;
    }
    Get.offAll(() => const UpdateRequiredPage());
  }

  Future<String> getUsername() async => await _secureStorage.getUsername();
  Future<String> getPassword() async => await _secureStorage.getPassword();
  Future<String?> getAccessToken() async =>
      await _secureStorage.getAccessToken();
  Future<String?> getRefreshToken() async =>
      await _secureStorage.getRefreshToken();
  Future<String?> getUserId() async => _getIdFromToken(await getAccessToken());

  Future setUsername(String username) async =>
      await _secureStorage.setUsername(username);
  Future setPassword(String password) async =>
      await _secureStorage.setPassword(password);
  Future setAccessToken(String accessToken) async =>
      await _secureStorage.setAccessToken(accessToken);
  Future setRefreshToken(String refreshToken) async =>
      await _secureStorage.setRefreshToken(refreshToken);

  loadSecureStorageData() async {
    await _secureStorage.loadSecureStorageData();
  }

  Future clear() async {
    await _secureStorage.clear();
  }

  Future<int> forgotPassword(String email) async {
    try {
      var res = await http
          .post(Uri.parse('${AppConfig.apiBaseUrl}/auth/forgot-password'),
              headers: await _buildHeaders(includeJson: true),
              body: jsonEncode(ForgotPasswordRequest(email: email).toJson()))
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () => http.Response('Timeout', 408),
          );

      switch (res.statusCode) {
        case 426:
          await _forceUpdateNavigation();
          return res.statusCode;
        default:
          return res.statusCode;
      }
    } on SocketException catch (_) {
      return 408;
    }
  }

  Future<int> resetPassword({
    required String email,
    required String code,
    required String newPassword,
  }) async {
    try {
      var res = await http
          .post(Uri.parse('${AppConfig.apiBaseUrl}/auth/reset-password'),
              headers: await _buildHeaders(includeJson: true),
              body: jsonEncode(ResetPasswordRequest(
                email: email,
                code: code,
                newPassword: newPassword,
              ).toJson()))
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () => http.Response('Timeout', 408),
          );

      switch (res.statusCode) {
        case 200:
        case 201:
        case 202:
        case 204:
          await _secureStorage.setUsername(email);
          await _secureStorage.setPassword(newPassword);
          return res.statusCode;
        case 426:
          await _forceUpdateNavigation();
          return res.statusCode;
        default:
          debugPrint(
              'An Error Occurred while resetting password. Status code: ${res.statusCode} , body: ${res.body.toString()}');
          return res.statusCode;
      }
    } on SocketException catch (_) {
      return 408;
    }
  }

  Future<int> authenticateUser(String username, String password) async {
    try {
      var res = await http
          .post(Uri.parse('${AppConfig.apiBaseUrl}/auth/token'),
              headers: await _buildHeaders(includeJson: true),
              body: jsonEncode({"username": username, "password": password}))
          .timeout(
            const Duration(seconds: 5),
            onTimeout: () => http.Response('Timeout', 408),
          );

      switch (res.statusCode) {
        case 200:
          var data = jsonDecode(res.body);
          await _secureStorage.setAccessToken(data['access_token']);
          await _secureStorage.setRefreshToken(data['refresh_token']);
          return res.statusCode;
        case 426:
          await _forceUpdateNavigation();
          return res.statusCode;
        default:
          debugPrint(
              "An Error Occurred while logging in. Status code: ${res.statusCode} , body: ${res.body.toString()}");
          return res.statusCode;
      }
    } on SocketException catch (_) {
      return 408;
    }
  }

  Future<int> refreshToken() async {
    try {
      var res = await http
          .post(Uri.parse('${AppConfig.apiBaseUrl}/auth/refresh'),
              headers: await _buildHeaders(includeJson: true),
              body: jsonEncode({
                "refresh_token": await getRefreshToken(),
              }))
          .timeout(
            const Duration(seconds: 5),
            onTimeout: () => http.Response('Timeout', 408),
          );

      switch (res.statusCode) {
        case 200:
          var data = jsonDecode(res.body);
          await _secureStorage.setAccessToken(data['access_token']);
          await _secureStorage.setRefreshToken(data['refresh_token']);
          print("Token refreshed successfully");
          return res.statusCode;
        case 426:
          await _forceUpdateNavigation();
          return res.statusCode;
        default:
          debugPrint(
              "An Error Occurred while refreshing token. Status code: ${res.statusCode} , body: ${res.body.toString()}");
          return res.statusCode;
      }
    } on SocketException catch (_) {
      return 408; // Timeout or network error
    }
  }

  Future<int> registerNewUser(
      {required String email,
      required String firstName,
      required String lastName,
      required String phoneNumber,
      required String password}) async {
    try {
      var res = await http
          .post(Uri.parse('${AppConfig.apiBaseUrl}/auth/registration'),
              headers: await _buildHeaders(includeJson: true),
              body: jsonEncode({
                "email": email,
                "username": email,
                "first_name": firstName,
                "last_name": lastName,
                "phone_number": phoneNumber,
                "password": password,
              }))
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () => http.Response('Timeout', 408),
          );

      switch (res.statusCode) {
        case 200:
          var data = jsonDecode(res.body);
          await _secureStorage.setAccessToken(data['access_token']);
          await _secureStorage.setRefreshToken(data['refresh_token']);
          return res.statusCode;
        case 426:
          await _forceUpdateNavigation();
          return res.statusCode;
        default:
          debugPrint(
              "An Error Occurred while logging in. Status code: ${res.statusCode} , body: ${res.body.toString()}");
          return res.statusCode;
      }
    } on SocketException catch (_) {
      return 408;
    }
  }

  Future<List<String>?> getAccessRequestEmails() async {
    try {
      var res = await http.get(
          Uri.parse('${AppConfig.apiBaseUrl}/auth/access-request-emails'),
          headers: await _buildHeaders(includeAuth: true)).timeout(
        const Duration(seconds: 5),
        onTimeout: () => http.Response('Timeout', 408),
      );

      switch (res.statusCode) {
        case 200:
          return res.body.isNotEmpty
              ? List<String>.from(jsonDecode(res.body))
              : [];
        case 426:
          await _forceUpdateNavigation();
          return null;
        default:
          debugPrint(
              "An Error Occurred while requesting access emails. Status code: ${res.statusCode} , body: ${res.body.toString()}");
          return null;
      }
    } on SocketException catch (_) {
      return null;
    }
  }

  Future<int> logoutUser() async {
    try {
      var res = await http
          .post(Uri.parse('${AppConfig.apiBaseUrl}/auth/logout'),
              headers: await _buildHeaders(includeJson: true),
              body: jsonEncode({
                "refresh_token": await getRefreshToken(),
              }))
          .timeout(
            const Duration(seconds: 5),
            onTimeout: () => http.Response('Timeout', 408),
          );

      switch (res.statusCode) {
        case 204:
          print("Logged out successfully");
          return res.statusCode;
        case 426:
          await _forceUpdateNavigation();
          return res.statusCode;
        default:
          debugPrint(
              "An Error Occurred while logging out. Status code: ${res.statusCode} , body: ${res.body.toString()}");
          return res.statusCode;
      }
    } on SocketException catch (_) {
      return 408;
    }
  }

  Future<int> deleteUserAccount() async {
    try {
      var res = await http.delete(
          Uri.parse(
              '${AppConfig.apiBaseUrl}/auth/delete-account/${await getUserId()}'),
          headers: await _buildHeaders(includeAuth: true)).timeout(
        const Duration(seconds: 5),
        onTimeout: () => http.Response('Timeout', 408),
      );

      switch (res.statusCode) {
        case 200:
        case 204:
          print("User account deleted successfully");
          return res.statusCode;
        case 426:
          await _forceUpdateNavigation();
          return res.statusCode;
        default:
          debugPrint(
              "An Error Occurred while deleting user account. Status code: ${res.statusCode} , body: ${res.body.toString()}");
          return res.statusCode;
      }
    } on SocketException catch (_) {
      return 408;
    }
  }

  Future<int> changePassword({
    required String newPassword,
  }) async {
    try {
      var res = await http
          .post(Uri.parse('${AppConfig.apiBaseUrl}/auth/change-password'),
              headers: await _buildHeaders(includeAuth: true, includeJson: true),
              body: jsonEncode({
                'new_password': newPassword,
              }))
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () => http.Response('Timeout', 408),
          );

      switch (res.statusCode) {
        case 200:
        case 201:
        case 202:
        case 204:
          await _secureStorage.setPassword(newPassword);
          return res.statusCode;
        case 426:
          await _forceUpdateNavigation();
          return res.statusCode;
        default:
          debugPrint(
              'An Error Occurred while changing password. Status code: ${res.statusCode} , body: ${res.body.toString()}');
          return res.statusCode;
      }
    } on SocketException catch (_) {
      return 408;
    }
  }

  List<String> getRolesFromToken(String token) {
    String payload = token.split('.')[1];
    String normalizedPayload = base64Url.normalize(payload);
    String decodedPayload = utf8.decode(base64Url.decode(normalizedPayload));
    Map<String, dynamic> payloadMap = jsonDecode(decodedPayload);
    List<String> roles = List<String>.from(payloadMap['realm_access']['roles']);
    return roles;
  }

  String? getPhoneNumberFromToken(String token) {
    String payload = token.split('.')[1];
    String normalizedPayload = base64Url.normalize(payload);
    String decodedPayload = utf8.decode(base64Url.decode(normalizedPayload));
    Map<String, dynamic> payloadMap = jsonDecode(decodedPayload);
    String? phoneNumber = payloadMap['phone_number'] ?? '';
    String? localPhoneNumber = payloadMap['local_phone_number'] ?? '';
    return phoneNumber != null && phoneNumber.isNotEmpty
        ? phoneNumber
        : (localPhoneNumber != null && localPhoneNumber.isNotEmpty
            ? localPhoneNumber
            : null);
  }

  String? getAuthSourceFromToken(String token) {
    final tokenParts = token.split('.');
    if (tokenParts.length != 3) {
      return null;
    }

    try {
      final payload = jsonDecode(utf8.decode(
        base64Url.decode(base64Url.normalize(tokenParts[1])),
      ));
      if (payload is! Map<String, dynamic>) {
        return null;
      }

      final authSource = payload['auth_source'];
      return authSource is String && authSource.trim().isNotEmpty
          ? authSource.trim()
          : null;
    } on FormatException {
      return null;
    }
  }

  static String? _getIdFromToken(String? token) {
    if (token == null) {
      return null;
    }
    String payload = token.split('.')[1];
    String normalizedPayload = base64Url.normalize(payload);
    String decodedPayload = utf8.decode(base64Url.decode(normalizedPayload));
    Map<String, dynamic> payloadMap = jsonDecode(decodedPayload);
    return payloadMap['sub'];
  }

  static DateTime? getTokenExpiration(String? token) {
    if (token == null) {
      return null;
    }
    String payload = token.split('.')[1];
    String normalizedPayload = base64Url.normalize(payload);
    String decodedPayload = utf8.decode(base64Url.decode(normalizedPayload));
    Map<String, dynamic> payloadMap = jsonDecode(decodedPayload);
    int expirationMillis =
        (payloadMap['exp'] ?? 0) * 1000; // Convert to milliseconds
    return DateTime.fromMillisecondsSinceEpoch(expirationMillis, isUtc: true);
  }

  static bool isTokenExpired(String? token,
      {Duration padding = const Duration(minutes: 5)}) {
    DateTime? expirationDate = getTokenExpiration(token);
    if (expirationDate == null) {
      return true; // If we can't determine expiration, consider it expired
    }
    return expirationDate.isBefore(DateTime.now().add(padding));
  }

  Future<bool> isAccessTokenValid(
      {Duration padding = const Duration(minutes: 5)}) async {
    String? accessToken = await getAccessToken();
    if (accessToken == null || accessToken.isEmpty) {
      return false;
    }
    return !isTokenExpired(accessToken, padding: padding);
  }

  Future<bool> isRefreshTokenValid(
      {Duration padding = const Duration(minutes: 5)}) async {
    String? refreshToken = await getRefreshToken();
    if (refreshToken == null || refreshToken.isEmpty) {
      return false;
    }
    return !isTokenExpired(refreshToken, padding: padding);
  }
}
