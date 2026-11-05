import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wzam/controllers/dashboard_controller.dart';
import 'package:wzam/models/mappable_field_device.dart';
import 'package:wzam/ui/styles/app_colors.dart';
import 'package:wzam/ui/styles/screen_size.dart';
import 'package:wzam/ui/styles/spacing.dart';

class DashboardListPanel extends StatelessWidget {
  const DashboardListPanel({
    super.key,
    required this.controller,
    required this.panelWidth,
    required this.onResize,
  });

  final DashboardController controller;
  final double panelWidth;
  final ValueChanged<double> onResize;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          width: panelWidth,
          height: screenHeight(Get.context!) * 0.9,
          child: Stack(
            children: [
              Container(
                width: panelWidth,
                height: screenHeight(Get.context!) * 0.9,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: extraLightGrey.withValues(alpha: 0.9),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        ExpansionTile(
                          title: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Road Events',
                                  style: TextStyle(
                                    color: textPrimaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              GetBuilder<DashboardController>(
                                builder: (controller) {
                                  final bool allVisible =
                                      controller.areAllFilteredRoadEventsVisible();
                                  return Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        allVisible ? 'Hide All' : 'Show All',
                                        style: TextStyle(
                                          color: textPrimaryColor,
                                          fontSize: 12,
                                        ),
                                      ),
                                      Checkbox(
                                        value: allVisible,
                                        visualDensity: VisualDensity.compact,
                                        onChanged: (val) async {
                                          await controller
                                              .setAllFilteredRoadEventsVisibility(
                                                  val ?? false);
                                        },
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ],
                          ),
                          children: [
                            SizedBox(
                              width: panelWidth,
                              child: GetBuilder<DashboardController>(
                                builder: (controller) {
                                  final roadEventWrappers =
                                      controller.getFilteredRoadEventWrappers();
                                  return ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: roadEventWrappers.length,
                                    itemBuilder: (context, index) {
                                      final roadEventWrapper =
                                          roadEventWrappers[index];
                                      final roadEvent = roadEventWrapper.roadEvent;
                                      final status = controller
                                          .getRoadEventFilterStatus(roadEvent);
                                      final statusText =
                                          status.toString().split('.').last;
                                      final int roadEventId = roadEvent.id.toInt();
                                      final bool isVisible = controller
                                          .isRoadEventVisible(roadEventId);
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 4.0, horizontal: 8.0),
                                        child: Obx(
                                          () => Container(
                                            decoration: BoxDecoration(
                                              color: controller
                                                          .selectedRoadEvent
                                                          .value ==
                                                      roadEvent.id.toInt()
                                                  ? primaryColor.withValues(
                                                      alpha: 0.3)
                                                  : Colors.transparent,
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              border: Border.all(
                                                color: controller
                                                            .selectedRoadEvent
                                                            .value ==
                                                        roadEvent.id.toInt()
                                                    ? primaryColor
                                                    : Colors.transparent,
                                                width: 2.0,
                                              ),
                                            ),
                                            child: ListTile(
                                              leading: Checkbox(
                                                value: isVisible,
                                                visualDensity:
                                                    VisualDensity.compact,
                                                onChanged: (val) async {
                                                  await controller
                                                      .setRoadEventVisibility(
                                                          roadEventId,
                                                          val ?? false);
                                                },
                                              ),
                                              title: Text(
                                                roadEvent.name,
                                                style: TextStyle(
                                                    color: textPrimaryColor),
                                              ),
                                              subtitle: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'Status: $statusText',
                                                    style: TextStyle(
                                                        color:
                                                            textPrimaryColor),
                                                  ),
                                                ],
                                              ),
                                              onTap: () {
                                                controller.selectedRoadEventWrapper.value = roadEventWrapper;
                                                controller.focusOnRoadEvent(
                                                    roadEventId);
                                              },
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                        verticalSpaceSmall,
                        ExpansionTile(
                          title: Text(
                            'Field Devices (Non-AVL)',
                            style: TextStyle(
                              color: textPrimaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          children: [
                            SizedBox(
                              width: panelWidth,
                              child: GetBuilder<DashboardController>(
                                builder: (controller) {
                                  final List<MappableFieldDevice> devices =
                                      controller.fieldDevicesNonAvl(
                                          controller.mappableFieldDevices);
                                  return ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: devices.length,
                                    itemBuilder: (context, index) {
                                      final fieldDevice = devices[index];
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 4.0, horizontal: 8.0),
                                        child: Obx(
                                          () => Container(
                                            decoration: BoxDecoration(
                                              color: controller
                                                          .selectedFieldDevice
                                                          .value ==
                                                      fieldDevice.id
                                                  ? primaryColor.withValues(
                                                      alpha: 0.3)
                                                  : Colors.transparent,
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              border: Border.all(
                                                color: controller
                                                            .selectedFieldDevice
                                                            .value ==
                                                        fieldDevice.id
                                                    ? primaryColor
                                                    : Colors.transparent,
                                                width: 2.0,
                                              ),
                                            ),
                                            child: ListTile(
                                              title: Text(
                                                '${fieldDevice.make} ${fieldDevice.deviceType.name}',
                                                style: TextStyle(
                                                    color: textPrimaryColor),
                                              ),
                                              subtitle: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    '${fieldDevice.name}',
                                                    style: TextStyle(
                                                        color:
                                                            textPrimaryColor),
                                                  ),
                                                ],
                                              ),
                                              onTap: () {
                                                final int index = devices.indexWhere(
                                                    (device) =>
                                                        device.id ==
                                                        fieldDevice.id);
                                                controller.selectFieldDevice(
                                                    index);
                                              },
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                        ExpansionTile(
                          title: Text(
                            'Field Devices (AVL)',
                            style: TextStyle(
                              color: textPrimaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          children: [
                            SizedBox(
                              width: panelWidth,
                              child: GetBuilder<DashboardController>(
                                builder: (controller) {
                                  final List<MappableFieldDevice> devices =
                                      controller.fieldDevicesAvl(
                                          controller.mappableFieldDevices);
                                  return ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: devices.length,
                                    itemBuilder: (context, index) {
                                      final fieldDevice = devices[index];
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 4.0, horizontal: 8.0),
                                        child: Obx(
                                          () => Container(
                                            decoration: BoxDecoration(
                                              color: controller
                                                          .selectedFieldDevice
                                                          .value ==
                                                      fieldDevice.id
                                                  ? primaryColor.withValues(
                                                      alpha: 0.3)
                                                  : Colors.transparent,
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              border: Border.all(
                                                color: controller
                                                            .selectedFieldDevice
                                                            .value ==
                                                        fieldDevice.id
                                                    ? primaryColor
                                                    : Colors.transparent,
                                                width: 2.0,
                                              ),
                                            ),
                                            child: ListTile(
                                              title: Text(
                                                '${fieldDevice.make} ${fieldDevice.deviceType.name}',
                                                style: TextStyle(
                                                    color: textPrimaryColor),
                                              ),
                                              subtitle: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    '${fieldDevice.name}',
                                                    style: TextStyle(
                                                        color:
                                                            textPrimaryColor),
                                                  ),
                                                ],
                                              ),
                                              onTap: () {
                                                final int index = devices.indexWhere(
                                                    (device) =>
                                                        device.id ==
                                                        fieldDevice.id);
                                                controller.selectFieldDevice(
                                                    index);
                                              },
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                        ExpansionTile(
                          title: Text(
                            'Reports',
                            style: TextStyle(
                              color: textPrimaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          children: [
                            SizedBox(
                              width: panelWidth,
                              child: GetBuilder<DashboardController>(
                                builder: (controller) {
                                  return ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: controller.reports.length,
                                    itemBuilder: (context, index) {
                                      final report = controller.reports[index];
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 4.0, horizontal: 8.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.transparent,
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            border: Border.all(
                                              color: Colors.transparent,
                                              width: 2.0,
                                            ),
                                          ),
                                          child: ListTile(
                                            title: Text(
                                              report.isFullReport
                                                  ? 'Full Report ${report.reportWithId!.name}'
                                                  : 'Report Edit ${report.id}',
                                              style: TextStyle(
                                                  color: textPrimaryColor),
                                            ),
                                            subtitle: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                report.isFullReport
                                                    ? Text(
                                                        'ID: ${report.reportWithId!.id}',
                                                  style: TextStyle(
                                                      color: textPrimaryColor),
                                                      )
                                                    : const SizedBox.shrink(),
                                                report.isPatch
                                                    ? Text(
                                                        'Road Event ID: ${report.reportPatch!.roadEventId}',
                                                        style: TextStyle(
                                                            color:
                                                                textPrimaryColor),
                                                      )
                                                    : const SizedBox.shrink(),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                        ExpansionTile(
                          title: Text(
                            'Recordings',
                            style: TextStyle(
                              color: textPrimaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          children: [
                            SizedBox(
                              width: panelWidth,
                              child: GetBuilder<DashboardController>(
                                builder: (controller) {
                                  return ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: controller.recordings.length,
                                    itemBuilder: (context, index) {
                                      final recording =
                                          controller.recordings[index];
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 4.0, horizontal: 8.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.transparent,
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            border: Border.all(
                                              color: Colors.transparent,
                                              width: 2.0,
                                            ),
                                          ),
                                          child: ListTile(
                                            title: Text(
                                              '${recording.name}',
                                              style: TextStyle(
                                                  color: textPrimaryColor),
                                            ),
                                            subtitle: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  '${recording.description}',
                                                  style: TextStyle(
                                                      color: textPrimaryColor),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                right: 0,
                top: 0,
                bottom: 0,
                child: MouseRegion(
                  cursor: SystemMouseCursors.resizeLeftRight,
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onHorizontalDragUpdate: (details) {
                      onResize(details.delta.dx);
                    },
                    child: Container(
                      width: 18,
                      alignment: Alignment.centerRight,
                      child: Container(
                        width: 4,
                        margin: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          color: textPrimaryColor.withValues(alpha: 0.25),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
