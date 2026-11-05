import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wzam/constants.dart';
import 'package:wzam/models/generated/common.pbenum.dart';

extension MarkedLocationTypeExtension
    on MarkedLocationType {
  Widget get icon {
    return switch (this) {
      MarkedLocationType.MARKED_LOCATION_TYPE_GENERIC =>
        SvgPicture.asset(Constants.genericIcon),
      MarkedLocationType.MARKED_LOCATION_TYPE_FLAGGER =>
        SvgPicture.asset(Constants.flaggerIcon),
      MarkedLocationType.MARKED_LOCATION_TYPE_LANE_CLOSURE_START =>
        SvgPicture.asset(Constants.laneClosureStartIcon),
      MarkedLocationType.MARKED_LOCATION_TYPE_LANE_CLOSURE_END =>
        SvgPicture.asset(Constants.laneClosureEndIcon),
      MarkedLocationType.MARKED_LOCATION_TYPE_WORKER_PRESENCE_START =>
        SvgPicture.asset(Constants.workerPresenceStartIcon),
      MarkedLocationType.MARKED_LOCATION_TYPE_WORKER_PRESENCE_END =>
        SvgPicture.asset(Constants.workerPresenceEndIcon),
      MarkedLocationType.MARKED_LOCATION_TYPE_WORKER_POSITION =>
        SvgPicture.asset(Constants.workerPositionIcon),
      MarkedLocationType.MARKED_LOCATION_TYPE_ROAD_CLOSURE_START =>
        SvgPicture.asset(Constants.roadClosureStartIcon),
      MarkedLocationType.MARKED_LOCATION_TYPE_ROAD_CLOSURE_END =>
        SvgPicture.asset(Constants.roadClosureEndIcon),
      MarkedLocationType.MARKED_LOCATION_TYPE_ROAD_EVENT_START =>
        SvgPicture.asset(Constants.roadEventStartIcon),
      MarkedLocationType.MARKED_LOCATION_TYPE_ROAD_EVENT_END =>
        SvgPicture.asset(Constants.roadEventEndIcon),
      MarkedLocationType.MARKED_LOCATION_TYPE_SPEED_REDUCTION_START =>
        SvgPicture.asset(Constants.speedReductionIcon),
      MarkedLocationType.MARKED_LOCATION_TYPE_SPEED_REDUCTION_END =>
        SvgPicture.asset(Constants.speedReductionEndIcon),
      MarkedLocationType.MARKED_LOCATION_TYPE_INCIDENT_START =>
        SvgPicture.asset(Constants.incidentStartIcon),
      MarkedLocationType.MARKED_LOCATION_TYPE_INCIDENT_END =>
        SvgPicture.asset(Constants.unknownIcon),
      MarkedLocationType.MARKED_LOCATION_TYPE_APPROACH_REGION =>
        SvgPicture.asset(Constants.approachIcon),
      _ => SvgPicture.asset(Constants.unknownIcon),
    };
  }
}
