import 'dart:convert';
import 'dart:io';
import 'dart:async';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:wzam/app_config.dart';
import 'package:wzam/models/datahub/lat_lng_and_milepost.dart';
import 'package:wzam/models/datahub/route_and_measure.dart';
import 'package:wzam/models/datahub/route_and_measure_range.dart';
import 'package:wzam/models/live_worker_location.dart';
import 'package:wzam/models/mixed_report.dart';
import 'package:wzam/models/mobile_vehicle_location.dart';
import 'package:wzam/models/notification_model.dart';
import 'package:wzam/models/page.dart';
import 'package:wzam/models/recording.dart';
import 'package:wzam/models/report.dart';
import 'package:wzam/models/road_event_status/road_event_status.dart';
import 'package:wzam/models/report_patch.dart';
import 'package:wzam/models/support_request.dart';
import 'package:wzam/models/user_registration_request.dart';
import 'package:wzam/models/worker_presence_report.dart';
import 'package:wzam/models/wrappers/field_device_reading.dart';
import 'package:wzam/models/wrappers/project_wrapper.dart';
import 'package:wzam/models/wrappers/road_event_wrapper.dart';
import 'package:wzam/services/auth_service.dart';
import 'package:wzam/services/app_update_service.dart';
import 'package:wzam/services/app_version_service.dart';
import 'package:wzam/services/push_notification_service.dart';
import 'package:wzam/ui/pages/login.dart';
import 'package:wzam/ui/pages/update_required_page.dart';

class WzamApi {
  static const Set<int> _retryableStatusCodes = <int>{
    408,
    425,
    429,
    500,
    502,
    503,
    504,
  };

  static Future<String?> _getCurrentAuthToken(AuthService authService) async {
    return await authService.getAccessToken();
  }

  static Future<void> _pushNotification(NotificationModel notification) async {
    PushNotificationService pushNotificationService =
        Get.find<PushNotificationService>();
    pushNotificationService.showSimpleNotification(
      title: notification.title,
      body: notification.body,
      payload: notification.title,
      id: 0,
    );
  }

  static Future<void> _pushNotificationForError(
      NotificationModel notification, String errorMessage) async {
    PushNotificationService pushNotificationService =
        Get.find<PushNotificationService>();
    pushNotificationService.showSimpleNotification(
      title: notification.title,
      body: "${notification.body}. Error: $errorMessage",
      payload: notification.title,
      id: 0,
    );
  }

  static Future<void> _logoutUser(AuthService authService) async {
    if (authService.logoutBlocked) {
      authService.deferLogout();
      return;
    }
    await authService.logoutUser();
    Get.offAll(() => LoginPage());
  }

  static Future<void> _forceUpdateNavigation() async {
    if (Get.isRegistered<AppUpdateService>()) {
      await Get.find<AppUpdateService>().enforceHardUpdate();
      return;
    }
    Get.offAll(() => const UpdateRequiredPage());
  }

  static Future<String> _getAppSemver() async {
    if (Get.isRegistered<AppVersionService>()) {
      return await Get.find<AppVersionService>().getSemver();
    }
    return '0.0.0';
  }

  static Future<http.Response?> makeAuthenticatedGetRequest(String endpoint,
      {Map<String, String>? additionalHeaders,
      bool requireLogin = true,
      int retryLimit = 0,
      NotificationModel? onErrorNotification}) async {
    AuthService authService = Get.find<AuthService>();
    String? token = await _getCurrentAuthToken(authService);
    DateTime? expirationDate = AuthService.getTokenExpiration(token);
    if (expirationDate != null &&
        DateTime.now().isAfter(expirationDate.subtract(const Duration(minutes: 5)))) { 
      // Token is expired or about to expire in the next 5 minute, attempt to refresh
      bool refreshTokenValid = await authService.isRefreshTokenValid();
      if (refreshTokenValid) {
        int refreshStatusCode = await authService.refreshToken();
        if (refreshStatusCode == 200) {
          token = await _getCurrentAuthToken(authService);
        } else {
          _logoutUser(authService);
          return null;
        }
      } else {
        _logoutUser(authService);
        return null;
      }
    }
    Map<String, String> headers = {
      'Authorization': 'Bearer $token',
      'X-App-Version': await _getAppSemver(),
    };

    if (additionalHeaders != null) {
      headers.addAll(additionalHeaders);
    }

    try {
      final int maxAttempts = retryLimit < 0 ? 1 : retryLimit + 1;
      for (int attempt = 1; attempt <= maxAttempts; attempt++) {
        final response = await http
            .get(
              Uri.parse(endpoint),
              headers: headers,
            )
            .timeout(
              const Duration(seconds: 10),
              onTimeout: () => http.Response('Timeout', 408),
            );

        print(
            "GET request to $endpoint, Code: ${response.statusCode}, Attempt: $attempt/$maxAttempts");

        switch (response.statusCode) {
          case 200:
          case 201:
          case 202:
          case 204:
            // TODO: Remove commented code once printing is no longer useful
            // try {
            //   final decoded = jsonDecode(response.body);
            //   if (decoded is Map<String, dynamic> && decoded.containsKey('content') && decoded['content'] is List) {
            //     for (var item in decoded['content']) {
            //       print(const JsonEncoder.withIndent('  ').convert(item));
            //     }
            //   } else {
            //     print(const JsonEncoder.withIndent('  ').convert(decoded));
            //   }
            // } catch (e) {
            //   print('Error decoding response body: $e');
            //   print(response.body);
            // }
            return response;
          case 401:
            if (requireLogin) _logoutUser(authService);
            return null;
          case 426:
            await _forceUpdateNavigation();
            return null;
          default:
            final bool canRetry =
                _retryableStatusCodes.contains(response.statusCode) &&
                    attempt < maxAttempts;
            if (canRetry) {
              await Future<void>.delayed(const Duration(milliseconds: 300));
              continue;
            }

            if (onErrorNotification != null) {
              _pushNotificationForError(onErrorNotification, response.body);
            }
            return null;
        }
      }

      return null;
    } on SocketException catch (_) {
      if (onErrorNotification != null) {
        _pushNotification(onErrorNotification.copyWith(title: "Network Error"));
      }
      return null;
    }
  }

  static Future<http.Response?> makeAuthenticatedPostRequest(
      String endpoint, String body,
      {Map<String, String>? additionalHeaders,
      bool requireLogin = true,
      NotificationModel? onErrorNotification}) async {
    AuthService authService = Get.find<AuthService>();
    String? token = await _getCurrentAuthToken(authService);
    DateTime? expirationDate = AuthService.getTokenExpiration(token);
    if (expirationDate != null &&
        DateTime.now().isAfter(expirationDate.subtract(const Duration(minutes: 5)))) { 
      bool refreshTokenValid = await authService.isRefreshTokenValid();
      if (refreshTokenValid) {
        int refreshStatusCode = await authService.refreshToken();
        if (refreshStatusCode == 200) {
          token = await _getCurrentAuthToken(authService);
        } else {
          _logoutUser(authService);
          return null;
        }
      } else {
        _logoutUser(authService);
        return null;
      }
    }
    Map<String, String> headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
      'X-App-Version': await _getAppSemver(),
    };

    if (additionalHeaders != null) {
      headers.addAll(additionalHeaders);
    }
    try {
      var response = await http
          .post(
            Uri.parse(endpoint),
            headers: headers,
            body: body,
          )
          .timeout(
            const Duration(seconds: 30),
            onTimeout: () => http.Response('Timeout', 408),
          );
      print(
          "POST request to $endpoint, Code: ${response.statusCode}");
      switch (response.statusCode) {
        case 200 || 201 || 202 || 204:
          return response;
        case 401:
          if (requireLogin) _logoutUser(authService);
          return null;
        case 426:
          await _forceUpdateNavigation();
          return null;
        default:
          if (onErrorNotification != null) {
            _pushNotificationForError(onErrorNotification, response.body);
          }
          return null;
      }
    } on SocketException catch (_) {
      if (onErrorNotification != null) {
        _pushNotification(onErrorNotification.copyWith(title: "Network Error"));
      }
      return null;
    }
  }

  static Future<http.Response?> makeAuthenticatedPutRequest(
      String endpoint, String body,
      {Map<String, String>? additionalHeaders,
      bool requireLogin = true,
      NotificationModel? onErrorNotification}) async {
    AuthService authService = Get.find<AuthService>();
    String? token = await _getCurrentAuthToken(authService);
    Map<String, String> headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
      'X-App-Version': await _getAppSemver(),
    };

    if (additionalHeaders != null) {
      headers.addAll(additionalHeaders);
    }
    try {
      var response = await http
          .put(
            Uri.parse(endpoint),
            headers: headers,
            body: body,
          )
          .timeout(
            const Duration(seconds: 30),
            onTimeout: () => http.Response('Timeout', 408),
          );
      print(
          "PUT request to $endpoint, Code: ${response.statusCode}");
      switch (response.statusCode) {
        case 200:
        case 201:
        case 202:
        case 204:
          return response;
        case 401:
          if (requireLogin) _logoutUser(authService);
          return null;
        case 426:
          await _forceUpdateNavigation();
          return null;
        default:
          if (onErrorNotification != null) {
            _pushNotificationForError(onErrorNotification, response.body);
          }
          return null;
      }
    } on SocketException catch (_) {
      if (onErrorNotification != null) {
        _pushNotification(onErrorNotification.copyWith(title: "Network Error"));
      }
      return null;
    }
  }

  static Future<http.Response?> makeAuthenticatedPatchRequest(
      String endpoint, String body,
      {Map<String, String>? additionalHeaders,
      bool requireLogin = true,
      NotificationModel? onErrorNotification}) async {
    AuthService authService = Get.find<AuthService>();
    String? token = await _getCurrentAuthToken(authService);
    Map<String, String> headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
      'X-App-Version': await _getAppSemver(),
    };

    if (additionalHeaders != null) {
      headers.addAll(additionalHeaders);
    }
    try {
      var response = await http
          .patch(
            Uri.parse(endpoint),
            headers: headers,
            body: body,
          )
          .timeout(
            const Duration(seconds: 30),
            onTimeout: () => http.Response('Timeout', 408),
          );
      print(
          "PATCH request to $endpoint, Code: ${response.statusCode}");
      switch (response.statusCode) {
        case 200 || 201 || 202 || 204:
          return response;
        case 401:
          if (requireLogin) _logoutUser(authService);
          return null;
        case 426:
          await _forceUpdateNavigation();
          return null;
        default:
          if (onErrorNotification != null) {
            _pushNotificationForError(onErrorNotification, response.body);
          }
          return null;
      }
    } on SocketException catch (_) {
      if (onErrorNotification != null) {
        _pushNotification(onErrorNotification.copyWith(title: "Network Error"));
      }
      return null;
    }
  }

  static Future<bool> updatePhoneNumber(String phoneNumber) async {
    final response = await makeAuthenticatedPatchRequest(
      "${AppConfig.apiBaseUrl}/auth/user-properties",
      jsonEncode({"phone_number": phoneNumber}),
    );
    return response != null;
  }

  static Future<Page<MixedReport>?> getReports(
      {NotificationModel? onErrorNotification}) async {
    var response = await makeAuthenticatedGetRequest(
        "${AppConfig.apiBaseUrl}/wzam/reports",
        onErrorNotification: onErrorNotification);
    if (response == null) return null;
    try {
      final dynamic decoded = json.decode(response.body);
      if (decoded is! Map<String, dynamic>) {
        print(
            'Error parsing Reports: unexpected payload type ${decoded.runtimeType}');
        return null;
      }

      final List<dynamic> rawContent = decoded['content'] is List
          ? decoded['content'] as List<dynamic>
          : const <dynamic>[];
      final List<MixedReport> parsedContent = <MixedReport>[];

      for (final dynamic item in rawContent) {
        if (item is! Map) {
          continue;
        }
        final Map<String, dynamic> itemMap = Map<String, dynamic>.from(item);
        final parsed = MixedReport.tryFromIndividualJson(itemMap);
        if (parsed != null) {
          parsedContent.add(parsed);
        } else {
          print('Skipped unparseable report item: $itemMap');
        }
      }

      final Page<MixedReport> output = Page<MixedReport>(
        content: parsedContent,
        pageable: _parsePageable(decoded['pageable']),
        totalPages: _asInt(decoded['totalPages']),
        totalElements: _asInt(decoded['totalElements']),
        last: _asBool(decoded['last']),
        first: _asBool(decoded['first']),
        numberOfElements:
            _asInt(decoded['numberOfElements'], fallback: parsedContent.length),
        size: _asInt(decoded['size']),
        number: _asInt(decoded['number']),
        sort: _parseSort(decoded['sort']),
        empty: _asBool(decoded['empty'], fallback: parsedContent.isEmpty),
      );

      final int fullCount =
          parsedContent.where((element) => element.isFullReport).length;
      final int patchCount =
          parsedContent.where((element) => element.isPatch).length;
      print(
          'Reports fetched: total=${parsedContent.length}, full=$fullCount, patch=$patchCount');
      return output;
    } catch (e, stacktrace) {
      print("Error parsing Reports: $e, $stacktrace");

      return null;
    }
  }

  static int _asInt(dynamic value, {int fallback = 0}) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return fallback;
  }

  static bool _asBool(dynamic value, {bool fallback = false}) {
    if (value is bool) return value;
    return fallback;
  }

  static Sort _parseSort(dynamic value) {
    if (value is Map) {
      final Map<String, dynamic> json = Map<String, dynamic>.from(value);
      return Sort(
        unsorted: _asBool(json['unsorted'], fallback: true),
        sorted: _asBool(json['sorted']),
        empty: _asBool(json['empty'], fallback: true),
      );
    }
    return Sort(
      unsorted: true,
      sorted: false,
      empty: true,
    );
  }

  static Pageable _parsePageable(dynamic value) {
    if (value is Map) {
      final Map<String, dynamic> json = Map<String, dynamic>.from(value);
      return Pageable(
        pageNumber: _asInt(json['pageNumber']),
        pageSize: _asInt(json['pageSize']),
        sort: _parseSort(json['sort']),
        offset: _asInt(json['offset']),
        paged: _asBool(json['paged'], fallback: true),
        unpaged: _asBool(json['unpaged']),
      );
    }
    return Pageable(
      pageNumber: 0,
      pageSize: 0,
      sort: _parseSort(null),
      offset: 0,
      paged: true,
      unpaged: false,
    );
  }

  static Future<ReportWithId?> createReport(Report report,
      {NotificationModel? onErrorNotification}) async {
    var response = await makeAuthenticatedPostRequest(
        "${AppConfig.apiBaseUrl}/wzam/reports", jsonEncode(report),
        onErrorNotification: onErrorNotification);
    if (response == null) return null;
    return ReportWithId.fromJson(json.decode(response.body));
  }

  static Future<bool> updateReport(ReportPatch report,
      {NotificationModel? onErrorNotification}) async {
    var response = await makeAuthenticatedPatchRequest(
        "${AppConfig.apiBaseUrl}/wzam/reports", jsonEncode(report),
        onErrorNotification: onErrorNotification);
    return response?.statusCode == 201 || response?.statusCode == 200;   
  }

  static Future<bool> updateLiveReportLocation(
      LiveWorkerLocation workerLocation,
      {NotificationModel? onErrorNotification}) async {
    var response = await makeAuthenticatedPostRequest(
        "${AppConfig.apiBaseUrl}/wzam/reports/live_position",
        jsonEncode(workerLocation),
        onErrorNotification: onErrorNotification);
    return response?.statusCode == 201 || response?.statusCode == 200;
  }

  static Future<bool> updateMobileVehicleLocation(
      MobileVehicleLocation vehicleLocation,
      {NotificationModel? onErrorNotification}) async {
    var response = await makeAuthenticatedPostRequest(
        "${AppConfig.apiBaseUrl}/wzam/reports/mobile-vehicle",
        jsonEncode(vehicleLocation),
        onErrorNotification: onErrorNotification);
    return response?.statusCode == 201 || response?.statusCode == 200;
  }

  static Future<Page<RecordingWithId>?> getRecordings(
      {NotificationModel? onErrorNotification}) async {
    var response = await makeAuthenticatedGetRequest(
        "${AppConfig.apiBaseUrl}/wzam/recordings",
        onErrorNotification: onErrorNotification);
    if (response == null) return null;
    return Page<RecordingWithId>.fromJson(json.decode(response.body),
        (json) => RecordingWithId.fromJson(json as Map<String, dynamic>));
  }

  static Future<RecordingWithId?> createRecording(Recording recording,
      {NotificationModel? onErrorNotification}) async {
    var response = await makeAuthenticatedPostRequest(
        "${AppConfig.apiBaseUrl}/wzam/recordings", jsonEncode(recording),
        onErrorNotification: onErrorNotification);
    if (response == null) return null;
    return RecordingWithId.fromJson(json.decode(response.body));
  }

  static Future<bool> updateRecording(RecordingWithId recording,
      {NotificationModel? onErrorNotification}) async {
    var response = await makeAuthenticatedPutRequest(
        "${AppConfig.apiBaseUrl}/wzam/recordings", jsonEncode(recording),
        onErrorNotification: onErrorNotification);
    return response?.statusCode == 201;
  }

  static Future<Page<ProjectWrapper>?> getProjects(
      {NotificationModel? onErrorNotification}) async {
    var response = await makeAuthenticatedGetRequest(
        "${AppConfig.apiBaseUrl}/wzam/projects",
        onErrorNotification: onErrorNotification);
    if (response == null) return null;
    return Page<ProjectWrapper>.fromJson(json.decode(response.body),
        (json) => ProjectWrapper.fromJson(json as Map<String, dynamic>));
  }

  static Future<Page<RoadEventWrapper>?> getRoadEvents(
      {NotificationModel? onErrorNotification}) async {
    var response = await makeAuthenticatedGetRequest(
        "${AppConfig.apiBaseUrl}/wzam/road_events",
        onErrorNotification: onErrorNotification);
    if (response == null) return null;
    try {
      Page<RoadEventWrapper> output = Page<RoadEventWrapper>.fromJson(
          json.decode(response.body),
          (json) => RoadEventWrapper.fromJson(json as Map<String, dynamic>));
      print("Road Events fetched: ${output.content.length}");
      return output;
    } catch (e, stacktrace) {
      print("Error parsing Road Events: $e, $stacktrace");
      
      return null;
    }
  }

  static Future<Page<FieldDeviceReading>?> getFieldDevices(
      {NotificationModel? onErrorNotification}) async {
    var response = await makeAuthenticatedGetRequest(
        "${AppConfig.apiBaseUrl}/wzam/field_device_readings",
        onErrorNotification: onErrorNotification);
    if (response == null) return null;
    return Page<FieldDeviceReading>.fromJson(json.decode(response.body),
        (json) => FieldDeviceReading.fromJson(json as Map<String, dynamic>));
  }

  static Future<int?> createWorkerPresenceReport(WorkerPresenceReport report,
      {NotificationModel? onErrorNotification}) async {
    var response = await makeAuthenticatedPostRequest(
        "${AppConfig.apiBaseUrl}/wzam/worker-presence-reports",
        jsonEncode(report),
        onErrorNotification: onErrorNotification);
    if (response == null) return null;
    return response.body as int;
  }

  static Future<String?> registerNewUser(UserRegistrationRequest request,
      {NotificationModel? onErrorNotification}) async {
    String endpoint = "${AppConfig.apiBaseUrl}/auth/registration";
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'X-App-Version': await _getAppSemver(),
    };
    print("Registering new user to $endpoint with body ${jsonEncode(request)}");

    try {
      var response = await http
          .post(
            Uri.parse(endpoint),
            headers: headers,
            body: jsonEncode(request),
          )
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () => http.Response('Timeout', 408),
          );
      print(
          "POST request to $endpoint, Code: ${response.statusCode}");
      switch (response.statusCode) {
        case 200:
        case 201:
        case 202:
        case 204:
          return null;
        case 426:
          await _forceUpdateNavigation();
          return null;
        default:
          print(
              "Error registering new user: ${response.statusCode}");
          return "Unknown error: ${response.statusCode}";
      }
    } on SocketException catch (_) {
      print("Timeout registering new user");
      return "Request Timed Out - Check Connection";
    }
  }

  static Future<void> submitSupportRequest(SupportRequest request) async {
    String endpoint = "${AppConfig.apiBaseUrl}/wzam/support-request";
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'X-App-Version': await _getAppSemver(),
    };
    print("Submitting support request to $endpoint with body ${jsonEncode(request)}");

    try {
      var response = await http
          .post(
            Uri.parse(endpoint),
            headers: headers,
            body: jsonEncode(request),
          )
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () => http.Response('Timeout', 408),
          );
      print(
          "POST request to $endpoint, Code: ${response.statusCode}");
      switch (response.statusCode) {
        case 201:
          return;
        case 426:
          await _forceUpdateNavigation();
          return;
        default:
          print(
              "Error submitting support request: ${response.statusCode}");
          return;
      }
    } on SocketException catch (_) {
      print("Timeout submitting support request");
      return;
    }
  }

  static Future<Page<RoadEventStatus>?> getRoadEventStatusList(String userId,
      {NotificationModel? onErrorNotification}) async {
    var response = await makeAuthenticatedGetRequest(
        "${AppConfig.apiBaseUrl}/wzam/road_event_status?user_id=$userId",
        onErrorNotification: onErrorNotification);
    if (response == null) return null;
    return Page<RoadEventStatus>.fromJson(json.decode(response.body),
        (json) => RoadEventStatus.fromJson(json as Map<String, dynamic>));
  }

  // ── GIS endpoints ──────────────────────────────────────────────────────────

  static Future<RouteAndMeasure?> getClosestRouteAndMeasure(
      double latitude, double longitude,
      {int tolerance = 1000, NotificationModel? onErrorNotification}) async {
    final uri =
        Uri.parse('${AppConfig.apiBaseUrl}/gis/closest-route-to-measure')
            .replace(queryParameters: {
      'latitude': '$latitude',
      'longitude': '$longitude',
      'tolerance': '$tolerance',
    });
    var response = await makeAuthenticatedGetRequest(uri.toString(),
        onErrorNotification: onErrorNotification, retryLimit: 4);
    if (response == null) return null;
    return RouteAndMeasure.fromJson(json.decode(response.body));
  }

  static Future<RouteAndMeasure?> getExpectedRouteAndMeasure(
      double latitude, double longitude, String expectedRouteId,
      {int tolerance = 100, NotificationModel? onErrorNotification}) async {
    final uri =
        Uri.parse('${AppConfig.apiBaseUrl}/gis/expected-route-and-measure')
            .replace(queryParameters: {
      'latitude': '$latitude',
      'longitude': '$longitude',
      'tolerance': '$tolerance',
      'expectedRouteId': expectedRouteId,
    });
    var response = await makeAuthenticatedGetRequest(uri.toString(),
        onErrorNotification: onErrorNotification, retryLimit: 4);
    if (response == null || response.body.isEmpty) return null;
    return RouteAndMeasure.fromJson(json.decode(response.body));
  }

  static Future<RouteAndMeasureRange?> getMatchingRouteAndMeasure(
      double latitude1, double longitude1, double latitude2, double longitude2,
      {int tolerance = 100, NotificationModel? onErrorNotification}) async {
    final uri =
        Uri.parse('${AppConfig.apiBaseUrl}/gis/matching-route-and-measure')
            .replace(queryParameters: {
      'latitude1': '$latitude1',
      'longitude1': '$longitude1',
      'latitude2': '$latitude2',
      'longitude2': '$longitude2',
      'tolerance': '$tolerance',
    });
    var response = await makeAuthenticatedGetRequest(uri.toString(),
        onErrorNotification: onErrorNotification, retryLimit: 4);
    if (response == null || response.body.isEmpty) return null;
    return RouteAndMeasureRange.fromJson(json.decode(response.body));
  }

  static Future<RouteAndMeasure?> translateMeasure(
      String routeId, double measure,
      {NotificationModel? onErrorNotification}) async {
    final uri = Uri.parse('${AppConfig.apiBaseUrl}/gis/translate-measure')
        .replace(queryParameters: {
      'routeId': routeId,
      'measure': '$measure',
    });
    var response = await makeAuthenticatedGetRequest(uri.toString(),
        onErrorNotification: onErrorNotification, retryLimit: 4);
    if (response == null || response.body.isEmpty) return null;
    return RouteAndMeasure.fromJson(json.decode(response.body));
  }

  static Future<List<Map<String, dynamic>>?> getRouteGeometry(
      String routeId, double startMeasure, double endMeasure,
      {NotificationModel? onErrorNotification}) async {
    final uri = Uri.parse('${AppConfig.apiBaseUrl}/gis/route-geometry')
        .replace(queryParameters: {
      'routeId': routeId,
      'startMeasure': '$startMeasure',
      'endMeasure': '$endMeasure',
    });
    var response = await makeAuthenticatedGetRequest(uri.toString(),
        onErrorNotification: onErrorNotification, retryLimit: 4);
    if (response == null || response.body.isEmpty) return null;
    return List<Map<String, dynamic>>.from(json.decode(response.body));
  }

  static Future<List<LatLngAndMilepost>?> getRouteGeometryWithMeasures(
      String routeId, double startMeasure, double endMeasure,
      {NotificationModel? onErrorNotification}) async {
    final uri =
        Uri.parse('${AppConfig.apiBaseUrl}/gis/route-geometry-with-measures')
            .replace(queryParameters: {
      'routeId': routeId,
      'startMeasure': '$startMeasure',
      'endMeasure': '$endMeasure',
    });
    var response = await makeAuthenticatedGetRequest(uri.toString(),
        onErrorNotification: onErrorNotification, retryLimit: 4);
    if (response == null || response.body.isEmpty) return null;
    return (json.decode(response.body) as List)
        .map((e) => LatLngAndMilepost.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  static Future<Map<String, dynamic>?> getGeometryForMeasure(
      String routeId, double measure,
      {NotificationModel? onErrorNotification}) async {
    final uri = Uri.parse('${AppConfig.apiBaseUrl}/gis/geometry-for-measure')
        .replace(queryParameters: {
      'routeId': routeId,
      'measure': measure.toStringAsFixed(3),
    });
    var response = await makeAuthenticatedGetRequest(uri.toString(),
        onErrorNotification: onErrorNotification, retryLimit: 4);
    if (response == null || response.body.isEmpty) return null;
    return json.decode(response.body) as Map<String, dynamic>;
  }

  static Future<String?> getRoadName(
      String routeId, double startMeasure, double endMeasure,
      {NotificationModel? onErrorNotification}) async {
    final uri = Uri.parse('${AppConfig.apiBaseUrl}/gis/road-name')
        .replace(queryParameters: {
      'routeId': routeId,
      'startMeasure': '$startMeasure',
      'endMeasure': '$endMeasure',
    });
    var response = await makeAuthenticatedGetRequest(uri.toString(),
        onErrorNotification: onErrorNotification, retryLimit: 4);
    if (response == null || response.body.isEmpty) return null;
    return response.body;
  }
}
