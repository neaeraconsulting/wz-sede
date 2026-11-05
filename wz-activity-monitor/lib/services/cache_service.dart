import 'package:get/get.dart';
import 'package:wzam/models/mixed_report.dart';
import 'package:wzam/models/recording.dart';
import 'package:wzam/models/wrappers/field_device_reading.dart';
import 'package:wzam/models/wrappers/road_event_wrapper.dart';
import 'package:wzam/models/wrappers/project_wrapper.dart';
import 'package:wzam/services/sembast_service.dart';
import 'package:wzam/services/wzam_api.dart';

class CacheService extends GetxService {
  SembastService sembastService = Get.find<SembastService>();

  Rx<Map<String, FieldDeviceReading>> fieldDevices =
      Rx<Map<String, FieldDeviceReading>>({});
  Rx<Map<int, RoadEventWrapper>> roadEvents =
      Rx<Map<int, RoadEventWrapper>>({});
  Rx<Map<int, ProjectWrapper>> projects = Rx<Map<int, ProjectWrapper>>({});
  Rx<Map<int, MixedReport>> reports = Rx<Map<int, MixedReport>>({});
  Rx<Map<int, RecordingWithId>> recordings = Rx<Map<int, RecordingWithId>>({});

  @override
  void onInit() async {
    super.onInit();
    await init();
  }

  Future<void> init() async {
    // Initialize data from sembast
    fieldDevices.value = await sembastService.getFieldDevices();
    roadEvents.value = await sembastService.getRoadEvents();
    projects.value = await sembastService.getProjects();
  }

  Future<Map<String, FieldDeviceReading>> updateFieldDevices() async {
    // Update field devices from sembast
    List<FieldDeviceReading>? deviceReadings =
        (await WzamApi.getFieldDevices())?.content;
    if (deviceReadings == null) {
      return fieldDevices.value;
    }
    // Update the local cache
    Map<String, FieldDeviceReading> deviceMap = {
      for (var deviceReading in deviceReadings)
        deviceReading.device.id.toString(): deviceReading
    };
    sembastService.writeFieldDevices(deviceReadings, clear: true);
    fieldDevices.value = deviceMap;
    return deviceMap;
  }

  Future<Map<int, RoadEventWrapper>> updateRoadEvents() async {
    // Update road events from sembast
    List<RoadEventWrapper>? roadEventWrappers =
        (await WzamApi.getRoadEvents())?.content;
    if (roadEventWrappers == null) {
      return roadEvents.value;
    }
    // Update the local cache
    Map<int, RoadEventWrapper> roadEventMap = {
      for (var roadEventWrapper in roadEventWrappers)
        roadEventWrapper.roadEvent.id.toInt(): roadEventWrapper
    };
    sembastService.writeRoadEvents(roadEventWrappers, clear: true);
    roadEvents.value = roadEventMap;
    return roadEventMap;
  }

  Future<Map<int, ProjectWrapper>> updateProjects() async {
    // Update projects from sembast
    List<ProjectWrapper>? projectList = (await WzamApi.getProjects())?.content;
    if (projectList == null) {
      return projects.value;
    }
    // Update the local cache
    Map<int, ProjectWrapper> projectMap = {
      for (var project in projectList) project.project.id.toInt(): project
    };
    sembastService.writeProjects(projectList, clear: true);
    projects.value = projectMap;
    return projectMap;
  }

  Future<Map<int, MixedReport>> updateReports() async {
    // Update reports from sembast
    List<MixedReport>? reportList = (await WzamApi.getReports())?.content;
    if (reportList == null) {
      return reports.value;
    }
    // Update the local cache
    Map<int, MixedReport> reportMap = {
      for (var report in reportList) report.id: report
    };
    sembastService.writeReports(reportList, clear: true);
    reports.value = reportMap;
    return reportMap;
  }

  Future<Map<int, RecordingWithId>> updateRecordings() async {
    // Update recordings from sembast
    List<RecordingWithId>? recordingList =
        (await WzamApi.getRecordings())?.content;
    if (recordingList == null) {
      return recordings.value;
    }
    // Update the local cache
    Map<int, RecordingWithId> recordingMap = {
      for (var recording in recordingList) recording.id: recording
    };
    sembastService.writeRecordings(recordingList, clear: true);
    recordings.value = recordingMap;
    return recordingMap;
  }
}
