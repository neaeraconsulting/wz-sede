import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:wzam/services/location_health_monitor_service.dart';
import 'package:wzam/services/push_notification_service.dart';
import 'package:wzam/ui/pages/load_screen.dart';
import 'package:wzam/ui/styles/theme_setting.dart';

Future<String> getAppVersion() async {
  final info = await PackageInfo.fromPlatform();
  return "${info.version}+${info.buildNumber}";
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await dotenv.load(fileName: '.env');
  Get.put(PushNotificationService());
  Get.put(LocationHealthMonitorService(), permanent: true);
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'WZAM',
      theme: lightTheme,
      darkTheme: darkTheme,
      home: const Load(),
    );
  }
}
