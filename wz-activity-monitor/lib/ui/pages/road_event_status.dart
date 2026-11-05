import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:wzam/models/page.dart' as page_model;
import 'package:wzam/models/road_event_status/road_event_status.dart';
import 'package:wzam/services/auth_service.dart';
import 'package:wzam/services/wzam_api.dart';
import 'package:wzam/ui/styles/app_colors.dart';

class RoadEventHistoryController extends GetxController {
  List<RoadEventStatus?> roadEventHistoryList = [];

  Future<void> initialize() async {
    roadEventHistoryList = await getRoadEvents();
    roadEventHistoryList.sort((a, b) {
      if (a == null || a.updates.isEmpty) return 1;
      if (b == null || b.updates.isEmpty) return -1;
      return b.updates.last.updateSubmittedTimestamp.millisecondsSinceEpoch
        .compareTo(a.updates.last.updateSubmittedTimestamp.millisecondsSinceEpoch);
    });
  }

  Future<List<RoadEventStatus?>> getRoadEvents() async {
    AuthService authService = Get.find<AuthService>();
    String? userId = await authService.getUserId();
    if (userId == null) {
      return [];
    }
    page_model.Page<RoadEventStatus?>? events = await WzamApi.getRoadEventStatusList(userId);
    if (events == null) {
      return [];
    } else {
      return events.content;
    }
  }
}

class RoadEventHistory extends StatelessWidget {

  RoadEventHistory({super.key});
  RoadEventHistoryController controller = Get.put(RoadEventHistoryController());

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: controller.initialize(),
      builder: (context, asyncSnapshot) {
        if (asyncSnapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Report History'),
            ),
            body: const Center(child: CircularProgressIndicator()),
          );
        } else if (asyncSnapshot.hasError) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Report History'),
            ),
            body: Center(child: Text('Error: ${asyncSnapshot.error}')),
          );
        } 
        return Scaffold(
          appBar: AppBar(
            title: const Text('Report History'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: controller.roadEventHistoryList.isEmpty
              ? const Center(
                  child: Text(
                    "No recent road event updates detected",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: controller.roadEventHistoryList.length,
                  itemBuilder: (context, index) {
                    final roadEventStatus = controller.roadEventHistoryList[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 8.0),
                      child: Container(
                        decoration: BoxDecoration(
                                color: roadEventStatus!.roadEvent != null
                                    ? primaryColor
                                    : Theme.of(context).cardTheme.color,
                          borderRadius: BorderRadius.circular(8.0),
                                border: Border.all(
                            width: 2.0,
                          ),
                        ),
                        child: ExpansionTile(
                          title: Text(roadEventStatus.roadEvent?.roadEvent.name ?? "NO EVENT CREATED"),
                                iconColor: roadEventStatus.roadEvent != null
                                    ? Colors.white
                                    : primaryColor,
                                collapsedIconColor:
                                    roadEventStatus.roadEvent != null
                                        ? Colors.white
                                        : primaryColor,
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: roadEventStatus.roadEvent != null ? [
                              Text("Latest Update: ${DateFormat.yMd().add_jm().format(DateTime.fromMillisecondsSinceEpoch(roadEventStatus.updates.last.updateSubmittedTimestamp.millisecondsSinceEpoch * 1000))}"),
                              Text('Source: ${roadEventStatus.updates.last.sourceType.name} - ID: ${roadEventStatus.updates.last.source['id'] ?? 'N/A'}'),
                            ] : [
                              Text("Latest Update: ${DateFormat.yMd().add_jm().format(DateTime.fromMillisecondsSinceEpoch(roadEventStatus.updates.last.updateSubmittedTimestamp.millisecondsSinceEpoch * 1000))}"),
                              Text('Source: ${roadEventStatus.updates.last.sourceType.name} - ID: ${roadEventStatus.updates.last.source['id'] ?? 'N/A'}'),
                            ],
                          ),
                          children: roadEventStatus.updates.map((update) {
                            return ListTile(
                              title: Text(
                                'Approval: ${update.approvalStatus.name}, Status: ${update.eventStatus.name}',
                                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                              ),
                              subtitle: Text(
                                'Submitted: ${DateFormat.yMd().add_jm().format(DateTime.fromMillisecondsSinceEpoch(update.updateSubmittedTimestamp.millisecondsSinceEpoch * 1000))}\n'
                                'Source: ${update.sourceType.name} - ID: ${update.source['id'] ?? 'N/A'}',
                                style: const TextStyle(fontSize: 12),
                              ),
                            );
                          }).toList(),
                        )),
                    );
                  },
                ),
          ),
        );
      }
    );
  }
}
