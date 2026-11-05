import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:latlong2/latlong.dart';

class AppConfig {
  static final apiBaseUrl = dotenv.env['API_BASE_URL']!;
  static final versionCheckEndpoint = '${apiBaseUrl}/app/version';
  static final mapboxAccessToken = dotenv.env['MAPBOX_ACCESS_TOKEN']!;
  static final adminEmailAddress = dotenv.env['ADMIN_EMAIL_ADDRESS']!;
  static final androidApplicationId =
    dotenv.env['ANDROID_APPLICATION_ID'] ?? 'com.wydot.wzam';
  static final iosAppStoreId = dotenv.env['IOS_APP_STORE_ID'] ?? '6751293464';
  static final androidStoreWebUrl =
    dotenv.env['ANDROID_STORE_URL'] ??
    'https://play.google.com/store/apps/details?id=$androidApplicationId';
  static final iosStoreUrl =
    dotenv.env['IOS_STORE_URL'] ?? 'https://apps.apple.com/app/id$iosAppStoreId';
  static final defaultMapCenter = LatLng(
    double.parse(dotenv.env['DEFAULT_MAP_CENTER_LATITUDE'] ?? "41.1644998"),
    double.parse(dotenv.env['DEFAULT_MAP_CENTER_LONGITUDE'] ?? "-104.8402687"),
  );
  static final liveReportMinUpdatePeriod = Duration(
    seconds:
        int.parse(dotenv.env['LIVE_REPORT_MIN_UPDATE_PERIOD_SECONDS'] ?? "10"),
  );
  static final liveReportMinPositionChangeMeters = double.parse(
    dotenv.env['LIVE_REPORT_MIN_POSITION_CHANGE'] ?? "50.0",
  );
}
