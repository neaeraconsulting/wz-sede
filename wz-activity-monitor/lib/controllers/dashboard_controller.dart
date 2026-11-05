import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:wzam/app_config.dart';
import 'package:wzam/models/fixed_length_queue.dart';
import 'package:wzam/models/generated/common.pb.dart';
import 'package:wzam/models/generated/common.pbenum.dart';
import 'package:wzam/models/generated/field_device.pb.dart';
import 'package:wzam/models/generated/road_event.pb.dart';
import 'package:wzam/models/generated/road_sub_event.pb.dart';
import 'package:wzam/models/generated/wzdx.pbenum.dart';
import 'package:wzam/models/mappable_field_device.dart';
import 'package:wzam/models/mappable_road_event.dart';
import 'package:wzam/models/mappable_sub_road_event.dart';
import 'package:wzam/models/marked_location_type_extension.dart';
import 'package:wzam/models/marker_data.dart';
import 'package:wzam/models/mixed_report.dart';
import 'package:wzam/models/recording.dart';
import 'package:wzam/models/wrappers/field_device_reading.dart';
import 'package:wzam/models/wrappers/road_event_wrapper.dart';
import 'package:wzam/models/wrappers/road_sub_event_wrapper.dart';
import 'package:wzam/services/auth_service.dart';
import 'package:wzam/services/cache_service.dart';
import 'package:wzam/services/file_storage.dart';
import 'package:wzam/services/wzam_api.dart';
import 'package:wzam/ui/styles/app_colors.dart';
import 'package:latlong2/latlong.dart' as map;
import 'package:wzam/ui/views/dashboard_details_dialog.dart';
import 'package:wzam/ui/views/dashboard_field_device_details_dialog.dart';
import 'package:wzam/ui/views/dashboard_road_event_details_dialog.dart';
import 'package:wzam/ui/views/dashboard_subevent_details_dialog.dart';
import 'package:wzam/models/page.dart' as page_model;
import 'package:wzam/models/generated/google/type/latlng.pb.dart' as pb;

enum RoadEventFilterStatus { Pending, Active, Completed }

class DashboardController extends GetxController {
  // Controllers and Services
  late MapController? mapController;
  AuthService authService = Get.find<AuthService>();
  FileStorageService fileService = Get.find<FileStorageService>();
  CacheService cacheService = Get.find<CacheService>();
  List<StreamSubscription> subscriptions = [];

  // Item lists based on types
  RxList<RoadEventWrapper> roadEvents = <RoadEventWrapper>[].obs;
  RxList<FieldDeviceReading> fieldDevices = <FieldDeviceReading>[].obs;
  RxList<MixedReport> reports = <MixedReport>[].obs;
  RxList<Recording> recordings = <Recording>[].obs;

  // Marker Data
  RxList<MarkerData> reportMarkerData = <MarkerData>[].obs;
  RxList<MappableRoadEvent> mappableRoadEvents = <MappableRoadEvent>[].obs;
  RxList<MarkerData> fieldDeviceMarkerData = <MarkerData>[].obs;
  RxList<MappableFieldDevice> mappableFieldDevices =
      <MappableFieldDevice>[].obs;
  RxList<MappableRoadSubEvent> mappableRoadSubEvents =
      <MappableRoadSubEvent>[].obs;
  Rx<Marker?> userMarker = Rx<Marker?>(null);

  // Marker Lists
  RxList<Marker> reportMarkers = <Marker>[].obs;
  RxList<Marker> roadEventMarkers = <Marker>[].obs;
  RxList<Marker> roadSubEventMarkers = <Marker>[].obs;

  // Polyline Lists
  final LayerHitNotifier<Object> _polylineHitNotifier = ValueNotifier(null);

  // Polygon Lists
  final LayerHitNotifier<Object> _polygonHitNotifier = ValueNotifier(null);

  // Layers
  Rx<MarkerLayer> markerLayer = const MarkerLayer(markers: <Marker>[]).obs;
  Rx<PolylineLayer> polylineLayer =
      const PolylineLayer(polylines: <Polyline>[]).obs;
  Rx<PolylineLayer> roadEventPolylineLayer =
      const PolylineLayer(polylines: <Polyline>[]).obs;
  Rx<PolygonLayer> polygonLayer = const PolygonLayer(polygons: <Polygon>[]).obs;
  Rx<RoadEventWrapper?> selectedRoadEventWrapper = Rx<RoadEventWrapper?>(null);

  Rx<int> selectedRoadEvent = (-1).obs;
  Rx<String> selectedFieldDevice = ''.obs;

  //Filters
  RxBool showFilters = false.obs;

  //Road Event Status Filters
  RxBool showActive = true.obs;
  RxBool showPending = true.obs;
  RxBool showCompleted = true.obs;
  RxBool showRecentlyCompleted = true.obs;

  //Road Event Type Filters
  RxBool showStatic = true.obs;
  RxBool showMoving = true.obs;
  RxBool showPlanned = true.obs;
  RxBool sortMine = false.obs;
  RxBool showFieldDevices = true.obs;
  RxBool showRoadEvents = true.obs;
  final Set<int> _hiddenRoadEventIds = <int>{};

  //Field Device Status Filters
  RxBool showDeviceUnknown = true.obs;
  RxBool showDeviceOK = true.obs;
  RxBool showDeviceWarning = true.obs;
  RxBool showDeviceError = true.obs;
  RxBool showDeviceOffline = true.obs;
  RxBool showDeviceInactive = true.obs;

  Rx<DateTime?> lastLiveWorkerLocationUpdate = Rx<DateTime?>(null);
  FixedLengthQueue<map.LatLng> positionHistory =
      FixedLengthQueue<map.LatLng>(10);
  Rx<Marker?> liveMarker = Rx<Marker?>(null);

  RxBool loadingLiveWorker = false.obs;
  RxDouble currentZoom = 18.0.obs;

  RxBool showLoadingCircle = false.obs;

  @override
  void onInit() {
    super.onInit();
    _polylineHitNotifier
        .addListener(() => onLayerTap(_polylineHitNotifier.value?.hitValues));
    _polygonHitNotifier
        .addListener(() => onLayerTap(_polygonHitNotifier.value?.hitValues));
  }

  Future<void> initialize({bool shouldMoveMap = true}) async {
    // Initializing road event update stream
    subscriptions.forEach((subscription) => subscription.cancel());
    subscriptions.clear();
    subscriptions.add(cacheService.roadEvents.listen((roadEvents) {
      updateRoadEventData(roadEvents.values.toList());
    }));
    subscriptions.add(cacheService.fieldDevices.listen((fieldDevices) {
      updateFieldDeviceData(fieldDevices.values.toList());
    }));
    subscriptions.add(cacheService.reports.listen((reports) {
      updateReportData(reports.values.toList());
    }));
    subscriptions.add(cacheService.recordings.listen((recordings) {
      updateRecordingData(recordings.values.toList());
    }));
    await cacheService.updateRoadEvents();
    await cacheService.updateFieldDevices();
    await cacheService.updateReports();
    await cacheService.updateRecordings();

    for (var wrapper in roadEvents) {
      RoadEvent event = wrapper.roadEvent;
      RoadEvent_RoadEventActiveStatus status = getRoadEventStatus(event);
      event.status = status;
    }
    mappableRoadEvents.value = getRoadEventMarkersData();
    mappableRoadSubEvents.value = getRoadSubEventMarkersData();
    mappableFieldDevices.value = getFieldDeviceMarkersData();
    await createLayers();

    if (shouldMoveMap) {
      // move to user location
      moveToUserLocation();
    }
  }

  Future<void> updateRoadEventData(
      List<RoadEventWrapper> updatedRoadEvents) async {
    roadEvents.value = updatedRoadEvents;
    _hiddenRoadEventIds.removeWhere(
      (id) => !roadEvents.any((wrapper) => wrapper.roadEvent.id.toInt() == id),
    );
    final int? selectedId =
        selectedRoadEventWrapper.value?.roadEvent.id.toInt();
    if (selectedId != null) {
      selectedRoadEventWrapper.value = roadEvents.firstWhereOrNull(
          (wrapper) => wrapper.roadEvent.id.toInt() == selectedId);
    }
    for (var wrapper in roadEvents) {
      RoadEvent event = wrapper.roadEvent;
      RoadEvent_RoadEventActiveStatus status = getRoadEventStatus(event);
      event.status = status;
    }
    mappableRoadEvents.value = getRoadEventMarkersData();
    await createLayers();
  }

  Future<void> updateFieldDeviceData(
      List<FieldDeviceReading> updatedFieldDevices) async {
    fieldDevices.value = updatedFieldDevices;
    mappableFieldDevices.value = getFieldDeviceMarkersData();
    await createLayers();
  }

  Future<void> updateReportData(List<MixedReport> updatedReport) async {
    reports.value = updatedReport;
  }

  Future<void> updateRecordingData(
      List<RecordingWithId> updatedRecording) async {
    recordings.value = updatedRecording;
  }

  void moveToUserLocation() {
    mapController?.move(
      userMarker.value?.point ?? AppConfig.defaultMapCenter,
      currentZoom.value,
    );
  }

  Future<List<RoadEventWrapper>> getRoadEvents() async {
    page_model.Page<RoadEventWrapper>? events = await WzamApi.getRoadEvents();
    if (events == null) {
      return [];
    } else {
      return events.content;
    }
  }

  Future<void> createLayers() async {
    List<Marker> markers = [];
    List<Polyline> polylines = [];
    List<Polyline> roadEventPolylines = [];
    List<Polygon> polygons = [];

    for (MappableFieldDevice fieldDevice in mappableFieldDevices) {
      if (fieldDevice.marker.marker != null) {
        markers.addAll(fieldDevice.marker.marker!);
      }
      if (fieldDevice.marker.polyline != null) {
        polylines.add(fieldDevice.marker.polyline!);
      }
      if (fieldDevice.marker.polygon != null) {
        polygons.add(fieldDevice.marker.polygon!);
      }
    }

    for (MappableRoadSubEvent subEvent in mappableRoadSubEvents) {
      if (subEvent.markers.marker != null) {
        markers.addAll(subEvent.markers.marker!);
      }
      if (subEvent.markers.polyline != null) {
        polylines.add(subEvent.markers.polyline!);
      }
      if (subEvent.markers.polygon != null) {
        polygons.add(subEvent.markers.polygon!);
      }
    }

    for (MappableRoadEvent roadEvent in mappableRoadEvents) {
      if (roadEvent.markers.marker != null) {
        markers.addAll(roadEvent.markers.marker!);
      }
      if (roadEvent.markers.polyline != null) {
        polylines.add(roadEvent.markers.polyline!);
        roadEventPolylines.add(roadEvent.markers.polyline!);
      }
      if (roadEvent.markers.polygon != null) {
        polygons.add(roadEvent.markers.polygon!);
      }
    }

    markerLayer.value = MarkerLayer(markers: markers);
    polylineLayer.value =
        PolylineLayer(polylines: polylines, hitNotifier: _polylineHitNotifier);
    roadEventPolylineLayer.value = PolylineLayer(
        polylines: roadEventPolylines, hitNotifier: _polylineHitNotifier);
    polygonLayer.value =
        PolygonLayer(polygons: polygons, hitNotifier: _polygonHitNotifier);
  }

  void handleMapTap() {
    final polyHitValues = _polylineHitNotifier.value?.hitValues;
    if (polyHitValues != null && polyHitValues.isNotEmpty) {
      List<Object> hitValue = polyHitValues.first as List<Object>;
      onObjectTap(hitValue[0] as int, subRoadEvent: hitValue[1] as bool);
      return;
    }
    return;
  }

  List<MappableRoadEvent> getRoadEventMarkersData() {
    List<MappableRoadEvent> markerDataList = [];
    if (!showRoadEvents.value) {
      return markerDataList;
    }
    for (RoadEventWrapper roadEventWrapper in roadEvents) {
      final RoadEvent roadEvent = roadEventWrapper.roadEvent;
      if (!_matchesRoadEventFilters(roadEvent) ||
          !isRoadEventVisible(roadEvent.id.toInt())) {
        continue;
      }
      MarkerData markerData = getRoadEventMarkerData(roadEvent);
      MappableRoadEvent mappableRoadEvent = MappableRoadEvent.fromRoadEvent(
        roadEventWrapper,
        markerData,
      );
      markerDataList.add(mappableRoadEvent);
    }
    return markerDataList;
  }

  List<MappableFieldDevice> getFieldDeviceMarkersData() {
    List<MappableFieldDevice> markerDataList = [];
    if (!showFieldDevices.value) {
      return markerDataList;
    }
    for (FieldDeviceReading fieldDevice in fieldDevices) {
      var status = fieldDevice.device.coreDetails.deviceStatus;
      if (status == FieldDevice_FieldDeviceStatus.FIELD_DEVICE_STATUS_UNKNOWN &&
          !showDeviceUnknown.value) {
        continue;
      }
      if (status == FieldDevice_FieldDeviceStatus.FIELD_DEVICE_STATUS_OK &&
          !showDeviceOK.value) {
        continue;
      }
      if (status == FieldDevice_FieldDeviceStatus.FIELD_DEVICE_STATUS_WARNING &&
          !showDeviceWarning.value) {
        continue;
      }
      if (status == FieldDevice_FieldDeviceStatus.FIELD_DEVICE_STATUS_ERROR &&
          !showDeviceError.value) {
        continue;
      }
      if (status == FieldDevice_FieldDeviceStatus.FIELD_DEVICE_STATUS_OFFLINE &&
          !showDeviceOffline.value) {
        continue;
      }
      if (status ==
              FieldDevice_FieldDeviceStatus.FIELD_DEVICE_STATUS_INACTIVE &&
          !showDeviceInactive.value) {
        continue;
      }
      void onTap(String id) {
        Get.dialog(DashboardFieldDeviceDetailsDialog(
          fieldDevice: MappableFieldDevice.fromFieldDevice(fieldDevice),
        ));
      }

      MappableFieldDevice mappableFieldDevice =
          MappableFieldDevice.fromFieldDevice(fieldDevice, onMarkerTap: onTap);
      markerDataList.add(mappableFieldDevice);
    }
    return markerDataList;
  }

  RoadEvent_RoadEventActiveStatus getRoadEventStatus(RoadEvent event) {
    DateTime now = DateTime.now();
    int startDateSeconds = event.startDate.seconds.toInt();
    int? endDateSeconds =
        event.hasEndDate() ? event.endDate.seconds.toInt() : null;
    int nowSeconds = now.millisecondsSinceEpoch ~/ 1000;
    if (startDateSeconds <= nowSeconds &&
        (endDateSeconds == null || endDateSeconds >= nowSeconds)) {
      return RoadEvent_RoadEventActiveStatus.ROAD_EVENT_ACTIVE_STATUS_ACTIVE;
    } else if (endDateSeconds != null && endDateSeconds < nowSeconds) {
      return RoadEvent_RoadEventActiveStatus.ROAD_EVENT_ACTIVE_STATUS_INACTIVE;
    } else {
      return RoadEvent_RoadEventActiveStatus.ROAD_EVENT_ACTIVE_STATUS_UNKNOWN;
    }
  }

  List<MappableRoadSubEvent> getRoadSubEventMarkersData() {
    List<MappableRoadSubEvent> markerDataList = [];
    if (!showRoadEvents.value) {
      return markerDataList;
    }
    for (RoadEventWrapper roadEventWrapper in roadEvents) {
      final RoadEvent roadEvent = roadEventWrapper.roadEvent;
      if (!_matchesRoadEventFilters(roadEvent) ||
          !isRoadEventVisible(roadEvent.id.toInt())) {
        continue;
      }
      List<RoadSubEventWrapper> roadSubEventWrappers =
          roadEventWrapper.roadSubEvents;
      for (RoadSubEventWrapper roadSubEventWrapper in roadSubEventWrappers) {
        MappableRoadSubEvent mappableRoadSubEvent =
            MappableRoadSubEvent.fromRoadSubEventTwo(roadSubEventWrapper,
                onMarkerTap: (String id) {
          onObjectTap(roadSubEventWrapper.roadSubEvent.id.toInt(),
              subRoadEvent: true);
        });
        markerDataList.add(mappableRoadSubEvent);
      }
    }
    return markerDataList;
  }

  MarkerData getRoadEventMarkerData(RoadEvent roadEvent) {
    List<Marker>? marker;
    Polyline? polyline;
    Polygon? polygon;
    if (roadEvent.whichGeometry() == RoadEvent_Geometry.point) {
      marker = [createRoadMarker(roadEvent)];
    } else if (roadEvent.whichGeometry() == RoadEvent_Geometry.lineString) {
      marker = createStartEndMarkers(roadEvent);
      polyline = createRoadPolyline(roadEvent);
    } else if (roadEvent.whichGeometry() == RoadEvent_Geometry.polygon) {
      polygon = createRoadPolygon(roadEvent);
    }
    return MarkerData(marker: marker, polyline: polyline, polygon: polygon);
  }

  void focusOnRoadEvent(int roadEventId) {
    int index =
        mappableRoadEvents.indexWhere((event) => event.id == roadEventId);
    if (index != -1) {
      selectRoadEvent(index);
    }
  }

  Marker createSubRoadEventMarker(pb.LatLng coordinates,
      MarkedLocationType locationType, RoadSubEvent roadSubEvent) {
    return Marker(
        width: 35.0,
        height: 35.0,
        rotate: true,
        point: map.LatLng(coordinates.latitude, coordinates.longitude),
        child: GestureDetector(
          onTap: () {
            onObjectTap(roadSubEvent.id.toInt(), subRoadEvent: true);
          },
          child: locationType.icon,
        ));
  }

  Marker createRoadMarker(RoadEvent roadEvent) {
    return Marker(
      width: 35.0,
      height: 35.0,
      rotate: true,
      point: map.LatLng(roadEvent.point.coordinates.latitude,
          roadEvent.point.coordinates.longitude),
      child: GestureDetector(
        onTap: () {
          onObjectTap(roadEvent.id.toInt());
        },
        child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: const BorderRadius.all(Radius.circular(6.0)),
              border: Border.all(
                  color: roadEvent.status ==
                          RoadEvent_RoadEventActiveStatus
                              .ROAD_EVENT_ACTIVE_STATUS_ACTIVE
                      ? primaryColor
                      : inactiveColor,
                  width: 2.0),
            ),
            alignment: Alignment.center,
            child: getEventIcon(roadEvent.status)),
      ),
    );
  }

  List<Marker> createStartEndMarkers(RoadEvent roadEvent) {
    Marker startMarker = Marker(
      width: 15.0,
      height: 15.0,
      rotate: true,
      point: map.LatLng(
          roadEvent.lineString.coordinates.coordinates.first.latitude,
          roadEvent.lineString.coordinates.coordinates.first.longitude),
      child: Container(
          width: 15,
          height: 15,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: roadEvent.status ==
                    RoadEvent_RoadEventActiveStatus
                        .ROAD_EVENT_ACTIVE_STATUS_ACTIVE
                ? primaryColor
                : inactiveColor,
          ),
          alignment: Alignment.center,
          child: const Icon(Icons.circle,
              color: Color.fromARGB(255, 0, 196, 7), size: 12)),
    );

    Marker endMarker = Marker(
      width: 15.0,
      height: 15.0,
      rotate: true,
      point: map.LatLng(
          roadEvent.lineString.coordinates.coordinates.last.latitude,
          roadEvent.lineString.coordinates.coordinates.last.longitude),
      child: Container(
          width: 15,
          height: 15,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: roadEvent.status ==
                    RoadEvent_RoadEventActiveStatus
                        .ROAD_EVENT_ACTIVE_STATUS_ACTIVE
                ? primaryColor
                : inactiveColor,
          ),
          alignment: Alignment.center,
          child: const Icon(Icons.circle,
              color: Color.fromARGB(255, 255, 17, 0), size: 12)),
    );
    return [startMarker, endMarker];
  }

  Polyline createRoadPolyline(RoadEvent roadEvent) {
    return Polyline(
      points: roadEvent.lineString.coordinates.coordinates
          .map((c) => map.LatLng(c.latitude, c.longitude))
          .toList(),
      color: roadEvent.status ==
              RoadEvent_RoadEventActiveStatus.ROAD_EVENT_ACTIVE_STATUS_ACTIVE
          ? primaryColor
          : inactiveColor,
      strokeWidth: 4.0,
      hitValue: [roadEvent.id.toInt(), false],
    );
  }

  Polygon createRoadPolygon(RoadEvent roadEvent) {
    return Polygon(
      points: roadEvent.polygon.coordinates.coordinates
          .map((c) => map.LatLng(c.latitude, c.longitude))
          .toList(),
      color: roadEvent.status ==
              RoadEvent_RoadEventActiveStatus.ROAD_EVENT_ACTIVE_STATUS_ACTIVE
          ? primaryColor.withValues(alpha: 0.5)
          : inactiveColor.withValues(alpha: 0.5),
      borderColor: roadEvent.status ==
              RoadEvent_RoadEventActiveStatus.ROAD_EVENT_ACTIVE_STATUS_ACTIVE
          ? primaryColor
          : inactiveColor,
      borderStrokeWidth: 2.0,
      hitValue: roadEvent.id.toInt(),
    );
  }

  void selectRoadEvent(int index) {
    if (index < 0 || index >= mappableRoadEvents.length) {
      return;
    }
    selectedRoadEvent.value = mappableRoadEvents[index].id;
    if (mappableRoadEvents[index].bounds == null) {
      mapController?.move(
        mappableRoadEvents[index].centerPoint,
        currentZoom.value, /*offset: const Offset(0, -150)*/
      );
    } else {
      if (mappableRoadEvents[index].bounds!.north ==
              mappableRoadEvents[index].bounds!.south ||
          mappableRoadEvents[index].bounds!.east ==
              mappableRoadEvents[index].bounds!.west) {
        mapController?.move(
          mappableRoadEvents[index].centerPoint,
          currentZoom.value, /*offset: const Offset(0, -150)*/
        );
      } else {
        CameraFit cameraFit = CameraFit.bounds(
            bounds: mappableRoadEvents[index].bounds!,
            padding: const EdgeInsets.only(
                top: 100.0, left: 100, right: 100, bottom: 100.0));
        mapController?.fitCamera(cameraFit);
      }
    }
  }

  void selectFieldDevice(int index) {
    if (index < 0 || index >= mappableFieldDevices.length) {
      return;
    }
    selectedFieldDevice.value = mappableFieldDevices[index].id;
    pb.LatLng coordinates =
        mappableFieldDevices[index].fieldDevice.geometry.coordinates;
    mapController?.move(
      map.LatLng(coordinates.latitude, coordinates.longitude),
      currentZoom.value,
    );
  }

  void onLayerTap(List<Object>? hitValues) {}

  void onObjectTap(int id, {bool subRoadEvent = false}) {
    if (!subRoadEvent) {
      selectedRoadEvent.value = id;
      RoadEventWrapper? roadEventWrapper =
          roadEvents.firstWhereOrNull((re) => re.roadEvent.id.toInt() == id);
      if (roadEventWrapper != null) {
        selectedRoadEventWrapper.value = roadEventWrapper;
      }
    } else {
      // id is sub event id
      MappableRoadSubEvent? mappableRoadSubEvent =
          mappableRoadSubEvents.firstWhereOrNull((re) => re.id == id);
      if (mappableRoadSubEvent != null) {
        Get.dialog(
            DashboardSubEventDetailsDialog(roadSubEvent: mappableRoadSubEvent));
        RoadEventWrapper? roadEventWrapper = roadEvents.firstWhereOrNull((re) =>
            re.roadEvent.id.toInt() ==
            mappableRoadSubEvent
                .roadSubEventWrappers.first.roadSubEvent.roadEventId.toInt());
        if (roadEventWrapper != null) {
          selectedRoadEventWrapper.value = roadEventWrapper;
        }
      } else {
        print("No road sub-event found with ID: $id");
      }
    }
  }

  Future<void> filter() async {
    mappableRoadEvents.value = getRoadEventMarkersData();
    mappableRoadSubEvents.value = getRoadSubEventMarkersData();
    mappableFieldDevices.value = getFieldDeviceMarkersData();
    await createLayers();
    update();
  }

  bool _matchesRoadEventFilters(RoadEvent roadEvent) {
    RoadEventFilterStatus status = getRoadEventFilterStatus(roadEvent);
    if (status == RoadEventFilterStatus.Pending && !showPending.value) {
      return false;
    }
    if (status == RoadEventFilterStatus.Active && !showActive.value) {
      return false;
    }
    if (status == RoadEventFilterStatus.Completed && !showCompleted.value) {
      return false;
    }

    if (roadEvent.areaType == WorkZoneType.WORK_ZONE_TYPE_STATIC &&
        !showStatic.value) {
      return false;
    }
    if (roadEvent.areaType == WorkZoneType.WORK_ZONE_TYPE_MOVING &&
        !showMoving.value) {
      return false;
    }
    if (roadEvent.areaType == WorkZoneType.WORK_ZONE_TYPE_PLANNED_MOVING_AREA &&
        !showPlanned.value) {
      return false;
    }

    return true;
  }

  List<RoadEventWrapper> getFilteredRoadEventWrappers() {
    return roadEvents
        .where((wrapper) => _matchesRoadEventFilters(wrapper.roadEvent))
        .toList();
  }

  bool isRoadEventVisible(int roadEventId) {
    return !_hiddenRoadEventIds.contains(roadEventId);
  }

  Future<void> setRoadEventVisibility(int roadEventId, bool visible) async {
    if (visible) {
      _hiddenRoadEventIds.remove(roadEventId);
    } else {
      _hiddenRoadEventIds.add(roadEventId);
    }
    await filter();
  }

  bool areAllFilteredRoadEventsVisible() {
    final List<RoadEventWrapper> filtered = getFilteredRoadEventWrappers();
    if (filtered.isEmpty) {
      return true;
    }
    return filtered
        .every((wrapper) => isRoadEventVisible(wrapper.roadEvent.id.toInt()));
  }

  Future<void> setAllFilteredRoadEventsVisibility(bool visible) async {
    for (final RoadEventWrapper wrapper in getFilteredRoadEventWrappers()) {
      final int roadEventId = wrapper.roadEvent.id.toInt();
      if (visible) {
        _hiddenRoadEventIds.remove(roadEventId);
      } else {
        _hiddenRoadEventIds.add(roadEventId);
      }
    }
    await filter();
  }

  RoadEventFilterStatus getRoadEventFilterStatus(RoadEvent event) {
    DateTime now = DateTime.now();
    int startDateSeconds = event.startDate.seconds.toInt();
    int? endDateSeconds =
        event.hasEndDate() ? event.endDate.seconds.toInt() : null;
    int nowSeconds = now.millisecondsSinceEpoch ~/ 1000;
    if (startDateSeconds <= nowSeconds &&
        (endDateSeconds == null || endDateSeconds >= nowSeconds)) {
      return RoadEventFilterStatus.Active;
    } else if (endDateSeconds != null && endDateSeconds < nowSeconds) {
      return RoadEventFilterStatus.Completed;
    } else {
      return RoadEventFilterStatus.Pending;
    }
  }

  Icon getEventIcon(RoadEvent_RoadEventActiveStatus status) {
    IconData iconData;
    Color iconColor;

    switch (status) {
      case RoadEvent_RoadEventActiveStatus.ROAD_EVENT_ACTIVE_STATUS_ACTIVE:
        iconData = Icons.construction;
        iconColor = primaryColor;
        break;
      case RoadEvent_RoadEventActiveStatus.ROAD_EVENT_ACTIVE_STATUS_INACTIVE:
        iconData = Icons.construction;
        iconColor = inactiveColor;
        break;
      case RoadEvent_RoadEventActiveStatus.ROAD_EVENT_ACTIVE_STATUS_UNKNOWN:
      default:
        iconData = Icons.close;
        iconColor = inactiveColor;
        break;
    }

    return Icon(
      iconData,
      color: iconColor,
      size: 30.0,
    );
  }

  void refreshMap() {
    initialize(shouldMoveMap: false);
  }

  List<MappableFieldDevice> fieldDevicesNonAvl(
      List<MappableFieldDevice> fieldDevices) {
    return fieldDevices.where((device) => device.make != "WYDOT AVL").toList();
  }

  List<MappableFieldDevice> fieldDevicesAvl(
      List<MappableFieldDevice> fieldDevices) {
    return fieldDevices.where((device) => device.make == "WYDOT AVL").toList();
  }
}
