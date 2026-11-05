import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geoxml/geoxml.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:wzam/app_config.dart';
import 'package:wzam/constants.dart';
import 'package:wzam/models/datahub/route_and_measure.dart';
import 'package:wzam/models/notification_model.dart';
import 'package:wzam/models/recording.dart';
import 'package:wzam/services/wzam_api.dart';
import 'package:wzam/ui/pages/dashboard/dashboard.dart';
import 'package:wzam/ui/styles/app_colors.dart';
import 'package:wzam/ui/styles/screen_size.dart';
import 'package:wzam/ui/styles/spacing.dart';
import 'package:wzam/ui/styles/theme_setting.dart';
import 'package:wzam/ui/styles/widgets/triangle.dart';
import 'package:wzam/models/wzdx_models.dart';

part 'assign_kml_stage_start_end.dart';
part 'assign_kml_stage_zone_marking.dart';

enum WaypointCategory {
  startPoint,
  endPoint,
  speedLimitMarker,
  laneClosed,
  laneOpen,
  startWorkerZone,
  endWorkerZone,
  ignore,
}

enum WaypointSortOrder {
  markerNumber,
  gisAscending,
  gisDescending,
}

enum AssignmentStage {
  startEndSelection,
  intervalMarking,
}

enum UnresolvedPointReason {
  notOnSelectedRoadway,
  outsideSelectedRange,
}

enum IntervalMarkingType {
  speedLimit,
  workerPresence,
  laneClosure,
}

enum IntervalSelectionPhase {
  selectStart,
  selectEnd,
}

extension IntervalMarkingTypeLabel on IntervalMarkingType {
  String get label {
    switch (this) {
      case IntervalMarkingType.speedLimit:
        return 'Speed Zone';
      case IntervalMarkingType.workerPresence:
        return 'Worker Presence Zone';
      case IntervalMarkingType.laneClosure:
        return 'Lane Closure Zone';
    }
  }
}

extension WaypointSortOrderLabel on WaypointSortOrder {
  String get label {
    switch (this) {
      case WaypointSortOrder.gisAscending:
        return 'Sort: GIS ascending';
      case WaypointSortOrder.gisDescending:
        return 'Sort: GIS descending';
      case WaypointSortOrder.markerNumber:
        return 'Sort: Marker number';
    }
  }
}

extension WaypointCategoryLabel on WaypointCategory {
  String get label {
    switch (this) {
      case WaypointCategory.startPoint:
        return 'Start Point';
      case WaypointCategory.endPoint:
        return 'End Point';
      case WaypointCategory.speedLimitMarker:
        return 'Speed Limit Marker';
      case WaypointCategory.laneClosed:
        return 'Lane Closed';
      case WaypointCategory.laneOpen:
        return 'Lane Open';
      case WaypointCategory.startWorkerZone:
        return 'Start Worker Presence';
      case WaypointCategory.endWorkerZone:
        return 'End Worker Presence';
      case WaypointCategory.ignore:
        return 'Ignore';
    }
  }
}

extension UnresolvedPointReasonLabel on UnresolvedPointReason {
  String get label {
    switch (this) {
      case UnresolvedPointReason.notOnSelectedRoadway:
        return 'Not on selected roadway';
      case UnresolvedPointReason.outsideSelectedRange:
        return 'Outside selected start/end range';
    }
  }
}

const double _kCategoryImageSize = 36.0;
const double _kMapMarkerSize = 36;
const double _kMarkerLabelZoomThreshold = 14.0;

Map<WaypointCategory, Widget> _kCategoryImages = {
  WaypointCategory.startPoint: SvgPicture.asset(
    Constants.roadClosureStartIcon,
    width: _kCategoryImageSize,
    height: _kCategoryImageSize,
    fit: BoxFit.contain,
  ),
  WaypointCategory.endPoint: SvgPicture.asset(
    Constants.roadClosureEndIcon,
    width: _kCategoryImageSize,
    height: _kCategoryImageSize,
    fit: BoxFit.contain,
  ),
  WaypointCategory.speedLimitMarker: Image.asset(
    'assets/images/speed_limit.png',
    width: _kCategoryImageSize,
    height: _kCategoryImageSize,
    fit: BoxFit.contain,
  ),
  WaypointCategory.laneClosed: Image.asset(
    'assets/images/closed_lane.png',
    width: _kCategoryImageSize,
    height: _kCategoryImageSize,
    fit: BoxFit.contain,
  ),
  WaypointCategory.laneOpen: Image.asset(
    'assets/images/lane.png',
    width: _kCategoryImageSize,
    height: _kCategoryImageSize,
    fit: BoxFit.contain,
  ),
  WaypointCategory.startWorkerZone: SvgPicture.asset(
    Constants.workerPresenceStartIcon,
    width: _kCategoryImageSize,
    height: _kCategoryImageSize,
    fit: BoxFit.contain,
  ),
  WaypointCategory.endWorkerZone: SvgPicture.asset(
    Constants.workerPresenceEndIcon,
    width: _kCategoryImageSize,
    height: _kCategoryImageSize,
    fit: BoxFit.contain,
  ),
};

class MappableKmlPoint {
  String description;
  LatLng point;
  Set<WaypointCategory> categories;
  RouteAndMeasure? gisMeasure;
  int? speed;
  RxList<int> lanesAffected = <int>[].obs;
  MappableKmlPoint(
      {required this.description,
      required this.point,
      Set<WaypointCategory>? categories,
      this.gisMeasure})
      : categories = categories ?? <WaypointCategory>{};

  MappableKmlPoint.fromWaypoint(Wpt waypoint)
      : description = waypoint.name ?? '',
        categories = <WaypointCategory>{},
        point = LatLng(waypoint.lat ?? 0.0, waypoint.lon ?? 0.0);

  Future<void> initializeGisMeasure() async {
    try {
      gisMeasure = await WzamApi.getClosestRouteAndMeasure(
          point.latitude, point.longitude);
      if (gisMeasure != null) {
        Map<String, dynamic>? gisLocation = await WzamApi.getGeometryForMeasure(
            gisMeasure!.routeId, gisMeasure!.measure);
        if (gisLocation != null) {
          point = LatLng(
              gisLocation['latitude'] ?? 0.0, gisLocation['longitude'] ?? 0.0);
        }
      } else {
        print(
            "No GIS measure found for point at ${point.latitude}, ${point.longitude} - Description: $description");
      }
    } catch (e) {
      print(
          "Error initializing GIS measure for point at ${point.latitude}, ${point.longitude} - Description: $description: $e");
    }
  }
}

class _IntervalMarking {
  final IntervalMarkingType type;
  final int startPointIndex;
  final int endPointIndex;
  final int? speedMph;
  final List<int> lanes;

  const _IntervalMarking({
    required this.type,
    required this.startPointIndex,
    required this.endPointIndex,
    this.speedMph,
    this.lanes = const <int>[],
  });
}

class _RecordingMarkingDraft {
  bool? refPt;
  List<Lane>? lanes;
  int? speedLimitMph;
  bool? workersPresent;

  bool get hasMarking =>
      refPt != null ||
      (lanes != null && lanes!.isNotEmpty) ||
      speedLimitMph != null ||
      workersPresent != null;

  RecordingMarking toRecordingMarking() {
    return RecordingMarking(
      refPt: refPt,
      lanes: lanes,
      speedLimitMph: speedLimitMph,
      workersPresent: workersPresent,
    );
  }
}

class KmlController extends GetxController {
  List<Wpt> waypoints = [];
  List<Rte> routes = [];
  List<Trk> tracks = [];
  late Recording recording;
  late int numLanes;
  late int speedLimit;
  late MapController? mapController;
  RxDouble currentZoom = 18.0.obs;
  Rx<MarkerLayer> markerLayer = const MarkerLayer(markers: <Marker>[]).obs;
  Rx<PolylineLayer> polylineLayer =
      const PolylineLayer(polylines: <Polyline>[]).obs;
  final RxInt selectedWaypointIndex = RxInt(-1);
  RxInt get selectedObjectId => selectedWaypointIndex;
  RxInt selectedRouteId = RxInt(-1);
  final RxMap<int, WaypointCategory?> intervalSelectionPreviewCategories =
      <int, WaypointCategory?>{}.obs;
  RxInt workZonePathRouteId = RxInt(-1);
  RxMap<int, WaypointCategory?> waypointCategories =
      <int, WaypointCategory?>{}.obs;
  RxList<MappableKmlPoint> mappableKmlPoints = <MappableKmlPoint>[].obs;
  final Map<int, TextEditingController> _speedControllers =
      <int, TextEditingController>{};
  final RxBool gisPointsLoading = false.obs;
  final RxInt gisPointsCompleted = 0.obs;
  final RxInt gisPointsTotal = 0.obs;
  final RxString gisPointsStatus = ''.obs;
  final Rx<WaypointSortOrder> waypointSortOrder =
      WaypointSortOrder.markerNumber.obs;
  final RxBool showMilepostsInLabels = false.obs;
  final Rx<AssignmentStage> assignmentStage =
      AssignmentStage.startEndSelection.obs;
  final Rx<int?> roadwayStartPointIndex = Rx<int?>(null);
  final Rx<int?> roadwayEndPointIndex = Rx<int?>(null);
  final RxString canonicalRouteId = ''.obs;
  final RxDouble roadwayStartMeasure = 0.0.obs;
  final RxDouble roadwayEndMeasure = 0.0.obs;
  final RxMap<int, double> resolvedMeasuresByPoint = <int, double>{}.obs;
  final RxMap<int, int> resolvedRankByPoint = <int, int>{}.obs;
  final RxList<int> unresolvedPointIndexes = <int>[].obs;
  final RxMap<int, UnresolvedPointReason> unresolvedPointReasons =
      <int, UnresolvedPointReason>{}.obs;
  final RxList<int> orderedResolvedPointIndexes = <int>[].obs;
  final RxBool routeResolutionInProgress = false.obs;
  final RxInt routeResolutionCompleted = 0.obs;
  final RxInt routeResolutionTotal = 0.obs;
  final RxString routeResolutionStatus = ''.obs;
  final RxBool uploadInProgress = false.obs;
  final Rx<IntervalMarkingType?> activeIntervalType =
      Rx<IntervalMarkingType?>(null);
  final Rx<IntervalSelectionPhase?> activeIntervalSelectionPhase =
      Rx<IntervalSelectionPhase?>(null);
  final RxInt activeIntervalStartPointIndex = RxInt(-1);
  final RxList<_IntervalMarking> intervalMarkings = <_IntervalMarking>[].obs;
  bool mapInitialized = false;

  bool get isSelectingInterval =>
      activeIntervalType.value != null &&
      activeIntervalSelectionPhase.value != null;

  bool get canAdvanceStartEnd =>
      roadwayStartPointIndex.value != null &&
      roadwayEndPointIndex.value != null &&
      roadwayStartPointIndex.value != roadwayEndPointIndex.value;

  int get excludedPointCount => unresolvedPointIndexes.length;

  bool isUnresolvedPoint(int pointIndex) {
    return unresolvedPointIndexes.contains(pointIndex);
  }

  String get intervalSelectionInstruction {
    if (!isSelectingInterval) {
      return '';
    }

    if (activeIntervalSelectionPhase.value ==
        IntervalSelectionPhase.selectStart) {
      return 'Select the start point for this zone.';
    }
    return 'Select the end point for this zone.';
  }

  void clearIntervalSelectionPreview() {
    intervalSelectionPreviewCategories.clear();
  }

  List<WaypointCategory> effectivePointCategories(int pointIndex) {
    if (pointIndex < 0 || pointIndex >= mappableKmlPoints.length) {
      return <WaypointCategory>[];
    }

    final Set<WaypointCategory> categories =
        Set<WaypointCategory>.from(mappableKmlPoints[pointIndex].categories);

    if (intervalSelectionPreviewCategories.containsKey(pointIndex)) {
      final WaypointCategory? previewCategory =
          intervalSelectionPreviewCategories[pointIndex];
      if (previewCategory != null) {
        categories.add(previewCategory);
      }
    }

    return categories.toList()
      ..sort((left, right) => left.index.compareTo(right.index));
  }

  WaypointCategory? effectivePointCategory(int pointIndex) {
    final List<WaypointCategory> categories =
        effectivePointCategories(pointIndex);
    if (categories.isEmpty) {
      return null;
    }

    const List<WaypointCategory> priority = <WaypointCategory>[
      WaypointCategory.ignore,
      WaypointCategory.startPoint,
      WaypointCategory.endPoint,
      WaypointCategory.speedLimitMarker,
      WaypointCategory.laneClosed,
      WaypointCategory.laneOpen,
      WaypointCategory.startWorkerZone,
      WaypointCategory.endWorkerZone,
    ];

    for (final WaypointCategory category in priority) {
      if (categories.contains(category)) {
        return category;
      }
    }
    return categories.first;
  }

  void _previewIntervalSelectionCategory(int pointIndex) {
    if (!isSelectingInterval) {
      return;
    }

    final IntervalMarkingType? currentType = activeIntervalType.value;
    if (currentType == null) {
      return;
    }

    intervalSelectionPreviewCategories.clear();
    switch (currentType) {
      case IntervalMarkingType.speedLimit:
        intervalSelectionPreviewCategories[pointIndex] =
            WaypointCategory.speedLimitMarker;
        break;
      case IntervalMarkingType.workerPresence:
        intervalSelectionPreviewCategories[pointIndex] =
            WaypointCategory.startWorkerZone;
        break;
      case IntervalMarkingType.laneClosure:
        intervalSelectionPreviewCategories[pointIndex] =
            WaypointCategory.laneClosed;
        break;
    }
  }

  UnresolvedPointReason? unresolvedReasonForPoint(int pointIndex) {
    return unresolvedPointReasons[pointIndex];
  }

  bool isPointSelectableInCurrentStage(int pointIndex) {
    if (assignmentStage.value == AssignmentStage.intervalMarking &&
        isSelectingInterval) {
      return isPointSelectableForCurrentStep(pointIndex);
    }
    return true;
  }

  List<int> sortedWaypointIndexes() {
    final List<int> indexes = List<int>.generate(
      mappableKmlPoints.length,
      (index) => index,
    ).where((index) {
      return !mappableKmlPoints[index]
          .categories
          .contains(WaypointCategory.ignore);
    }).toList();

    int compareByMeasure(int left, int right, bool ascending) {
      final String? leftRouteId = mappableKmlPoints[left].gisMeasure?.routeId;
      final String? rightRouteId = mappableKmlPoints[right].gisMeasure?.routeId;

      if (leftRouteId != rightRouteId) {
        if (leftRouteId == null) {
          return 1;
        }
        if (rightRouteId == null) {
          return -1;
        }
        return ascending
            ? leftRouteId.compareTo(rightRouteId)
            : rightRouteId.compareTo(leftRouteId);
      }

      final double? leftMeasure = mappableKmlPoints[left].gisMeasure?.measure;
      final double? rightMeasure = mappableKmlPoints[right].gisMeasure?.measure;

      if (leftMeasure == null && rightMeasure == null) {
        return left.compareTo(right);
      }
      if (leftMeasure == null) {
        return 1;
      }
      if (rightMeasure == null) {
        return -1;
      }

      final int compare = ascending
          ? leftMeasure.compareTo(rightMeasure)
          : rightMeasure.compareTo(leftMeasure);
      return compare != 0 ? compare : left.compareTo(right);
    }

    switch (waypointSortOrder.value) {
      case WaypointSortOrder.gisAscending:
        indexes.sort((left, right) => compareByMeasure(left, right, true));
        break;
      case WaypointSortOrder.gisDescending:
        indexes.sort((left, right) => compareByMeasure(left, right, false));
        break;
      case WaypointSortOrder.markerNumber:
        break;
    }

    return indexes.toList();
  }

  TextEditingController speedControllerFor(int index) {
    return _speedControllers.putIfAbsent(
      index,
      () => TextEditingController(
          text: mappableKmlPoints[index].speed?.toString() ?? ''),
    );
  }

  void setSpeedForPoint(int index, String value) {
    mappableKmlPoints[index].speed = int.tryParse(value);
    mappableKmlPoints.refresh();
  }

  void clearSpeedForPoint(int index) {
    mappableKmlPoints[index].speed = null;
    final controller = _speedControllers[index];
    if (controller != null) {
      controller.text = '';
    }
    mappableKmlPoints.refresh();
  }

  String pointDisplayName(int pointIndex) {
    final String trimmed = mappableKmlPoints[pointIndex].description.trim();
    return trimmed.isEmpty ? 'Point #${pointIndex + 1}' : trimmed;
  }

  void setRoadwayStart(int pointIndex) {
    if (pointIndex < 0 || pointIndex >= mappableKmlPoints.length) {
      sendToast('Select a waypoint first.');
      return;
    }
    roadwayStartPointIndex.value = pointIndex;
  }

  void setRoadwayEnd(int pointIndex) {
    if (pointIndex < 0 || pointIndex >= mappableKmlPoints.length) {
      sendToast('Select a waypoint first.');
      return;
    }
    roadwayEndPointIndex.value = pointIndex;
  }

  Future<void> resolveRoadwayAndAdvanceToMarkingStage() async {
    if (roadwayStartPointIndex.value == null ||
        roadwayEndPointIndex.value == null) {
      sendToast('Select both roadway start and end points first.');
      return;
    }
    if (roadwayStartPointIndex.value == roadwayEndPointIndex.value) {
      sendToast('Roadway start and end points must be different.');
      return;
    }

    final int startIndex = roadwayStartPointIndex.value!;
    final int endIndex = roadwayEndPointIndex.value!;
    final MappableKmlPoint startPoint = mappableKmlPoints[startIndex];
    final MappableKmlPoint endPoint = mappableKmlPoints[endIndex];

    final List<int> candidateIndexes = List<int>.generate(
      mappableKmlPoints.length,
      (index) => index,
    ).where((i) {
      if (i == startIndex || i == endIndex) {
        return false;
      }
      return !mappableKmlPoints[i].categories.contains(WaypointCategory.ignore);
    }).toList();

    routeResolutionInProgress.value = true;
    routeResolutionTotal.value = candidateIndexes.length;
    routeResolutionCompleted.value = 0;
    routeResolutionStatus.value =
        'Resolving route and measures (0/${routeResolutionTotal.value})';
    try {
      late String routeId;
      late double startMeasure;
      late double endMeasure;

      if (startPoint.gisMeasure != null &&
          endPoint.gisMeasure != null &&
          startPoint.gisMeasure!.routeId == endPoint.gisMeasure!.routeId) {
        routeId = startPoint.gisMeasure!.routeId;
        startMeasure = startPoint.gisMeasure!.measure;
        endMeasure = endPoint.gisMeasure!.measure;
      } else {
        final matching = await WzamApi.getMatchingRouteAndMeasure(
          startPoint.point.latitude,
          startPoint.point.longitude,
          endPoint.point.latitude,
          endPoint.point.longitude,
          tolerance: 50,
        );
        if (matching == null) {
          await _showBlockingRouteErrorDialog();
          return;
        }
        routeId = matching.routeId;
        startMeasure = matching.startMeasure;
        endMeasure = matching.endMeasure;
      }

      canonicalRouteId.value = routeId;
      roadwayStartMeasure.value = startMeasure;
      roadwayEndMeasure.value = endMeasure;

      final double lowerBoundMeasure =
          startMeasure < endMeasure ? startMeasure : endMeasure;
      final double upperBoundMeasure =
          startMeasure > endMeasure ? startMeasure : endMeasure;

      final Map<int, double> resolvedMeasures = <int, double>{
        startIndex: startMeasure,
        endIndex: endMeasure,
      };
      final List<int> failedIndexes = <int>[];
      final Map<int, UnresolvedPointReason> failedReasons =
          <int, UnresolvedPointReason>{};

      bool isMeasureWithinSelectedRange(double measure) {
        return measure >= lowerBoundMeasure && measure <= upperBoundMeasure;
      }

      void markPointResolvedProgress() {
        routeResolutionCompleted.value += 1;
        routeResolutionStatus.value =
            'Resolving route and measures (${routeResolutionCompleted.value}/${routeResolutionTotal.value})';
      }

      for (final int i in candidateIndexes) {
        final MappableKmlPoint point = mappableKmlPoints[i];

        if (point.gisMeasure != null && point.gisMeasure!.routeId == routeId) {
          if (isMeasureWithinSelectedRange(point.gisMeasure!.measure)) {
            resolvedMeasures[i] = point.gisMeasure!.measure;
          } else {
            failedIndexes.add(i);
            failedReasons[i] = UnresolvedPointReason.outsideSelectedRange;
          }
          markPointResolvedProgress();
          continue;
        }

        final translated = await WzamApi.getExpectedRouteAndMeasure(
          point.point.latitude,
          point.point.longitude,
          routeId,
          tolerance: 50,
        );
        if (translated != null) {
          if (isMeasureWithinSelectedRange(translated.measure)) {
            resolvedMeasures[i] = translated.measure;
          } else {
            failedIndexes.add(i);
            failedReasons[i] = UnresolvedPointReason.outsideSelectedRange;
          }
        } else {
          failedIndexes.add(i);
          failedReasons[i] = UnresolvedPointReason.notOnSelectedRoadway;
        }
        markPointResolvedProgress();
      }

      resolvedMeasuresByPoint.value = resolvedMeasures;
      unresolvedPointIndexes.value = failedIndexes;
      unresolvedPointReasons.value = failedReasons;
      _rebuildResolvedOrderAndRank();
      if (failedIndexes.isNotEmpty) {
        await _showExcludedPointsDialog();
        _applyExcludedPoints();
      }

      _resetIntervalsAndPointMarkings();
      assignmentStage.value = AssignmentStage.intervalMarking;
      if (failedIndexes.isNotEmpty) {
        sendToast(
            'Route locked. Excluded ${failedIndexes.length} point(s). Select interval markings.');
      } else {
        sendToast('Route locked. Select interval markings.');
      }
    } finally {
      routeResolutionInProgress.value = false;
      routeResolutionStatus.value = '';
      routeResolutionCompleted.value = 0;
      routeResolutionTotal.value = 0;
      mappableKmlPoints.refresh();
    }
  }

  void returnToStartEndSelection() {
    assignmentStage.value = AssignmentStage.startEndSelection;
    selectedWaypointIndex.value = -1;
    selectedRouteId.value = -1;
    clearIntervalSelectionPreview();
    unresolvedPointIndexes.clear();
    unresolvedPointReasons.clear();
    resolvedMeasuresByPoint.clear();
    resolvedRankByPoint.clear();
    orderedResolvedPointIndexes.clear();
    canonicalRouteId.value = '';
    roadwayStartMeasure.value = 0.0;
    roadwayEndMeasure.value = 0.0;
    _resetIntervalsAndPointMarkings();
    sendToast('Returned to roadway start/end selection.');
  }

  void _applyExcludedPoints() {
    for (final int pointIndex in unresolvedPointIndexes) {
      final MappableKmlPoint failedPoint = mappableKmlPoints[pointIndex];
      failedPoint.categories
        ..clear()
        ..add(WaypointCategory.ignore);
      failedPoint.speed = null;
      failedPoint.lanesAffected.clear();
    }
    unresolvedPointIndexes.clear();
    unresolvedPointReasons.clear();
    selectedWaypointIndex.value = -1;
    mappableKmlPoints.refresh();
  }

  Map<String, List<int>> unresolvedPointsGroupedByRoute() {
    final Map<String, List<int>> grouped = <String, List<int>>{};
    for (final int index in unresolvedPointIndexes) {
      final String routeId =
          mappableKmlPoints[index].gisMeasure?.routeId.trim().isNotEmpty == true
              ? mappableKmlPoints[index].gisMeasure!.routeId
              : 'No GIS route';
      grouped.putIfAbsent(routeId, () => <int>[]).add(index);
    }
    return grouped;
  }

  String unresolvedReasonLabel(int pointIndex) {
    return unresolvedReasonForPoint(pointIndex)?.label ??
        'Not on selected roadway';
  }

  Future<void> _showExcludedPointsDialog() async {
    final Map<String, List<int>> grouped = unresolvedPointsGroupedByRoute();
    final List<String> routeIds = grouped.keys.toList()..sort();
    await Get.dialog<void>(
      AlertDialog(
        title: Text('Excluded Points (${unresolvedPointIndexes.length})'),
        content: SizedBox(
          width: 420,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 380),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'These points will be excluded because they are off the selected roadway or outside the selected start/end range.',
                  ),
                  const SizedBox(height: 10),
                  for (final String routeId in routeIds) ...[
                    Text(
                      'Route: $routeId (${grouped[routeId]!.length})',
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 4),
                    ...grouped[routeId]!.map((pointIndex) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Text(
                          '${pointDisplayName(pointIndex)} (${unresolvedReasonLabel(pointIndex)})',
                          style: const TextStyle(fontSize: 13),
                        ),
                      );
                    }),
                    const SizedBox(height: 8),
                  ],
                ],
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Continue'),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  void _rebuildResolvedOrderAndRank() {
    final List<MapEntry<int, double>> entries =
        resolvedMeasuresByPoint.entries.toList();
    entries.sort((left, right) => left.value.compareTo(right.value));

    if (roadwayStartMeasure.value > roadwayEndMeasure.value) {
      entries.replaceRange(0, entries.length, entries.reversed);
    }

    orderedResolvedPointIndexes.value = entries.map((e) => e.key).toList();
    resolvedRankByPoint.clear();
    for (int i = 0; i < orderedResolvedPointIndexes.length; i++) {
      resolvedRankByPoint[orderedResolvedPointIndexes[i]] = i;
    }
  }

  void _resetIntervalsAndPointMarkings() {
    intervalMarkings.clear();
    activeIntervalType.value = null;
    clearIntervalSelectionPreview();
    activeIntervalSelectionPhase.value = null;
    activeIntervalStartPointIndex.value = -1;

    for (int i = 0; i < mappableKmlPoints.length; i++) {
      final point = mappableKmlPoints[i];
      if (point.categories.contains(WaypointCategory.ignore)) {
        continue;
      }
      point.categories.clear();
      point.speed = null;
      point.lanesAffected.clear();
    }

    if (roadwayStartPointIndex.value != null) {
      mappableKmlPoints[roadwayStartPointIndex.value!]
          .categories
          .add(WaypointCategory.startPoint);
    }
    if (roadwayEndPointIndex.value != null) {
      mappableKmlPoints[roadwayEndPointIndex.value!]
          .categories
          .add(WaypointCategory.endPoint);
    }
    mappableKmlPoints.refresh();
  }

  void startIntervalSelection(IntervalMarkingType type) {
    if (assignmentStage.value != AssignmentStage.intervalMarking) {
      sendToast('Resolve roadway first.');
      return;
    }
    activeIntervalType.value = type;
    activeIntervalSelectionPhase.value = IntervalSelectionPhase.selectStart;
    activeIntervalStartPointIndex.value = -1;
    clearIntervalSelectionPreview();
    sendToast(
      intervalSelectionInstruction.isNotEmpty
          ? intervalSelectionInstruction
          : 'Select ${type.label} start point.',
    );
  }

  void cancelIntervalSelection() {
    activeIntervalType.value = null;
    activeIntervalSelectionPhase.value = null;
    activeIntervalStartPointIndex.value = -1;
    clearIntervalSelectionPreview();
  }

  bool isPointSelectableForCurrentStep(int pointIndex) {
    if (assignmentStage.value != AssignmentStage.intervalMarking ||
        !isSelectingInterval) {
      return true;
    }
    if (!resolvedRankByPoint.containsKey(pointIndex)) {
      return false;
    }
    if (unresolvedPointIndexes.contains(pointIndex)) {
      return false;
    }

    final IntervalMarkingType currentType = activeIntervalType.value!;
    final IntervalSelectionPhase phase = activeIntervalSelectionPhase.value!;
    final int rank = resolvedRankByPoint[pointIndex]!;

    if (phase == IntervalSelectionPhase.selectStart) {
      if (pointIndex == roadwayStartPointIndex.value ||
          pointIndex == roadwayEndPointIndex.value) {
        return false;
      }
      for (final interval
          in intervalMarkings.where((e) => e.type == currentType)) {
        final int? startRank = resolvedRankByPoint[interval.startPointIndex];
        final int? endRank = resolvedRankByPoint[interval.endPointIndex];
        if (startRank == null || endRank == null) {
          continue;
        }
        final int low = startRank < endRank ? startRank : endRank;
        final int high = startRank > endRank ? startRank : endRank;
        if (rank > low && rank < high) {
          return false;
        }
      }
      return true;
    }

    final int startPointIndex = activeIntervalStartPointIndex.value;
    if (startPointIndex < 0 ||
        !resolvedRankByPoint.containsKey(startPointIndex)) {
      return false;
    }
    if (pointIndex == startPointIndex) {
      return false;
    }
    final int startRank = resolvedRankByPoint[startPointIndex]!;
    if (rank <= startRank) {
      return false;
    }

    for (final interval
        in intervalMarkings.where((e) => e.type == currentType)) {
      final int? intervalStart = resolvedRankByPoint[interval.startPointIndex];
      final int? intervalEnd = resolvedRankByPoint[interval.endPointIndex];
      if (intervalStart == null || intervalEnd == null) {
        continue;
      }
      final int low = intervalStart < intervalEnd ? intervalStart : intervalEnd;
      final int high =
          intervalStart > intervalEnd ? intervalStart : intervalEnd;
      if (startRank < high && rank > low) {
        return false;
      }
    }
    return true;
  }

  Future<void> _handleIntervalPointSelection(int pointIndex) async {
    if (!isPointSelectableForCurrentStep(pointIndex)) {
      sendToast('That point is unavailable for this selection step.');
      return;
    }

    final IntervalSelectionPhase phase = activeIntervalSelectionPhase.value!;
    if (phase == IntervalSelectionPhase.selectStart) {
      activeIntervalStartPointIndex.value = pointIndex;
      activeIntervalSelectionPhase.value = IntervalSelectionPhase.selectEnd;
      _previewIntervalSelectionCategory(pointIndex);
      sendToast(intervalSelectionInstruction.isNotEmpty
          ? intervalSelectionInstruction
          : 'Now select the interval end point.');
      return;
    }

    await _finalizeIntervalSelection(pointIndex);
  }

  Future<void> _finalizeIntervalSelection(int endPointIndex) async {
    final IntervalMarkingType type = activeIntervalType.value!;
    final int startPointIndex = activeIntervalStartPointIndex.value;
    if (startPointIndex < 0) {
      sendToast('Select a start point first.');
      return;
    }

    int? speedMph;
    List<int> lanes = <int>[];

    if (type == IntervalMarkingType.speedLimit) {
      speedMph = await _showSpeedSelectionDialog();
      if (speedMph == null) {
        return;
      }
    } else if (type == IntervalMarkingType.laneClosure) {
      final selectedLanes = await _showLaneSelectionDialog();
      if (selectedLanes == null || selectedLanes.isEmpty) {
        sendToast('Select at least one lane.');
        return;
      }
      lanes = selectedLanes;
    }

    final interval = _IntervalMarking(
      type: type,
      startPointIndex: startPointIndex,
      endPointIndex: endPointIndex,
      speedMph: speedMph,
      lanes: lanes,
    );
    intervalMarkings.add(interval);
    _applyIntervalDisplayState(interval);
    cancelIntervalSelection();
  }

  void deleteIntervalAt(int intervalIndex) {
    if (intervalIndex < 0 || intervalIndex >= intervalMarkings.length) {
      return;
    }
    intervalMarkings.removeAt(intervalIndex);
    _rebuildIntervalDisplayStateFromMarkings();
    sendToast('Zone removed.');
  }

  void _rebuildIntervalDisplayStateFromMarkings() {
    for (int i = 0; i < mappableKmlPoints.length; i++) {
      final point = mappableKmlPoints[i];
      if (point.categories.contains(WaypointCategory.ignore)) {
        continue;
      }
      point.categories.clear();
      point.speed = null;
      point.lanesAffected.clear();
    }

    if (roadwayStartPointIndex.value != null) {
      mappableKmlPoints[roadwayStartPointIndex.value!]
          .categories
          .add(WaypointCategory.startPoint);
    }
    if (roadwayEndPointIndex.value != null) {
      mappableKmlPoints[roadwayEndPointIndex.value!]
          .categories
          .add(WaypointCategory.endPoint);
    }

    for (final interval in intervalMarkings) {
      _applyIntervalDisplayState(interval, refresh: false);
    }
    mappableKmlPoints.refresh();
  }

  void _applyIntervalDisplayState(_IntervalMarking interval,
      {bool refresh = true}) {
    final start = mappableKmlPoints[interval.startPointIndex];
    final end = mappableKmlPoints[interval.endPointIndex];

    switch (interval.type) {
      case IntervalMarkingType.speedLimit:
        start.categories.add(WaypointCategory.speedLimitMarker);
        end.categories.add(WaypointCategory.speedLimitMarker);
        start.speed = interval.speedMph;
        end.speed = speedLimit;
        break;
      case IntervalMarkingType.workerPresence:
        start.categories.add(WaypointCategory.startWorkerZone);
        end.categories.add(WaypointCategory.endWorkerZone);
        break;
      case IntervalMarkingType.laneClosure:
        start.categories.add(WaypointCategory.laneClosed);
        end.categories.add(WaypointCategory.laneOpen);
        start.lanesAffected.value = interval.lanes;
        end.lanesAffected.value = interval.lanes;
        break;
    }
    if (refresh) {
      mappableKmlPoints.refresh();
    }
  }

  String intervalTypeSummary(_IntervalMarking interval) {
    switch (interval.type) {
      case IntervalMarkingType.speedLimit:
        return 'Speed Zone';
      case IntervalMarkingType.workerPresence:
        return 'Worker Presence Zone';
      case IntervalMarkingType.laneClosure:
        return 'Lane Closure Zone';
    }
  }

  String intervalPropertySummary(_IntervalMarking interval) {
    switch (interval.type) {
      case IntervalMarkingType.speedLimit:
        return interval.speedMph == null
            ? 'Speed: unset'
            : 'Speed: ${interval.speedMph} mph';
      case IntervalMarkingType.workerPresence:
        return 'Workers Present';
      case IntervalMarkingType.laneClosure:
        if (interval.lanes.isEmpty) {
          return 'Lanes: none';
        }
        final List<int> sortedLanes = [...interval.lanes]..sort();
        return 'Lanes Closed: ${sortedLanes.join(', ')}';
    }
  }

  String intervalMilepostRangeSummary(_IntervalMarking interval) {
    final double? startMeasure =
        resolvedMeasuresByPoint[interval.startPointIndex];
    final double? endMeasure = resolvedMeasuresByPoint[interval.endPointIndex];
    if (startMeasure == null || endMeasure == null) {
      return 'MP range unavailable';
    }

    final double low = startMeasure < endMeasure ? startMeasure : endMeasure;
    final double high = startMeasure > endMeasure ? startMeasure : endMeasure;
    return 'MP ${low.toStringAsFixed(1)} - ${high.toStringAsFixed(1)}';
  }

  Future<int?> _showSpeedSelectionDialog() async {
    final speedController = TextEditingController(text: '$speedLimit');
    final int? speed = await Get.dialog<int>(
      AlertDialog(
        title: const Text('Speed Zone Value'),
        content: TextField(
          controller: speedController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: 'Speed (MPH)'),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: null),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () =>
                Get.back(result: int.tryParse(speedController.text)),
            child: const Text('Apply'),
          ),
        ],
      ),
      barrierDismissible: false,
    );
    return speed;
  }

  Future<List<int>?> _showLaneSelectionDialog() async {
    final RxList<int> selectedLanes = <int>[].obs;
    return await Get.dialog<List<int>>(
      AlertDialog(
        title: const Text('Lane Closure Lanes'),
        content: SizedBox(
          width: 240,
          child: Obx(
            () => Wrap(
              spacing: 8,
              runSpacing: 8,
              children: List.generate(numLanes, (i) {
                final laneNumber = i + 1;
                final bool selected = selectedLanes.contains(laneNumber);
                return FilterChip(
                  label: Text('Lane $laneNumber'),
                  selected: selected,
                  onSelected: (value) {
                    if (value) {
                      selectedLanes.add(laneNumber);
                    } else {
                      selectedLanes.remove(laneNumber);
                    }
                  },
                );
              }),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: null),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Get.back(result: selectedLanes.toList()..sort()),
            child: const Text('Apply'),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  void handleMapTap() {
    selectedWaypointIndex.value = -1;
    selectedRouteId.value = -1;
  }

  Future<void> createGisPoints(
      List<Wpt> waypoints, List<Rte> routes, List<Trk> tracks) async {
    gisPointsLoading.value = true;
    gisPointsTotal.value = waypoints.length;
    gisPointsCompleted.value = 0;
    gisPointsStatus.value = 'Generated 0/${waypoints.length} points';

    try {
      mappableKmlPoints.clear();
      for (final controller in _speedControllers.values) {
        controller.dispose();
      }
      _speedControllers.clear();

      final List<MappableKmlPoint> generatedPoints = await Future.wait(
        waypoints.map((wpt) async {
          final MappableKmlPoint mappablePoint =
              MappableKmlPoint.fromWaypoint(wpt);
          await mappablePoint.initializeGisMeasure();
          gisPointsCompleted.value += 1;
          gisPointsStatus.value =
              'Generated ${gisPointsCompleted.value}/${gisPointsTotal.value} points';
          return mappablePoint;
        }),
      );

      mappableKmlPoints.addAll(generatedPoints);
    } finally {
      gisPointsLoading.value = false;
    }
  }

  @override
  void onClose() {
    for (final controller in _speedControllers.values) {
      controller.dispose();
    }
    _speedControllers.clear();
    super.onClose();
  }

  Future<void> initializeKmlPoints(
      List<Wpt> waypoints, List<Rte> routes, List<Trk> tracks) async {
    await createGisPoints(waypoints, routes, tracks);
  }

  void fitMap() {
    if (mappableKmlPoints.isEmpty) return;
    final latitudes = mappableKmlPoints.map((pt) => pt.point.latitude);
    final longitudes = mappableKmlPoints.map((pt) => pt.point.longitude);
    final southWest = LatLng(latitudes.reduce((a, b) => a < b ? a : b),
        longitudes.reduce((a, b) => a < b ? a : b));
    final northEast = LatLng(latitudes.reduce((a, b) => a > b ? a : b),
        longitudes.reduce((a, b) => a > b ? a : b));
    final bounds = LatLngBounds(southWest, northEast);
    CameraFit cameraFit = CameraFit.bounds(
        bounds: bounds,
        padding: const EdgeInsets.only(
            left: 200.0, top: 60.0, right: 60.0, bottom: 60.0));
    mapController?.fitCamera(cameraFit);
  }

  String? markerMilepostText(MappableKmlPoint pt) {
    return pt.gisMeasure?.measure != null
        ? 'MP ${pt.gisMeasure!.measure.toStringAsFixed(2)}'
        : null;
  }

  Widget markerLabelWidget(MappableKmlPoint pt, {double maxWidth = 170}) {
    final String description = pt.description.trim();
    final String? milepost = markerMilepostText(pt);

    final List<Widget> labelLines = [];
    if (description.isNotEmpty) {
      labelLines.add(
        Text(
          description,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      );
    }
    if (showMilepostsInLabels.value && milepost != null) {
      labelLines.add(
        Text(
          milepost,
          maxLines: 1,
          overflow: TextOverflow.visible,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
      );
    }

    return IgnorePointer(
      child: Container(
        constraints: BoxConstraints(maxWidth: maxWidth),
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 2,
        ),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: labelLines,
        ),
      ),
    );
  }

  MarkerLayer getMarkerLayer() {
    List<Marker> markers = [];
    final bool showLabelsForZoom =
        currentZoom.value >= _kMarkerLabelZoomThreshold;
    Marker? selectedMarkerLayer;
    for (int i = 0; i < mappableKmlPoints.length; i++) {
      MappableKmlPoint pt = mappableKmlPoints[i];
      if (pt.gisMeasure != null) {
        final category = effectivePointCategory(i);
        if (category == WaypointCategory.ignore) {
          continue;
        }
        Widget? image = category != null ? _kCategoryImages[category] : null;
        if (category != null) {
          image = _kCategoryImages[category];
        } else if (i == roadwayStartPointIndex.value) {
          image = _kCategoryImages[WaypointCategory.startPoint];
        } else if (i == roadwayEndPointIndex.value) {
          image = _kCategoryImages[WaypointCategory.endPoint];
        }
        final bool selectable = isPointSelectableInCurrentStage(i);
        if (selectedWaypointIndex.value == i) {
          selectedMarkerLayer = selectedMarker(
            pt,
            index: i,
            image: image,
            selectable: selectable,
          );
        } else {
          final marker = Marker(
            rotate: true,
            width: 180,
            height: _kMapMarkerSize,
            point: pt.point,
            child: SizedBox(
              width: 180,
              height: _kMapMarkerSize,
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.topCenter,
                children: [
                  Opacity(
                    opacity: selectable ? 1.0 : 0.25,
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: selectable
                          ? () {
                              pointTap(i);
                            }
                          : null,
                      child: SizedBox(
                        width: _kMapMarkerSize,
                        height: _kMapMarkerSize,
                        child: image != null
                            ? Stack(
                                clipBehavior: Clip.none,
                                alignment: Alignment.center,
                                children: [
                                  image,
                                  if (category ==
                                      WaypointCategory.speedLimitMarker)
                                    Positioned(
                                      top: 11,
                                      child: Text(
                                        '${pt.speed ?? "-"}',
                                        style: const TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                ],
                              )
                            : const Icon(Icons.circle),
                      ),
                    ),
                  ),
                  if (showLabelsForZoom &&
                      (pt.description.trim().isNotEmpty ||
                          (showMilepostsInLabels.value &&
                              pt.gisMeasure?.measure != null)))
                    Positioned(
                      top: _kMapMarkerSize + 4,
                      child: markerLabelWidget(pt),
                    ),
                ],
              ),
            ),
          );
          markers.add(marker);
        }
      }
    }
    // Include selected marker later to ensure it is displayed on top
    if (selectedMarkerLayer != null) {
      markers.add(selectedMarkerLayer);
    }
    return MarkerLayer(markers: markers);
  }

  Marker selectedMarker(MappableKmlPoint pt,
      {int index = -1, Widget? image, bool selectable = true}) {
    final String title = pointDisplayName(index);
    final String routeText = pt.gisMeasure == null
        ? 'No GIS route'
        : '${pt.gisMeasure!.routeId} @ ${pt.gisMeasure!.measure.toStringAsFixed(2)}';
    final WaypointCategory? category = effectivePointCategory(index);
    return Marker(
      point: pt.point,
      height: 230,
      width: 240,
      alignment: Alignment.bottomCenter,
      child: Transform.translate(
        offset: const Offset(0, -25),
        child: Column(children: [
          SizedBox(
            width: _kMapMarkerSize,
            height: _kMapMarkerSize + 14,
            child: image != null
                ? Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.center,
                    children: [
                      image,
                      if (category == WaypointCategory.speedLimitMarker)
                        Positioned(
                          top: 11,
                          child: Text(
                            '${pt.speed ?? "-"}',
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                    ],
                  )
                : const Icon(Icons.circle),
          ),
          ClipPath(
            clipper: TriangleClipper(),
            child: Container(
              width: 20,
              height: 12,
              color: Colors.white,
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
            ),
            width: 240,
            height: 100,
            child: Obx(() => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                          )),
                      const SizedBox(height: 4),
                      Text(routeText,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: textPrimaryColor)),
                      const SizedBox(height: 8),
                      if (assignmentStage.value ==
                          AssignmentStage.startEndSelection)
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () {
                                  setRoadwayStart(index);
                                },
                                child: const Text('Set Start'),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () {
                                  setRoadwayEnd(index);
                                },
                                child: const Text('Set End'),
                              ),
                            ),
                          ],
                        )
                      else if (isSelectingInterval)
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: selectable
                                ? () => _handleIntervalPointSelection(index)
                                : null,
                            child: Text(
                              activeIntervalSelectionPhase.value ==
                                      IntervalSelectionPhase.selectStart
                                  ? 'Use as Start'
                                  : 'Use as End',
                            ),
                          ),
                        )
                      else
                        Text(
                          effectivePointCategory(index)?.label ??
                              'Available for interval selection',
                          style: TextStyle(color: textPrimaryColor),
                        ),
                    ],
                  ),
                )),
          )
        ]),
      ),
    );
  }

  void createMapWidgets(
      List<Wpt> waypoints, List<Rte> routes, List<Trk> tracks) {
    List<Marker> newMarkers = [];
    List<Polyline> newPolylines = [];
    for (var i = 0; i < waypoints.length; i++) {
      var wpt = waypoints[i];
      final category = waypointCategories[i];
      final image = category != null ? _kCategoryImages[category] : null;
      Marker marker = Marker(
        point: LatLng(wpt.lat ?? 0.0, wpt.lon ?? 0.0),
        child: image != null
            ? GestureDetector(
                onTap: () {
                  pointTap(i);
                  createMapWidgets(waypoints, routes, tracks);
                },
                child: image)
            : IconButton(
                icon: const Icon(Icons.location_on),
                color: selectedWaypointIndex.value == i
                    ? Colors.green
                    : Colors.blue,
                iconSize: 30,
                onPressed: () {
                  selectedRouteId.value = -1;
                  selectedWaypointIndex.value = i;
                  createMapWidgets(waypoints, routes, tracks);
                },
              ),
      );
      newMarkers.add(marker);
    }
    for (var rte in routes) {
      List<LatLng> points = [];
      for (var pt in rte.rtepts) {
        points.add(LatLng(pt.lat ?? 0.0, pt.lon ?? 0.0));
      }
      Polyline polyline = Polyline(
        points: points,
        strokeWidth: 4.0,
        color: selectedRouteId.value == routes.indexOf(rte)
            ? Colors.green
            : Colors.blue,
      );
      newPolylines.add(polyline);
    }

    markerLayer.value = MarkerLayer(markers: newMarkers);
    polylineLayer.value = PolylineLayer(polylines: newPolylines);
  }

  Future<void> uploadRecording() async {
    if (uploadInProgress.value) {
      return;
    }

    uploadInProgress.value = true;
    try {
      final List<RecordingPoint>? recordingPoints =
          await createRecordingPoints();
      if (recordingPoints == null || recordingPoints.isEmpty) {
        return;
      }
      Recording recordingNew = recording.copyWith(
          points: recordingPoints,
          recordingEndTimestamp: DateTime.now(),
          sourceType: RecordingSourceType.kmlUpload);
      final bool success = await postRecording(recordingNew);
      if (success) {
        Get.offAll(() => const Dashboard());
      }
    } finally {
      uploadInProgress.value = false;
    }
  }

  Future<bool> postRecording(Recording recording) async {
    final createdRecording = await WzamApi.createRecording(recording,
        onErrorNotification: NotificationModel.simple("Recording Upload Failed",
            'The recording was not posted to the server. It has been saved locally'));
    if (createdRecording != null) {
      sendToast('Recording posted successfully.');
      return true;
    }
    return false;
  }

  Future<void> _showBlockingRouteErrorDialog() async {
    await Get.dialog<void>(
      AlertDialog(
        title: const Text('Road Event Cannot Be Generated'),
        content: const Text(
          'The start and end points are not on the same route. A road event cannot be generated.',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('OK'),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  List<Lane>? _initializeLanes(int maxLanes) {
    return List.generate(
      maxLanes,
      (idx) => Lane(
          laneOrder: idx,
          type: LaneType.general,
          status: LaneStatus.open,
          restrictions: []),
    );
  }

  List<Lane>? convertLaneNumToLanes(
      List<int> affectedLanes, LaneStatus status) {
    List<Lane> lanes = [];
    for (var lane in affectedLanes) {
      lanes.add(Lane(
        laneOrder: lane,
        type: LaneType.general,
        status: status,
        restrictions: [],
      ));
    }
    return lanes;
  }

  void selectPointFromMarker(int index, {bool shouldCenter = false}) {
    if (assignmentStage.value == AssignmentStage.intervalMarking &&
        isSelectingInterval) {
      _handleIntervalPointSelection(index);
      if (shouldCenter && mapController != null) {
        mapController!.move(mappableKmlPoints[index].point, currentZoom.value);
      }
      return;
    }

    selectedRouteId.value = -1;
    selectedWaypointIndex.value = index;
    if (shouldCenter && mapController != null) {
      mapController!.move(mappableKmlPoints[index].point, currentZoom.value);
    }
  }

  void pointTap(int index, {bool shouldCenter = false}) {
    selectPointFromMarker(index, shouldCenter: shouldCenter);
  }

  bool checkIfValid() {
    if (mappableKmlPoints.isEmpty) {
      sendToast("No KML points available.");
      return false;
    }
    if (assignmentStage.value != AssignmentStage.intervalMarking) {
      sendToast('Resolve roadway route before publishing.');
      return false;
    }
    if (roadwayStartPointIndex.value == null ||
        roadwayEndPointIndex.value == null) {
      sendToast('Roadway start/end points are required.');
      return false;
    }
    if (canonicalRouteId.value.isEmpty || orderedResolvedPointIndexes.isEmpty) {
      sendToast('Roadway route has not been resolved.');
      return false;
    }
    for (final interval in intervalMarkings) {
      if (interval.type == IntervalMarkingType.speedLimit &&
          interval.speedMph == null) {
        sendToast('Each speed zone must have a speed value.');
        return false;
      }
      if (interval.type == IntervalMarkingType.laneClosure &&
          interval.lanes.isEmpty) {
        sendToast('Each lane closure zone must include lanes.');
        return false;
      }
    }
    return true;
  }

  _RecordingMarkingDraft _draftForIndex(
      Map<int, _RecordingMarkingDraft> drafts, int pointIndex) {
    final existing = drafts[pointIndex];
    if (existing != null) {
      return existing;
    }
    final created = _RecordingMarkingDraft();
    drafts[pointIndex] = created;
    return created;
  }

  List<Lane>? _openLanesForInterval(List<int> lanes) {
    return convertLaneNumToLanes(lanes, LaneStatus.open);
  }

  List<Lane>? _closedLanesForInterval(List<int> lanes) {
    return convertLaneNumToLanes(lanes, LaneStatus.closed);
  }

  Future<List<RecordingPoint>?> createRecordingPoints() async {
    if (!checkIfValid()) {
      return null;
    }

    final int startIndex = roadwayStartPointIndex.value!;
    final int endIndex = roadwayEndPointIndex.value!;
    final Map<int, _RecordingMarkingDraft> drafts =
        <int, _RecordingMarkingDraft>{};

    final _RecordingMarkingDraft startDraft =
        _draftForIndex(drafts, startIndex);
    startDraft.refPt = true;
    startDraft.lanes = _initializeLanes(numLanes);
    startDraft.speedLimitMph = speedLimit;

    final _RecordingMarkingDraft endDraft = _draftForIndex(drafts, endIndex);
    endDraft.refPt = false;

    for (final interval in intervalMarkings) {
      final _RecordingMarkingDraft intervalStartDraft =
          _draftForIndex(drafts, interval.startPointIndex);
      final _RecordingMarkingDraft intervalEndDraft =
          _draftForIndex(drafts, interval.endPointIndex);

      switch (interval.type) {
        case IntervalMarkingType.speedLimit:
          intervalStartDraft.speedLimitMph = interval.speedMph;
          intervalEndDraft.speedLimitMph = speedLimit;
          break;
        case IntervalMarkingType.workerPresence:
          intervalStartDraft.workersPresent = true;
          intervalEndDraft.workersPresent = false;
          break;
        case IntervalMarkingType.laneClosure:
          intervalStartDraft.lanes = _closedLanesForInterval(interval.lanes);
          intervalEndDraft.lanes = _openLanesForInterval(interval.lanes);
          break;
      }
    }

    final List<RecordingPoint> recordingPoints = <RecordingPoint>[];
    for (final pointIndex in orderedResolvedPointIndexes) {
      final draft = drafts[pointIndex];
      if (draft == null || !draft.hasMarking) {
        continue;
      }
      final point = mappableKmlPoints[pointIndex].point;
      recordingPoints.add(
        RecordingPoint(
          timestamp: DateTime.now().toUtc().millisecondsSinceEpoch,
          numSatellites: 0,
          accuracy: 0,
          latitude: point.latitude,
          longitude: point.longitude,
          altitude: 0,
          speed: 0,
          heading: 0,
          marking: draft.toRecordingMarking(),
        ),
      );
    }

    return recordingPoints;
  }

  sendToast(String message) {
    try {
      Fluttertoast.showToast(
          msg: message,
          toastLength: Toast.LENGTH_SHORT,
          timeInSecForIosWeb: 4,
          webBgColor: "#FFFFFF",
          webPosition: "right",
          textColor: Colors.black,
          fontSize: 24.0)
        ..catchError((_) {
          return false;
        });
    } catch (_) {}
  }
}

class AssignKmlDialog extends StatelessWidget
    with AssignKmlStartEndStage, AssignKmlZoneMarkingStage {
  AssignKmlDialog(
      {super.key,
      required this.waypoints,
      required this.routes,
      required this.tracks,
      required this.recording,
      required this.numLanes,
      required this.speedLimit});

  final List<Wpt> waypoints;
  final List<Rte> routes;
  final List<Trk> tracks;
  final Recording recording;
  final int numLanes;
  final int speedLimit;
  final mapController = MapController();
  final ScrollController _waypointListScrollController = ScrollController();
  final Map<int, GlobalKey> _waypointItemKeys = <int, GlobalKey>{};
  final RxInt _lastScrolledWaypointIndex = (-1).obs;

  final KmlController controller = Get.put(KmlController());

  Future<bool> _confirmExitAndLoseProgress() async {
    final bool? shouldExit = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Exit KML Assignment?'),
        content: const Text(
          'If you exit now, your KML assignment progress will be lost.',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: const Text('Exit and Lose Progress'),
          ),
        ],
      ),
      barrierDismissible: false,
    );
    return shouldExit == true;
  }

  Future<void> _cancelAndExit() async {
    final bool shouldExit = await _confirmExitAndLoseProgress();
    if (shouldExit && Get.isDialogOpen == true) {
      Get.offAll(() => const Dashboard());
    }
  }

  Widget _withExitGuard(Widget child) {
    return WillPopScope(
      onWillPop: _confirmExitAndLoseProgress,
      child: child,
    );
  }

  void _scrollSelectedWaypointIntoView(KmlController controller) {
    final int selectedIndex = controller.selectedWaypointIndex.value;
    if (selectedIndex < 0 ||
        selectedIndex == _lastScrolledWaypointIndex.value) {
      return;
    }

    final List<int> sortedIndexes = controller.sortedWaypointIndexes();
    if (!sortedIndexes.contains(selectedIndex)) {
      return;
    }

    final GlobalKey? waypointKey = _waypointItemKeys[selectedIndex];
    final BuildContext? context = waypointKey?.currentContext;
    if (context == null) {
      return;
    }

    _lastScrolledWaypointIndex.value = selectedIndex;
    Scrollable.ensureVisible(
      context,
      alignment: 0.1,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    controller.waypoints = waypoints;
    controller.routes = routes;
    controller.tracks = tracks;
    controller.recording = recording;
    controller.numLanes = numLanes;
    controller.speedLimit = speedLimit;
    return Theme(
      data: lightTheme,
      child: FutureBuilder(
          future: controller.initializeKmlPoints(waypoints, routes, tracks),
          builder: (context, asyncSnapshot) {
            if (asyncSnapshot.connectionState != ConnectionState.done) {
              return _withExitGuard(Dialog(
                insetPadding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 320),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Obx(
                      () => Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const CircularProgressIndicator(),
                          verticalSpaceMedium,
                          Text(
                            controller.gisPointsStatus.value.isEmpty
                                ? 'Preparing GIS points...'
                                : controller.gisPointsStatus.value,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: textPrimaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 12),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: LinearProgressIndicator(
                              minHeight: 8,
                              value: controller.gisPointsTotal.value == 0
                                  ? null
                                  : controller.gisPointsCompleted.value /
                                      controller.gisPointsTotal.value,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ));
            }
            return _withExitGuard(Dialog(
              child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: screenHeight(context) * 0.7,
                      ),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          double panelWidth = constraints.maxWidth * 0.26;
                          if (panelWidth < 220) {
                            panelWidth = 220;
                          } else if (panelWidth > 360) {
                            panelWidth = 360;
                          }

                          final double rightRegionLeft = panelWidth + 20;
                          double rightRegionWidth =
                              constraints.maxWidth - rightRegionLeft - 16;
                          if (rightRegionWidth < 180) {
                            rightRegionWidth = 180;
                          }

                          final double actionBarWidth =
                              rightRegionWidth < 430 ? rightRegionWidth : 430;
                          final double summaryWidth =
                              rightRegionWidth < 360 ? rightRegionWidth : 360;

                          return Stack(children: [
                            _map(context, controller, mapController),
                            Positioned(
                              top: 0,
                              left: 0,
                              child: _stageLeftPanel(controller, panelWidth),
                            ),
                            _stageTopRightPanel(
                              controller,
                              rightRegionLeft: rightRegionLeft,
                              actionBarWidth: actionBarWidth,
                            ),
                            _stageBottomRightPanel(
                              controller,
                              rightRegionLeft: rightRegionLeft,
                              summaryWidth: summaryWidth,
                            ),
                            Positioned(
                              bottom: 20,
                              right: 20,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ElevatedButton(
                                    onPressed: () async {
                                      await _cancelAndExit();
                                    },
                                    child: const Text('Cancel and Exit'),
                                  ),
                                  const SizedBox(width: 12),
                                  _primaryStageActionButton(controller),
                                ],
                              ),
                            ),
                            _routeResolutionOverlay(controller),
                            _uploadOverlay(controller),
                          ]);
                        },
                      ))),
            ));
          }),
    );
  }

  Widget _stageLeftPanel(KmlController controller, double panelWidth) {
    return pointList(panelWidth);
  }

  Widget _routeResolutionOverlay(KmlController controller) {
    return Obx(() {
      if (!controller.routeResolutionInProgress.value) {
        return const SizedBox.shrink();
      }

      return Positioned.fill(
        child: ColoredBox(
          color: Colors.black.withValues(alpha: 0.35),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 360),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircularProgressIndicator(),
                      verticalSpaceMedium,
                      Text(
                        controller.routeResolutionStatus.value.isEmpty
                            ? 'Resolving route and mileposts...'
                            : controller.routeResolutionStatus.value,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: textPrimaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          minHeight: 8,
                          value: controller.routeResolutionTotal.value == 0
                              ? null
                              : controller.routeResolutionCompleted.value /
                                  controller.routeResolutionTotal.value,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _uploadOverlay(KmlController controller) {
    return Obx(() {
      if (!controller.uploadInProgress.value) {
        return const SizedBox.shrink();
      }

      return Positioned.fill(
        child: ColoredBox(
          color: Colors.black.withValues(alpha: 0.35),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 320),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircularProgressIndicator(),
                      const SizedBox(height: 12),
                      Text(
                        'Uploading recording...',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: textPrimaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _map(BuildContext context, KmlController controller,
      MapController mapController) {
    return SizedBox(
      width: screenWidth(context),
      height: screenHeight(context),
      child: Obx(
        () => FlutterMap(
            mapController: mapController,
            options: MapOptions(
              initialCenter: AppConfig.defaultMapCenter,
              initialZoom: 8,
              onMapReady: () {
                controller.mapController = mapController;
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  Future.delayed(const Duration(milliseconds: 200), () {
                    controller.fitMap();
                  });
                });
              },
              onMapEvent: (event) {
                controller.currentZoom.value = event.camera.zoom;
              },
              onTap: (tapPosition, point) {
                controller.handleMapTap();
              },
            ),
            children: [
              TileLayer(
                urlTemplate:
                    "https://api.mapbox.com/styles/v1/mapbox/satellite-streets-v11/tiles/256/{z}/{x}/{y}@2x?access_token={accessToken}",
                additionalOptions: {
                  'accessToken': AppConfig.mapboxAccessToken,
                  'id': 'mapbox.satellite',
                },
              ),
              controller.polylineLayer.value,
              controller.getMarkerLayer(),
            ]),
      ),
    );
  }

  Widget pointList(double panelWidth) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        width: panelWidth,
        height: screenHeight(Get.context!) * 0.65,
        //color: extraLightGrey,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: extraLightGrey.withValues(alpha: 0.9),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
          child: Obx(
            () {
              final int selectedIndex = controller.selectedWaypointIndex.value;
              if (selectedIndex >= 0) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _scrollSelectedWaypointIntoView(controller);
                });
              }

              return ListView(
                controller: _waypointListScrollController,
                children: [
                  _stageControlPanel(controller),
                  verticalSpaceSmall,
                  ExpansionTile(
                    initiallyExpanded: true,
                    tilePadding: const EdgeInsets.symmetric(horizontal: 8.0),
                    title: Text(
                      'Waypoints (${controller.sortedWaypointIndexes().length})',
                      style: TextStyle(
                        color: textPrimaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Obx(
                          () => DropdownButtonHideUnderline(
                            child: DropdownButton<WaypointSortOrder>(
                              value: controller.waypointSortOrder.value,
                              hint: const Text('Sort waypoints'),
                              isExpanded: true,
                              dropdownColor: Colors.white,
                              items: WaypointSortOrder.values
                                  .map(
                                    (value) =>
                                        DropdownMenuItem<WaypointSortOrder>(
                                      value: value,
                                      child: Text(value.label),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (value) {
                                if (value != null) {
                                  controller.waypointSortOrder.value = value;
                                }
                              },
                            ),
                          ),
                        ),
                      ),
                      verticalSpaceSmall,
                      Obx(
                        () {
                          // Required for Obx to detect updates
                          final List<int> sortedIndexes =
                              controller.sortedWaypointIndexes();
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: sortedIndexes.length,
                            itemBuilder: (context, index) {
                              final int pointIndex = sortedIndexes[index];
                              MappableKmlPoint point =
                                  controller.mappableKmlPoints[pointIndex];
                              final name =
                                  "#${pointIndex + 1}, ${point.description}";
                              final measureString = point.gisMeasure != null
                                  ? "${point.gisMeasure!.routeId}: ${point.gisMeasure!.measure.toStringAsFixed(2)}"
                                  : null;
                              final bool selectable = controller
                                  .isPointSelectableInCurrentStage(pointIndex);
                              final bool isRoadwayStart =
                                  controller.roadwayStartPointIndex.value ==
                                      pointIndex;
                              final bool isRoadwayEnd =
                                  controller.roadwayEndPointIndex.value ==
                                      pointIndex;
                              final bool isUnresolved = controller
                                  .unresolvedPointIndexes
                                  .contains(pointIndex);
                              final List<WaypointCategory> pointCategories =
                                  controller
                                      .effectivePointCategories(pointIndex);
                              final GlobalKey waypointKey = _waypointItemKeys
                                  .putIfAbsent(pointIndex, () => GlobalKey());
                              return Obx(
                                () => Padding(
                                  key: waypointKey,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 4.0, horizontal: 8.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: controller.selectedWaypointIndex
                                                  .value ==
                                              pointIndex
                                          ? primaryColor.withValues(alpha: 0.3)
                                          : selectable
                                              ? lightGrey
                                              : lightGrey.withValues(
                                                  alpha: 0.35),
                                      borderRadius: BorderRadius.circular(8.0),
                                      border: Border.all(
                                        color: controller.selectedWaypointIndex
                                                    .value ==
                                                pointIndex
                                            ? primaryColor
                                            : Colors.transparent,
                                        width: 2.0,
                                      ),
                                    ),
                                    child: ListTile(
                                      title: Text(name,
                                          style: TextStyle(
                                              color: textPrimaryColor)),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          measureString != null
                                              ? Text(measureString,
                                                  style: TextStyle(
                                                      color: textPrimaryColor))
                                              : const SizedBox.shrink(),
                                          Wrap(
                                            spacing: 6,
                                            runSpacing: 6,
                                            children: [
                                              if (isRoadwayStart)
                                                const Chip(
                                                  label: Text('Roadway Start'),
                                                  visualDensity:
                                                      VisualDensity.compact,
                                                ),
                                              if (isRoadwayEnd)
                                                const Chip(
                                                  label: Text('Roadway End'),
                                                  visualDensity:
                                                      VisualDensity.compact,
                                                ),
                                              if (isUnresolved)
                                                const Chip(
                                                  label: Text('Excluded'),
                                                  backgroundColor:
                                                      Colors.redAccent,
                                                  labelStyle: TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                  visualDensity:
                                                      VisualDensity.compact,
                                                ),
                                              if (!isUnresolved)
                                                ...pointCategories
                                                    .where((category) {
                                                  return category !=
                                                          WaypointCategory
                                                              .startPoint &&
                                                      category !=
                                                          WaypointCategory
                                                              .endPoint &&
                                                      category !=
                                                          WaypointCategory
                                                              .ignore;
                                                }).map(
                                                  (category) => Chip(
                                                    label: Text(category.label),
                                                    visualDensity:
                                                        VisualDensity.compact,
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      onTap: () {
                                        if (selectable) {
                                          controller.pointTap(pointIndex,
                                              shouldCenter: true);
                                        }
                                      },
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                  ExpansionTile(
                    initiallyExpanded: false,
                    tilePadding: const EdgeInsets.symmetric(horizontal: 8.0),
                    title: Text(
                      'Routes (${controller.routes.length})',
                      style: TextStyle(
                        color: textPrimaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    children: [
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: controller.routes.length,
                        itemBuilder: (context, index) {
                          final route = controller.routes[index];
                          final routeName = route.name?.isNotEmpty == true
                              ? route.name!
                              : 'Unnamed Route';
                          final pointCount = route.rtepts.length;
                          return Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 4.0, horizontal: 8.0),
                              child: Obx(
                                () => Container(
                                  decoration: BoxDecoration(
                                    color: controller.selectedRouteId.value ==
                                            index
                                        ? primaryColor.withValues(alpha: 0.3)
                                        : lightGrey,
                                    borderRadius: BorderRadius.circular(8.0),
                                    border: Border.all(
                                      color: controller.selectedRouteId.value ==
                                              index
                                          ? primaryColor
                                          : Colors.transparent,
                                      width: 2.0,
                                    ),
                                  ),
                                  child: ListTile(
                                    title: Text(
                                      'Route ${index + 1}: $routeName',
                                      style: TextStyle(color: textPrimaryColor),
                                    ),
                                    subtitle: Obx(
                                      () => Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Points: $pointCount',
                                            style: TextStyle(
                                                color: textPrimaryColor),
                                          ),
                                          Row(
                                            children: [
                                              Checkbox(
                                                value: controller
                                                        .workZonePathRouteId
                                                        .value ==
                                                    index,
                                                onChanged: (checked) {
                                                  controller.workZonePathRouteId
                                                          .value =
                                                      checked == true
                                                          ? index
                                                          : -1;
                                                },
                                              ),
                                              Text(
                                                'Work zone path',
                                                style: TextStyle(
                                                    color: textPrimaryColor),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    onTap: () {
                                      // controller.selectedObjectId.value = -1;
                                      // controller.selectedRouteId.value =
                                      //     index;
                                      controller.pointTap(index,
                                          shouldCenter: true);
                                      controller.createMapWidgets(
                                          controller.waypoints,
                                          controller.routes,
                                          controller.tracks);
                                    },
                                  ),
                                ),
                              ));
                        },
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
