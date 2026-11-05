import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wzam/constants.dart';
import 'package:wzam/models/generated/road_sub_event.pb.dart';

extension SpeedReductionLayerTypeExtension
    on RoadSubEvent_SpeedReductionLayer {
  Widget get icon {
    //add speed limit overtop of the icon
    double reducedSpeedLimitMPH = this.reducedSpeedLimitKph * 0.621371;
    return Container(
      width: 50,
      height: 50,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SvgPicture.asset(Constants.speedReductionIcon),
          Positioned(
            top: 0,
            child: Text(
              reducedSpeedLimitMPH.round().toString(),
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
    //return SvgPicture.asset(Constants.speedReductionIcon);
  }
}
