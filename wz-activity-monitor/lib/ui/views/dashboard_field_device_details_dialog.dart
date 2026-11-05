import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:intl/intl.dart';
import 'package:wzam/models/generated/google/protobuf/timestamp.pb.dart';
import 'package:wzam/models/mappable_field_device.dart';
import 'package:wzam/ui/styles/screen_size.dart';
import 'package:wzam/ui/styles/spacing.dart';
import 'package:wzam/ui/styles/widgets/wzam_text.dart';



class DashboardFieldDeviceDetailsDialog extends StatelessWidget {
  final MappableFieldDevice fieldDevice;
  final mapController = MapController();
  DashboardFieldDeviceDetailsDialog({super.key, required this.fieldDevice});


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
              child: SelectableRegion(
                focusNode: FocusNode(),
                selectionControls: MaterialTextSelectionControls(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    WZAMText.styleFour("Id: ${fieldDevice.id}"),
                    WZAMText.styleFour("Project Id: ${fieldDevice.projectId}"),
                    WZAMText.styleFour("Road Event Id: ${fieldDevice.roadEventId}"),
                    WZAMText.styleFour("Name: ${fieldDevice.name}"),
                    WZAMText.styleFour("Make: ${fieldDevice.make}"),
                    WZAMText.styleFour("Status: ${fieldDevice.fieldDevice.coreDetails.deviceStatus.name}"),
                    WZAMText.styleFour("Last Updated: ${fieldDevice.lastUpdated}"),
                    WZAMText.styleFour("Description: ${fieldDevice.description}"),
                    WZAMText.styleFour("Device Type: ${fieldDevice.deviceType.name}"),
                    fieldDevice.fieldDevice.hasLocationType() ? WZAMText.styleFour("Location Type: ${fieldDevice.fieldDevice.locationType.name}") : Container(),
                    fieldDevice.fieldDevice.hasArrowBoard() ? WZAMText.styleFour("Arrowboard Type: ${fieldDevice.fieldDevice.arrowBoard.pattern.name}") : Container(),
                    verticalSpaceSmall,
                  ],
                ),
              ),
            ),
          )),
    );
  }

  String timestampToString(Timestamp timestamp) {
    int seconds = timestamp.seconds.toInt();
    return DateFormat.yMd().add_jm().format(DateTime.fromMillisecondsSinceEpoch(seconds * 1000));
  }
}

