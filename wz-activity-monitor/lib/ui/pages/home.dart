import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:wzam/controllers/reports_controller.dart';
import 'package:wzam/controllers/view_recordings_controller.dart';
import 'package:wzam/services/auth_service.dart';
import 'package:wzam/services/file_storage.dart';
import 'package:wzam/services/push_notification_service.dart';
import 'package:wzam/ui/pages/mobile_vehicle_map.dart';
import 'package:wzam/ui/pages/road_event_status.dart';
import 'package:wzam/ui/pages/work_zone_map.dart';
import 'package:wzam/ui/styles/app_colors.dart';
import 'package:wzam/ui/styles/screen_size.dart';
import 'package:wzam/ui/styles/spacing.dart';
import 'package:wzam/ui/styles/text_styles.dart';
import 'package:wzam/ui/styles/widgets/wzam_app_bar.dart';
import 'package:wzam/ui/styles/widgets/wzam_text.dart';

import 'package:wzam/ui/views/road_event_selection_dialog.dart';

class Home extends StatelessWidget {
  Home({super.key});
  final ScrollController _scrollController = ScrollController();
  final FileStorageService fileStorageService = Get.find<FileStorageService>();
  final ReportsController viewReportsController =
      Get.find<ReportsController>();
  final ViewRecordingsController viewRecordingsController =
      Get.find<ViewRecordingsController>();

  Future<bool> isConnectedToInternet() async {
      var connectivityResult = await Connectivity().checkConnectivity();
      return !connectivityResult.contains(ConnectivityResult.none);
    }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
    Get.find<AuthService>().unblockLogout();
    return Scaffold(
      appBar: const WZAMAppBar(
        title: 'Work Zone Activity Monitor',
      ),
      body: SafeArea(
        child: Center(
          child: Scrollbar(
            controller: _scrollController,
            thumbVisibility: true,
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                // Logo
                Obx(() => SizedBox(
                  child: Image.asset(
                    'assets/images/wzam_abr.png',
                    scale: viewRecordingsController.unUploadedRecordings.isNotEmpty ||
                            viewReportsController.areThereLocalReports.value
                        ? 3.5
                            : 2.5,
                  ),
                )),
                verticalSpaceMedium,
                Obx(() => (viewReportsController.areThereLocalReports.value ||
                        viewRecordingsController.areThereLocalRecordings.value)
                    ? unUploadedWarning(context)
                    : Container()),
                // Grid of tiles
                SizedBox(
                  width: screenWidthPercentage(context, percentage: 0.85),
                  height: screenHeightPercentage(context, percentage: 0.35),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      // Derive tile size from both axes so the grid fits without clipping.
                      const int itemCount = 4;
                      const double spacing = 16.0;
                      final int crossAxisCount =
                          constraints.maxWidth > 600 ? 3 : 2;
                      final int rowCount =
                          ((itemCount + crossAxisCount - 1) / crossAxisCount)
                              .floor();

                      final double availableTileWidth = constraints.maxWidth -
                          (spacing * (crossAxisCount - 1));
                      final double availableTileHeight =
                          constraints.maxHeight - (spacing * (rowCount - 1));
                      final double tileWidth =
                          availableTileWidth / crossAxisCount;
                      final double tileHeight = availableTileHeight / rowCount;
                      final double childAspectRatio =
                          tileHeight > 0 ? (tileWidth / tileHeight) : 1.0;

                      return GridView.count(
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: crossAxisCount,
                        mainAxisSpacing: spacing,
                        crossAxisSpacing: spacing,
                        childAspectRatio: childAspectRatio,
                        children: [
                          _buildTile(
                            context: context,
                            title: 'Create Report',
                            imagePath: 'assets/images/work_zone_report.png',
                            imageScale: 1,
                            onTap: () => Get.dialog(const RoadEventListDialog(isReport: true)),
                          ),
                          _buildTile(
                            context: context,
                            title: 'Map Work Zone',
                            imagePath: 'assets/images/map_work_zone_icon.png',
                            imageScale: 1,
                            onTap: () => Get.dialog(const RoadEventListDialog(isReport: false)),
                          ),
                          _buildTile(
                            context: context,
                            title: 'View Work Zone Map',
                            imagePath: 'assets/images/work_zone_map_icon.png',
                            imageScale: 1,
                            onTap: () => Get.to(() => const WorkZoneMap()),
                          ),
                          _buildTile(
                            context: context,
                            title: 'Mobile Vehicle',
                            imagePath: 'assets/images/mobile_vehicle_icon.png',
                            imageScale: 1,
                            onTap: () => Get.to(() => const MobileVehicleMap()),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                verticalSpaceMedium,
                // Start Live Worker Session button
                SizedBox(
                  width: screenWidthPercentage(context, percentage: 0.85),
                  child: ElevatedButton(
                    child: const Text("Start Live Worker Session"),
                    onPressed: () async {
                      // Check if user has service
                      if (!(await isConnectedToInternet())) {
                        PushNotificationService pushNotificationService =
                            Get.find<PushNotificationService>();
                        pushNotificationService.showSimpleNotification(
                          title: 'No Internet Connection',
                          body: 'Please check your internet connection and try again.',
                          payload: 'No Internet Connection',
                          id: 0,
                        );
                        return;
                      }
                      Get.dialog(const RoadEventListDialog(isLiveReport: true));
                    },
                  ),
                ),
                verticalSpaceSmall,
                SizedBox(
                  width: screenWidthPercentage(context, percentage: 0.85),
                  child: ElevatedButton(
                    child: const Text("View Report History"),
                    onPressed: () async {
                      Get.to(() => RoadEventHistory());
                    },
                  ),
                ),
              ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTile({
    required BuildContext context,
    required String title,
    required String imagePath,
    required double imageScale,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: lightGrey,
          borderRadius: BorderRadius.circular(15.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.6),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: styleFour.copyWith(
                  fontWeight: FontWeight.bold,
                  color: textPrimaryColor,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Expanded(
                child: Image.asset(
                  imagePath,
                  scale: imageScale,
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget unUploadedWarning(BuildContext context) {
    PushNotificationService pushNotificationService =
        Get.find<PushNotificationService>();
    RxBool isTryingToUpload = false.obs;
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: screenWidthPercentage(context, percentage: 0.8),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border.all(
                    color: Colors.red,
                    width: 3.0,
                    style: BorderStyle.values[1]),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Text(
                        "You have un-uploaded recordings or reports. Please upload them.",
                        style: styleFour.copyWith(color: Colors.red)),
                    ElevatedButton(
                      onPressed: () async {
                        isTryingToUpload.value = true;
                        bool recordingLoadSuccessful =
                            await fileStorageService.uploadLocalRecordings();
                        bool reportLoadSuccessful =
                            await fileStorageService.uploadLocalReports();
                        if (recordingLoadSuccessful && reportLoadSuccessful) {
                          Get.snackbar('Upload Successful',
                              'All recordings and reports have been uploaded successfully.',
                              backgroundColor: Colors.green,
                              colorText: Colors.white);
                          await fileStorageService.clearLocalRecordings();
                          await fileStorageService.clearLocalReports();
                          await fileStorageService.refreshLocalUploadState();
                          pushNotificationService.cancelAll();
                        } else {
                          pushNotificationService.showSimpleNotification(
                            title: 'Upload Failed',
                            body:
                                'Some recordings or reports failed to upload.',
                            payload: 'Upload Failed',
                            id: 0,
                          );
                        }
                        isTryingToUpload.value = false;
                      },
                      child: const WZAMText.styleFour('Upload Now'),
                    ),
                  ],
                ),
              ),
            ),
            Obx(() => isTryingToUpload.value
                ? const Center(child: CircularProgressIndicator())
                : Container()),
          ],
        ),
        verticalSpaceSmall,
      ],
    );
  }
}
