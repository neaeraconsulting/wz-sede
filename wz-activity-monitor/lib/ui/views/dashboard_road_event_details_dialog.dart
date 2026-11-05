import 'package:flutter/material.dart';
import 'package:wzam/models/wrappers/road_event_wrapper.dart';
import 'package:wzam/ui/styles/screen_size.dart';
import 'package:wzam/ui/views/dashboard_road_event_info_widget.dart';

class DashboardRoadEventDetailsDialog extends StatelessWidget {
  final RoadEventWrapper roadEvent;
  DashboardRoadEventDetailsDialog({super.key, required this.roadEvent});


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
              child: DashboardRoadEventInfoWidget(
                roadEventWrapper: roadEvent,
              ),
            ),
          )),
    );
  }
}

