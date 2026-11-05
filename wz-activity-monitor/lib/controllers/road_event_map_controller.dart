import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:wzam/models/generated/road_event.pb.dart';
import 'package:wzam/models/generated/wzdx.pb.dart';
import 'package:wzam/models/mappable_road_event.dart';
import 'package:wzam/models/marker_data.dart';
import 'package:wzam/models/position_extensions.dart';
import 'package:wzam/models/wrappers/road_event_wrapper.dart';
import 'package:wzam/services/cache_service.dart';
import 'package:wzam/services/location_service.dart';
import 'package:wzam/ui/styles/app_colors.dart';
import 'package:wzam/ui/styles/screen_size.dart';
import 'package:wzam/ui/styles/spacing.dart';
import 'package:wzam/ui/styles/text_styles.dart';
import 'package:wzam/ui/styles/widgets/wzam_text.dart';

import 'package:latlong2/latlong.dart';
import 'package:protobuf/protobuf.dart';
import 'package:wzam/models/generated/google/type/latlng.pb.dart' as pb;

class RoadEventMapController extends GetxController {
  MapController? mapController;
  LocationService locationService = Get.find<LocationService>();
  CacheService cacheService = Get.find<CacheService>();
  List<MappableRoadEvent> completeRoadEventsList = [];
  List<RoadEventWrapper> roadEventWrapperList = [];
  RxList<MappableRoadEvent> roadEventMap = RxList<MappableRoadEvent>([]);
  RxList<int> filteredRoadEventIds = <int>[].obs;
  Rx<Marker?> userMarker = Rx<Marker?>(null);
  Rx<int?> selectedRoadEvent = Rx<int?>(null);
  Rx<int?> selectedProject = Rx<int?>(null);
  final LayerHitNotifier<Object> _polylineHitNotifier = ValueNotifier(null);
  final LayerHitNotifier<Object> _polygonHitNotifier = ValueNotifier(null);
  List<StreamSubscription> subscriptions = [];

  Future<void> initialize(
      {int? selectedProjectId, int? selectedRoadEventId}) async {
    roadEventMap.clear();
    completeRoadEventsList.clear();
    roadEventWrapperList.clear();
    selectedProject.value = selectedProjectId;
    selectedRoadEvent.value = selectedRoadEventId;

    // Initializing road event update stream
    for (var subscription in subscriptions) {
      subscription.cancel();
    }
    subscriptions.clear();
    subscriptions.add(cacheService.roadEvents.listen((roadEvents) {
      List<RoadEventWrapper> wrappers = roadEvents.values.toList();
      for (int i = wrappers.length - 1; i >= 0; i--) {
        RoadEventWrapper wrapper = wrappers[i];
        if (wrapper.roadEvent.lineString.coordinates.coordinates.isEmpty) {
          //remove any road events that don't have coordinates
          wrappers.removeAt(i);
        }
      }
      updateRoadEventData(wrappers);
    }));
    await cacheService.updateRoadEvents();

    updateUserMarker();
    _polylineHitNotifier
        .addListener(() => onLayerTap(_polylineHitNotifier.value?.hitValues));
    _polygonHitNotifier
        .addListener(() => onLayerTap(_polygonHitNotifier.value?.hitValues));
  }

  void onLayerTap(List<Object>? hitValues) {
    if (hitValues != null && hitValues.isNotEmpty) {
      // Assuming the first hit value is the ID of the road event
      int id = hitValues.first as int;
      onObjectTap(id);
    }
  }


  void onObjectTap(int id) {
    selectedRoadEvent.value = id;
  }

  MarkerLayer constructMarkerLayer(
      Marker? userMarker, List<MappableRoadEvent> roadEvents, int? selectedId) {
    List<Marker> markers = [];
    List<Marker> selectedMarkers = [];
    if (userMarker != null) {
      markers.add(userMarker);
    }
    for (MappableRoadEvent roadEvent in roadEvents) {
      if (roadEvent.markers.marker != null) {
        if (selectedId == roadEvent.id) {
          // Highlight the selected polygon
          selectedMarkers.add(createRoadMarker(
              roadEvent.roadEvent.point.coordinates, roadEvent.id, onObjectTap,
              selected: true)); 
        } else {
          // Add the polygon normally
          markers.addAll(roadEvent.markers.marker!);
        }
        markers.addAll(roadEvent.markers.marker!);
      }
      if (roadEvent.markers.polyline != null) {
        Marker roadEventPolylineMarker = createRoadMarker(
            roadEvent.roadEvent.lineString.coordinates.coordinates[0],
            roadEvent.id,
            onObjectTap, selected: selectedId == roadEvent.id);
        markers.add(roadEventPolylineMarker);
      }
    }
    return MarkerLayer(markers: [...markers, ...selectedMarkers]);
  }

  PolylineLayer constructPolylineLayer(
      List<MappableRoadEvent> roadEvents, int? selectedId) {
    List<Polyline> polylines = [];
    List<Polyline> selectedPolylines = [];
    for (MappableRoadEvent roadEvent in roadEvents) {
      if (roadEvent.markers.polyline != null) {
        if (selectedId == roadEvent.id) {
          // Highlight the selected polygon
          selectedPolylines.add(createPolyline(
              roadEvent.roadEvent.lineString.coordinates.coordinates,
              roadEvent.id,
              selected: true));
        } else {
          // Add the polygon normally
          polylines.add(roadEvent.markers.polyline!);
        }
      }
    }
    return PolylineLayer(
        polylines: [...polylines, ...selectedPolylines],
        hitNotifier: _polylineHitNotifier);
  }

  PolygonLayer constructPolygonLayer(
      List<MappableRoadEvent> roadEvents, int? selectedId) {
    List<Polygon> polygons = [];
    List<Polygon> selectedPolygons = [];
    for (MappableRoadEvent roadEvent in roadEvents) {
      if (roadEvent.markers.polygon != null) {
        if (selectedId == roadEvent.id) {
          // Highlight the selected polygon
          selectedPolygons.add(createPolygon(
              roadEvent.roadEvent.polygon.coordinates.coordinates, roadEvent.id,
              selected: true));
        } else {
          // Add the polygon normally
          polygons.add(roadEvent.markers.polygon!);
        }
      }
    }
    return PolygonLayer(
        polygons: [...polygons, ...selectedPolygons],
        hitNotifier: _polygonHitNotifier);
  }

  Future<void> updateRoadEventData(List<RoadEventWrapper> roadEvents) async {
    roadEvents = roadEvents
        .where((roadEvent) =>
            roadEvent.roadEvent.areaType ==
            (WorkZoneType.WORK_ZONE_TYPE_STATIC))
        .toList();
    roadEventWrapperList = roadEvents;
    for (RoadEventWrapper roadEventWrapper in roadEvents) {
      RoadEvent roadEvent = roadEventWrapper.roadEvent;
      Marker marker = createRoadMarker(
          roadEvent.point.coordinates, roadEvent.id.toInt(), onObjectTap);
      Polyline polyline = createPolyline(
          roadEvent.lineString.coordinates.coordinates, roadEvent.id.toInt());
      Polygon polygon = createPolygon(
          roadEvent.polygon.coordinates.coordinates, roadEvent.id.toInt());
      MarkerData markers = MarkerData(
          marker: roadEvent.hasPoint() ? [marker] : null,
          polyline: roadEvent.hasLineString() ? polyline : null,
          polygon: roadEvent.hasPolygon() ? polygon : null);
      MappableRoadEvent mappableRoadEvent =
          MappableRoadEvent.fromRoadEvent(roadEventWrapper, markers);
      completeRoadEventsList
          .add(mappableRoadEvent);
    }
    roadEventMap.value = completeRoadEventsList
        .where((roadEvent) =>
            roadEvent.projectId ==
            (selectedProject.value ?? roadEvent.projectId))
        .toList();
  }

  Future<void> updateUserMarker() async {
    Position? position = locationService.currentPosition.value ??
        await locationService.getCurrentLocation();
    if (position != null) {
      userMarker.value = _createUserMaker(position);
    }
  }

  Widget markerShownButton(MappableRoadEvent item) {
    Color iconColor = primaryColor;
    return GestureDetector(
        child: Icon(Icons.circle, color: iconColor),
        onTap: () {
          Get.dialog(_selectRoadEventDialog(item));
        });
  }

  Widget markerHiddenButton(MappableRoadEvent item) {
    return GestureDetector(
        child: const Icon(Icons.circle, color: Colors.transparent),
        onTap: () {
          Get.dialog(_selectRoadEventDialog(item));
        });
  }

  Marker _createUserMaker(Position position) {
    return Marker(
        point: position.getLatLng(),
        child: Image.asset('assets/images/location_with_border.png',
            width: 25.0, height: 25.0),
        rotate: true);
  }

  RichText _formattedText(String name, String content, BuildContext context) {
    return RichText(
        text: TextSpan(children: [
      TextSpan(
          text: "$name: ",
          style: styleBody.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).textTheme.bodySmall?.color ??
                  Colors.black)),
      TextSpan(
          text: content,
          style: styleBody.copyWith(
              color:
                  Theme.of(context).textTheme.bodySmall?.color ?? Colors.black))
    ]));
  }

  Polygon createPolygon(PbList<pb.LatLng> points, int id,
      {bool selected = false}) {
    return Polygon(
      color: selected ? primaryColor.withAlpha(50) : inactiveColor.withAlpha(70),
      borderColor: selected ? primaryColor : inactiveColor,
      hitValue: id,
      points: points.map((p) => LatLng(p.latitude, p.longitude)).toList(),
    );
  }

  Polyline createPolyline(PbList<pb.LatLng> points, int id,
      {bool selected = false}) {
    return Polyline(
      color: selected ? primaryColor : inactiveColor,
      strokeWidth: 6,
      hitValue: id,
      points: points.map((p) => LatLng(p.latitude, p.longitude)).toList(),
    );
  }

  Marker createMarker(pb.LatLng point, int id, void Function(int) onTap,
      {bool selected = false}) {
    return Marker(
      child: GestureDetector(
        onTap: () => onTap(id),
        child: Icon(Icons.warning_rounded,
            color: selected ? inactiveColor : Colors.black,
            size: selected ? 30 : 20),
      ),
      point: LatLng(point.latitude, point.longitude),
    );
  }

  Marker createRoadMarker(pb.LatLng point, int id, void Function(int) onTap, {bool selected = false}) {
    return Marker(
        width: 35.0,
        height: 35.0,
        rotate: true,
        point: LatLng(point.latitude, point.longitude),
        child: GestureDetector(  
          onTap: () => onTap(id),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: const BorderRadius.all(Radius.circular(6.0)),
              border: Border.all(color: selected ? primaryColor : inactiveColor, width: 2.0),
            ),
            alignment: Alignment.center,
            child: getEventIcon(selected: selected),
          ),
        ),
    );
  }

  Icon getEventIcon({bool selected = false}) {
    IconData iconData = Icons.construction;
    Color iconColor = selected ? primaryColor : inactiveColor;

    return Icon(
      iconData,
      color: iconColor,
      size: 30.0,
    );
  }

  Dialog _selectRoadEventDialog(MappableRoadEvent roadEvent) {
    BuildContext context = Get.context!;

    // Format the DateTime objects
    String formattedStartDate =
        DateFormat.yMd().add_jm().format(roadEvent.startDate);
    String formattedEndDate =
        DateFormat.yMd().add_jm().format(roadEvent.endDate);
    return Dialog(
      insetPadding: const EdgeInsets.all(40.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
        side: const BorderSide(color: Colors.black, width: 1.0),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: screenWidth(context) * 0.8,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(roadEvent.roadEvent.name.toUpperCase(),
                            style:
                                styleTwo.copyWith(
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                    verticalSpaceSmall,
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 1.0),
                      ),
                    ),
                    verticalSpaceSmall,
                  ],
                ),
              ),
              SizedBox(
                width: screenWidth(context) * 0.6,
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    _formattedText("Description",
                        roadEvent.roadEvent.description, context),
                    _formattedText("Start Date", formattedStartDate, context),
                    _formattedText("End Date", formattedEndDate, context),
                    verticalSpaceSmall,
                  ],
                ),
              ),
              verticalSpaceSmall,
              Align(
                alignment: Alignment.bottomRight,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ClickableText(
                      text: "Select This Road Event",
                      onTap: () {
                        Get.back(result: roadEvent);
                      },
                    ),
                    Expanded(child: Container()),
                    ClickableText(
                      text: "Close",
                      onTap: () => Get.back(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
