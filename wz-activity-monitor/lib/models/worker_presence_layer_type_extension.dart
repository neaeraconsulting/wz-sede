import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wzam/constants.dart';
import 'package:wzam/models/generated/road_sub_event.pb.dart';

extension WorkerPresenceLayerTypeExtension
    on RoadSubEvent_WorkerPresenceLayer {
  Widget get icon {
    return SvgPicture.asset(Constants.workerPresenceStartIcon);
  }
}
