import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:wzam/app_config.dart';
import 'package:wzam/controllers/dashboard_controller.dart';
import 'package:wzam/controllers/mile_marker_controller.dart';
import 'package:wzam/ui/pages/dashboard/dashboard_crosshair_overlay.dart';
import 'package:wzam/ui/pages/dashboard/dashboard_filters_panel.dart';
import 'package:wzam/ui/pages/dashboard/dashboard_map_widget.dart';
import 'package:wzam/ui/pages/dashboard/dashboard_list_panel.dart';
import 'package:wzam/ui/pages/settings.dart';
import 'package:wzam/ui/styles/app_colors.dart';
import 'package:wzam/ui/styles/screen_size.dart';
import 'package:wzam/ui/styles/theme_setting.dart';
import 'package:wzam/ui/views/dashboard_road_event_info_widget.dart';
import 'package:wzam/ui/views/recording_configuration_dialog.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  double? _listPanelWidth;
  late Future<void> _initializeFuture;
  bool _showCrosshair = false;
  LatLng _crosshairCenter = AppConfig.defaultMapCenter;

  @override
  void initState() {
    super.initState();
    _initializeFuture = Get.find<DashboardController>().initialize();
  }

  double _minListPanelWidth(double screenWidth) {
    return screenWidth < 700 ? 180 : 240;
  }

  double _maxListPanelWidth(double screenWidth) {
    return screenWidth * 0.65;
  }

  double _defaultListPanelWidth(double screenWidth) {
    return screenWidth * 0.33;
  }

  void _resizeListPanel(double deltaX, double screenWidth) {
    final double minWidth = _minListPanelWidth(screenWidth);
    final double maxWidth = _maxListPanelWidth(screenWidth);
    final double currentWidth =
        (_listPanelWidth ?? _defaultListPanelWidth(screenWidth))
            .clamp(minWidth, maxWidth);

    setState(() {
      _listPanelWidth = (currentWidth + deltaX).clamp(minWidth, maxWidth);
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DashboardController>();
    final mileMarkerController = Get.find<MileMarkerController>();
    final double currentScreenWidth = screenWidth(context);
    final double minPanelWidth = _minListPanelWidth(currentScreenWidth);
    final double maxPanelWidth = _maxListPanelWidth(currentScreenWidth);
    final double panelWidth =
      (_listPanelWidth ?? _defaultListPanelWidth(currentScreenWidth))
        .clamp(minPanelWidth, maxPanelWidth);

    return Theme(
      data: lightTheme,
      child: FutureBuilder(
        future: _initializeFuture,
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              appBar: AppBar(
                title: const Text('Work Zone Map'),
                actions: [
                  IconButton(
                      icon: const Icon(Icons.settings),
                      onPressed: () {
                        Get.to(() => SettingsPage());
                      }),
                ],
              ),
              body: const Stack(
                children: [
                  Center(child: CircularProgressIndicator()),
                ],
              ),
            );
          }
          return Scaffold(
            appBar: AppBar(
              title: const Text('Datahub Visualizer'),
              actions: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                  ),
                  onPressed: () {
                    Get.dialog(Theme(
                        data: lightTheme,
                        child: RecordingConfigurationDialog(
                            existingRoadEvent: null)));
                  },
                  child: const Text("Create Work Zone from KML"),
                ),
                IconButton(
                  icon: Icon(
                    _showCrosshair ? Icons.gps_fixed : Icons.gps_not_fixed,
                  ),
                  tooltip: _showCrosshair
                      ? 'Hide crosshair overlay'
                      : 'Show crosshair overlay',
                  onPressed: () {
                    setState(() {
                      _showCrosshair = !_showCrosshair;
                    });
                  },
                ),
                IconButton(
                    icon: const Icon(Icons.refresh),
                    onPressed: () async {
                      setState(() {
                        _initializeFuture =
                            controller.initialize(shouldMoveMap: false);
                      });
                    }),
                IconButton(
                    icon: const Icon(Icons.settings),
                    onPressed: () {
                      Get.to(() => SettingsPage());
                    }),
              ],
            ),
            body: Stack(
              children: [
                DashboardMapWidget(
                  dashboardController: controller,
                  mileMarkerController: mileMarkerController,
                  onMapCenterChanged: (center) {
                    _crosshairCenter = center;
                    if (_showCrosshair) {
                      setState(() {});
                    }
                  },
                ),
                DashboardFiltersPanel(controller: controller),
                Obx(() => controller.showLoadingCircle.value
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : Container()),
                DashboardListPanel(
                  controller: controller,
                  panelWidth: panelWidth,
                  onResize: (deltaX) {
                    _resizeListPanel(deltaX, currentScreenWidth);
                  },
                ),
                DashboardCrosshairOverlay(
                  showCrosshair: _showCrosshair,
                  center: _crosshairCenter,
                ),
                Positioned(
                  right: 12,
                  bottom: 12,
                  child: Obx(() {
                    final selectedRoadEvent =
                        controller.selectedRoadEventWrapper.value;
                    if (selectedRoadEvent == null) {
                      return const SizedBox.shrink();
                    }

                    final double overlayWidth =
                        (screenWidth(context) * 0.35).clamp(320.0, 520.0);
                    return Container(
                      width: overlayWidth,
                      constraints: BoxConstraints(
                        maxHeight: screenHeight(context) * 0.45,
                      ),
                      decoration: BoxDecoration(
                        color: extraLightGrey.withValues(alpha: 0.95),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: primaryColor.withValues(alpha: 0.45),
                          width: 1,
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x33000000),
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(10),
                        child: DashboardRoadEventInfoWidget(
                          roadEventWrapper: selectedRoadEvent,
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget roadEventList() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        width: screenWidth(Get.context!) * 0.25,
        height: screenHeight(Get.context!) * 0.9,
        //color: extraLightGrey,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: extraLightGrey.withValues(alpha: 0.9),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: GetBuilder<DashboardController>(
            builder: (controller) {
              return ListView.builder(
                itemCount: controller.mappableRoadEvents.length,
                itemBuilder: (context, index) {
                  final roadEventWrapper = controller.mappableRoadEvents[index];
                  final roadEvent = roadEventWrapper.roadEvent;
                  final status = controller.getRoadEventFilterStatus(roadEvent);
                  final statusText = status.toString().split('.').last;
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 4.0, horizontal: 8.0),
                    child: Obx(() => Container(
                          //color: controller.selectedRoadEvent.value == roadEvent.id.toInt() ? primaryColor.withValues(alpha: 0.3) : Colors.transparent,
                          //borderRadius: BorderRadius.circular(8.0),
                          decoration: BoxDecoration(
                            color: controller.selectedRoadEvent.value ==
                                    roadEvent.id.toInt()
                                ? primaryColor.withValues(alpha: 0.3)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(8.0),
                            border: Border.all(
                              color: controller.selectedRoadEvent.value ==
                                      roadEvent.id.toInt()
                                  ? primaryColor
                                  : Colors.transparent,
                              width: 2.0,
                            ),
                          ),
                          // shape: RoundedRectangleBorder(
                          //   borderRadius: BorderRadius.circular(8.0),
                          //   side: BorderSide(
                          //     color: controller.selectedRoadEvent.value == roadEvent.id.toInt() ? primaryColor : Colors.transparent,
                          //     width: 2.0,
                          //   ),
                          // ),
                          child: ListTile(
                            title: Text(roadEvent.name,
                                style: TextStyle(color: textPrimaryColor)),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Status: $statusText',
                                    style: TextStyle(color: textPrimaryColor)),
                              ],
                            ),
                            //isThreeLine: true,
                            onTap: () {
                              int index = controller.mappableRoadEvents
                                  .indexWhere((event) =>
                                      event.id.toInt() == roadEvent.id.toInt());
                              controller.selectRoadEvent(index);
                              //Get.dialog(RoadEventDetailsDialog(roadEvent: roadEventWrapper));
                            },
                          ),
                        )),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
