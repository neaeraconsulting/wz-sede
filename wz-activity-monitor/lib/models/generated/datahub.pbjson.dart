// This is a generated file - do not edit.
//
// Generated from datahub.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use dataHubFieldDeviceUpdateDescriptor instead')
const DataHubFieldDeviceUpdate$json = {
  '1': 'DataHubFieldDeviceUpdate',
  '2': [
    {'1': 'request_id', '3': 1, '4': 1, '5': 4, '10': 'requestId'},
    {'1': 'timestamp', '3': 2, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'timestamp'},
    {'1': 'created', '3': 3, '4': 1, '5': 11, '6': '.datahub.v1.CreateFieldDevice', '9': 0, '10': 'created'},
    {'1': 'updated', '3': 4, '4': 1, '5': 11, '6': '.datahub.v1.UpdateFieldDevice', '9': 0, '10': 'updated'},
  ],
  '8': [
    {'1': 'type'},
  ],
};

/// Descriptor for `DataHubFieldDeviceUpdate`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List dataHubFieldDeviceUpdateDescriptor = $convert.base64Decode(
    'ChhEYXRhSHViRmllbGREZXZpY2VVcGRhdGUSHQoKcmVxdWVzdF9pZBgBIAEoBFIJcmVxdWVzdE'
    'lkEjgKCXRpbWVzdGFtcBgCIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCXRpbWVz'
    'dGFtcBI5CgdjcmVhdGVkGAMgASgLMh0uZGF0YWh1Yi52MS5DcmVhdGVGaWVsZERldmljZUgAUg'
    'djcmVhdGVkEjkKB3VwZGF0ZWQYBCABKAsyHS5kYXRhaHViLnYxLlVwZGF0ZUZpZWxkRGV2aWNl'
    'SABSB3VwZGF0ZWRCBgoEdHlwZQ==');

@$core.Deprecated('Use dataHubRoadEventUpdateDescriptor instead')
const DataHubRoadEventUpdate$json = {
  '1': 'DataHubRoadEventUpdate',
  '2': [
    {'1': 'request_id', '3': 1, '4': 1, '5': 4, '10': 'requestId'},
    {'1': 'timestamp', '3': 2, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'timestamp'},
    {'1': 'created', '3': 3, '4': 1, '5': 11, '6': '.datahub.v1.CreateRoadEvent', '9': 0, '10': 'created'},
    {'1': 'updated', '3': 4, '4': 1, '5': 11, '6': '.datahub.v1.UpdateRoadEvent', '9': 0, '10': 'updated'},
  ],
  '8': [
    {'1': 'type'},
  ],
};

/// Descriptor for `DataHubRoadEventUpdate`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List dataHubRoadEventUpdateDescriptor = $convert.base64Decode(
    'ChZEYXRhSHViUm9hZEV2ZW50VXBkYXRlEh0KCnJlcXVlc3RfaWQYASABKARSCXJlcXVlc3RJZB'
    'I4Cgl0aW1lc3RhbXAYAiABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgl0aW1lc3Rh'
    'bXASNwoHY3JlYXRlZBgDIAEoCzIbLmRhdGFodWIudjEuQ3JlYXRlUm9hZEV2ZW50SABSB2NyZW'
    'F0ZWQSNwoHdXBkYXRlZBgEIAEoCzIbLmRhdGFodWIudjEuVXBkYXRlUm9hZEV2ZW50SABSB3Vw'
    'ZGF0ZWRCBgoEdHlwZQ==');

@$core.Deprecated('Use createFieldDeviceDescriptor instead')
const CreateFieldDevice$json = {
  '1': 'CreateFieldDevice',
  '2': [
    {'1': 'field_device', '3': 1, '4': 1, '5': 11, '6': '.datahub.v1.FieldDevice', '10': 'fieldDevice'},
  ],
};

/// Descriptor for `CreateFieldDevice`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createFieldDeviceDescriptor = $convert.base64Decode(
    'ChFDcmVhdGVGaWVsZERldmljZRI6CgxmaWVsZF9kZXZpY2UYASABKAsyFy5kYXRhaHViLnYxLk'
    'ZpZWxkRGV2aWNlUgtmaWVsZERldmljZQ==');

@$core.Deprecated('Use updateFieldDeviceDescriptor instead')
const UpdateFieldDevice$json = {
  '1': 'UpdateFieldDevice',
  '2': [
    {'1': 'field_device', '3': 1, '4': 1, '5': 11, '6': '.datahub.v1.FieldDevice', '10': 'fieldDevice'},
  ],
};

/// Descriptor for `UpdateFieldDevice`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateFieldDeviceDescriptor = $convert.base64Decode(
    'ChFVcGRhdGVGaWVsZERldmljZRI6CgxmaWVsZF9kZXZpY2UYASABKAsyFy5kYXRhaHViLnYxLk'
    'ZpZWxkRGV2aWNlUgtmaWVsZERldmljZQ==');

@$core.Deprecated('Use createRoadEventDescriptor instead')
const CreateRoadEvent$json = {
  '1': 'CreateRoadEvent',
  '2': [
    {'1': 'road_event', '3': 1, '4': 1, '5': 11, '6': '.datahub.v1.RoadEvent', '10': 'roadEvent'},
    {'1': 'source', '3': 2, '4': 1, '5': 11, '6': '.datahub.v1.DataHubUpdateSource', '10': 'source'},
    {'1': 'road_sub_events', '3': 4, '4': 3, '5': 11, '6': '.datahub.v1.RoadSubEvent', '10': 'roadSubEvents'},
  ],
  '9': [
    {'1': 3, '2': 4},
  ],
};

/// Descriptor for `CreateRoadEvent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List createRoadEventDescriptor = $convert.base64Decode(
    'Cg9DcmVhdGVSb2FkRXZlbnQSNAoKcm9hZF9ldmVudBgBIAEoCzIVLmRhdGFodWIudjEuUm9hZE'
    'V2ZW50Uglyb2FkRXZlbnQSNwoGc291cmNlGAIgASgLMh8uZGF0YWh1Yi52MS5EYXRhSHViVXBk'
    'YXRlU291cmNlUgZzb3VyY2USQAoPcm9hZF9zdWJfZXZlbnRzGAQgAygLMhguZGF0YWh1Yi52MS'
    '5Sb2FkU3ViRXZlbnRSDXJvYWRTdWJFdmVudHNKBAgDEAQ=');

@$core.Deprecated('Use updateRoadEventDescriptor instead')
const UpdateRoadEvent$json = {
  '1': 'UpdateRoadEvent',
  '2': [
    {'1': 'road_event', '3': 1, '4': 1, '5': 11, '6': '.datahub.v1.RoadEvent', '10': 'roadEvent'},
    {'1': 'source', '3': 2, '4': 1, '5': 11, '6': '.datahub.v1.DataHubUpdateSource', '10': 'source'},
    {'1': 'road_sub_events', '3': 6, '4': 3, '5': 11, '6': '.datahub.v1.RoadSubEvent', '10': 'roadSubEvents'},
  ],
  '9': [
    {'1': 3, '2': 4},
    {'1': 4, '2': 5},
    {'1': 5, '2': 6},
  ],
};

/// Descriptor for `UpdateRoadEvent`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List updateRoadEventDescriptor = $convert.base64Decode(
    'Cg9VcGRhdGVSb2FkRXZlbnQSNAoKcm9hZF9ldmVudBgBIAEoCzIVLmRhdGFodWIudjEuUm9hZE'
    'V2ZW50Uglyb2FkRXZlbnQSNwoGc291cmNlGAIgASgLMh8uZGF0YWh1Yi52MS5EYXRhSHViVXBk'
    'YXRlU291cmNlUgZzb3VyY2USQAoPcm9hZF9zdWJfZXZlbnRzGAYgAygLMhguZGF0YWh1Yi52MS'
    '5Sb2FkU3ViRXZlbnRSDXJvYWRTdWJFdmVudHNKBAgDEARKBAgEEAVKBAgFEAY=');

@$core.Deprecated('Use reportSummaryDescriptor instead')
const ReportSummary$json = {
  '1': 'ReportSummary',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 4, '10': 'id'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'description', '3': 3, '4': 1, '5': 9, '10': 'description'},
    {'1': 'timestamp', '3': 4, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'timestamp'},
    {'1': 'contact_info', '3': 7, '4': 1, '5': 11, '6': '.datahub.v1.ContactInfo', '10': 'contactInfo'},
  ],
  '9': [
    {'1': 5, '2': 6},
    {'1': 6, '2': 7},
  ],
};

/// Descriptor for `ReportSummary`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List reportSummaryDescriptor = $convert.base64Decode(
    'Cg1SZXBvcnRTdW1tYXJ5Eg4KAmlkGAEgASgEUgJpZBISCgRuYW1lGAIgASgJUgRuYW1lEiAKC2'
    'Rlc2NyaXB0aW9uGAMgASgJUgtkZXNjcmlwdGlvbhI4Cgl0aW1lc3RhbXAYBCABKAsyGi5nb29n'
    'bGUucHJvdG9idWYuVGltZXN0YW1wUgl0aW1lc3RhbXASOgoMY29udGFjdF9pbmZvGAcgASgLMh'
    'cuZGF0YWh1Yi52MS5Db250YWN0SW5mb1ILY29udGFjdEluZm9KBAgFEAZKBAgGEAc=');

@$core.Deprecated('Use recordingSummaryDescriptor instead')
const RecordingSummary$json = {
  '1': 'RecordingSummary',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 4, '10': 'id'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'description', '3': 3, '4': 1, '5': 9, '10': 'description'},
    {'1': 'timestamp', '3': 4, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'timestamp'},
    {'1': 'length_meters', '3': 5, '4': 1, '5': 1, '10': 'lengthMeters'},
    {'1': 'position_accuracy_meters', '3': 6, '4': 1, '5': 1, '10': 'positionAccuracyMeters'},
    {'1': 'contact_info', '3': 7, '4': 1, '5': 11, '6': '.datahub.v1.ContactInfo', '10': 'contactInfo'},
  ],
};

/// Descriptor for `RecordingSummary`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List recordingSummaryDescriptor = $convert.base64Decode(
    'ChBSZWNvcmRpbmdTdW1tYXJ5Eg4KAmlkGAEgASgEUgJpZBISCgRuYW1lGAIgASgJUgRuYW1lEi'
    'AKC2Rlc2NyaXB0aW9uGAMgASgJUgtkZXNjcmlwdGlvbhI4Cgl0aW1lc3RhbXAYBCABKAsyGi5n'
    'b29nbGUucHJvdG9idWYuVGltZXN0YW1wUgl0aW1lc3RhbXASIwoNbGVuZ3RoX21ldGVycxgFIA'
    'EoAVIMbGVuZ3RoTWV0ZXJzEjgKGHBvc2l0aW9uX2FjY3VyYWN5X21ldGVycxgGIAEoAVIWcG9z'
    'aXRpb25BY2N1cmFjeU1ldGVycxI6Cgxjb250YWN0X2luZm8YByABKAsyFy5kYXRhaHViLnYxLk'
    'NvbnRhY3RJbmZvUgtjb250YWN0SW5mbw==');

@$core.Deprecated('Use fieldDeviceSummaryArrayDescriptor instead')
const FieldDeviceSummaryArray$json = {
  '1': 'FieldDeviceSummaryArray',
  '2': [
    {'1': 'field_device_summary', '3': 1, '4': 3, '5': 11, '6': '.datahub.v1.FieldDeviceSummary', '10': 'fieldDeviceSummary'},
  ],
};

/// Descriptor for `FieldDeviceSummaryArray`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List fieldDeviceSummaryArrayDescriptor = $convert.base64Decode(
    'ChdGaWVsZERldmljZVN1bW1hcnlBcnJheRJQChRmaWVsZF9kZXZpY2Vfc3VtbWFyeRgBIAMoCz'
    'IeLmRhdGFodWIudjEuRmllbGREZXZpY2VTdW1tYXJ5UhJmaWVsZERldmljZVN1bW1hcnk=');

@$core.Deprecated('Use fieldDeviceSummaryDescriptor instead')
const FieldDeviceSummary$json = {
  '1': 'FieldDeviceSummary',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 4, '10': 'id'},
    {'1': 'device', '3': 2, '4': 1, '5': 11, '6': '.datahub.v1.FieldDevice', '10': 'device'},
    {'1': 'update_date', '3': 3, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'updateDate'},
  ],
};

/// Descriptor for `FieldDeviceSummary`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List fieldDeviceSummaryDescriptor = $convert.base64Decode(
    'ChJGaWVsZERldmljZVN1bW1hcnkSDgoCaWQYASABKARSAmlkEi8KBmRldmljZRgCIAEoCzIXLm'
    'RhdGFodWIudjEuRmllbGREZXZpY2VSBmRldmljZRI7Cgt1cGRhdGVfZGF0ZRgDIAEoCzIaLmdv'
    'b2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCnVwZGF0ZURhdGU=');

@$core.Deprecated('Use dataHubUpdateSourceDescriptor instead')
const DataHubUpdateSource$json = {
  '1': 'DataHubUpdateSource',
  '2': [
    {'1': 'report_summary', '3': 1, '4': 1, '5': 11, '6': '.datahub.v1.ReportSummary', '9': 0, '10': 'reportSummary'},
    {'1': 'recording_summary', '3': 2, '4': 1, '5': 11, '6': '.datahub.v1.RecordingSummary', '9': 0, '10': 'recordingSummary'},
    {'1': 'field_device_summaries', '3': 3, '4': 1, '5': 11, '6': '.datahub.v1.FieldDeviceSummaryArray', '9': 0, '10': 'fieldDeviceSummaries'},
  ],
  '8': [
    {'1': 'source'},
  ],
};

/// Descriptor for `DataHubUpdateSource`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List dataHubUpdateSourceDescriptor = $convert.base64Decode(
    'ChNEYXRhSHViVXBkYXRlU291cmNlEkIKDnJlcG9ydF9zdW1tYXJ5GAEgASgLMhkuZGF0YWh1Yi'
    '52MS5SZXBvcnRTdW1tYXJ5SABSDXJlcG9ydFN1bW1hcnkSSwoRcmVjb3JkaW5nX3N1bW1hcnkY'
    'AiABKAsyHC5kYXRhaHViLnYxLlJlY29yZGluZ1N1bW1hcnlIAFIQcmVjb3JkaW5nU3VtbWFyeR'
    'JbChZmaWVsZF9kZXZpY2Vfc3VtbWFyaWVzGAMgASgLMiMuZGF0YWh1Yi52MS5GaWVsZERldmlj'
    'ZVN1bW1hcnlBcnJheUgAUhRmaWVsZERldmljZVN1bW1hcmllc0IICgZzb3VyY2U=');

