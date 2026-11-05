// This is a generated file - do not edit.
//
// Generated from wzdx.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use workZoneTypeDescriptor instead')
const WorkZoneType$json = {
  '1': 'WorkZoneType',
  '2': [
    {'1': 'WORK_ZONE_TYPE_UNKNOWN', '2': 0},
    {'1': 'WORK_ZONE_TYPE_STATIC', '2': 1},
    {'1': 'WORK_ZONE_TYPE_MOVING', '2': 2},
    {'1': 'WORK_ZONE_TYPE_PLANNED_MOVING_AREA', '2': 3},
  ],
};

/// Descriptor for `WorkZoneType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List workZoneTypeDescriptor = $convert.base64Decode(
    'CgxXb3JrWm9uZVR5cGUSGgoWV09SS19aT05FX1RZUEVfVU5LTk9XThAAEhkKFVdPUktfWk9ORV'
    '9UWVBFX1NUQVRJQxABEhkKFVdPUktfWk9ORV9UWVBFX01PVklORxACEiYKIldPUktfWk9ORV9U'
    'WVBFX1BMQU5ORURfTU9WSU5HX0FSRUEQAw==');

@$core.Deprecated('Use locationMethodDescriptor instead')
const LocationMethod$json = {
  '1': 'LocationMethod',
  '2': [
    {'1': 'LOCATION_METHOD_UNKNOWN', '2': 0},
    {'1': 'LOCATION_METHOD_CHANNEL_DEVICE_METHOD', '2': 1},
    {'1': 'LOCATION_METHOD_SIGN_METHOD', '2': 2},
    {'1': 'LOCATION_METHOD_JUNCTION_METHOD', '2': 3},
    {'1': 'LOCATION_METHOD_OTHER', '2': 4},
  ],
};

/// Descriptor for `LocationMethod`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List locationMethodDescriptor = $convert.base64Decode(
    'Cg5Mb2NhdGlvbk1ldGhvZBIbChdMT0NBVElPTl9NRVRIT0RfVU5LTk9XThAAEikKJUxPQ0FUSU'
    '9OX01FVEhPRF9DSEFOTkVMX0RFVklDRV9NRVRIT0QQARIfChtMT0NBVElPTl9NRVRIT0RfU0lH'
    'Tl9NRVRIT0QQAhIjCh9MT0NBVElPTl9NRVRIT0RfSlVOQ1RJT05fTUVUSE9EEAMSGQoVTE9DQV'
    'RJT05fTUVUSE9EX09USEVSEAQ=');

@$core.Deprecated('Use vehicleImpactDescriptor instead')
const VehicleImpact$json = {
  '1': 'VehicleImpact',
  '2': [
    {'1': 'VEHICLE_IMPACT_UNKNOWN', '2': 0},
    {'1': 'VEHICLE_IMPACT_ALL_LANES_CLOSED', '2': 1},
    {'1': 'VEHICLE_IMPACT_SOME_LANES_CLOSED', '2': 2},
    {'1': 'VEHICLE_IMPACT_ALL_LANES_OPEN', '2': 3},
    {'1': 'VEHICLE_IMPACT_ALTERNATING_ONE_WAY', '2': 4},
    {'1': 'VEHICLE_IMPACT_SOME_LANES_CLOSED_MERGE_LEFT', '2': 5},
    {'1': 'VEHICLE_IMPACT_SOME_LANES_CLOSED_MERGE_RIGHT', '2': 6},
    {'1': 'VEHICLE_IMPACT_ALL_LANES_OPEN_SHIFT_LEFT', '2': 7},
    {'1': 'VEHICLE_IMPACT_ALL_LANES_OPEN_SHIFT_RIGHT', '2': 8},
    {'1': 'VEHICLE_IMPACT_SOME_LANES_CLOSED_SPLIT', '2': 9},
    {'1': 'VEHICLE_IMPACT_FLAGGING', '2': 10},
    {'1': 'VEHICLE_IMPACT_TEMPORARY_TRAFFIC_SIGNAL', '2': 11},
  ],
};

/// Descriptor for `VehicleImpact`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List vehicleImpactDescriptor = $convert.base64Decode(
    'Cg1WZWhpY2xlSW1wYWN0EhoKFlZFSElDTEVfSU1QQUNUX1VOS05PV04QABIjCh9WRUhJQ0xFX0'
    'lNUEFDVF9BTExfTEFORVNfQ0xPU0VEEAESJAogVkVISUNMRV9JTVBBQ1RfU09NRV9MQU5FU19D'
    'TE9TRUQQAhIhCh1WRUhJQ0xFX0lNUEFDVF9BTExfTEFORVNfT1BFThADEiYKIlZFSElDTEVfSU'
    '1QQUNUX0FMVEVSTkFUSU5HX09ORV9XQVkQBBIvCitWRUhJQ0xFX0lNUEFDVF9TT01FX0xBTkVT'
    'X0NMT1NFRF9NRVJHRV9MRUZUEAUSMAosVkVISUNMRV9JTVBBQ1RfU09NRV9MQU5FU19DTE9TRU'
    'RfTUVSR0VfUklHSFQQBhIsCihWRUhJQ0xFX0lNUEFDVF9BTExfTEFORVNfT1BFTl9TSElGVF9M'
    'RUZUEAcSLQopVkVISUNMRV9JTVBBQ1RfQUxMX0xBTkVTX09QRU5fU0hJRlRfUklHSFQQCBIqCi'
    'ZWRUhJQ0xFX0lNUEFDVF9TT01FX0xBTkVTX0NMT1NFRF9TUExJVBAJEhsKF1ZFSElDTEVfSU1Q'
    'QUNUX0ZMQUdHSU5HEAoSKwonVkVISUNMRV9JTVBBQ1RfVEVNUE9SQVJZX1RSQUZGSUNfU0lHTk'
    'FMEAs=');

@$core.Deprecated('Use laneTypeDescriptor instead')
const LaneType$json = {
  '1': 'LaneType',
  '2': [
    {'1': 'LANE_TYPE_UNKNOWN', '2': 0},
    {'1': 'LANE_TYPE_GENERAL', '2': 1},
    {'1': 'LANE_TYPE_EXIT_LANE', '2': 2},
    {'1': 'LANE_TYPE_EXIT_RAMP', '2': 3},
    {'1': 'LANE_TYPE_ENTRANCE_LANE', '2': 4},
    {'1': 'LANE_TYPE_ENTRANCE_RAMP', '2': 5},
    {'1': 'LANE_TYPE_SIDEWALK', '2': 6},
    {'1': 'LANE_TYPE_BIKE_LANE', '2': 7},
    {'1': 'LANE_TYPE_SHOULDER', '2': 8},
    {'1': 'LANE_TYPE_PARKING', '2': 9},
    {'1': 'LANE_TYPE_MEDIAN', '2': 10},
    {'1': 'LANE_TYPE_TWO_WAY_CENTER_TURN_LANE', '2': 11},
  ],
};

/// Descriptor for `LaneType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List laneTypeDescriptor = $convert.base64Decode(
    'CghMYW5lVHlwZRIVChFMQU5FX1RZUEVfVU5LTk9XThAAEhUKEUxBTkVfVFlQRV9HRU5FUkFMEA'
    'ESFwoTTEFORV9UWVBFX0VYSVRfTEFORRACEhcKE0xBTkVfVFlQRV9FWElUX1JBTVAQAxIbChdM'
    'QU5FX1RZUEVfRU5UUkFOQ0VfTEFORRAEEhsKF0xBTkVfVFlQRV9FTlRSQU5DRV9SQU1QEAUSFg'
    'oSTEFORV9UWVBFX1NJREVXQUxLEAYSFwoTTEFORV9UWVBFX0JJS0VfTEFORRAHEhYKEkxBTkVf'
    'VFlQRV9TSE9VTERFUhAIEhUKEUxBTkVfVFlQRV9QQVJLSU5HEAkSFAoQTEFORV9UWVBFX01FRE'
    'lBThAKEiYKIkxBTkVfVFlQRV9UV09fV0FZX0NFTlRFUl9UVVJOX0xBTkUQCw==');

@$core.Deprecated('Use laneStatusDescriptor instead')
const LaneStatus$json = {
  '1': 'LaneStatus',
  '2': [
    {'1': 'LANE_STATUS_UNKNOWN', '2': 0},
    {'1': 'LANE_STATUS_OPEN', '2': 1},
    {'1': 'LANE_STATUS_CLOSED', '2': 2},
    {'1': 'LANE_STATUS_SHIFT_LEFT', '2': 3},
    {'1': 'LANE_STATUS_SHIFT_RIGHT', '2': 4},
    {'1': 'LANE_STATUS_MERGE_LEFT', '2': 5},
    {'1': 'LANE_STATUS_MERGE_RIGHT', '2': 6},
    {'1': 'LANE_STATUS_ALTERNATING_FLOW', '2': 7},
  ],
};

/// Descriptor for `LaneStatus`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List laneStatusDescriptor = $convert.base64Decode(
    'CgpMYW5lU3RhdHVzEhcKE0xBTkVfU1RBVFVTX1VOS05PV04QABIUChBMQU5FX1NUQVRVU19PUE'
    'VOEAESFgoSTEFORV9TVEFUVVNfQ0xPU0VEEAISGgoWTEFORV9TVEFUVVNfU0hJRlRfTEVGVBAD'
    'EhsKF0xBTkVfU1RBVFVTX1NISUZUX1JJR0hUEAQSGgoWTEFORV9TVEFUVVNfTUVSR0VfTEVGVB'
    'AFEhsKF0xBTkVfU1RBVFVTX01FUkdFX1JJR0hUEAYSIAocTEFORV9TVEFUVVNfQUxURVJOQVRJ'
    'TkdfRkxPVxAH');

@$core.Deprecated('Use restrictionTypeDescriptor instead')
const RestrictionType$json = {
  '1': 'RestrictionType',
  '2': [
    {'1': 'RESTRICTION_TYPE_UNKNOWN', '2': 0},
    {'1': 'RESTRICTION_TYPE_LOCAL_ACCESS_ONLY', '2': 1},
    {'1': 'RESTRICTION_TYPE_NO_TRUCKS', '2': 2},
    {'1': 'RESTRICTION_TYPE_TRAVEL_PEAK_HOURS_ONLY', '2': 3},
    {'1': 'RESTRICTION_TYPE_HOV_3', '2': 4},
    {'1': 'RESTRICTION_TYPE_HOV_2', '2': 5},
    {'1': 'RESTRICTION_TYPE_NO_PARKING', '2': 6},
    {'1': 'RESTRICTION_TYPE_REDUCED_WIDTH', '2': 7},
    {'1': 'RESTRICTION_TYPE_REDUCED_HEIGHT', '2': 8},
    {'1': 'RESTRICTION_TYPE_REDUCED_LENGTH', '2': 9},
    {'1': 'RESTRICTION_TYPE_REDUCED_WEIGHT', '2': 10},
    {'1': 'RESTRICTION_TYPE_AXLE_LOAD_LIMIT', '2': 11},
    {'1': 'RESTRICTION_TYPE_GROSS_WEIGHT_LIMIT', '2': 12},
    {'1': 'RESTRICTION_TYPE_TOWING_PROHIBITED', '2': 13},
    {'1': 'RESTRICTION_TYPE_PERMITTED_OVERSIZE_LOADS_PROHIBITED', '2': 14},
    {'1': 'RESTRICTION_TYPE_NO_PASSING', '2': 15},
  ],
};

/// Descriptor for `RestrictionType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List restrictionTypeDescriptor = $convert.base64Decode(
    'Cg9SZXN0cmljdGlvblR5cGUSHAoYUkVTVFJJQ1RJT05fVFlQRV9VTktOT1dOEAASJgoiUkVTVF'
    'JJQ1RJT05fVFlQRV9MT0NBTF9BQ0NFU1NfT05MWRABEh4KGlJFU1RSSUNUSU9OX1RZUEVfTk9f'
    'VFJVQ0tTEAISKwonUkVTVFJJQ1RJT05fVFlQRV9UUkFWRUxfUEVBS19IT1VSU19PTkxZEAMSGg'
    'oWUkVTVFJJQ1RJT05fVFlQRV9IT1ZfMxAEEhoKFlJFU1RSSUNUSU9OX1RZUEVfSE9WXzIQBRIf'
    'ChtSRVNUUklDVElPTl9UWVBFX05PX1BBUktJTkcQBhIiCh5SRVNUUklDVElPTl9UWVBFX1JFRF'
    'VDRURfV0lEVEgQBxIjCh9SRVNUUklDVElPTl9UWVBFX1JFRFVDRURfSEVJR0hUEAgSIwofUkVT'
    'VFJJQ1RJT05fVFlQRV9SRURVQ0VEX0xFTkdUSBAJEiMKH1JFU1RSSUNUSU9OX1RZUEVfUkVEVU'
    'NFRF9XRUlHSFQQChIkCiBSRVNUUklDVElPTl9UWVBFX0FYTEVfTE9BRF9MSU1JVBALEicKI1JF'
    'U1RSSUNUSU9OX1RZUEVfR1JPU1NfV0VJR0hUX0xJTUlUEAwSJgoiUkVTVFJJQ1RJT05fVFlQRV'
    '9UT1dJTkdfUFJPSElCSVRFRBANEjgKNFJFU1RSSUNUSU9OX1RZUEVfUEVSTUlUVEVEX09WRVJT'
    'SVpFX0xPQURTX1BST0hJQklURUQQDhIfChtSRVNUUklDVElPTl9UWVBFX05PX1BBU1NJTkcQDw'
    '==');

@$core.Deprecated('Use unitOfMeasurementDescriptor instead')
const UnitOfMeasurement$json = {
  '1': 'UnitOfMeasurement',
  '2': [
    {'1': 'UNIT_OF_MEASUREMENT_UNKNOWN', '2': 0},
    {'1': 'UNIT_OF_MEASUREMENT_FEET', '2': 1},
    {'1': 'UNIT_OF_MEASUREMENT_METERS', '2': 2},
    {'1': 'UNIT_OF_MEASUREMENT_CENTIMETERS', '2': 3},
    {'1': 'UNIT_OF_MEASUREMENT_POUNDS', '2': 4},
    {'1': 'UNIT_OF_MEASUREMENT_TONS', '2': 5},
    {'1': 'UNIT_OF_MEASUREMENT_KILOGRAMS', '2': 6},
    {'1': 'UNIT_OF_MEASUREMENT_INCHES', '2': 7},
  ],
};

/// Descriptor for `UnitOfMeasurement`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List unitOfMeasurementDescriptor = $convert.base64Decode(
    'ChFVbml0T2ZNZWFzdXJlbWVudBIfChtVTklUX09GX01FQVNVUkVNRU5UX1VOS05PV04QABIcCh'
    'hVTklUX09GX01FQVNVUkVNRU5UX0ZFRVQQARIeChpVTklUX09GX01FQVNVUkVNRU5UX01FVEVS'
    'UxACEiMKH1VOSVRfT0ZfTUVBU1VSRU1FTlRfQ0VOVElNRVRFUlMQAxIeChpVTklUX09GX01FQV'
    'NVUkVNRU5UX1BPVU5EUxAEEhwKGFVOSVRfT0ZfTUVBU1VSRU1FTlRfVE9OUxAFEiEKHVVOSVRf'
    'T0ZfTUVBU1VSRU1FTlRfS0lMT0dSQU1TEAYSHgoaVU5JVF9PRl9NRUFTVVJFTUVOVF9JTkNIRV'
    'MQBw==');

@$core.Deprecated('Use workTypeNameDescriptor instead')
const WorkTypeName$json = {
  '1': 'WorkTypeName',
  '2': [
    {'1': 'WORK_TYPE_NAME_UNKNOWN', '2': 0},
    {'1': 'WORK_TYPE_NAME_MAINTENANCE', '2': 1},
    {'1': 'WORK_TYPE_NAME_MINOR_ROAD_DEFECT_REPAIR', '2': 2},
    {'1': 'WORK_TYPE_NAME_ROADSIDE_WORK', '2': 3},
    {'1': 'WORK_TYPE_NAME_OVERHEAD_WORK', '2': 4},
    {'1': 'WORK_TYPE_NAME_BELOW_ROAD_WORK', '2': 5},
    {'1': 'WORK_TYPE_NAME_BARRIER_WORK', '2': 6},
    {'1': 'WORK_TYPE_NAME_SURFACE_WORK', '2': 7},
    {'1': 'WORK_TYPE_NAME_PAINTING', '2': 8},
    {'1': 'WORK_TYPE_NAME_ROADWAY_RELOCATION', '2': 9},
    {'1': 'WORK_TYPE_NAME_ROADWAY_CREATION', '2': 10},
  ],
};

/// Descriptor for `WorkTypeName`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List workTypeNameDescriptor = $convert.base64Decode(
    'CgxXb3JrVHlwZU5hbWUSGgoWV09SS19UWVBFX05BTUVfVU5LTk9XThAAEh4KGldPUktfVFlQRV'
    '9OQU1FX01BSU5URU5BTkNFEAESKwonV09SS19UWVBFX05BTUVfTUlOT1JfUk9BRF9ERUZFQ1Rf'
    'UkVQQUlSEAISIAocV09SS19UWVBFX05BTUVfUk9BRFNJREVfV09SSxADEiAKHFdPUktfVFlQRV'
    '9OQU1FX09WRVJIRUFEX1dPUksQBBIiCh5XT1JLX1RZUEVfTkFNRV9CRUxPV19ST0FEX1dPUksQ'
    'BRIfChtXT1JLX1RZUEVfTkFNRV9CQVJSSUVSX1dPUksQBhIfChtXT1JLX1RZUEVfTkFNRV9TVV'
    'JGQUNFX1dPUksQBxIbChdXT1JLX1RZUEVfTkFNRV9QQUlOVElORxAIEiUKIVdPUktfVFlQRV9O'
    'QU1FX1JPQURXQVlfUkVMT0NBVElPThAJEiMKH1dPUktfVFlQRV9OQU1FX1JPQURXQVlfQ1JFQV'
    'RJT04QCg==');

@$core.Deprecated('Use workerPresenceDefinitionDescriptor instead')
const WorkerPresenceDefinition$json = {
  '1': 'WorkerPresenceDefinition',
  '2': [
    {'1': 'WORKER_PRESENCE_DEFINITION_UNKNOWN', '2': 0},
    {'1': 'WORKER_PRESENCE_DEFINITION_WORKERS_IN_WORK_ZONE_WORKING', '2': 1},
    {'1': 'WORKER_PRESENCE_DEFINITION_WORKERS_IN_WORK_ZONE_NOT_WORKING', '2': 2},
    {'1': 'WORKER_PRESENCE_DEFINITION_MOBILE_EQUIPMENT_IN_WORK_ZONE_MOVING', '2': 3},
    {'1': 'WORKER_PRESENCE_DEFINITION_MOBILE_EQUIPMENT_IN_WORK_ZONE_NOT_MOVING', '2': 4},
    {'1': 'WORKER_PRESENCE_DEFINITION_FIXED_EQUIPMENT_IN_WORK_ZONE', '2': 5},
    {'1': 'WORKER_PRESENCE_DEFINITION_HUMANS_BEHIND_BARRIER', '2': 6},
    {'1': 'WORKER_PRESENCE_DEFINITION_HUMANS_IN_RIGHT_OF_WAY', '2': 7},
  ],
};

/// Descriptor for `WorkerPresenceDefinition`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List workerPresenceDefinitionDescriptor = $convert.base64Decode(
    'ChhXb3JrZXJQcmVzZW5jZURlZmluaXRpb24SJgoiV09SS0VSX1BSRVNFTkNFX0RFRklOSVRJT0'
    '5fVU5LTk9XThAAEjsKN1dPUktFUl9QUkVTRU5DRV9ERUZJTklUSU9OX1dPUktFUlNfSU5fV09S'
    'S19aT05FX1dPUktJTkcQARI/CjtXT1JLRVJfUFJFU0VOQ0VfREVGSU5JVElPTl9XT1JLRVJTX0'
    'lOX1dPUktfWk9ORV9OT1RfV09SS0lORxACEkMKP1dPUktFUl9QUkVTRU5DRV9ERUZJTklUSU9O'
    'X01PQklMRV9FUVVJUE1FTlRfSU5fV09SS19aT05FX01PVklORxADEkcKQ1dPUktFUl9QUkVTRU'
    '5DRV9ERUZJTklUSU9OX01PQklMRV9FUVVJUE1FTlRfSU5fV09SS19aT05FX05PVF9NT1ZJTkcQ'
    'BBI7CjdXT1JLRVJfUFJFU0VOQ0VfREVGSU5JVElPTl9GSVhFRF9FUVVJUE1FTlRfSU5fV09SS1'
    '9aT05FEAUSNAowV09SS0VSX1BSRVNFTkNFX0RFRklOSVRJT05fSFVNQU5TX0JFSElORF9CQVJS'
    'SUVSEAYSNQoxV09SS0VSX1BSRVNFTkNFX0RFRklOSVRJT05fSFVNQU5TX0lOX1JJR0hUX09GX1'
    'dBWRAH');

@$core.Deprecated('Use workerPresenceMethodDescriptor instead')
const WorkerPresenceMethod$json = {
  '1': 'WorkerPresenceMethod',
  '2': [
    {'1': 'WORKER_PRESENCE_METHOD_UNKNOWN', '2': 0},
    {'1': 'WORKER_PRESENCE_METHOD_CAMERA_MONITORING', '2': 1},
    {'1': 'WORKER_PRESENCE_METHOD_CONES_PRESENT', '2': 2},
    {'1': 'WORKER_PRESENCE_METHOD_MAINTENANCE_VEHICLE_PRESENT', '2': 3},
    {'1': 'WORKER_PRESENCE_METHOD_WEARABLES_PRESENT', '2': 4},
    {'1': 'WORKER_PRESENCE_METHOD_MOBILE_DEVICE_PRESENT', '2': 5},
    {'1': 'WORKER_PRESENCE_METHOD_CHECK_IN_APP', '2': 6},
    {'1': 'WORKER_PRESENCE_METHOD_CHECK_IN_VERBAL', '2': 7},
    {'1': 'WORKER_PRESENCE_METHOD_SCHEDULED', '2': 8},
  ],
};

/// Descriptor for `WorkerPresenceMethod`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List workerPresenceMethodDescriptor = $convert.base64Decode(
    'ChRXb3JrZXJQcmVzZW5jZU1ldGhvZBIiCh5XT1JLRVJfUFJFU0VOQ0VfTUVUSE9EX1VOS05PV0'
    '4QABIsCihXT1JLRVJfUFJFU0VOQ0VfTUVUSE9EX0NBTUVSQV9NT05JVE9SSU5HEAESKAokV09S'
    'S0VSX1BSRVNFTkNFX01FVEhPRF9DT05FU19QUkVTRU5UEAISNgoyV09SS0VSX1BSRVNFTkNFX0'
    '1FVEhPRF9NQUlOVEVOQU5DRV9WRUhJQ0xFX1BSRVNFTlQQAxIsCihXT1JLRVJfUFJFU0VOQ0Vf'
    'TUVUSE9EX1dFQVJBQkxFU19QUkVTRU5UEAQSMAosV09SS0VSX1BSRVNFTkNFX01FVEhPRF9NT0'
    'JJTEVfREVWSUNFX1BSRVNFTlQQBRInCiNXT1JLRVJfUFJFU0VOQ0VfTUVUSE9EX0NIRUNLX0lO'
    'X0FQUBAGEioKJldPUktFUl9QUkVTRU5DRV9NRVRIT0RfQ0hFQ0tfSU5fVkVSQkFMEAcSJAogV0'
    '9SS0VSX1BSRVNFTkNFX01FVEhPRF9TQ0hFRFVMRUQQCA==');

@$core.Deprecated('Use workerPresenceConfidenceDescriptor instead')
const WorkerPresenceConfidence$json = {
  '1': 'WorkerPresenceConfidence',
  '2': [
    {'1': 'WORKER_PRESENCE_CONFIDENCE_UNKNOWN', '2': 0},
    {'1': 'WORKER_PRESENCE_CONFIDENCE_LOW', '2': 1},
    {'1': 'WORKER_PRESENCE_CONFIDENCE_MEDIUM', '2': 2},
    {'1': 'WORKER_PRESENCE_CONFIDENCE_HIGH', '2': 3},
  ],
};

/// Descriptor for `WorkerPresenceConfidence`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List workerPresenceConfidenceDescriptor = $convert.base64Decode(
    'ChhXb3JrZXJQcmVzZW5jZUNvbmZpZGVuY2USJgoiV09SS0VSX1BSRVNFTkNFX0NPTkZJREVOQ0'
    'VfVU5LTk9XThAAEiIKHldPUktFUl9QUkVTRU5DRV9DT05GSURFTkNFX0xPVxABEiUKIVdPUktF'
    'Ul9QUkVTRU5DRV9DT05GSURFTkNFX01FRElVTRACEiMKH1dPUktFUl9QUkVTRU5DRV9DT05GSU'
    'RFTkNFX0hJR0gQAw==');

@$core.Deprecated('Use roadwayDirectionDescriptor instead')
const RoadwayDirection$json = {
  '1': 'RoadwayDirection',
  '2': [
    {'1': 'ROADWAY_DIRECTION_UNKNOWN', '2': 0},
    {'1': 'ROADWAY_DIRECTION_NORTHBOUND', '2': 1},
    {'1': 'ROADWAY_DIRECTION_SOUTHBOUND', '2': 2},
    {'1': 'ROADWAY_DIRECTION_EASTBOUND', '2': 3},
    {'1': 'ROADWAY_DIRECTION_WESTBOUND', '2': 4},
    {'1': 'ROADWAY_DIRECTION_INNER_LOOP', '2': 5},
    {'1': 'ROADWAY_DIRECTION_OUTER_LOOP', '2': 6},
    {'1': 'ROADWAY_DIRECTION_UNDEFINED', '2': 7},
  ],
};

/// Descriptor for `RoadwayDirection`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List roadwayDirectionDescriptor = $convert.base64Decode(
    'ChBSb2Fkd2F5RGlyZWN0aW9uEh0KGVJPQURXQVlfRElSRUNUSU9OX1VOS05PV04QABIgChxST0'
    'FEV0FZX0RJUkVDVElPTl9OT1JUSEJPVU5EEAESIAocUk9BRFdBWV9ESVJFQ1RJT05fU09VVEhC'
    'T1VORBACEh8KG1JPQURXQVlfRElSRUNUSU9OX0VBU1RCT1VORBADEh8KG1JPQURXQVlfRElSRU'
    'NUSU9OX1dFU1RCT1VORBAEEiAKHFJPQURXQVlfRElSRUNUSU9OX0lOTkVSX0xPT1AQBRIgChxS'
    'T0FEV0FZX0RJUkVDVElPTl9PVVRFUl9MT09QEAYSHwobUk9BRFdBWV9ESVJFQ1RJT05fVU5ERU'
    'ZJTkVEEAc=');

@$core.Deprecated('Use restrictionDescriptor instead')
const Restriction$json = {
  '1': 'Restriction',
  '2': [
    {'1': 'type', '3': 1, '4': 1, '5': 14, '6': '.datahub.v1.RestrictionType', '10': 'type'},
    {'1': 'value', '3': 2, '4': 1, '5': 2, '10': 'value'},
    {'1': 'unit', '3': 3, '4': 1, '5': 14, '6': '.datahub.v1.UnitOfMeasurement', '10': 'unit'},
  ],
};

/// Descriptor for `Restriction`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List restrictionDescriptor = $convert.base64Decode(
    'CgtSZXN0cmljdGlvbhIvCgR0eXBlGAEgASgOMhsuZGF0YWh1Yi52MS5SZXN0cmljdGlvblR5cG'
    'VSBHR5cGUSFAoFdmFsdWUYAiABKAJSBXZhbHVlEjEKBHVuaXQYAyABKA4yHS5kYXRhaHViLnYx'
    'LlVuaXRPZk1lYXN1cmVtZW50UgR1bml0');

@$core.Deprecated('Use laneDescriptor instead')
const Lane$json = {
  '1': 'Lane',
  '2': [
    {'1': 'lane_order', '3': 1, '4': 1, '5': 13, '10': 'laneOrder'},
    {'1': 'type', '3': 2, '4': 1, '5': 14, '6': '.datahub.v1.LaneType', '10': 'type'},
    {'1': 'status', '3': 3, '4': 1, '5': 14, '6': '.datahub.v1.LaneStatus', '10': 'status'},
    {'1': 'restrictions', '3': 4, '4': 3, '5': 11, '6': '.datahub.v1.Restriction', '10': 'restrictions'},
  ],
};

/// Descriptor for `Lane`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List laneDescriptor = $convert.base64Decode(
    'CgRMYW5lEh0KCmxhbmVfb3JkZXIYASABKA1SCWxhbmVPcmRlchIoCgR0eXBlGAIgASgOMhQuZG'
    'F0YWh1Yi52MS5MYW5lVHlwZVIEdHlwZRIuCgZzdGF0dXMYAyABKA4yFi5kYXRhaHViLnYxLkxh'
    'bmVTdGF0dXNSBnN0YXR1cxI7CgxyZXN0cmljdGlvbnMYBCADKAsyFy5kYXRhaHViLnYxLlJlc3'
    'RyaWN0aW9uUgxyZXN0cmljdGlvbnM=');

@$core.Deprecated('Use typeOfWorkDescriptor instead')
const TypeOfWork$json = {
  '1': 'TypeOfWork',
  '2': [
    {'1': 'type_name', '3': 1, '4': 1, '5': 14, '6': '.datahub.v1.WorkTypeName', '10': 'typeName'},
    {'1': 'is_architectural_change', '3': 2, '4': 1, '5': 8, '10': 'isArchitecturalChange'},
  ],
};

/// Descriptor for `TypeOfWork`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List typeOfWorkDescriptor = $convert.base64Decode(
    'CgpUeXBlT2ZXb3JrEjUKCXR5cGVfbmFtZRgBIAEoDjIYLmRhdGFodWIudjEuV29ya1R5cGVOYW'
    '1lUgh0eXBlTmFtZRI2Chdpc19hcmNoaXRlY3R1cmFsX2NoYW5nZRgCIAEoCFIVaXNBcmNoaXRl'
    'Y3R1cmFsQ2hhbmdl');

@$core.Deprecated('Use workerPresenceDescriptor instead')
const WorkerPresence$json = {
  '1': 'WorkerPresence',
  '2': [
    {'1': 'are_workers_present', '3': 1, '4': 1, '5': 8, '10': 'areWorkersPresent'},
    {'1': 'definition', '3': 2, '4': 1, '5': 14, '6': '.datahub.v1.WorkerPresenceDefinition', '10': 'definition'},
    {'1': 'method', '3': 3, '4': 1, '5': 14, '6': '.datahub.v1.WorkerPresenceMethod', '10': 'method'},
    {'1': 'worker_presence_last_confirmed_date', '3': 4, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'workerPresenceLastConfirmedDate'},
    {'1': 'confidence', '3': 5, '4': 1, '5': 14, '6': '.datahub.v1.WorkerPresenceConfidence', '10': 'confidence'},
  ],
};

/// Descriptor for `WorkerPresence`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List workerPresenceDescriptor = $convert.base64Decode(
    'Cg5Xb3JrZXJQcmVzZW5jZRIuChNhcmVfd29ya2Vyc19wcmVzZW50GAEgASgIUhFhcmVXb3JrZX'
    'JzUHJlc2VudBJECgpkZWZpbml0aW9uGAIgASgOMiQuZGF0YWh1Yi52MS5Xb3JrZXJQcmVzZW5j'
    'ZURlZmluaXRpb25SCmRlZmluaXRpb24SOAoGbWV0aG9kGAMgASgOMiAuZGF0YWh1Yi52MS5Xb3'
    'JrZXJQcmVzZW5jZU1ldGhvZFIGbWV0aG9kEmgKI3dvcmtlcl9wcmVzZW5jZV9sYXN0X2NvbmZp'
    'cm1lZF9kYXRlGAQgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIfd29ya2VyUHJlc2'
    'VuY2VMYXN0Q29uZmlybWVkRGF0ZRJECgpjb25maWRlbmNlGAUgASgOMiQuZGF0YWh1Yi52MS5X'
    'b3JrZXJQcmVzZW5jZUNvbmZpZGVuY2VSCmNvbmZpZGVuY2U=');

