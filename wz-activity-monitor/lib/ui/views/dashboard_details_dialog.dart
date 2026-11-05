import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:intl/intl.dart';
import 'package:wzam/models/generated/google/protobuf/timestamp.pb.dart';
import 'package:wzam/models/mappable_road_event.dart';
import 'package:wzam/ui/styles/screen_size.dart';
import 'package:wzam/ui/styles/spacing.dart';
import 'package:wzam/ui/styles/widgets/wzam_text.dart';

class DashboardDetailsDialog extends StatelessWidget {
  final MappableRoadEvent roadEvent;
  final mapController = MapController();
  DashboardDetailsDialog({super.key, required this.roadEvent});


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
                  WZAMText.styleThree(roadEvent.roadEvent.name.toUpperCase()),
                  verticalSpaceSmall,
                  WZAMText.styleFour(
                    "Description: ${roadEvent.roadEvent.hasDescription() ? roadEvent.roadEvent.description : "None"}"),
                  WZAMText.styleFour(
                    "ID: ${roadEvent.roadEvent.id}"),
                  WZAMText.styleFour(
                    "Start Date: ${timestampToString(roadEvent.roadEvent.startDate)}"),
                  WZAMText.styleFour(
                    "End Date: ${roadEvent.roadEvent.hasEndDate() ? timestampToString(roadEvent.roadEvent.endDate) : "Ongoing"}"),
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

