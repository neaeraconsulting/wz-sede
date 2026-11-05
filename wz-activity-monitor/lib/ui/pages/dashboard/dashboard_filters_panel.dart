import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wzam/controllers/dashboard_controller.dart';
import 'package:wzam/ui/styles/app_colors.dart';
import 'package:wzam/ui/styles/spacing.dart';
import 'package:wzam/ui/styles/widgets/wzam_text.dart';

class DashboardFiltersPanel extends StatelessWidget {
  const DashboardFiltersPanel({
    super.key,
    required this.controller,
  });

  final DashboardController controller;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 10,
      right: 10,
      child: Obx(
        () => Container(
          width: controller.showFilters.value ? 225 : 120,
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            color: lightGrey.withValues(alpha: 0.9),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  controller.showFilters.value = !controller.showFilters.value;
                },
                child: Row(
                  children: [
                    Text(
                      'Filters',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: textPrimaryColor,
                      ),
                    ),
                    Expanded(child: Container()),
                    Icon(
                      controller.showFilters.value
                          ? Icons.keyboard_arrow_down
                          : Icons.keyboard_arrow_left,
                      color: textPrimaryColor,
                    ),
                  ],
                ),
              ),
              ...(controller.showFilters.value
                  ? _filters(controller)
                  : [Container()]),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _filters(DashboardController controller) {
    return [
      verticalSpaceSmall,
      WZAMText.body('Road Event Status',
          style: TextStyle(color: textPrimaryColor)),
      InkWell(
        onTap: () async {
          controller.showPending.value = !controller.showPending.value;
          await controller.filter();
        },
        child: Row(
          children: [
            Obx(
              () => Checkbox(
                value: controller.showPending.value,
                visualDensity: VisualDensity.compact,
                onChanged: (val) async {
                  controller.showPending.value = val ?? false;
                  await controller.filter();
                },
              ),
            ),
            Text('Pending', style: TextStyle(color: textPrimaryColor)),
          ],
        ),
      ),
      InkWell(
        onTap: () async {
          controller.showActive.value = !controller.showActive.value;
          await controller.filter();
        },
        child: Row(
          children: [
            Obx(
              () => Checkbox(
                value: controller.showActive.value,
                visualDensity: VisualDensity.compact,
                onChanged: (val) async {
                  controller.showActive.value = val ?? false;
                  await controller.filter();
                },
              ),
            ),
            Text('Active', style: TextStyle(color: textPrimaryColor)),
          ],
        ),
      ),
      InkWell(
        onTap: () async {
          controller.showCompleted.value = !controller.showCompleted.value;
          await controller.filter();
        },
        child: Row(
          children: [
            Obx(
              () => Checkbox(
                value: controller.showCompleted.value,
                visualDensity: VisualDensity.compact,
                onChanged: (val) async {
                  controller.showCompleted.value = val ?? false;
                  await controller.filter();
                },
              ),
            ),
            Text('Completed', style: TextStyle(color: textPrimaryColor)),
          ],
        ),
      ),
      WZAMText.body('Field Device Status',
          style: TextStyle(color: textPrimaryColor)),
      InkWell(
        onTap: () async {
          controller.showDeviceUnknown.value = !controller.showDeviceUnknown.value;
          await controller.filter();
        },
        child: Row(
          children: [
            Obx(
              () => Checkbox(
                value: controller.showDeviceUnknown.value,
                visualDensity: VisualDensity.compact,
                onChanged: (val) async {
                  controller.showDeviceUnknown.value = val ?? false;
                  await controller.filter();
                },
              ),
            ),
            Text('Unknown', style: TextStyle(color: textPrimaryColor)),
          ],
        ),
      ),
      InkWell(
        onTap: () async {
          controller.showDeviceOK.value = !controller.showDeviceOK.value;
          await controller.filter();
        },
        child: Row(
          children: [
            Obx(
              () => Checkbox(
                value: controller.showDeviceOK.value,
                visualDensity: VisualDensity.compact,
                onChanged: (val) async {
                  controller.showDeviceOK.value = val ?? false;
                  await controller.filter();
                },
              ),
            ),
            Text('OK', style: TextStyle(color: textPrimaryColor)),
          ],
        ),
      ),
      InkWell(
        onTap: () async {
          controller.showDeviceWarning.value = !controller.showDeviceWarning.value;
          await controller.filter();
        },
        child: Row(
          children: [
            Obx(
              () => Checkbox(
                value: controller.showDeviceWarning.value,
                visualDensity: VisualDensity.compact,
                onChanged: (val) async {
                  controller.showDeviceWarning.value = val ?? false;
                  await controller.filter();
                },
              ),
            ),
            Text('Warning', style: TextStyle(color: textPrimaryColor)),
          ],
        ),
      ),
      InkWell(
        onTap: () async {
          controller.showDeviceError.value = !controller.showDeviceError.value;
          await controller.filter();
        },
        child: Row(
          children: [
            Obx(
              () => Checkbox(
                value: controller.showDeviceError.value,
                visualDensity: VisualDensity.compact,
                onChanged: (val) async {
                  controller.showDeviceError.value = val ?? false;
                  await controller.filter();
                },
              ),
            ),
            Text('Error', style: TextStyle(color: textPrimaryColor)),
          ],
        ),
      ),
      InkWell(
        onTap: () async {
          controller.showDeviceOffline.value = !controller.showDeviceOffline.value;
          await controller.filter();
        },
        child: Row(
          children: [
            Obx(
              () => Checkbox(
                value: controller.showDeviceOffline.value,
                visualDensity: VisualDensity.compact,
                onChanged: (val) async {
                  controller.showDeviceOffline.value = val ?? false;
                  await controller.filter();
                },
              ),
            ),
            Text('Offline', style: TextStyle(color: textPrimaryColor)),
          ],
        ),
      ),
      InkWell(
        onTap: () async {
          controller.showDeviceInactive.value = !controller.showDeviceInactive.value;
          await controller.filter();
        },
        child: Row(
          children: [
            Obx(
              () => Checkbox(
                value: controller.showDeviceInactive.value,
                visualDensity: VisualDensity.compact,
                onChanged: (val) async {
                  controller.showDeviceInactive.value = val ?? false;
                  await controller.filter();
                },
              ),
            ),
            Text('Inactive', style: TextStyle(color: textPrimaryColor)),
          ],
        ),
      ),
      WZAMText.body('Layers', style: TextStyle(color: textPrimaryColor)),
      InkWell(
        onTap: () async {
          controller.showRoadEvents.value = !controller.showRoadEvents.value;
          await controller.filter();
        },
        child: Row(
          children: [
            Obx(
              () => Checkbox(
                value: controller.showRoadEvents.value,
                visualDensity: VisualDensity.compact,
                onChanged: (val) async {
                  controller.showRoadEvents.value = val ?? false;
                  await controller.filter();
                },
              ),
            ),
            Text('Road Events', style: TextStyle(color: textPrimaryColor)),
          ],
        ),
      ),
      InkWell(
        onTap: () async {
          controller.showFieldDevices.value = !controller.showFieldDevices.value;
          await controller.filter();
        },
        child: Row(
          children: [
            Obx(
              () => Checkbox(
                value: controller.showFieldDevices.value,
                visualDensity: VisualDensity.compact,
                onChanged: (val) async {
                  controller.showFieldDevices.value = val ?? false;
                  await controller.filter();
                },
              ),
            ),
            Text('Field Devices', style: TextStyle(color: textPrimaryColor)),
          ],
        ),
      ),
    ];
  }
}
