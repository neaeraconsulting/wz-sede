import 'package:flutter/material.dart';
import 'package:wzam/models/live_worker_location.dart';
import 'package:wzam/models/mobile_vehicle_location.dart';
import 'package:wzam/models/pair.dart';
import 'package:wzam/models/wzdx_models.dart';

extension LaneStatusIcon on LaneStatus {
  Widget image({double scale = 1.0}) {
    switch (this) {
      case LaneStatus.open:
        return Image.asset('assets/images/lane.png', scale: scale);
      case LaneStatus.closed:
        return Image.asset('assets/images/closed_lane.png', scale: scale);
      case LaneStatus.shiftLeft:
        return Icon(
          Icons.arrow_left,
          color: color,
          size: 24 * scale,
        );
      case LaneStatus.shiftRight:
        return Icon(
          Icons.arrow_right,
          color: color,
          size: 24 * scale,
        );
      case LaneStatus.mergeLeft:
        return Icon(
          Icons.merge_type,
          color: color,
          size: 24 * scale,
        );
      case LaneStatus.mergeRight:
        return Icon(
          Icons.merge_type,
          color: color,
          size: 24 * scale,
        );
      case LaneStatus.alternatingFlow:
        return Icon(
          Icons.swap_horiz,
          color: color,
          size: 24 * scale,
        );
    }
  }

  Color get color {
    switch (this) {
      case LaneStatus.open:
        return Colors.green;
      case LaneStatus.closed:
        return Colors.red;
      case LaneStatus.shiftLeft:
        return Colors.blue;
      case LaneStatus.shiftRight:
        return Colors.blue;
      case LaneStatus.mergeLeft:
        return Colors.yellow;
      case LaneStatus.mergeRight:
        return Colors.yellow;
      case LaneStatus.alternatingFlow:
        return Colors.purple;
    }
  }
}

extension MobileVehicleOperationTypeExtensions on MobileVehicleOperationType {
  String get displayName {
    switch (this) {
      case MobileVehicleOperationType.GENERAL_ACTIVE:
        return 'General Active';
      case MobileVehicleOperationType.GENERAL_INACTIVE:
        return 'Inactive';
      case MobileVehicleOperationType.MOWING:
        return 'Mowing';
      case MobileVehicleOperationType.PLOWING:
        return 'Snow Plow';
      case MobileVehicleOperationType.STRIPING:
        return 'Painting/Striping';
    }
  }

  static List<Pair<MobileVehicleOperationType, String>> getPairs() =>
      MobileVehicleOperationType.values
          .map((type) => Pair(type, type.displayName))
          .where(
              (pair) => pair.first != MobileVehicleOperationType.GENERAL_ACTIVE)
          .where((pair) =>
              pair.first != MobileVehicleOperationType.GENERAL_INACTIVE)
          .toList();
}

extension WorkZoneTypeExtensions on WorkZoneType {
  String get displayName {
    switch (this) {
      case WorkZoneType.static:
        return 'Static';
      case WorkZoneType.moving:
        return 'Moving';
      case WorkZoneType.plannedMovingArea:
        return 'Planned Moving Area';
    }
  }

  static List<Pair<WorkZoneType, String>> getPairs() =>
      WorkZoneType.values.map((type) => Pair(type, type.displayName)).toList();
  

  static List<Pair<WorkZoneType, String>> getAllowedPairs() =>
      WorkZoneType.values
          .where((e) => e != WorkZoneType.moving)
          .map((type) => Pair(type, type.displayName))
          .toList();
}

extension WorkTypeNameExtensions on WorkTypeName {
  String get displayName {
    switch (this) {
      case WorkTypeName.maintenance:
        return 'Maintenance';
      case WorkTypeName.minorRoadDefectRepair:
        return 'Minor Road Defect Repair';
      case WorkTypeName.roadsideWork:
        return 'Roadside Work';
      case WorkTypeName.overheadWork:
        return 'Overhead Work';
      case WorkTypeName.belowRoadWork:
        return 'Below Road Work';
      case WorkTypeName.barrierWork:
        return 'Barrier Work';
      case WorkTypeName.surfaceWork:
        return 'Surface Work';
      case WorkTypeName.painting:
        return 'Painting';
      case WorkTypeName.roadwayRelocation:
        return 'Roadway Relocation';
      case WorkTypeName.roadwayCreation:
        return 'Roadway Creation';
    }
  }

  static List<Pair<WorkTypeName, String>> getPairs() =>
      WorkTypeName.values.map((type) => Pair(type, type.displayName)).toList();
}

extension RoadSegmentSurfaceTypeExtensions on RoadSegmentSurfaceType {
  String get displayName {
    switch (this) {
      case RoadSegmentSurfaceType.paved:
        return 'Paved';
      case RoadSegmentSurfaceType.gravel:
        return 'Gravel';
      case RoadSegmentSurfaceType.dirt:
        return 'Dirt';
      case RoadSegmentSurfaceType.grooved:
        return 'Grooved';
    }
  }

  static List<Pair<RoadSegmentSurfaceType, String>> getPairs() =>
      RoadSegmentSurfaceType.values
          .map((type) => Pair(type, type.displayName))
          .toList();
}

extension RoadwayDirectionExtensions on RoadwayDirection {
  String get displayName {
    switch (this) {
      case RoadwayDirection.northbound:
        return 'Northbound';
      case RoadwayDirection.eastbound:
        return 'Eastbound';
      case RoadwayDirection.southbound:
        return 'Southbound';
      case RoadwayDirection.westbound:
        return 'Westbound';
      case RoadwayDirection.innerLoop:
        return 'Inner Loop';
      case RoadwayDirection.outerLoop:
        return 'Outer Loop';
      case RoadwayDirection.undefined:
        return 'Undefined';
      case RoadwayDirection.unknown:
        return 'Unknown';
    }
  }

  static List<Pair<RoadwayDirection, String>> getPairs() =>
      RoadwayDirection.values
          .map((type) => Pair(type, type.displayName))
          .toList();
}

extension WorkerLocationTypeExtensions on WorkerLocationType {
  String get displayName {
    switch (this) {
      case WorkerLocationType.WORKER:
        return 'Worker';
      case WorkerLocationType.MOBILE_OPERATOR:
        return 'Mobile Operator';
      case WorkerLocationType.FLAGGER:
        return 'Flagger';
    }
  }

  static List<Pair<WorkerLocationType, String>> getPairs() =>
      WorkerLocationType.values
          .map((type) => Pair(type, type.displayName))
          .where((pair) => pair.first != WorkerLocationType.FLAGGER)
          .toList();
}

extension VehicleImpactExtensions on VehicleImpact {
  String get displayName {
    switch (this) {
      case VehicleImpact.allLanesClosed:
        return 'All lanes closed';
      case VehicleImpact.someLanesClosed:
        return 'Some lanes closed';
      case VehicleImpact.allLanesOpen:
        return 'All lanes open';
      case VehicleImpact.alternatingOneWay:
        return 'Alternating One-Way';
      case VehicleImpact.someLanesClosedMergeLeft:
        return 'Some lanes closed, merge left';
      case VehicleImpact.someLanesClosedMergeRight:
        return 'Some lanes closed, merge right';
      case VehicleImpact.allLanesOpenShiftLeft:
        return 'All lanes open, shift left';
      case VehicleImpact.allLanesOpenShiftRight:
        return 'All lanes open, shift right';
      case VehicleImpact.someLanesClosedSplit:
        return 'Some lanes closed, split';
      case VehicleImpact.flagging:
        return 'Flagging';
      case VehicleImpact.temporaryTrafficSignal:
        return 'Temporary Traffic Signal';
      case VehicleImpact.unknown:
        return 'Unknown';
    }
  }

  static List<Pair<VehicleImpact, String>> getPairs() =>
      VehicleImpact.values.map((type) => Pair(type, type.displayName)).toList();

  static List<Pair<VehicleImpact, String>> getAllowedPairs() => [
        VehicleImpact.allLanesOpen,
        VehicleImpact.someLanesClosed,
        VehicleImpact.allLanesClosed,
        VehicleImpact.alternatingOneWay
      ].map((type) => Pair(type, type.displayName)).toList();
}
