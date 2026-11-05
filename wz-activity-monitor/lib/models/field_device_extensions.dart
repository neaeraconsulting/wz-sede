import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wzam/constants.dart';
import 'package:wzam/models/generated/field_device.pb.dart';

extension ArrowBoardPatternExtension
    on FieldDevice_ArrowBoard_ArrowBoardPattern {
  Widget get icon {
    return switch (this) {
      FieldDevice_ArrowBoard_ArrowBoardPattern.ARROW_BOARD_PATTERN_UNKNOWN =>
        SvgPicture.asset(Constants.arrowBoardBlankIcon),
      FieldDevice_ArrowBoard_ArrowBoardPattern.ARROW_BOARD_PATTERN_BLANK =>
        SvgPicture.asset(Constants.arrowBoardBlankIcon),
      FieldDevice_ArrowBoard_ArrowBoardPattern
            .ARROW_BOARD_PATTERN_RIGHT_ARROW_STATIC =>
        SvgPicture.asset(Constants.arrowBoardRightArrowIcon),
      FieldDevice_ArrowBoard_ArrowBoardPattern
            .ARROW_BOARD_PATTERN_RIGHT_ARROW_FLASHING =>
        SvgPicture.asset(Constants.arrowBoardRightArrowIcon),
      FieldDevice_ArrowBoard_ArrowBoardPattern
            .ARROW_BOARD_PATTERN_RIGHT_ARROW_SEQUENTIAL =>
        SvgPicture.asset(Constants.arrowBoardRightArrowIcon),
      FieldDevice_ArrowBoard_ArrowBoardPattern
            .ARROW_BOARD_PATTERN_RIGHT_CHEVRON_STATIC =>
        SvgPicture.asset(Constants.arrowBoardRightChevronIcon),
      FieldDevice_ArrowBoard_ArrowBoardPattern
            .ARROW_BOARD_PATTERN_RIGHT_CHEVRON_FLASHING =>
        SvgPicture.asset(Constants.arrowBoardRightChevronIcon),
      FieldDevice_ArrowBoard_ArrowBoardPattern
            .ARROW_BOARD_PATTERN_RIGHT_CHEVRON_SEQUENTIAL =>
        SvgPicture.asset(Constants.arrowBoardRightChevronIcon),
      FieldDevice_ArrowBoard_ArrowBoardPattern
            .ARROW_BOARD_PATTERN_LEFT_ARROW_STATIC =>
        SvgPicture.asset(Constants.arrowBoardLeftArrowIcon),
      FieldDevice_ArrowBoard_ArrowBoardPattern
            .ARROW_BOARD_PATTERN_LEFT_ARROW_FLASHING =>
        SvgPicture.asset(Constants.arrowBoardLeftArrowIcon),
      FieldDevice_ArrowBoard_ArrowBoardPattern
            .ARROW_BOARD_PATTERN_LEFT_ARROW_SEQUENTIAL =>
        SvgPicture.asset(Constants.arrowBoardLeftArrowIcon),
      FieldDevice_ArrowBoard_ArrowBoardPattern
            .ARROW_BOARD_PATTERN_LEFT_CHEVRON_STATIC =>
        SvgPicture.asset(Constants.arrowBoardLeftChevronIcon),
      FieldDevice_ArrowBoard_ArrowBoardPattern
            .ARROW_BOARD_PATTERN_LEFT_CHEVRON_FLASHING =>
        SvgPicture.asset(Constants.arrowBoardLeftChevronIcon),
      FieldDevice_ArrowBoard_ArrowBoardPattern
            .ARROW_BOARD_PATTERN_LEFT_CHEVRON_SEQUENTIAL =>
        SvgPicture.asset(Constants.arrowBoardLeftChevronIcon),
      FieldDevice_ArrowBoard_ArrowBoardPattern
            .ARROW_BOARD_PATTERN_BIDIRECTIONAL_ARROW_STATIC =>
        SvgPicture.asset(Constants.arrowBoardBidirectionalArrowIcon),
      FieldDevice_ArrowBoard_ArrowBoardPattern
            .ARROW_BOARD_PATTERN_BIDIRECTIONAL_ARROW_FLASHING =>
        SvgPicture.asset(Constants.arrowBoardBidirectionalArrowIcon),
      FieldDevice_ArrowBoard_ArrowBoardPattern
            .ARROW_BOARD_PATTERN_LINE_FLASHING =>
        SvgPicture.asset(Constants.arrowBoardLineIcon),
      FieldDevice_ArrowBoard_ArrowBoardPattern
            .ARROW_BOARD_PATTERN_DIAMONDS_ALTERNATING =>
        SvgPicture.asset(Constants.arrowBoardDiamondsIcon),
      FieldDevice_ArrowBoard_ArrowBoardPattern
            .ARROW_BOARD_PATTERN_FOUR_CORNERS_FLASHING =>
        SvgPicture.asset(Constants.arrowBoardFourCornersIcon),
      FieldDevice_ArrowBoard_ArrowBoardPattern() =>
        SvgPicture.asset(Constants.arrowBoardBlankIcon),
    };
  }
}


