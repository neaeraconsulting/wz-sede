// This is a generated file - do not edit.
//
// Generated from field_device.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class FieldDevice_FieldDeviceStatus extends $pb.ProtobufEnum {
  static const FieldDevice_FieldDeviceStatus FIELD_DEVICE_STATUS_UNKNOWN = FieldDevice_FieldDeviceStatus._(0, _omitEnumNames ? '' : 'FIELD_DEVICE_STATUS_UNKNOWN');
  static const FieldDevice_FieldDeviceStatus FIELD_DEVICE_STATUS_OK = FieldDevice_FieldDeviceStatus._(1, _omitEnumNames ? '' : 'FIELD_DEVICE_STATUS_OK');
  static const FieldDevice_FieldDeviceStatus FIELD_DEVICE_STATUS_WARNING = FieldDevice_FieldDeviceStatus._(2, _omitEnumNames ? '' : 'FIELD_DEVICE_STATUS_WARNING');
  static const FieldDevice_FieldDeviceStatus FIELD_DEVICE_STATUS_ERROR = FieldDevice_FieldDeviceStatus._(3, _omitEnumNames ? '' : 'FIELD_DEVICE_STATUS_ERROR');
  /// Device is not reachable - powered off or no connection
  static const FieldDevice_FieldDeviceStatus FIELD_DEVICE_STATUS_OFFLINE = FieldDevice_FieldDeviceStatus._(4, _omitEnumNames ? '' : 'FIELD_DEVICE_STATUS_OFFLINE');
  /// Device information is available, but is stale
  static const FieldDevice_FieldDeviceStatus FIELD_DEVICE_STATUS_INACTIVE = FieldDevice_FieldDeviceStatus._(5, _omitEnumNames ? '' : 'FIELD_DEVICE_STATUS_INACTIVE');

  static const $core.List<FieldDevice_FieldDeviceStatus> values = <FieldDevice_FieldDeviceStatus> [
    FIELD_DEVICE_STATUS_UNKNOWN,
    FIELD_DEVICE_STATUS_OK,
    FIELD_DEVICE_STATUS_WARNING,
    FIELD_DEVICE_STATUS_ERROR,
    FIELD_DEVICE_STATUS_OFFLINE,
    FIELD_DEVICE_STATUS_INACTIVE,
  ];

  static final $core.List<FieldDevice_FieldDeviceStatus?> _byValue = $pb.ProtobufEnum.$_initByValueList(values, 5);
  static FieldDevice_FieldDeviceStatus? valueOf($core.int value) =>  value < 0 || value >= _byValue.length ? null : _byValue[value];

  const FieldDevice_FieldDeviceStatus._(super.value, super.name);
}

class FieldDevice_ArrowBoard_ArrowBoardTransportPosition extends $pb.ProtobufEnum {
  static const FieldDevice_ArrowBoard_ArrowBoardTransportPosition ARROW_BOARD_TRANSPORT_POSITION_UNKNOWN = FieldDevice_ArrowBoard_ArrowBoardTransportPosition._(0, _omitEnumNames ? '' : 'ARROW_BOARD_TRANSPORT_POSITION_UNKNOWN');
  static const FieldDevice_ArrowBoard_ArrowBoardTransportPosition ARROW_BOARD_TRANSPORT_POSITION_STOWED = FieldDevice_ArrowBoard_ArrowBoardTransportPosition._(1, _omitEnumNames ? '' : 'ARROW_BOARD_TRANSPORT_POSITION_STOWED');
  static const FieldDevice_ArrowBoard_ArrowBoardTransportPosition ARROW_BOARD_TRANSPORT_POSITION_DEPLOYED = FieldDevice_ArrowBoard_ArrowBoardTransportPosition._(2, _omitEnumNames ? '' : 'ARROW_BOARD_TRANSPORT_POSITION_DEPLOYED');

  static const $core.List<FieldDevice_ArrowBoard_ArrowBoardTransportPosition> values = <FieldDevice_ArrowBoard_ArrowBoardTransportPosition> [
    ARROW_BOARD_TRANSPORT_POSITION_UNKNOWN,
    ARROW_BOARD_TRANSPORT_POSITION_STOWED,
    ARROW_BOARD_TRANSPORT_POSITION_DEPLOYED,
  ];

  static final $core.List<FieldDevice_ArrowBoard_ArrowBoardTransportPosition?> _byValue = $pb.ProtobufEnum.$_initByValueList(values, 2);
  static FieldDevice_ArrowBoard_ArrowBoardTransportPosition? valueOf($core.int value) =>  value < 0 || value >= _byValue.length ? null : _byValue[value];

  const FieldDevice_ArrowBoard_ArrowBoardTransportPosition._(super.value, super.name);
}

/// https://github.com/usdot-jpo-ode/wzdx/blob/develop/spec-content/enumerated-types/ArrowBoardPattern.md
class FieldDevice_ArrowBoard_ArrowBoardPattern extends $pb.ProtobufEnum {
  static const FieldDevice_ArrowBoard_ArrowBoardPattern ARROW_BOARD_PATTERN_UNKNOWN = FieldDevice_ArrowBoard_ArrowBoardPattern._(0, _omitEnumNames ? '' : 'ARROW_BOARD_PATTERN_UNKNOWN');
  static const FieldDevice_ArrowBoard_ArrowBoardPattern ARROW_BOARD_PATTERN_BLANK = FieldDevice_ArrowBoard_ArrowBoardPattern._(1, _omitEnumNames ? '' : 'ARROW_BOARD_PATTERN_BLANK');
  static const FieldDevice_ArrowBoard_ArrowBoardPattern ARROW_BOARD_PATTERN_RIGHT_ARROW_STATIC = FieldDevice_ArrowBoard_ArrowBoardPattern._(2, _omitEnumNames ? '' : 'ARROW_BOARD_PATTERN_RIGHT_ARROW_STATIC');
  static const FieldDevice_ArrowBoard_ArrowBoardPattern ARROW_BOARD_PATTERN_RIGHT_ARROW_FLASHING = FieldDevice_ArrowBoard_ArrowBoardPattern._(3, _omitEnumNames ? '' : 'ARROW_BOARD_PATTERN_RIGHT_ARROW_FLASHING');
  static const FieldDevice_ArrowBoard_ArrowBoardPattern ARROW_BOARD_PATTERN_RIGHT_ARROW_SEQUENTIAL = FieldDevice_ArrowBoard_ArrowBoardPattern._(4, _omitEnumNames ? '' : 'ARROW_BOARD_PATTERN_RIGHT_ARROW_SEQUENTIAL');
  static const FieldDevice_ArrowBoard_ArrowBoardPattern ARROW_BOARD_PATTERN_RIGHT_CHEVRON_STATIC = FieldDevice_ArrowBoard_ArrowBoardPattern._(5, _omitEnumNames ? '' : 'ARROW_BOARD_PATTERN_RIGHT_CHEVRON_STATIC');
  static const FieldDevice_ArrowBoard_ArrowBoardPattern ARROW_BOARD_PATTERN_RIGHT_CHEVRON_FLASHING = FieldDevice_ArrowBoard_ArrowBoardPattern._(6, _omitEnumNames ? '' : 'ARROW_BOARD_PATTERN_RIGHT_CHEVRON_FLASHING');
  static const FieldDevice_ArrowBoard_ArrowBoardPattern ARROW_BOARD_PATTERN_RIGHT_CHEVRON_SEQUENTIAL = FieldDevice_ArrowBoard_ArrowBoardPattern._(7, _omitEnumNames ? '' : 'ARROW_BOARD_PATTERN_RIGHT_CHEVRON_SEQUENTIAL');
  static const FieldDevice_ArrowBoard_ArrowBoardPattern ARROW_BOARD_PATTERN_LEFT_ARROW_STATIC = FieldDevice_ArrowBoard_ArrowBoardPattern._(8, _omitEnumNames ? '' : 'ARROW_BOARD_PATTERN_LEFT_ARROW_STATIC');
  static const FieldDevice_ArrowBoard_ArrowBoardPattern ARROW_BOARD_PATTERN_LEFT_ARROW_FLASHING = FieldDevice_ArrowBoard_ArrowBoardPattern._(9, _omitEnumNames ? '' : 'ARROW_BOARD_PATTERN_LEFT_ARROW_FLASHING');
  static const FieldDevice_ArrowBoard_ArrowBoardPattern ARROW_BOARD_PATTERN_LEFT_ARROW_SEQUENTIAL = FieldDevice_ArrowBoard_ArrowBoardPattern._(10, _omitEnumNames ? '' : 'ARROW_BOARD_PATTERN_LEFT_ARROW_SEQUENTIAL');
  static const FieldDevice_ArrowBoard_ArrowBoardPattern ARROW_BOARD_PATTERN_LEFT_CHEVRON_STATIC = FieldDevice_ArrowBoard_ArrowBoardPattern._(11, _omitEnumNames ? '' : 'ARROW_BOARD_PATTERN_LEFT_CHEVRON_STATIC');
  static const FieldDevice_ArrowBoard_ArrowBoardPattern ARROW_BOARD_PATTERN_LEFT_CHEVRON_FLASHING = FieldDevice_ArrowBoard_ArrowBoardPattern._(12, _omitEnumNames ? '' : 'ARROW_BOARD_PATTERN_LEFT_CHEVRON_FLASHING');
  static const FieldDevice_ArrowBoard_ArrowBoardPattern ARROW_BOARD_PATTERN_LEFT_CHEVRON_SEQUENTIAL = FieldDevice_ArrowBoard_ArrowBoardPattern._(13, _omitEnumNames ? '' : 'ARROW_BOARD_PATTERN_LEFT_CHEVRON_SEQUENTIAL');
  static const FieldDevice_ArrowBoard_ArrowBoardPattern ARROW_BOARD_PATTERN_BIDIRECTIONAL_ARROW_STATIC = FieldDevice_ArrowBoard_ArrowBoardPattern._(14, _omitEnumNames ? '' : 'ARROW_BOARD_PATTERN_BIDIRECTIONAL_ARROW_STATIC');
  static const FieldDevice_ArrowBoard_ArrowBoardPattern ARROW_BOARD_PATTERN_BIDIRECTIONAL_ARROW_FLASHING = FieldDevice_ArrowBoard_ArrowBoardPattern._(15, _omitEnumNames ? '' : 'ARROW_BOARD_PATTERN_BIDIRECTIONAL_ARROW_FLASHING');
  static const FieldDevice_ArrowBoard_ArrowBoardPattern ARROW_BOARD_PATTERN_LINE_FLASHING = FieldDevice_ArrowBoard_ArrowBoardPattern._(16, _omitEnumNames ? '' : 'ARROW_BOARD_PATTERN_LINE_FLASHING');
  static const FieldDevice_ArrowBoard_ArrowBoardPattern ARROW_BOARD_PATTERN_DIAMONDS_ALTERNATING = FieldDevice_ArrowBoard_ArrowBoardPattern._(17, _omitEnumNames ? '' : 'ARROW_BOARD_PATTERN_DIAMONDS_ALTERNATING');
  static const FieldDevice_ArrowBoard_ArrowBoardPattern ARROW_BOARD_PATTERN_FOUR_CORNERS_FLASHING = FieldDevice_ArrowBoard_ArrowBoardPattern._(18, _omitEnumNames ? '' : 'ARROW_BOARD_PATTERN_FOUR_CORNERS_FLASHING');

  static const $core.List<FieldDevice_ArrowBoard_ArrowBoardPattern> values = <FieldDevice_ArrowBoard_ArrowBoardPattern> [
    ARROW_BOARD_PATTERN_UNKNOWN,
    ARROW_BOARD_PATTERN_BLANK,
    ARROW_BOARD_PATTERN_RIGHT_ARROW_STATIC,
    ARROW_BOARD_PATTERN_RIGHT_ARROW_FLASHING,
    ARROW_BOARD_PATTERN_RIGHT_ARROW_SEQUENTIAL,
    ARROW_BOARD_PATTERN_RIGHT_CHEVRON_STATIC,
    ARROW_BOARD_PATTERN_RIGHT_CHEVRON_FLASHING,
    ARROW_BOARD_PATTERN_RIGHT_CHEVRON_SEQUENTIAL,
    ARROW_BOARD_PATTERN_LEFT_ARROW_STATIC,
    ARROW_BOARD_PATTERN_LEFT_ARROW_FLASHING,
    ARROW_BOARD_PATTERN_LEFT_ARROW_SEQUENTIAL,
    ARROW_BOARD_PATTERN_LEFT_CHEVRON_STATIC,
    ARROW_BOARD_PATTERN_LEFT_CHEVRON_FLASHING,
    ARROW_BOARD_PATTERN_LEFT_CHEVRON_SEQUENTIAL,
    ARROW_BOARD_PATTERN_BIDIRECTIONAL_ARROW_STATIC,
    ARROW_BOARD_PATTERN_BIDIRECTIONAL_ARROW_FLASHING,
    ARROW_BOARD_PATTERN_LINE_FLASHING,
    ARROW_BOARD_PATTERN_DIAMONDS_ALTERNATING,
    ARROW_BOARD_PATTERN_FOUR_CORNERS_FLASHING,
  ];

  static final $core.List<FieldDevice_ArrowBoard_ArrowBoardPattern?> _byValue = $pb.ProtobufEnum.$_initByValueList(values, 18);
  static FieldDevice_ArrowBoard_ArrowBoardPattern? valueOf($core.int value) =>  value < 0 || value >= _byValue.length ? null : _byValue[value];

  const FieldDevice_ArrowBoard_ArrowBoardPattern._(super.value, super.name);
}

class FieldDevice_FlashingBeacon_FlashingBeaconFunction extends $pb.ProtobufEnum {
  static const FieldDevice_FlashingBeacon_FlashingBeaconFunction FLASHING_BEACON_FUNCTION_UNKNOWN = FieldDevice_FlashingBeacon_FlashingBeaconFunction._(0, _omitEnumNames ? '' : 'FLASHING_BEACON_FUNCTION_UNKNOWN');
  static const FieldDevice_FlashingBeacon_FlashingBeaconFunction FLASHING_BEACON_FUNCTION_VEHICLE_ENTERING = FieldDevice_FlashingBeacon_FlashingBeaconFunction._(1, _omitEnumNames ? '' : 'FLASHING_BEACON_FUNCTION_VEHICLE_ENTERING');
  static const FieldDevice_FlashingBeacon_FlashingBeaconFunction FLASHING_BEACON_FUNCTION_QUEUE_WARNING = FieldDevice_FlashingBeacon_FlashingBeaconFunction._(2, _omitEnumNames ? '' : 'FLASHING_BEACON_FUNCTION_QUEUE_WARNING');
  static const FieldDevice_FlashingBeacon_FlashingBeaconFunction FLASHING_BEACON_FUNCTION_REDUCED_SPEED = FieldDevice_FlashingBeacon_FlashingBeaconFunction._(3, _omitEnumNames ? '' : 'FLASHING_BEACON_FUNCTION_REDUCED_SPEED');
  static const FieldDevice_FlashingBeacon_FlashingBeaconFunction FLASHING_BEACON_FUNCTION_WORKERS_PRESENT = FieldDevice_FlashingBeacon_FlashingBeaconFunction._(4, _omitEnumNames ? '' : 'FLASHING_BEACON_FUNCTION_WORKERS_PRESENT');

  static const $core.List<FieldDevice_FlashingBeacon_FlashingBeaconFunction> values = <FieldDevice_FlashingBeacon_FlashingBeaconFunction> [
    FLASHING_BEACON_FUNCTION_UNKNOWN,
    FLASHING_BEACON_FUNCTION_VEHICLE_ENTERING,
    FLASHING_BEACON_FUNCTION_QUEUE_WARNING,
    FLASHING_BEACON_FUNCTION_REDUCED_SPEED,
    FLASHING_BEACON_FUNCTION_WORKERS_PRESENT,
  ];

  static final $core.List<FieldDevice_FlashingBeacon_FlashingBeaconFunction?> _byValue = $pb.ProtobufEnum.$_initByValueList(values, 4);
  static FieldDevice_FlashingBeacon_FlashingBeaconFunction? valueOf($core.int value) =>  value < 0 || value >= _byValue.length ? null : _byValue[value];

  const FieldDevice_FlashingBeacon_FlashingBeaconFunction._(super.value, super.name);
}

class FieldDevice_HybridSign_HybridSignDynamicMessageFunction extends $pb.ProtobufEnum {
  static const FieldDevice_HybridSign_HybridSignDynamicMessageFunction HYBRID_SIGN_DYNAMIC_MESSAGE_FUNCTION_UNKNOWN = FieldDevice_HybridSign_HybridSignDynamicMessageFunction._(0, _omitEnumNames ? '' : 'HYBRID_SIGN_DYNAMIC_MESSAGE_FUNCTION_UNKNOWN');
  static const FieldDevice_HybridSign_HybridSignDynamicMessageFunction HYBRID_SIGN_DYNAMIC_MESSAGE_FUNCTION_SPEED_LIMIT = FieldDevice_HybridSign_HybridSignDynamicMessageFunction._(1, _omitEnumNames ? '' : 'HYBRID_SIGN_DYNAMIC_MESSAGE_FUNCTION_SPEED_LIMIT');
  static const FieldDevice_HybridSign_HybridSignDynamicMessageFunction HYBRID_SIGN_DYNAMIC_MESSAGE_FUNCTION_TRAVEL_TIME = FieldDevice_HybridSign_HybridSignDynamicMessageFunction._(2, _omitEnumNames ? '' : 'HYBRID_SIGN_DYNAMIC_MESSAGE_FUNCTION_TRAVEL_TIME');
  static const FieldDevice_HybridSign_HybridSignDynamicMessageFunction HYBRID_SIGN_DYNAMIC_MESSAGE_FUNCTION_OTHER = FieldDevice_HybridSign_HybridSignDynamicMessageFunction._(3, _omitEnumNames ? '' : 'HYBRID_SIGN_DYNAMIC_MESSAGE_FUNCTION_OTHER');

  static const $core.List<FieldDevice_HybridSign_HybridSignDynamicMessageFunction> values = <FieldDevice_HybridSign_HybridSignDynamicMessageFunction> [
    HYBRID_SIGN_DYNAMIC_MESSAGE_FUNCTION_UNKNOWN,
    HYBRID_SIGN_DYNAMIC_MESSAGE_FUNCTION_SPEED_LIMIT,
    HYBRID_SIGN_DYNAMIC_MESSAGE_FUNCTION_TRAVEL_TIME,
    HYBRID_SIGN_DYNAMIC_MESSAGE_FUNCTION_OTHER,
  ];

  static final $core.List<FieldDevice_HybridSign_HybridSignDynamicMessageFunction?> _byValue = $pb.ProtobufEnum.$_initByValueList(values, 3);
  static FieldDevice_HybridSign_HybridSignDynamicMessageFunction? valueOf($core.int value) =>  value < 0 || value >= _byValue.length ? null : _byValue[value];

  const FieldDevice_HybridSign_HybridSignDynamicMessageFunction._(super.value, super.name);
}

class FieldDevice_TrafficSignal_TrafficSignalMode extends $pb.ProtobufEnum {
  static const FieldDevice_TrafficSignal_TrafficSignalMode TRAFFIC_SIGNAL_MODE_UNKNOWN = FieldDevice_TrafficSignal_TrafficSignalMode._(0, _omitEnumNames ? '' : 'TRAFFIC_SIGNAL_MODE_UNKNOWN');
  static const FieldDevice_TrafficSignal_TrafficSignalMode TRAFFIC_SIGNAL_MODE_BLANK = FieldDevice_TrafficSignal_TrafficSignalMode._(1, _omitEnumNames ? '' : 'TRAFFIC_SIGNAL_MODE_BLANK');
  static const FieldDevice_TrafficSignal_TrafficSignalMode TRAFFIC_SIGNAL_MODE_FLASHING_RED = FieldDevice_TrafficSignal_TrafficSignalMode._(2, _omitEnumNames ? '' : 'TRAFFIC_SIGNAL_MODE_FLASHING_RED');
  static const FieldDevice_TrafficSignal_TrafficSignalMode TRAFFIC_SIGNAL_MODE_FLASHING_YELLOW = FieldDevice_TrafficSignal_TrafficSignalMode._(3, _omitEnumNames ? '' : 'TRAFFIC_SIGNAL_MODE_FLASHING_YELLOW');
  static const FieldDevice_TrafficSignal_TrafficSignalMode TRAFFIC_SIGNAL_MODE_FULLY_ACTUATED = FieldDevice_TrafficSignal_TrafficSignalMode._(4, _omitEnumNames ? '' : 'TRAFFIC_SIGNAL_MODE_FULLY_ACTUATED');
  static const FieldDevice_TrafficSignal_TrafficSignalMode TRAFFIC_SIGNAL_MODE_MANUAL = FieldDevice_TrafficSignal_TrafficSignalMode._(5, _omitEnumNames ? '' : 'TRAFFIC_SIGNAL_MODE_MANUAL');
  static const FieldDevice_TrafficSignal_TrafficSignalMode TRAFFIC_SIGNAL_MODE_PRE_TIMED = FieldDevice_TrafficSignal_TrafficSignalMode._(6, _omitEnumNames ? '' : 'TRAFFIC_SIGNAL_MODE_PRE_TIMED');
  static const FieldDevice_TrafficSignal_TrafficSignalMode TRAFFIC_SIGNAL_MODE_SEMI_ACTUATED = FieldDevice_TrafficSignal_TrafficSignalMode._(7, _omitEnumNames ? '' : 'TRAFFIC_SIGNAL_MODE_SEMI_ACTUATED');

  static const $core.List<FieldDevice_TrafficSignal_TrafficSignalMode> values = <FieldDevice_TrafficSignal_TrafficSignalMode> [
    TRAFFIC_SIGNAL_MODE_UNKNOWN,
    TRAFFIC_SIGNAL_MODE_BLANK,
    TRAFFIC_SIGNAL_MODE_FLASHING_RED,
    TRAFFIC_SIGNAL_MODE_FLASHING_YELLOW,
    TRAFFIC_SIGNAL_MODE_FULLY_ACTUATED,
    TRAFFIC_SIGNAL_MODE_MANUAL,
    TRAFFIC_SIGNAL_MODE_PRE_TIMED,
    TRAFFIC_SIGNAL_MODE_SEMI_ACTUATED,
  ];

  static final $core.List<FieldDevice_TrafficSignal_TrafficSignalMode?> _byValue = $pb.ProtobufEnum.$_initByValueList(values, 7);
  static FieldDevice_TrafficSignal_TrafficSignalMode? valueOf($core.int value) =>  value < 0 || value >= _byValue.length ? null : _byValue[value];

  const FieldDevice_TrafficSignal_TrafficSignalMode._(super.value, super.name);
}

class FieldDevice_MobileVehicle_VehicleOperationType extends $pb.ProtobufEnum {
  static const FieldDevice_MobileVehicle_VehicleOperationType VEHICLE_OPERATION_UNKNOWN = FieldDevice_MobileVehicle_VehicleOperationType._(0, _omitEnumNames ? '' : 'VEHICLE_OPERATION_UNKNOWN');
  static const FieldDevice_MobileVehicle_VehicleOperationType VEHICLE_OPERATION_STRIPING = FieldDevice_MobileVehicle_VehicleOperationType._(1, _omitEnumNames ? '' : 'VEHICLE_OPERATION_STRIPING');
  static const FieldDevice_MobileVehicle_VehicleOperationType VEHICLE_OPERATION_PLOWING = FieldDevice_MobileVehicle_VehicleOperationType._(2, _omitEnumNames ? '' : 'VEHICLE_OPERATION_PLOWING');
  static const FieldDevice_MobileVehicle_VehicleOperationType VEHICLE_OPERATION_MOWING = FieldDevice_MobileVehicle_VehicleOperationType._(3, _omitEnumNames ? '' : 'VEHICLE_OPERATION_MOWING');
  static const FieldDevice_MobileVehicle_VehicleOperationType VEHICLE_OPERATION_GENERAL_ACTIVE = FieldDevice_MobileVehicle_VehicleOperationType._(4, _omitEnumNames ? '' : 'VEHICLE_OPERATION_GENERAL_ACTIVE');
  static const FieldDevice_MobileVehicle_VehicleOperationType VEHICLE_OPERATION_GENERAL_INACTIVE = FieldDevice_MobileVehicle_VehicleOperationType._(5, _omitEnumNames ? '' : 'VEHICLE_OPERATION_GENERAL_INACTIVE');

  static const $core.List<FieldDevice_MobileVehicle_VehicleOperationType> values = <FieldDevice_MobileVehicle_VehicleOperationType> [
    VEHICLE_OPERATION_UNKNOWN,
    VEHICLE_OPERATION_STRIPING,
    VEHICLE_OPERATION_PLOWING,
    VEHICLE_OPERATION_MOWING,
    VEHICLE_OPERATION_GENERAL_ACTIVE,
    VEHICLE_OPERATION_GENERAL_INACTIVE,
  ];

  static final $core.List<FieldDevice_MobileVehicle_VehicleOperationType?> _byValue = $pb.ProtobufEnum.$_initByValueList(values, 5);
  static FieldDevice_MobileVehicle_VehicleOperationType? valueOf($core.int value) =>  value < 0 || value >= _byValue.length ? null : _byValue[value];

  const FieldDevice_MobileVehicle_VehicleOperationType._(super.value, super.name);
}

class FieldDevice_FieldWorker_OperationType extends $pb.ProtobufEnum {
  static const FieldDevice_FieldWorker_OperationType OPERATION_TYPE_UNKNOWN = FieldDevice_FieldWorker_OperationType._(0, _omitEnumNames ? '' : 'OPERATION_TYPE_UNKNOWN');
  static const FieldDevice_FieldWorker_OperationType OPERATION_TYPE_FLAGGER = FieldDevice_FieldWorker_OperationType._(1, _omitEnumNames ? '' : 'OPERATION_TYPE_FLAGGER');
  static const FieldDevice_FieldWorker_OperationType OPERATION_TYPE_WORKER = FieldDevice_FieldWorker_OperationType._(2, _omitEnumNames ? '' : 'OPERATION_TYPE_WORKER');
  static const FieldDevice_FieldWorker_OperationType OPERATION_TYPE_MOBILE_IN_VEHICLE = FieldDevice_FieldWorker_OperationType._(3, _omitEnumNames ? '' : 'OPERATION_TYPE_MOBILE_IN_VEHICLE');

  static const $core.List<FieldDevice_FieldWorker_OperationType> values = <FieldDevice_FieldWorker_OperationType> [
    OPERATION_TYPE_UNKNOWN,
    OPERATION_TYPE_FLAGGER,
    OPERATION_TYPE_WORKER,
    OPERATION_TYPE_MOBILE_IN_VEHICLE,
  ];

  static final $core.List<FieldDevice_FieldWorker_OperationType?> _byValue = $pb.ProtobufEnum.$_initByValueList(values, 3);
  static FieldDevice_FieldWorker_OperationType? valueOf($core.int value) =>  value < 0 || value >= _byValue.length ? null : _byValue[value];

  const FieldDevice_FieldWorker_OperationType._(super.value, super.name);
}


const $core.bool _omitEnumNames = $core.bool.fromEnvironment('protobuf.omit_enum_names');
