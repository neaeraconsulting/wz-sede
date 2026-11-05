// This is a generated file - do not edit.
//
// Generated from road_sub_event.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use roadSubEventDescriptor instead')
const RoadSubEvent$json = {
  '1': 'RoadSubEvent',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 4, '10': 'id'},
    {'1': 'project_id', '3': 2, '4': 1, '5': 4, '9': 2, '10': 'projectId', '17': true},
    {'1': 'road_event_id', '3': 3, '4': 1, '5': 4, '10': 'roadEventId'},
    {'1': 'direction', '3': 4, '4': 1, '5': 14, '6': '.datahub.v1.RoadwayDirection', '10': 'direction'},
    {'1': 'road_names', '3': 7, '4': 3, '5': 9, '10': 'roadNames'},
    {'1': 'beginning_cross_street', '3': 8, '4': 1, '5': 9, '9': 3, '10': 'beginningCrossStreet', '17': true},
    {'1': 'ending_cross_street', '3': 9, '4': 1, '5': 9, '9': 4, '10': 'endingCrossStreet', '17': true},
    {'1': 'beginning_milepost', '3': 10, '4': 1, '5': 1, '10': 'beginningMilepost'},
    {'1': 'ending_milepost', '3': 11, '4': 1, '5': 1, '10': 'endingMilepost'},
    {'1': 'start_location_type', '3': 17, '4': 1, '5': 14, '6': '.datahub.v1.MarkedLocationType', '9': 5, '10': 'startLocationType', '17': true},
    {'1': 'end_location_type', '3': 18, '4': 1, '5': 14, '6': '.datahub.v1.MarkedLocationType', '9': 6, '10': 'endLocationType', '17': true},
    {'1': 'point', '3': 19, '4': 1, '5': 11, '6': '.datahub.v1.PointGeometry', '9': 0, '10': 'point'},
    {'1': 'line_string', '3': 20, '4': 1, '5': 11, '6': '.datahub.v1.LineStringGeometry', '9': 0, '10': 'lineString'},
    {'1': 'polygon', '3': 21, '4': 1, '5': 11, '6': '.datahub.v1.PolygonGeometry', '9': 0, '10': 'polygon'},
    {'1': 'bbox', '3': 22, '4': 1, '5': 11, '6': '.datahub.v1.BoundingBox', '9': 7, '10': 'bbox', '17': true},
    {'1': 'route_id', '3': 23, '4': 1, '5': 9, '10': 'routeId'},
    {'1': 'schedule', '3': 24, '4': 1, '5': 11, '6': '.datahub.v1.EventRecurrence', '9': 8, '10': 'schedule', '17': true},
    {'1': 'base_layer', '3': 26, '4': 1, '5': 11, '6': '.datahub.v1.RoadSubEvent.BaseLayer', '9': 1, '10': 'baseLayer'},
    {'1': 'speed_reduction_layer', '3': 27, '4': 1, '5': 11, '6': '.datahub.v1.RoadSubEvent.SpeedReductionLayer', '9': 1, '10': 'speedReductionLayer'},
    {'1': 'worker_presence_layer', '3': 28, '4': 1, '5': 11, '6': '.datahub.v1.RoadSubEvent.WorkerPresenceLayer', '9': 1, '10': 'workerPresenceLayer'},
    {'1': 'linked_events', '3': 30, '4': 3, '5': 11, '6': '.datahub.v1.RoadSubEvent.RoadSubEventLink', '10': 'linkedEvents'},
  ],
  '3': [RoadSubEvent_BaseLayer$json, RoadSubEvent_SpeedReductionLayer$json, RoadSubEvent_WorkerPresenceLayer$json, RoadSubEvent_RoadSubEventLink$json],
  '4': [RoadSubEvent_RoadDirection$json, RoadSubEvent_RoadSubEventLinkType$json],
  '8': [
    {'1': 'Geometry'},
    {'1': 'Layer'},
    {'1': '_project_id'},
    {'1': '_beginning_cross_street'},
    {'1': '_ending_cross_street'},
    {'1': '_start_location_type'},
    {'1': '_end_location_type'},
    {'1': '_bbox'},
    {'1': '_schedule'},
  ],
  '9': [
    {'1': 5, '2': 6},
    {'1': 6, '2': 7},
    {'1': 12, '2': 13},
    {'1': 13, '2': 14},
    {'1': 14, '2': 15},
    {'1': 15, '2': 16},
    {'1': 16, '2': 17},
    {'1': 25, '2': 26},
    {'1': 29, '2': 30},
  ],
};

@$core.Deprecated('Use roadSubEventDescriptor instead')
const RoadSubEvent_BaseLayer$json = {
  '1': 'BaseLayer',
  '2': [
    {'1': 'vehicle_impact', '3': 1, '4': 1, '5': 14, '6': '.datahub.v1.VehicleImpact', '10': 'vehicleImpact'},
    {'1': 'lanes', '3': 2, '4': 3, '5': 11, '6': '.datahub.v1.Lane', '10': 'lanes'},
    {'1': 'restrictions', '3': 3, '4': 3, '5': 11, '6': '.datahub.v1.Restriction', '10': 'restrictions'},
    {'1': 'surface_type', '3': 4, '4': 1, '5': 14, '6': '.datahub.v1.RoadSurfaceType', '10': 'surfaceType'},
  ],
};

@$core.Deprecated('Use roadSubEventDescriptor instead')
const RoadSubEvent_SpeedReductionLayer$json = {
  '1': 'SpeedReductionLayer',
  '2': [
    {'1': 'reduced_speed_limit_kph', '3': 1, '4': 1, '5': 2, '10': 'reducedSpeedLimitKph'},
  ],
};

@$core.Deprecated('Use roadSubEventDescriptor instead')
const RoadSubEvent_WorkerPresenceLayer$json = {
  '1': 'WorkerPresenceLayer',
  '2': [
    {'1': 'worker_presence', '3': 1, '4': 1, '5': 11, '6': '.datahub.v1.WorkerPresence', '10': 'workerPresence'},
  ],
};

@$core.Deprecated('Use roadSubEventDescriptor instead')
const RoadSubEvent_RoadSubEventLink$json = {
  '1': 'RoadSubEventLink',
  '2': [
    {'1': 'linked_road_sub_event_id', '3': 1, '4': 1, '5': 4, '9': 0, '10': 'linkedRoadSubEventId', '17': true},
    {'1': 'road_sub_event_link_type', '3': 2, '4': 1, '5': 14, '6': '.datahub.v1.RoadSubEvent.RoadSubEventLink.RoadSubEventLinkType', '10': 'roadSubEventLinkType'},
  ],
  '4': [RoadSubEvent_RoadSubEventLink_RoadSubEventLinkType$json],
  '8': [
    {'1': '_linked_road_sub_event_id'},
  ],
};

@$core.Deprecated('Use roadSubEventDescriptor instead')
const RoadSubEvent_RoadSubEventLink_RoadSubEventLinkType$json = {
  '1': 'RoadSubEventLinkType',
  '2': [
    {'1': 'ROAD_SUB_EVENT_LINK_TYPE_UNKNOWN', '2': 0},
    {'1': 'ROAD_SUB_EVENT_LINK_TYPE_FIRST_IN_SEQUENCE', '2': 1},
    {'1': 'ROAD_SUB_EVENT_LINK_TYPE_NEXT_IN_SEQUENCE', '2': 2},
    {'1': 'ROAD_SUB_EVENT_LINK_TYPE_FIRST_OCCURRENCE', '2': 3},
    {'1': 'ROAD_SUB_EVENT_LINK_TYPE_NEXT_OCCURRENCE', '2': 4},
    {'1': 'ROAD_SUB_EVENT_LINK_TYPE_RELATED_ROAD_EVENT', '2': 5},
    {'1': 'ROAD_SUB_EVENT_LINK_TYPE_RELATED_DETOUR', '2': 6},
    {'1': 'ROAD_SUB_EVENT_LINK_TYPE_PLANNED_MOVING_OPERATION', '2': 7},
    {'1': 'ROAD_SUB_EVENT_LINK_TYPE_ACTIVE_MOVING_OPERATION', '2': 8},
  ],
};

@$core.Deprecated('Use roadSubEventDescriptor instead')
const RoadSubEvent_RoadDirection$json = {
  '1': 'RoadDirection',
  '2': [
    {'1': 'ROAD_DIRECTION_UNKNOWN', '2': 0},
    {'1': 'ROAD_DIRECTION_BOTH', '2': 1},
    {'1': 'ROAD_DIRECTION_NORTHBOUND', '2': 2},
    {'1': 'ROAD_DIRECTION_SOUTHBOUND', '2': 3},
    {'1': 'ROAD_DIRECTION_EASTBOUND', '2': 4},
    {'1': 'ROAD_DIRECTION_WESTBOUND', '2': 5},
  ],
};

@$core.Deprecated('Use roadSubEventDescriptor instead')
const RoadSubEvent_RoadSubEventLinkType$json = {
  '1': 'RoadSubEventLinkType',
  '2': [
    {'1': 'ROAD_SUB_EVENT_LINK_TYPE_UNKNOWN', '2': 0},
    {'1': 'ROAD_SUB_EVENT_LINK_TYPE_FIRST_IN_SEQUENCE', '2': 1},
    {'1': 'ROAD_SUB_EVENT_LINK_TYPE_NEXT_IN_SEQUENCE', '2': 2},
    {'1': 'ROAD_SUB_EVENT_LINK_TYPE_FIRST_OCCURRENCE', '2': 3},
    {'1': 'ROAD_SUB_EVENT_LINK_TYPE_NEXT_OCCURRENCE', '2': 4},
    {'1': 'ROAD_SUB_EVENT_LINK_TYPE_RELATED_ROAD_EVENT', '2': 5},
    {'1': 'ROAD_SUB_EVENT_LINK_TYPE_RELATED_DETOUR', '2': 6},
    {'1': 'ROAD_SUB_EVENT_LINK_TYPE_PLANNED_MOVING_OPERATION', '2': 7},
    {'1': 'ROAD_SUB_EVENT_LINK_TYPE_ACTIVE_MOVING_OPERATION', '2': 8},
  ],
};

/// Descriptor for `RoadSubEvent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List roadSubEventDescriptor = $convert.base64Decode(
    'CgxSb2FkU3ViRXZlbnQSDgoCaWQYASABKARSAmlkEiIKCnByb2plY3RfaWQYAiABKARIAlIJcH'
    'JvamVjdElkiAEBEiIKDXJvYWRfZXZlbnRfaWQYAyABKARSC3JvYWRFdmVudElkEjoKCWRpcmVj'
    'dGlvbhgEIAEoDjIcLmRhdGFodWIudjEuUm9hZHdheURpcmVjdGlvblIJZGlyZWN0aW9uEh0KCn'
    'JvYWRfbmFtZXMYByADKAlSCXJvYWROYW1lcxI5ChZiZWdpbm5pbmdfY3Jvc3Nfc3RyZWV0GAgg'
    'ASgJSANSFGJlZ2lubmluZ0Nyb3NzU3RyZWV0iAEBEjMKE2VuZGluZ19jcm9zc19zdHJlZXQYCS'
    'ABKAlIBFIRZW5kaW5nQ3Jvc3NTdHJlZXSIAQESLQoSYmVnaW5uaW5nX21pbGVwb3N0GAogASgB'
    'UhFiZWdpbm5pbmdNaWxlcG9zdBInCg9lbmRpbmdfbWlsZXBvc3QYCyABKAFSDmVuZGluZ01pbG'
    'Vwb3N0ElMKE3N0YXJ0X2xvY2F0aW9uX3R5cGUYESABKA4yHi5kYXRhaHViLnYxLk1hcmtlZExv'
    'Y2F0aW9uVHlwZUgFUhFzdGFydExvY2F0aW9uVHlwZYgBARJPChFlbmRfbG9jYXRpb25fdHlwZR'
    'gSIAEoDjIeLmRhdGFodWIudjEuTWFya2VkTG9jYXRpb25UeXBlSAZSD2VuZExvY2F0aW9uVHlw'
    'ZYgBARIxCgVwb2ludBgTIAEoCzIZLmRhdGFodWIudjEuUG9pbnRHZW9tZXRyeUgAUgVwb2ludB'
    'JBCgtsaW5lX3N0cmluZxgUIAEoCzIeLmRhdGFodWIudjEuTGluZVN0cmluZ0dlb21ldHJ5SABS'
    'CmxpbmVTdHJpbmcSNwoHcG9seWdvbhgVIAEoCzIbLmRhdGFodWIudjEuUG9seWdvbkdlb21ldH'
    'J5SABSB3BvbHlnb24SMAoEYmJveBgWIAEoCzIXLmRhdGFodWIudjEuQm91bmRpbmdCb3hIB1IE'
    'YmJveIgBARIZCghyb3V0ZV9pZBgXIAEoCVIHcm91dGVJZBI8CghzY2hlZHVsZRgYIAEoCzIbLm'
    'RhdGFodWIudjEuRXZlbnRSZWN1cnJlbmNlSAhSCHNjaGVkdWxliAEBEkMKCmJhc2VfbGF5ZXIY'
    'GiABKAsyIi5kYXRhaHViLnYxLlJvYWRTdWJFdmVudC5CYXNlTGF5ZXJIAVIJYmFzZUxheWVyEm'
    'IKFXNwZWVkX3JlZHVjdGlvbl9sYXllchgbIAEoCzIsLmRhdGFodWIudjEuUm9hZFN1YkV2ZW50'
    'LlNwZWVkUmVkdWN0aW9uTGF5ZXJIAVITc3BlZWRSZWR1Y3Rpb25MYXllchJiChV3b3JrZXJfcH'
    'Jlc2VuY2VfbGF5ZXIYHCABKAsyLC5kYXRhaHViLnYxLlJvYWRTdWJFdmVudC5Xb3JrZXJQcmVz'
    'ZW5jZUxheWVySAFSE3dvcmtlclByZXNlbmNlTGF5ZXISTgoNbGlua2VkX2V2ZW50cxgeIAMoCz'
    'IpLmRhdGFodWIudjEuUm9hZFN1YkV2ZW50LlJvYWRTdWJFdmVudExpbmtSDGxpbmtlZEV2ZW50'
    'cxryAQoJQmFzZUxheWVyEkAKDnZlaGljbGVfaW1wYWN0GAEgASgOMhkuZGF0YWh1Yi52MS5WZW'
    'hpY2xlSW1wYWN0Ug12ZWhpY2xlSW1wYWN0EiYKBWxhbmVzGAIgAygLMhAuZGF0YWh1Yi52MS5M'
    'YW5lUgVsYW5lcxI7CgxyZXN0cmljdGlvbnMYAyADKAsyFy5kYXRhaHViLnYxLlJlc3RyaWN0aW'
    '9uUgxyZXN0cmljdGlvbnMSPgoMc3VyZmFjZV90eXBlGAQgASgOMhsuZGF0YWh1Yi52MS5Sb2Fk'
    'U3VyZmFjZVR5cGVSC3N1cmZhY2VUeXBlGkwKE1NwZWVkUmVkdWN0aW9uTGF5ZXISNQoXcmVkdW'
    'NlZF9zcGVlZF9saW1pdF9rcGgYASABKAJSFHJlZHVjZWRTcGVlZExpbWl0S3BoGloKE1dvcmtl'
    'clByZXNlbmNlTGF5ZXISQwoPd29ya2VyX3ByZXNlbmNlGAEgASgLMhouZGF0YWh1Yi52MS5Xb3'
    'JrZXJQcmVzZW5jZVIOd29ya2VyUHJlc2VuY2UaqgUKEFJvYWRTdWJFdmVudExpbmsSOwoYbGlu'
    'a2VkX3JvYWRfc3ViX2V2ZW50X2lkGAEgASgESABSFGxpbmtlZFJvYWRTdWJFdmVudElkiAEBEn'
    'YKGHJvYWRfc3ViX2V2ZW50X2xpbmtfdHlwZRgCIAEoDjI+LmRhdGFodWIudjEuUm9hZFN1YkV2'
    'ZW50LlJvYWRTdWJFdmVudExpbmsuUm9hZFN1YkV2ZW50TGlua1R5cGVSFHJvYWRTdWJFdmVudE'
    'xpbmtUeXBlIsMDChRSb2FkU3ViRXZlbnRMaW5rVHlwZRIkCiBST0FEX1NVQl9FVkVOVF9MSU5L'
    'X1RZUEVfVU5LTk9XThAAEi4KKlJPQURfU1VCX0VWRU5UX0xJTktfVFlQRV9GSVJTVF9JTl9TRV'
    'FVRU5DRRABEi0KKVJPQURfU1VCX0VWRU5UX0xJTktfVFlQRV9ORVhUX0lOX1NFUVVFTkNFEAIS'
    'LQopUk9BRF9TVUJfRVZFTlRfTElOS19UWVBFX0ZJUlNUX09DQ1VSUkVOQ0UQAxIsCihST0FEX1'
    'NVQl9FVkVOVF9MSU5LX1RZUEVfTkVYVF9PQ0NVUlJFTkNFEAQSLworUk9BRF9TVUJfRVZFTlRf'
    'TElOS19UWVBFX1JFTEFURURfUk9BRF9FVkVOVBAFEisKJ1JPQURfU1VCX0VWRU5UX0xJTktfVF'
    'lQRV9SRUxBVEVEX0RFVE9VUhAGEjUKMVJPQURfU1VCX0VWRU5UX0xJTktfVFlQRV9QTEFOTkVE'
    'X01PVklOR19PUEVSQVRJT04QBxI0CjBST0FEX1NVQl9FVkVOVF9MSU5LX1RZUEVfQUNUSVZFX0'
    '1PVklOR19PUEVSQVRJT04QCEIbChlfbGlua2VkX3JvYWRfc3ViX2V2ZW50X2lkIr4BCg1Sb2Fk'
    'RGlyZWN0aW9uEhoKFlJPQURfRElSRUNUSU9OX1VOS05PV04QABIXChNST0FEX0RJUkVDVElPTl'
    '9CT1RIEAESHQoZUk9BRF9ESVJFQ1RJT05fTk9SVEhCT1VORBACEh0KGVJPQURfRElSRUNUSU9O'
    'X1NPVVRIQk9VTkQQAxIcChhST0FEX0RJUkVDVElPTl9FQVNUQk9VTkQQBBIcChhST0FEX0RJUk'
    'VDVElPTl9XRVNUQk9VTkQQBSLDAwoUUm9hZFN1YkV2ZW50TGlua1R5cGUSJAogUk9BRF9TVUJf'
    'RVZFTlRfTElOS19UWVBFX1VOS05PV04QABIuCipST0FEX1NVQl9FVkVOVF9MSU5LX1RZUEVfRk'
    'lSU1RfSU5fU0VRVUVOQ0UQARItCilST0FEX1NVQl9FVkVOVF9MSU5LX1RZUEVfTkVYVF9JTl9T'
    'RVFVRU5DRRACEi0KKVJPQURfU1VCX0VWRU5UX0xJTktfVFlQRV9GSVJTVF9PQ0NVUlJFTkNFEA'
    'MSLAooUk9BRF9TVUJfRVZFTlRfTElOS19UWVBFX05FWFRfT0NDVVJSRU5DRRAEEi8KK1JPQURf'
    'U1VCX0VWRU5UX0xJTktfVFlQRV9SRUxBVEVEX1JPQURfRVZFTlQQBRIrCidST0FEX1NVQl9FVk'
    'VOVF9MSU5LX1RZUEVfUkVMQVRFRF9ERVRPVVIQBhI1CjFST0FEX1NVQl9FVkVOVF9MSU5LX1RZ'
    'UEVfUExBTk5FRF9NT1ZJTkdfT1BFUkFUSU9OEAcSNAowUk9BRF9TVUJfRVZFTlRfTElOS19UWV'
    'BFX0FDVElWRV9NT1ZJTkdfT1BFUkFUSU9OEAhCCgoIR2VvbWV0cnlCBwoFTGF5ZXJCDQoLX3By'
    'b2plY3RfaWRCGQoXX2JlZ2lubmluZ19jcm9zc19zdHJlZXRCFgoUX2VuZGluZ19jcm9zc19zdH'
    'JlZXRCFgoUX3N0YXJ0X2xvY2F0aW9uX3R5cGVCFAoSX2VuZF9sb2NhdGlvbl90eXBlQgcKBV9i'
    'Ym94QgsKCV9zY2hlZHVsZUoECAUQBkoECAYQB0oECAwQDUoECA0QDkoECA4QD0oECA8QEEoECB'
    'AQEUoECBkQGkoECB0QHg==');

