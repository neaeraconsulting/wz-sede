import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:wzam/controllers/work_zone_map_controller.dart';
import 'package:wzam/models/generated/google/protobuf/timestamp.pb.dart';
import 'package:wzam/models/generated/wzdx.pbenum.dart';
import 'package:wzam/models/live_worker_location.dart';
import 'package:wzam/models/mappable_road_event.dart';
import 'package:wzam/ui/pages/work_zone_map.dart';
import 'package:wzam/ui/styles/screen_size.dart';
import 'package:wzam/ui/styles/spacing.dart';
import 'package:wzam/ui/styles/widgets/wzam_text.dart';



class RoadEventDetailsDialog extends StatelessWidget {
  final MappableRoadEvent roadEvent;
  final mapController = MapController();
  RoadEventDetailsDialog({super.key, required this.roadEvent});
  
  
  @override
  Widget build(BuildContext context) {
    WorkZoneMapController workZoneMapController = Get.find<WorkZoneMapController>();
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
                  WZAMText.styleTwo(roadEvent.roadEvent.name.toUpperCase()),
                  verticalSpaceSmall,
                  WZAMText.styleThree(
                    "Description: ${roadEvent.roadEvent.hasDescription() ? roadEvent.roadEvent.description : "None"}"),
                  WZAMText.styleThree(
                    "ID: ${roadEvent.roadEvent.id}"),
                  WZAMText.styleThree(
                    "Start Date: ${timestampToString(roadEvent.roadEvent.startDate)}"),
                  WZAMText.styleThree(
                    "End Date: ${roadEvent.roadEvent.hasEndDate() ? timestampToString(roadEvent.roadEvent.endDate) : "Ongoing"}"),
                  verticalSpaceSmall,
                  roadEvent.roadEvent.areaType == WorkZoneType.WORK_ZONE_TYPE_STATIC ? SizedBox(
                    width: screenWidth(context) * 0.8,
                    child: ElevatedButton(
                      child: const Text("Start Live Worker Session"),
                      onPressed: () {
                        Get.back();
                        String currentRoute = Get.currentRoute;
                        if (currentRoute == '/Home') {
                          Get.to(() => const WorkZoneMap());
                        }
                        workZoneMapController.startLiveWorkerSession(
                          roadEvent.roadEvent, WorkerLocationType.WORKER,
                        );
                      },
                    ),
                  ) : Container(),
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

