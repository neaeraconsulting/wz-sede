import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:intl/intl.dart';
import 'package:wzam/models/generated/google/protobuf/timestamp.pb.dart';
import 'package:wzam/models/generated/road_sub_event.pb.dart';
import 'package:wzam/models/mappable_sub_road_event.dart';
import 'package:wzam/ui/styles/screen_size.dart';
import 'package:wzam/ui/styles/spacing.dart';
import 'package:wzam/ui/styles/widgets/wzam_text.dart';



class DashboardSubEventDetailsDialog extends StatelessWidget {
  final MappableRoadSubEvent roadSubEvent;
  final mapController = MapController();
  DashboardSubEventDetailsDialog({super.key, required this.roadSubEvent});


  @override
  Widget build(BuildContext context) {
    RoadSubEvent roadSubEventTwo = roadSubEvent.roadSubEventWrappers.first.roadSubEvent;
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
                  WZAMText.styleFour("Id: ${roadSubEventTwo.id}"),
                  WZAMText.styleFour("Project Id: ${roadSubEventTwo.projectId}"),
                  WZAMText.styleFour("Road Event Id: ${roadSubEventTwo.roadEventId}"),
                  WZAMText.styleFour("Route Id: ${roadSubEventTwo.routeId}"),
                  roadSubEventTwo.hasBaseLayer() ? WZAMText.styleFour("Vehicle Impact: ${roadSubEventTwo.baseLayer.vehicleImpact.name}") : Container(),
                  roadSubEventTwo.hasWorkerPresenceLayer() ? WZAMText.styleFour("Worker Presence Status: ${roadSubEventTwo.workerPresenceLayer.workerPresence}") : Container(),
                  roadSubEventTwo.hasSpeedReductionLayer() ? WZAMText.styleFour("Reduced Speed Limit: ${(roadSubEventTwo.speedReductionLayer.reducedSpeedLimitKph * 0.621371).round()} MPH") : Container(),
                  roadSubEventTwo.hasDirection() ? WZAMText.styleFour("Direction: ${roadSubEventTwo.direction}") : Container(),
                  roadSubEventTwo.hasBeginningMilepost() ? WZAMText.styleFour("Beginning Milepost: ${roadSubEventTwo.beginningMilepost.toStringAsFixed(2)}") : Container(),
                  roadSubEventTwo.hasEndingMilepost() ? WZAMText.styleFour("Ending Milepost: ${roadSubEventTwo.endingMilepost.toStringAsFixed(2)}") : Container(),
                  roadSubEventTwo.hasBeginningCrossStreet() ? WZAMText.styleFour("Beginning Cross Street: ${roadSubEventTwo.beginningCrossStreet}") : Container(),
                  roadSubEventTwo.hasEndingCrossStreet() ? WZAMText.styleFour("Ending Cross Street: ${roadSubEventTwo.endingCrossStreet}") : Container(),
                  roadSubEventTwo.hasBeginningMilepost() ? WZAMText.styleFour("Beginning Milepost: ${roadSubEventTwo.beginningMilepost.toStringAsFixed(2)}") : Container(),
                  roadSubEventTwo.hasEndingMilepost() ? WZAMText.styleFour("Ending Milepost: ${roadSubEventTwo.endingMilepost.toStringAsFixed(2)}") : Container(),
                  roadSubEventTwo.hasSchedule() ? WZAMText.styleFour("Schedule: ${roadSubEventTwo.schedule}") : Container(),
                  verticalSpaceSmall,
                ],
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

