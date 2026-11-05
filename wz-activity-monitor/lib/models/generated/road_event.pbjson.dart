// This is a generated file - do not edit.
//
// Generated from road_event.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use roadEventDescriptor instead')
const RoadEvent$json = {
  '1': 'RoadEvent',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 4, '10': 'id'},
    {'1': 'project_id', '3': 2, '4': 1, '5': 4, '9': 1, '10': 'projectId', '17': true},
    {'1': 'name', '3': 4, '4': 1, '5': 9, '10': 'name'},
    {'1': 'description', '3': 5, '4': 1, '5': 9, '10': 'description'},
    {'1': 'status', '3': 6, '4': 1, '5': 14, '6': '.datahub.v1.RoadEvent.RoadEventActiveStatus', '10': 'status'},
    {'1': 'start_date', '3': 7, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'startDate'},
    {'1': 'end_date', '3': 8, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '9': 2, '10': 'endDate', '17': true},
    {'1': 'area_type', '3': 9, '4': 1, '5': 14, '6': '.datahub.v1.WorkZoneType', '10': 'areaType'},
    {'1': 'types_of_work', '3': 10, '4': 3, '5': 11, '6': '.datahub.v1.TypeOfWork', '10': 'typesOfWork'},
    {'1': 'point', '3': 12, '4': 1, '5': 11, '6': '.datahub.v1.PointGeometry', '9': 0, '10': 'point'},
    {'1': 'line_string', '3': 13, '4': 1, '5': 11, '6': '.datahub.v1.LineStringGeometry', '9': 0, '10': 'lineString'},
    {'1': 'polygon', '3': 14, '4': 1, '5': 11, '6': '.datahub.v1.PolygonGeometry', '9': 0, '10': 'polygon'},
    {'1': 'bbox', '3': 15, '4': 1, '5': 11, '6': '.datahub.v1.BoundingBox', '9': 3, '10': 'bbox', '17': true},
    {'1': 'default_schedule', '3': 18, '4': 1, '5': 11, '6': '.datahub.v1.EventRecurrence', '9': 4, '10': 'defaultSchedule', '17': true},
    {'1': 'linked_field_device_ids', '3': 19, '4': 3, '5': 9, '10': 'linkedFieldDeviceIds'},
  ],
  '4': [RoadEvent_RoadEventActiveStatus$json],
  '8': [
    {'1': 'Geometry'},
    {'1': '_project_id'},
    {'1': '_end_date'},
    {'1': '_bbox'},
    {'1': '_default_schedule'},
  ],
  '9': [
    {'1': 3, '2': 4},
    {'1': 11, '2': 12},
    {'1': 16, '2': 17},
    {'1': 17, '2': 18},
  ],
};

@$core.Deprecated('Use roadEventDescriptor instead')
const RoadEvent_RoadEventActiveStatus$json = {
  '1': 'RoadEventActiveStatus',
  '2': [
    {'1': 'ROAD_EVENT_ACTIVE_STATUS_UNKNOWN', '2': 0},
    {'1': 'ROAD_EVENT_ACTIVE_STATUS_ACTIVE', '2': 1},
    {'1': 'ROAD_EVENT_ACTIVE_STATUS_INACTIVE', '2': 2},
  ],
};

/// Descriptor for `RoadEvent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List roadEventDescriptor = $convert.base64Decode(
    'CglSb2FkRXZlbnQSDgoCaWQYASABKARSAmlkEiIKCnByb2plY3RfaWQYAiABKARIAVIJcHJvam'
    'VjdElkiAEBEhIKBG5hbWUYBCABKAlSBG5hbWUSIAoLZGVzY3JpcHRpb24YBSABKAlSC2Rlc2Ny'
    'aXB0aW9uEkMKBnN0YXR1cxgGIAEoDjIrLmRhdGFodWIudjEuUm9hZEV2ZW50LlJvYWRFdmVudE'
    'FjdGl2ZVN0YXR1c1IGc3RhdHVzEjkKCnN0YXJ0X2RhdGUYByABKAsyGi5nb29nbGUucHJvdG9i'
    'dWYuVGltZXN0YW1wUglzdGFydERhdGUSOgoIZW5kX2RhdGUYCCABKAsyGi5nb29nbGUucHJvdG'
    '9idWYuVGltZXN0YW1wSAJSB2VuZERhdGWIAQESNQoJYXJlYV90eXBlGAkgASgOMhguZGF0YWh1'
    'Yi52MS5Xb3JrWm9uZVR5cGVSCGFyZWFUeXBlEjoKDXR5cGVzX29mX3dvcmsYCiADKAsyFi5kYX'
    'RhaHViLnYxLlR5cGVPZldvcmtSC3R5cGVzT2ZXb3JrEjEKBXBvaW50GAwgASgLMhkuZGF0YWh1'
    'Yi52MS5Qb2ludEdlb21ldHJ5SABSBXBvaW50EkEKC2xpbmVfc3RyaW5nGA0gASgLMh4uZGF0YW'
    'h1Yi52MS5MaW5lU3RyaW5nR2VvbWV0cnlIAFIKbGluZVN0cmluZxI3Cgdwb2x5Z29uGA4gASgL'
    'MhsuZGF0YWh1Yi52MS5Qb2x5Z29uR2VvbWV0cnlIAFIHcG9seWdvbhIwCgRiYm94GA8gASgLMh'
    'cuZGF0YWh1Yi52MS5Cb3VuZGluZ0JveEgDUgRiYm94iAEBEksKEGRlZmF1bHRfc2NoZWR1bGUY'
    'EiABKAsyGy5kYXRhaHViLnYxLkV2ZW50UmVjdXJyZW5jZUgEUg9kZWZhdWx0U2NoZWR1bGWIAQ'
    'ESNQoXbGlua2VkX2ZpZWxkX2RldmljZV9pZHMYEyADKAlSFGxpbmtlZEZpZWxkRGV2aWNlSWRz'
    'IokBChVSb2FkRXZlbnRBY3RpdmVTdGF0dXMSJAogUk9BRF9FVkVOVF9BQ1RJVkVfU1RBVFVTX1'
    'VOS05PV04QABIjCh9ST0FEX0VWRU5UX0FDVElWRV9TVEFUVVNfQUNUSVZFEAESJQohUk9BRF9F'
    'VkVOVF9BQ1RJVkVfU1RBVFVTX0lOQUNUSVZFEAJCCgoIR2VvbWV0cnlCDQoLX3Byb2plY3RfaW'
    'RCCwoJX2VuZF9kYXRlQgcKBV9iYm94QhMKEV9kZWZhdWx0X3NjaGVkdWxlSgQIAxAESgQICxAM'
    'SgQIEBARSgQIERAS');

@$core.Deprecated('Use eventRecurrenceDescriptor instead')
const EventRecurrence$json = {
  '1': 'EventRecurrence',
  '2': [
    {'1': 'start_time', '3': 1, '4': 1, '5': 11, '6': '.google.type.TimeOfDay', '10': 'startTime'},
    {'1': 'end_time', '3': 2, '4': 1, '5': 11, '6': '.google.type.TimeOfDay', '10': 'endTime'},
    {'1': 'start_date', '3': 3, '4': 1, '5': 11, '6': '.google.type.Date', '10': 'startDate'},
    {'1': 'end_date', '3': 4, '4': 1, '5': 11, '6': '.google.type.Date', '10': 'endDate'},
    {'1': 'monday', '3': 5, '4': 1, '5': 8, '10': 'monday'},
    {'1': 'tuesday', '3': 6, '4': 1, '5': 8, '10': 'tuesday'},
    {'1': 'wednesday', '3': 7, '4': 1, '5': 8, '10': 'wednesday'},
    {'1': 'thursday', '3': 8, '4': 1, '5': 8, '10': 'thursday'},
    {'1': 'friday', '3': 9, '4': 1, '5': 8, '10': 'friday'},
    {'1': 'saturday', '3': 10, '4': 1, '5': 8, '10': 'saturday'},
    {'1': 'sunday', '3': 11, '4': 1, '5': 8, '10': 'sunday'},
    {'1': 'exclusion', '3': 12, '4': 1, '5': 8, '9': 0, '10': 'exclusion', '17': true},
  ],
  '8': [
    {'1': '_exclusion'},
  ],
};

/// Descriptor for `EventRecurrence`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List eventRecurrenceDescriptor = $convert.base64Decode(
    'Cg9FdmVudFJlY3VycmVuY2USNQoKc3RhcnRfdGltZRgBIAEoCzIWLmdvb2dsZS50eXBlLlRpbW'
    'VPZkRheVIJc3RhcnRUaW1lEjEKCGVuZF90aW1lGAIgASgLMhYuZ29vZ2xlLnR5cGUuVGltZU9m'
    'RGF5UgdlbmRUaW1lEjAKCnN0YXJ0X2RhdGUYAyABKAsyES5nb29nbGUudHlwZS5EYXRlUglzdG'
    'FydERhdGUSLAoIZW5kX2RhdGUYBCABKAsyES5nb29nbGUudHlwZS5EYXRlUgdlbmREYXRlEhYK'
    'Bm1vbmRheRgFIAEoCFIGbW9uZGF5EhgKB3R1ZXNkYXkYBiABKAhSB3R1ZXNkYXkSHAoJd2Vkbm'
    'VzZGF5GAcgASgIUgl3ZWRuZXNkYXkSGgoIdGh1cnNkYXkYCCABKAhSCHRodXJzZGF5EhYKBmZy'
    'aWRheRgJIAEoCFIGZnJpZGF5EhoKCHNhdHVyZGF5GAogASgIUghzYXR1cmRheRIWCgZzdW5kYX'
    'kYCyABKAhSBnN1bmRheRIhCglleGNsdXNpb24YDCABKAhIAFIJZXhjbHVzaW9uiAEBQgwKCl9l'
    'eGNsdXNpb24=');

