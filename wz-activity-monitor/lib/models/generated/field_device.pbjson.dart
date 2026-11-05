// This is a generated file - do not edit.
//
// Generated from field_device.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use fieldDeviceDescriptor instead')
const FieldDevice$json = {
  '1': 'FieldDevice',
  '2': [
    {'1': 'arrow_board', '3': 1, '4': 1, '5': 11, '6': '.datahub.v1.FieldDevice.ArrowBoard', '9': 0, '10': 'arrowBoard'},
    {'1': 'camera', '3': 2, '4': 1, '5': 11, '6': '.datahub.v1.FieldDevice.Camera', '9': 0, '10': 'camera'},
    {'1': 'dynamic_message_sign', '3': 3, '4': 1, '5': 11, '6': '.datahub.v1.FieldDevice.DynamicMessageSign', '9': 0, '10': 'dynamicMessageSign'},
    {'1': 'flashing_beacon', '3': 4, '4': 1, '5': 11, '6': '.datahub.v1.FieldDevice.FlashingBeacon', '9': 0, '10': 'flashingBeacon'},
    {'1': 'hybrid_sign', '3': 5, '4': 1, '5': 11, '6': '.datahub.v1.FieldDevice.HybridSign', '9': 0, '10': 'hybridSign'},
    {'1': 'location_marker', '3': 6, '4': 1, '5': 11, '6': '.datahub.v1.FieldDevice.LocationMarker', '9': 0, '10': 'locationMarker'},
    {'1': 'traffic_sensor', '3': 7, '4': 1, '5': 11, '6': '.datahub.v1.FieldDevice.TrafficSensor', '9': 0, '10': 'trafficSensor'},
    {'1': 'traffic_signal', '3': 8, '4': 1, '5': 11, '6': '.datahub.v1.FieldDevice.TrafficSignal', '9': 0, '10': 'trafficSignal'},
    {'1': 'mobile_vehicle', '3': 16, '4': 1, '5': 11, '6': '.datahub.v1.FieldDevice.MobileVehicle', '9': 0, '10': 'mobileVehicle'},
    {'1': 'field_worker', '3': 17, '4': 1, '5': 11, '6': '.datahub.v1.FieldDevice.FieldWorker', '9': 0, '10': 'fieldWorker'},
    {'1': 'id', '3': 18, '4': 1, '5': 9, '10': 'id'},
    {'1': 'project_id', '3': 10, '4': 1, '5': 4, '9': 1, '10': 'projectId', '17': true},
    {'1': 'road_event_id', '3': 11, '4': 1, '5': 4, '9': 2, '10': 'roadEventId', '17': true},
    {'1': 'location_type', '3': 12, '4': 1, '5': 14, '6': '.datahub.v1.MarkedLocationType', '10': 'locationType'},
    {'1': 'geometry', '3': 13, '4': 1, '5': 11, '6': '.datahub.v1.PointGeometry', '10': 'geometry'},
    {'1': 'bbox', '3': 14, '4': 1, '5': 11, '6': '.datahub.v1.BoundingBox', '9': 3, '10': 'bbox', '17': true},
    {'1': 'core_details', '3': 15, '4': 1, '5': 11, '6': '.datahub.v1.FieldDevice.FieldDeviceCoreDetails', '10': 'coreDetails'},
  ],
  '3': [FieldDevice_FieldDeviceCoreDetails$json, FieldDevice_ArrowBoard$json, FieldDevice_Camera$json, FieldDevice_DynamicMessageSign$json, FieldDevice_FlashingBeacon$json, FieldDevice_HybridSign$json, FieldDevice_LocationMarker$json, FieldDevice_TrafficSensor$json, FieldDevice_TrafficSignal$json, FieldDevice_MobileVehicle$json, FieldDevice_FieldWorker$json],
  '4': [FieldDevice_FieldDeviceStatus$json],
  '8': [
    {'1': 'Device'},
    {'1': '_project_id'},
    {'1': '_road_event_id'},
    {'1': '_bbox'},
  ],
  '9': [
    {'1': 9, '2': 10},
  ],
};

@$core.Deprecated('Use fieldDeviceDescriptor instead')
const FieldDevice_FieldDeviceCoreDetails$json = {
  '1': 'FieldDeviceCoreDetails',
  '2': [
    {'1': 'device_status', '3': 1, '4': 1, '5': 14, '6': '.datahub.v1.FieldDevice.FieldDeviceStatus', '10': 'deviceStatus'},
    {'1': 'has_automatic_location', '3': 2, '4': 1, '5': 8, '10': 'hasAutomaticLocation'},
    {'1': 'road_direction', '3': 3, '4': 1, '5': 14, '6': '.datahub.v1.RoadwayDirection', '9': 0, '10': 'roadDirection', '17': true},
    {'1': 'road_names', '3': 4, '4': 3, '5': 9, '10': 'roadNames'},
    {'1': 'name', '3': 5, '4': 1, '5': 9, '10': 'name'},
    {'1': 'description', '3': 6, '4': 1, '5': 9, '9': 1, '10': 'description', '17': true},
    {'1': 'status_messages', '3': 7, '4': 3, '5': 9, '10': 'statusMessages'},
    {'1': 'is_moving', '3': 8, '4': 1, '5': 8, '10': 'isMoving'},
    {'1': 'milepost', '3': 12, '4': 1, '5': 1, '9': 2, '10': 'milepost', '17': true},
    {'1': 'make', '3': 13, '4': 1, '5': 9, '10': 'make'},
    {'1': 'model', '3': 14, '4': 1, '5': 9, '10': 'model'},
    {'1': 'serial_number', '3': 15, '4': 1, '5': 9, '10': 'serialNumber'},
    {'1': 'firmware_version', '3': 16, '4': 1, '5': 9, '9': 3, '10': 'firmwareVersion', '17': true},
    {'1': 'velocity_kph', '3': 17, '4': 1, '5': 1, '9': 4, '10': 'velocityKph', '17': true},
  ],
  '8': [
    {'1': '_road_direction'},
    {'1': '_description'},
    {'1': '_milepost'},
    {'1': '_firmware_version'},
    {'1': '_velocity_kph'},
  ],
};

@$core.Deprecated('Use fieldDeviceDescriptor instead')
const FieldDevice_ArrowBoard$json = {
  '1': 'ArrowBoard',
  '2': [
    {'1': 'pattern', '3': 2, '4': 1, '5': 14, '6': '.datahub.v1.FieldDevice.ArrowBoard.ArrowBoardPattern', '10': 'pattern'},
    {'1': 'is_in_transport_position', '3': 4, '4': 1, '5': 14, '6': '.datahub.v1.FieldDevice.ArrowBoard.ArrowBoardTransportPosition', '10': 'isInTransportPosition'},
  ],
  '4': [FieldDevice_ArrowBoard_ArrowBoardTransportPosition$json, FieldDevice_ArrowBoard_ArrowBoardPattern$json],
  '9': [
    {'1': 1, '2': 2},
    {'1': 3, '2': 4},
  ],
};

@$core.Deprecated('Use fieldDeviceDescriptor instead')
const FieldDevice_ArrowBoard_ArrowBoardTransportPosition$json = {
  '1': 'ArrowBoardTransportPosition',
  '2': [
    {'1': 'ARROW_BOARD_TRANSPORT_POSITION_UNKNOWN', '2': 0},
    {'1': 'ARROW_BOARD_TRANSPORT_POSITION_STOWED', '2': 1},
    {'1': 'ARROW_BOARD_TRANSPORT_POSITION_DEPLOYED', '2': 2},
  ],
};

@$core.Deprecated('Use fieldDeviceDescriptor instead')
const FieldDevice_ArrowBoard_ArrowBoardPattern$json = {
  '1': 'ArrowBoardPattern',
  '2': [
    {'1': 'ARROW_BOARD_PATTERN_UNKNOWN', '2': 0},
    {'1': 'ARROW_BOARD_PATTERN_BLANK', '2': 1},
    {'1': 'ARROW_BOARD_PATTERN_RIGHT_ARROW_STATIC', '2': 2},
    {'1': 'ARROW_BOARD_PATTERN_RIGHT_ARROW_FLASHING', '2': 3},
    {'1': 'ARROW_BOARD_PATTERN_RIGHT_ARROW_SEQUENTIAL', '2': 4},
    {'1': 'ARROW_BOARD_PATTERN_RIGHT_CHEVRON_STATIC', '2': 5},
    {'1': 'ARROW_BOARD_PATTERN_RIGHT_CHEVRON_FLASHING', '2': 6},
    {'1': 'ARROW_BOARD_PATTERN_RIGHT_CHEVRON_SEQUENTIAL', '2': 7},
    {'1': 'ARROW_BOARD_PATTERN_LEFT_ARROW_STATIC', '2': 8},
    {'1': 'ARROW_BOARD_PATTERN_LEFT_ARROW_FLASHING', '2': 9},
    {'1': 'ARROW_BOARD_PATTERN_LEFT_ARROW_SEQUENTIAL', '2': 10},
    {'1': 'ARROW_BOARD_PATTERN_LEFT_CHEVRON_STATIC', '2': 11},
    {'1': 'ARROW_BOARD_PATTERN_LEFT_CHEVRON_FLASHING', '2': 12},
    {'1': 'ARROW_BOARD_PATTERN_LEFT_CHEVRON_SEQUENTIAL', '2': 13},
    {'1': 'ARROW_BOARD_PATTERN_BIDIRECTIONAL_ARROW_STATIC', '2': 14},
    {'1': 'ARROW_BOARD_PATTERN_BIDIRECTIONAL_ARROW_FLASHING', '2': 15},
    {'1': 'ARROW_BOARD_PATTERN_LINE_FLASHING', '2': 16},
    {'1': 'ARROW_BOARD_PATTERN_DIAMONDS_ALTERNATING', '2': 17},
    {'1': 'ARROW_BOARD_PATTERN_FOUR_CORNERS_FLASHING', '2': 18},
  ],
};

@$core.Deprecated('Use fieldDeviceDescriptor instead')
const FieldDevice_Camera$json = {
  '1': 'Camera',
  '2': [
    {'1': 'image_url', '3': 2, '4': 1, '5': 9, '9': 0, '10': 'imageUrl', '17': true},
    {'1': 'image_timestamp', '3': 3, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '9': 1, '10': 'imageTimestamp', '17': true},
  ],
  '8': [
    {'1': '_image_url'},
    {'1': '_image_timestamp'},
  ],
  '9': [
    {'1': 1, '2': 2},
  ],
};

@$core.Deprecated('Use fieldDeviceDescriptor instead')
const FieldDevice_DynamicMessageSign$json = {
  '1': 'DynamicMessageSign',
  '2': [
    {'1': 'message_multi_string', '3': 2, '4': 1, '5': 9, '10': 'messageMultiString'},
  ],
  '9': [
    {'1': 1, '2': 2},
  ],
};

@$core.Deprecated('Use fieldDeviceDescriptor instead')
const FieldDevice_FlashingBeacon$json = {
  '1': 'FlashingBeacon',
  '2': [
    {'1': 'function', '3': 2, '4': 1, '5': 14, '6': '.datahub.v1.FieldDevice.FlashingBeacon.FlashingBeaconFunction', '10': 'function'},
    {'1': 'is_flashing', '3': 3, '4': 1, '5': 8, '9': 0, '10': 'isFlashing', '17': true},
    {'1': 'sign_text', '3': 4, '4': 1, '5': 9, '9': 1, '10': 'signText', '17': true},
  ],
  '4': [FieldDevice_FlashingBeacon_FlashingBeaconFunction$json],
  '8': [
    {'1': '_is_flashing'},
    {'1': '_sign_text'},
  ],
  '9': [
    {'1': 1, '2': 2},
  ],
};

@$core.Deprecated('Use fieldDeviceDescriptor instead')
const FieldDevice_FlashingBeacon_FlashingBeaconFunction$json = {
  '1': 'FlashingBeaconFunction',
  '2': [
    {'1': 'FLASHING_BEACON_FUNCTION_UNKNOWN', '2': 0},
    {'1': 'FLASHING_BEACON_FUNCTION_VEHICLE_ENTERING', '2': 1},
    {'1': 'FLASHING_BEACON_FUNCTION_QUEUE_WARNING', '2': 2},
    {'1': 'FLASHING_BEACON_FUNCTION_REDUCED_SPEED', '2': 3},
    {'1': 'FLASHING_BEACON_FUNCTION_WORKERS_PRESENT', '2': 4},
  ],
};

@$core.Deprecated('Use fieldDeviceDescriptor instead')
const FieldDevice_HybridSign$json = {
  '1': 'HybridSign',
  '2': [
    {'1': 'dynamic_message_function', '3': 2, '4': 1, '5': 14, '6': '.datahub.v1.FieldDevice.HybridSign.HybridSignDynamicMessageFunction', '10': 'dynamicMessageFunction'},
    {'1': 'dynamic_message_text', '3': 3, '4': 1, '5': 9, '9': 0, '10': 'dynamicMessageText', '17': true},
    {'1': 'static_sign_text', '3': 4, '4': 1, '5': 9, '9': 1, '10': 'staticSignText', '17': true},
  ],
  '4': [FieldDevice_HybridSign_HybridSignDynamicMessageFunction$json],
  '8': [
    {'1': '_dynamic_message_text'},
    {'1': '_static_sign_text'},
  ],
  '9': [
    {'1': 1, '2': 2},
  ],
};

@$core.Deprecated('Use fieldDeviceDescriptor instead')
const FieldDevice_HybridSign_HybridSignDynamicMessageFunction$json = {
  '1': 'HybridSignDynamicMessageFunction',
  '2': [
    {'1': 'HYBRID_SIGN_DYNAMIC_MESSAGE_FUNCTION_UNKNOWN', '2': 0},
    {'1': 'HYBRID_SIGN_DYNAMIC_MESSAGE_FUNCTION_SPEED_LIMIT', '2': 1},
    {'1': 'HYBRID_SIGN_DYNAMIC_MESSAGE_FUNCTION_TRAVEL_TIME', '2': 2},
    {'1': 'HYBRID_SIGN_DYNAMIC_MESSAGE_FUNCTION_OTHER', '2': 3},
  ],
};

@$core.Deprecated('Use fieldDeviceDescriptor instead')
const FieldDevice_LocationMarker$json = {
  '1': 'LocationMarker',
  '9': [
    {'1': 1, '2': 2},
  ],
};

@$core.Deprecated('Use fieldDeviceDescriptor instead')
const FieldDevice_TrafficSensor$json = {
  '1': 'TrafficSensor',
  '2': [
    {'1': 'collection_interval_start_date', '3': 2, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'collectionIntervalStartDate'},
    {'1': 'collection_interval_end_date', '3': 3, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'collectionIntervalEndDate'},
    {'1': 'average_speed_kph', '3': 4, '4': 1, '5': 1, '9': 0, '10': 'averageSpeedKph', '17': true},
    {'1': 'volume_kph', '3': 5, '4': 1, '5': 1, '9': 1, '10': 'volumeKph', '17': true},
    {'1': 'occupancy_percent', '3': 6, '4': 1, '5': 1, '9': 2, '10': 'occupancyPercent', '17': true},
    {'1': 'lane_data', '3': 7, '4': 3, '5': 11, '6': '.datahub.v1.FieldDevice.TrafficSensor.TrafficSensorLaneData', '10': 'laneData'},
  ],
  '3': [FieldDevice_TrafficSensor_TrafficSensorLaneData$json],
  '8': [
    {'1': '_average_speed_kph'},
    {'1': '_volume_kph'},
    {'1': '_occupancy_percent'},
  ],
  '9': [
    {'1': 1, '2': 2},
  ],
};

@$core.Deprecated('Use fieldDeviceDescriptor instead')
const FieldDevice_TrafficSensor_TrafficSensorLaneData$json = {
  '1': 'TrafficSensorLaneData',
  '2': [
    {'1': 'lane_order', '3': 1, '4': 1, '5': 13, '10': 'laneOrder'},
    {'1': 'road_event_id', '3': 2, '4': 1, '5': 4, '10': 'roadEventId'},
    {'1': 'average_speed_kph', '3': 3, '4': 1, '5': 1, '10': 'averageSpeedKph'},
    {'1': 'volume_kph', '3': 4, '4': 1, '5': 1, '10': 'volumeKph'},
    {'1': 'occupancy_percent', '3': 5, '4': 1, '5': 1, '10': 'occupancyPercent'},
  ],
};

@$core.Deprecated('Use fieldDeviceDescriptor instead')
const FieldDevice_TrafficSignal$json = {
  '1': 'TrafficSignal',
  '2': [
    {'1': 'mode', '3': 2, '4': 1, '5': 14, '6': '.datahub.v1.FieldDevice.TrafficSignal.TrafficSignalMode', '10': 'mode'},
  ],
  '4': [FieldDevice_TrafficSignal_TrafficSignalMode$json],
  '9': [
    {'1': 1, '2': 2},
  ],
};

@$core.Deprecated('Use fieldDeviceDescriptor instead')
const FieldDevice_TrafficSignal_TrafficSignalMode$json = {
  '1': 'TrafficSignalMode',
  '2': [
    {'1': 'TRAFFIC_SIGNAL_MODE_UNKNOWN', '2': 0},
    {'1': 'TRAFFIC_SIGNAL_MODE_BLANK', '2': 1},
    {'1': 'TRAFFIC_SIGNAL_MODE_FLASHING_RED', '2': 2},
    {'1': 'TRAFFIC_SIGNAL_MODE_FLASHING_YELLOW', '2': 3},
    {'1': 'TRAFFIC_SIGNAL_MODE_FULLY_ACTUATED', '2': 4},
    {'1': 'TRAFFIC_SIGNAL_MODE_MANUAL', '2': 5},
    {'1': 'TRAFFIC_SIGNAL_MODE_PRE_TIMED', '2': 6},
    {'1': 'TRAFFIC_SIGNAL_MODE_SEMI_ACTUATED', '2': 7},
  ],
};

@$core.Deprecated('Use fieldDeviceDescriptor instead')
const FieldDevice_MobileVehicle$json = {
  '1': 'MobileVehicle',
  '2': [
    {'1': 'operation_type', '3': 1, '4': 1, '5': 14, '6': '.datahub.v1.FieldDevice.MobileVehicle.VehicleOperationType', '10': 'operationType'},
    {'1': 'license_plate', '3': 2, '4': 1, '5': 9, '10': 'licensePlate'},
    {'1': 'heading', '3': 3, '4': 1, '5': 13, '10': 'heading'},
  ],
  '4': [FieldDevice_MobileVehicle_VehicleOperationType$json],
};

@$core.Deprecated('Use fieldDeviceDescriptor instead')
const FieldDevice_MobileVehicle_VehicleOperationType$json = {
  '1': 'VehicleOperationType',
  '2': [
    {'1': 'VEHICLE_OPERATION_UNKNOWN', '2': 0},
    {'1': 'VEHICLE_OPERATION_STRIPING', '2': 1},
    {'1': 'VEHICLE_OPERATION_PLOWING', '2': 2},
    {'1': 'VEHICLE_OPERATION_MOWING', '2': 3},
    {'1': 'VEHICLE_OPERATION_GENERAL_ACTIVE', '2': 4},
    {'1': 'VEHICLE_OPERATION_GENERAL_INACTIVE', '2': 5},
  ],
};

@$core.Deprecated('Use fieldDeviceDescriptor instead')
const FieldDevice_FieldWorker$json = {
  '1': 'FieldWorker',
  '2': [
    {'1': 'operation_type', '3': 1, '4': 1, '5': 14, '6': '.datahub.v1.FieldDevice.FieldWorker.OperationType', '10': 'operationType'},
  ],
  '4': [FieldDevice_FieldWorker_OperationType$json],
};

@$core.Deprecated('Use fieldDeviceDescriptor instead')
const FieldDevice_FieldWorker_OperationType$json = {
  '1': 'OperationType',
  '2': [
    {'1': 'OPERATION_TYPE_UNKNOWN', '2': 0},
    {'1': 'OPERATION_TYPE_FLAGGER', '2': 1},
    {'1': 'OPERATION_TYPE_WORKER', '2': 2},
    {'1': 'OPERATION_TYPE_MOBILE_IN_VEHICLE', '2': 3},
  ],
};

@$core.Deprecated('Use fieldDeviceDescriptor instead')
const FieldDevice_FieldDeviceStatus$json = {
  '1': 'FieldDeviceStatus',
  '2': [
    {'1': 'FIELD_DEVICE_STATUS_UNKNOWN', '2': 0},
    {'1': 'FIELD_DEVICE_STATUS_OK', '2': 1},
    {'1': 'FIELD_DEVICE_STATUS_WARNING', '2': 2},
    {'1': 'FIELD_DEVICE_STATUS_ERROR', '2': 3},
    {'1': 'FIELD_DEVICE_STATUS_OFFLINE', '2': 4},
    {'1': 'FIELD_DEVICE_STATUS_INACTIVE', '2': 5},
  ],
};

/// Descriptor for `FieldDevice`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List fieldDeviceDescriptor = $convert.base64Decode(
    'CgtGaWVsZERldmljZRJFCgthcnJvd19ib2FyZBgBIAEoCzIiLmRhdGFodWIudjEuRmllbGREZX'
    'ZpY2UuQXJyb3dCb2FyZEgAUgphcnJvd0JvYXJkEjgKBmNhbWVyYRgCIAEoCzIeLmRhdGFodWIu'
    'djEuRmllbGREZXZpY2UuQ2FtZXJhSABSBmNhbWVyYRJeChRkeW5hbWljX21lc3NhZ2Vfc2lnbh'
    'gDIAEoCzIqLmRhdGFodWIudjEuRmllbGREZXZpY2UuRHluYW1pY01lc3NhZ2VTaWduSABSEmR5'
    'bmFtaWNNZXNzYWdlU2lnbhJRCg9mbGFzaGluZ19iZWFjb24YBCABKAsyJi5kYXRhaHViLnYxLk'
    'ZpZWxkRGV2aWNlLkZsYXNoaW5nQmVhY29uSABSDmZsYXNoaW5nQmVhY29uEkUKC2h5YnJpZF9z'
    'aWduGAUgASgLMiIuZGF0YWh1Yi52MS5GaWVsZERldmljZS5IeWJyaWRTaWduSABSCmh5YnJpZF'
    'NpZ24SUQoPbG9jYXRpb25fbWFya2VyGAYgASgLMiYuZGF0YWh1Yi52MS5GaWVsZERldmljZS5M'
    'b2NhdGlvbk1hcmtlckgAUg5sb2NhdGlvbk1hcmtlchJOCg50cmFmZmljX3NlbnNvchgHIAEoCz'
    'IlLmRhdGFodWIudjEuRmllbGREZXZpY2UuVHJhZmZpY1NlbnNvckgAUg10cmFmZmljU2Vuc29y'
    'Ek4KDnRyYWZmaWNfc2lnbmFsGAggASgLMiUuZGF0YWh1Yi52MS5GaWVsZERldmljZS5UcmFmZm'
    'ljU2lnbmFsSABSDXRyYWZmaWNTaWduYWwSTgoObW9iaWxlX3ZlaGljbGUYECABKAsyJS5kYXRh'
    'aHViLnYxLkZpZWxkRGV2aWNlLk1vYmlsZVZlaGljbGVIAFINbW9iaWxlVmVoaWNsZRJICgxmaW'
    'VsZF93b3JrZXIYESABKAsyIy5kYXRhaHViLnYxLkZpZWxkRGV2aWNlLkZpZWxkV29ya2VySABS'
    'C2ZpZWxkV29ya2VyEg4KAmlkGBIgASgJUgJpZBIiCgpwcm9qZWN0X2lkGAogASgESAFSCXByb2'
    'plY3RJZIgBARInCg1yb2FkX2V2ZW50X2lkGAsgASgESAJSC3JvYWRFdmVudElkiAEBEkMKDWxv'
    'Y2F0aW9uX3R5cGUYDCABKA4yHi5kYXRhaHViLnYxLk1hcmtlZExvY2F0aW9uVHlwZVIMbG9jYX'
    'Rpb25UeXBlEjUKCGdlb21ldHJ5GA0gASgLMhkuZGF0YWh1Yi52MS5Qb2ludEdlb21ldHJ5Ughn'
    'ZW9tZXRyeRIwCgRiYm94GA4gASgLMhcuZGF0YWh1Yi52MS5Cb3VuZGluZ0JveEgDUgRiYm94iA'
    'EBElEKDGNvcmVfZGV0YWlscxgPIAEoCzIuLmRhdGFodWIudjEuRmllbGREZXZpY2UuRmllbGRE'
    'ZXZpY2VDb3JlRGV0YWlsc1ILY29yZURldGFpbHMapgUKFkZpZWxkRGV2aWNlQ29yZURldGFpbH'
    'MSTgoNZGV2aWNlX3N0YXR1cxgBIAEoDjIpLmRhdGFodWIudjEuRmllbGREZXZpY2UuRmllbGRE'
    'ZXZpY2VTdGF0dXNSDGRldmljZVN0YXR1cxI0ChZoYXNfYXV0b21hdGljX2xvY2F0aW9uGAIgAS'
    'gIUhRoYXNBdXRvbWF0aWNMb2NhdGlvbhJICg5yb2FkX2RpcmVjdGlvbhgDIAEoDjIcLmRhdGFo'
    'dWIudjEuUm9hZHdheURpcmVjdGlvbkgAUg1yb2FkRGlyZWN0aW9uiAEBEh0KCnJvYWRfbmFtZX'
    'MYBCADKAlSCXJvYWROYW1lcxISCgRuYW1lGAUgASgJUgRuYW1lEiUKC2Rlc2NyaXB0aW9uGAYg'
    'ASgJSAFSC2Rlc2NyaXB0aW9uiAEBEicKD3N0YXR1c19tZXNzYWdlcxgHIAMoCVIOc3RhdHVzTW'
    'Vzc2FnZXMSGwoJaXNfbW92aW5nGAggASgIUghpc01vdmluZxIfCghtaWxlcG9zdBgMIAEoAUgC'
    'UghtaWxlcG9zdIgBARISCgRtYWtlGA0gASgJUgRtYWtlEhQKBW1vZGVsGA4gASgJUgVtb2RlbB'
    'IjCg1zZXJpYWxfbnVtYmVyGA8gASgJUgxzZXJpYWxOdW1iZXISLgoQZmlybXdhcmVfdmVyc2lv'
    'bhgQIAEoCUgDUg9maXJtd2FyZVZlcnNpb26IAQESJgoMdmVsb2NpdHlfa3BoGBEgASgBSARSC3'
    'ZlbG9jaXR5S3BoiAEBQhEKD19yb2FkX2RpcmVjdGlvbkIOCgxfZGVzY3JpcHRpb25CCwoJX21p'
    'bGVwb3N0QhMKEV9maXJtd2FyZV92ZXJzaW9uQg8KDV92ZWxvY2l0eV9rcGga9wkKCkFycm93Qm'
    '9hcmQSTgoHcGF0dGVybhgCIAEoDjI0LmRhdGFodWIudjEuRmllbGREZXZpY2UuQXJyb3dCb2Fy'
    'ZC5BcnJvd0JvYXJkUGF0dGVyblIHcGF0dGVybhJ3Chhpc19pbl90cmFuc3BvcnRfcG9zaXRpb2'
    '4YBCABKA4yPi5kYXRhaHViLnYxLkZpZWxkRGV2aWNlLkFycm93Qm9hcmQuQXJyb3dCb2FyZFRy'
    'YW5zcG9ydFBvc2l0aW9uUhVpc0luVHJhbnNwb3J0UG9zaXRpb24ioQEKG0Fycm93Qm9hcmRUcm'
    'Fuc3BvcnRQb3NpdGlvbhIqCiZBUlJPV19CT0FSRF9UUkFOU1BPUlRfUE9TSVRJT05fVU5LTk9X'
    'ThAAEikKJUFSUk9XX0JPQVJEX1RSQU5TUE9SVF9QT1NJVElPTl9TVE9XRUQQARIrCidBUlJPV1'
    '9CT0FSRF9UUkFOU1BPUlRfUE9TSVRJT05fREVQTE9ZRUQQAiLvBgoRQXJyb3dCb2FyZFBhdHRl'
    'cm4SHwobQVJST1dfQk9BUkRfUEFUVEVSTl9VTktOT1dOEAASHQoZQVJST1dfQk9BUkRfUEFUVE'
    'VSTl9CTEFOSxABEioKJkFSUk9XX0JPQVJEX1BBVFRFUk5fUklHSFRfQVJST1dfU1RBVElDEAIS'
    'LAooQVJST1dfQk9BUkRfUEFUVEVSTl9SSUdIVF9BUlJPV19GTEFTSElORxADEi4KKkFSUk9XX0'
    'JPQVJEX1BBVFRFUk5fUklHSFRfQVJST1dfU0VRVUVOVElBTBAEEiwKKEFSUk9XX0JPQVJEX1BB'
    'VFRFUk5fUklHSFRfQ0hFVlJPTl9TVEFUSUMQBRIuCipBUlJPV19CT0FSRF9QQVRURVJOX1JJR0'
    'hUX0NIRVZST05fRkxBU0hJTkcQBhIwCixBUlJPV19CT0FSRF9QQVRURVJOX1JJR0hUX0NIRVZS'
    'T05fU0VRVUVOVElBTBAHEikKJUFSUk9XX0JPQVJEX1BBVFRFUk5fTEVGVF9BUlJPV19TVEFUSU'
    'MQCBIrCidBUlJPV19CT0FSRF9QQVRURVJOX0xFRlRfQVJST1dfRkxBU0hJTkcQCRItCilBUlJP'
    'V19CT0FSRF9QQVRURVJOX0xFRlRfQVJST1dfU0VRVUVOVElBTBAKEisKJ0FSUk9XX0JPQVJEX1'
    'BBVFRFUk5fTEVGVF9DSEVWUk9OX1NUQVRJQxALEi0KKUFSUk9XX0JPQVJEX1BBVFRFUk5fTEVG'
    'VF9DSEVWUk9OX0ZMQVNISU5HEAwSLworQVJST1dfQk9BUkRfUEFUVEVSTl9MRUZUX0NIRVZST0'
    '5fU0VRVUVOVElBTBANEjIKLkFSUk9XX0JPQVJEX1BBVFRFUk5fQklESVJFQ1RJT05BTF9BUlJP'
    'V19TVEFUSUMQDhI0CjBBUlJPV19CT0FSRF9QQVRURVJOX0JJRElSRUNUSU9OQUxfQVJST1dfRk'
    'xBU0hJTkcQDxIlCiFBUlJPV19CT0FSRF9QQVRURVJOX0xJTkVfRkxBU0hJTkcQEBIsCihBUlJP'
    'V19CT0FSRF9QQVRURVJOX0RJQU1PTkRTX0FMVEVSTkFUSU5HEBESLQopQVJST1dfQk9BUkRfUE'
    'FUVEVSTl9GT1VSX0NPUk5FUlNfRkxBU0hJTkcQEkoECAEQAkoECAMQBBqcAQoGQ2FtZXJhEiAK'
    'CWltYWdlX3VybBgCIAEoCUgAUghpbWFnZVVybIgBARJICg9pbWFnZV90aW1lc3RhbXAYAyABKA'
    'syGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wSAFSDmltYWdlVGltZXN0YW1wiAEBQgwKCl9p'
    'bWFnZV91cmxCEgoQX2ltYWdlX3RpbWVzdGFtcEoECAEQAhpMChJEeW5hbWljTWVzc2FnZVNpZ2'
    '4SMAoUbWVzc2FnZV9tdWx0aV9zdHJpbmcYAiABKAlSEm1lc3NhZ2VNdWx0aVN0cmluZ0oECAEQ'
    'AhrNAwoORmxhc2hpbmdCZWFjb24SWQoIZnVuY3Rpb24YAiABKA4yPS5kYXRhaHViLnYxLkZpZW'
    'xkRGV2aWNlLkZsYXNoaW5nQmVhY29uLkZsYXNoaW5nQmVhY29uRnVuY3Rpb25SCGZ1bmN0aW9u'
    'EiQKC2lzX2ZsYXNoaW5nGAMgASgISABSCmlzRmxhc2hpbmeIAQESIAoJc2lnbl90ZXh0GAQgAS'
    'gJSAFSCHNpZ25UZXh0iAEBIvMBChZGbGFzaGluZ0JlYWNvbkZ1bmN0aW9uEiQKIEZMQVNISU5H'
    'X0JFQUNPTl9GVU5DVElPTl9VTktOT1dOEAASLQopRkxBU0hJTkdfQkVBQ09OX0ZVTkNUSU9OX1'
    'ZFSElDTEVfRU5URVJJTkcQARIqCiZGTEFTSElOR19CRUFDT05fRlVOQ1RJT05fUVVFVUVfV0FS'
    'TklORxACEioKJkZMQVNISU5HX0JFQUNPTl9GVU5DVElPTl9SRURVQ0VEX1NQRUVEEAMSLAooRk'
    'xBU0hJTkdfQkVBQ09OX0ZVTkNUSU9OX1dPUktFUlNfUFJFU0VOVBAEQg4KDF9pc19mbGFzaGlu'
    'Z0IMCgpfc2lnbl90ZXh0SgQIARACGpgECgpIeWJyaWRTaWduEn0KGGR5bmFtaWNfbWVzc2FnZV'
    '9mdW5jdGlvbhgCIAEoDjJDLmRhdGFodWIudjEuRmllbGREZXZpY2UuSHlicmlkU2lnbi5IeWJy'
    'aWRTaWduRHluYW1pY01lc3NhZ2VGdW5jdGlvblIWZHluYW1pY01lc3NhZ2VGdW5jdGlvbhI1Ch'
    'RkeW5hbWljX21lc3NhZ2VfdGV4dBgDIAEoCUgAUhJkeW5hbWljTWVzc2FnZVRleHSIAQESLQoQ'
    'c3RhdGljX3NpZ25fdGV4dBgEIAEoCUgBUg5zdGF0aWNTaWduVGV4dIgBASLwAQogSHlicmlkU2'
    'lnbkR5bmFtaWNNZXNzYWdlRnVuY3Rpb24SMAosSFlCUklEX1NJR05fRFlOQU1JQ19NRVNTQUdF'
    'X0ZVTkNUSU9OX1VOS05PV04QABI0CjBIWUJSSURfU0lHTl9EWU5BTUlDX01FU1NBR0VfRlVOQ1'
    'RJT05fU1BFRURfTElNSVQQARI0CjBIWUJSSURfU0lHTl9EWU5BTUlDX01FU1NBR0VfRlVOQ1RJ'
    'T05fVFJBVkVMX1RJTUUQAhIuCipIWUJSSURfU0lHTl9EWU5BTUlDX01FU1NBR0VfRlVOQ1RJT0'
    '5fT1RIRVIQA0IXChVfZHluYW1pY19tZXNzYWdlX3RleHRCEwoRX3N0YXRpY19zaWduX3RleHRK'
    'BAgBEAIaFgoOTG9jYXRpb25NYXJrZXJKBAgBEAIaxAUKDVRyYWZmaWNTZW5zb3ISXwoeY29sbG'
    'VjdGlvbl9pbnRlcnZhbF9zdGFydF9kYXRlGAIgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVz'
    'dGFtcFIbY29sbGVjdGlvbkludGVydmFsU3RhcnREYXRlElsKHGNvbGxlY3Rpb25faW50ZXJ2YW'
    'xfZW5kX2RhdGUYAyABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUhljb2xsZWN0aW9u'
    'SW50ZXJ2YWxFbmREYXRlEi8KEWF2ZXJhZ2Vfc3BlZWRfa3BoGAQgASgBSABSD2F2ZXJhZ2VTcG'
    'VlZEtwaIgBARIiCgp2b2x1bWVfa3BoGAUgASgBSAFSCXZvbHVtZUtwaIgBARIwChFvY2N1cGFu'
    'Y3lfcGVyY2VudBgGIAEoAUgCUhBvY2N1cGFuY3lQZXJjZW50iAEBElgKCWxhbmVfZGF0YRgHIA'
    'MoCzI7LmRhdGFodWIudjEuRmllbGREZXZpY2UuVHJhZmZpY1NlbnNvci5UcmFmZmljU2Vuc29y'
    'TGFuZURhdGFSCGxhbmVEYXRhGtIBChVUcmFmZmljU2Vuc29yTGFuZURhdGESHQoKbGFuZV9vcm'
    'RlchgBIAEoDVIJbGFuZU9yZGVyEiIKDXJvYWRfZXZlbnRfaWQYAiABKARSC3JvYWRFdmVudElk'
    'EioKEWF2ZXJhZ2Vfc3BlZWRfa3BoGAMgASgBUg9hdmVyYWdlU3BlZWRLcGgSHQoKdm9sdW1lX2'
    'twaBgEIAEoAVIJdm9sdW1lS3BoEisKEW9jY3VwYW5jeV9wZXJjZW50GAUgASgBUhBvY2N1cGFu'
    'Y3lQZXJjZW50QhQKEl9hdmVyYWdlX3NwZWVkX2twaEINCgtfdm9sdW1lX2twaEIUChJfb2NjdX'
    'BhbmN5X3BlcmNlbnRKBAgBEAIamQMKDVRyYWZmaWNTaWduYWwSSwoEbW9kZRgCIAEoDjI3LmRh'
    'dGFodWIudjEuRmllbGREZXZpY2UuVHJhZmZpY1NpZ25hbC5UcmFmZmljU2lnbmFsTW9kZVIEbW'
    '9kZSK0AgoRVHJhZmZpY1NpZ25hbE1vZGUSHwobVFJBRkZJQ19TSUdOQUxfTU9ERV9VTktOT1dO'
    'EAASHQoZVFJBRkZJQ19TSUdOQUxfTU9ERV9CTEFOSxABEiQKIFRSQUZGSUNfU0lHTkFMX01PRE'
    'VfRkxBU0hJTkdfUkVEEAISJwojVFJBRkZJQ19TSUdOQUxfTU9ERV9GTEFTSElOR19ZRUxMT1cQ'
    'AxImCiJUUkFGRklDX1NJR05BTF9NT0RFX0ZVTExZX0FDVFVBVEVEEAQSHgoaVFJBRkZJQ19TSU'
    'dOQUxfTU9ERV9NQU5VQUwQBRIhCh1UUkFGRklDX1NJR05BTF9NT0RFX1BSRV9USU1FRBAGEiUK'
    'IVRSQUZGSUNfU0lHTkFMX01PREVfU0VNSV9BQ1RVQVRFRBAHSgQIARACGpQDCg1Nb2JpbGVWZW'
    'hpY2xlEmEKDm9wZXJhdGlvbl90eXBlGAEgASgOMjouZGF0YWh1Yi52MS5GaWVsZERldmljZS5N'
    'b2JpbGVWZWhpY2xlLlZlaGljbGVPcGVyYXRpb25UeXBlUg1vcGVyYXRpb25UeXBlEiMKDWxpY2'
    'Vuc2VfcGxhdGUYAiABKAlSDGxpY2Vuc2VQbGF0ZRIYCgdoZWFkaW5nGAMgASgNUgdoZWFkaW5n'
    'IuABChRWZWhpY2xlT3BlcmF0aW9uVHlwZRIdChlWRUhJQ0xFX09QRVJBVElPTl9VTktOT1dOEA'
    'ASHgoaVkVISUNMRV9PUEVSQVRJT05fU1RSSVBJTkcQARIdChlWRUhJQ0xFX09QRVJBVElPTl9Q'
    'TE9XSU5HEAISHAoYVkVISUNMRV9PUEVSQVRJT05fTU9XSU5HEAMSJAogVkVISUNMRV9PUEVSQV'
    'RJT05fR0VORVJBTF9BQ1RJVkUQBBImCiJWRUhJQ0xFX09QRVJBVElPTl9HRU5FUkFMX0lOQUNU'
    'SVZFEAUa8gEKC0ZpZWxkV29ya2VyElgKDm9wZXJhdGlvbl90eXBlGAEgASgOMjEuZGF0YWh1Yi'
    '52MS5GaWVsZERldmljZS5GaWVsZFdvcmtlci5PcGVyYXRpb25UeXBlUg1vcGVyYXRpb25UeXBl'
    'IogBCg1PcGVyYXRpb25UeXBlEhoKFk9QRVJBVElPTl9UWVBFX1VOS05PV04QABIaChZPUEVSQV'
    'RJT05fVFlQRV9GTEFHR0VSEAESGQoVT1BFUkFUSU9OX1RZUEVfV09SS0VSEAISJAogT1BFUkFU'
    'SU9OX1RZUEVfTU9CSUxFX0lOX1ZFSElDTEUQAyLTAQoRRmllbGREZXZpY2VTdGF0dXMSHwobRk'
    'lFTERfREVWSUNFX1NUQVRVU19VTktOT1dOEAASGgoWRklFTERfREVWSUNFX1NUQVRVU19PSxAB'
    'Eh8KG0ZJRUxEX0RFVklDRV9TVEFUVVNfV0FSTklORxACEh0KGUZJRUxEX0RFVklDRV9TVEFUVV'
    'NfRVJST1IQAxIfChtGSUVMRF9ERVZJQ0VfU1RBVFVTX09GRkxJTkUQBBIgChxGSUVMRF9ERVZJ'
    'Q0VfU1RBVFVTX0lOQUNUSVZFEAVCCAoGRGV2aWNlQg0KC19wcm9qZWN0X2lkQhAKDl9yb2FkX2'
    'V2ZW50X2lkQgcKBV9iYm94SgQICRAK');

