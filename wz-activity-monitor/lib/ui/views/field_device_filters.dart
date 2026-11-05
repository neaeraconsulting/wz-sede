import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wzam/controllers/field_device_map_controller.dart';
import 'package:wzam/ui/styles/screen_size.dart';
import 'package:wzam/ui/styles/spacing.dart';
import 'package:wzam/ui/styles/widgets/wzam_text.dart';



class FieldDeviceFiltersDialog extends StatelessWidget {
  FieldDeviceFiltersDialog({super.key});
  FieldDeviceMapController controller = Get.find<FieldDeviceMapController>();
  
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ConstrainedBox(
            constraints: BoxConstraints(  
              maxHeight: screenHeight(context) * 0.7, // Limit the height
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  ...filters(),
                  verticalSpaceSmall,
                  SizedBox(
                    width: screenWidth(context) * 0.8,
                    child: ElevatedButton(
                      child: const Text("Apply Filters"),
                      onPressed: () {
                        Get.back();
                      },
                    ),
                  ),
                  verticalSpaceSmall,
                ],
              ),
            ),
          )),
    );
  }

  List<Widget> filters() {
    return [
      verticalSpaceSmall,
      const WZAMText.body("Device Types"),
      ...deviceTypeFilters(),
      // Add your date filter widgets here
      const WZAMText.body("Manufacturers"),
      ...manufacturerFilters(),
      const WZAMText.body("Status"),
      filterOption("Linked", controller.isLinked),
      filterOption("Unlinked", controller.isUnlinked),
    ];
  }

  List<Widget> manufacturerFilters() {
    return controller.manufacturerFilters.entries.map((entry) {
      String manufacturer = entry.key;
      RxBool isSelected = entry.value;
      return filterOption(manufacturer, isSelected);
    }).toList();
  }

  List<Widget> deviceTypeFilters() {
    return controller.deviceTypeFilters.entries.map((entry) {
      String deviceType = entry.key;
      RxBool isSelected = entry.value;
      return filterOption(deviceType, isSelected);
    }).toList();
  }

  Widget filterOption(String title, RxBool value) {
    return InkWell(
      onTap: () async {
        value.value = !value.value;
      },
      child: Obx(() =>Row(
        children: [
          Checkbox(
            value: value.value,
            visualDensity: VisualDensity.compact,
            onChanged: (val) async {
              value.value = val ?? false;
            },
          ),
          Text(title),
        ],
      )),
    );
  }

}

