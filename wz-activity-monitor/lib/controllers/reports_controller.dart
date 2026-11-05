import 'dart:async';

import 'package:get/get.dart';
import 'package:wzam/models/mixed_report.dart';
import 'package:wzam/models/report.dart';
import 'package:wzam/services/auth_service.dart';
import 'package:wzam/services/file_storage.dart';

class ReportsController extends GetxController {
  AuthService authService = Get.find<AuthService>();
  RxList<MixedReportLocal> localReports = <MixedReportLocal>[].obs;
  RxBool tryingToUpload = false.obs;
  RxBool areThereLocalReports = false.obs;

  Rx<Report?> selectedReport = Rx<Report?>(null);

  String? userId = '';

  @override
  void onInit() {
    super.onInit();
    unawaited(syncLocalReportsState());
  }

  Future<void> initialize() async {
    userId = await authService.getUserId();
  }

  Future<void> syncLocalReportsState() async {
    FileStorageService fileService = Get.find<FileStorageService>();
    await fileService.refreshLocalUploadState();
    localReports.value = fileService.localReports.toList();
    areThereLocalReports.value = fileService.hasLocalReports.value;
  }
}
