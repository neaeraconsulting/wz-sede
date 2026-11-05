import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wzam/constants.dart';
import 'package:wzam/models/generated/road_sub_event.pb.dart';

import 'generated/wzdx.pbenum.dart';

extension BaseLayerTypeExtension
    on RoadSubEvent_BaseLayer {
  Widget get icon {
    return switch (vehicleImpact) {
      VehicleImpact.VEHICLE_IMPACT_UNKNOWN =>
        SvgPicture.asset(Constants.unknownIcon),
      VehicleImpact.VEHICLE_IMPACT_ALL_LANES_CLOSED =>
        SvgPicture.asset(Constants.vehicleImpactAllLanesClosedIcon),
      VehicleImpact.VEHICLE_IMPACT_SOME_LANES_CLOSED =>
        SvgPicture.asset(Constants.laneClosureStartIcon),
      VehicleImpact.VEHICLE_IMPACT_ALL_LANES_OPEN =>
        SvgPicture.asset(Constants.vehicleImpactAllLanesOpenIcon),
      VehicleImpact.VEHICLE_IMPACT_ALTERNATING_ONE_WAY =>
        SvgPicture.asset(Constants.vehicleImpactAlternatingOneWayIcon),
      VehicleImpact.VEHICLE_IMPACT_SOME_LANES_CLOSED_MERGE_LEFT =>
        SvgPicture.asset(Constants.vehicleImpactSomeLanesClosedMergeLeftIcon),
      VehicleImpact.VEHICLE_IMPACT_SOME_LANES_CLOSED_MERGE_RIGHT =>
        SvgPicture.asset(Constants.vehicleImpactSomeLanesClosedMergeRightIcon),
      VehicleImpact.VEHICLE_IMPACT_ALL_LANES_OPEN_SHIFT_LEFT =>
        SvgPicture.asset(Constants.vehicleImpactAllLanesOpenShiftLeftIcon),
      VehicleImpact.VEHICLE_IMPACT_ALL_LANES_OPEN_SHIFT_RIGHT =>
        SvgPicture.asset(Constants.vehicleImpactAllLanesOpenShiftRightIcon),
      VehicleImpact.VEHICLE_IMPACT_SOME_LANES_CLOSED_SPLIT =>
        SvgPicture.asset(Constants.vehicleImpactSomeLanesClosedSplitIcon),
      VehicleImpact.VEHICLE_IMPACT_FLAGGING =>
        SvgPicture.asset(Constants.laneClosureStartIcon),
      VehicleImpact.VEHICLE_IMPACT_TEMPORARY_TRAFFIC_SIGNAL =>
        SvgPicture.asset(Constants.laneClosureStartIcon),
      _ => SvgPicture.asset(Constants.unknownIcon),
    };
  }
}
