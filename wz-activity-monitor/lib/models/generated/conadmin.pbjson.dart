// This is a generated file - do not edit.
//
// Generated from conadmin.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use conAdminFieldDeviceUpdateDescriptor instead')
const ConAdminFieldDeviceUpdate$json = {
  '1': 'ConAdminFieldDeviceUpdate',
  '2': [
    {'1': 'request_id', '3': 1, '4': 1, '5': 4, '10': 'requestId'},
    {'1': 'timestamp', '3': 2, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'timestamp'},
    {'1': 'updated', '3': 4, '4': 1, '5': 11, '6': '.datahub.v1.UpdateFieldDevice', '9': 0, '10': 'updated'},
  ],
  '8': [
    {'1': 'type'},
  ],
  '9': [
    {'1': 3, '2': 4},
  ],
};

/// Descriptor for `ConAdminFieldDeviceUpdate`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List conAdminFieldDeviceUpdateDescriptor = $convert.base64Decode(
    'ChlDb25BZG1pbkZpZWxkRGV2aWNlVXBkYXRlEh0KCnJlcXVlc3RfaWQYASABKARSCXJlcXVlc3'
    'RJZBI4Cgl0aW1lc3RhbXAYAiABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgl0aW1l'
    'c3RhbXASOQoHdXBkYXRlZBgEIAEoCzIdLmRhdGFodWIudjEuVXBkYXRlRmllbGREZXZpY2VIAF'
    'IHdXBkYXRlZEIGCgR0eXBlSgQIAxAE');

@$core.Deprecated('Use conAdminProjectUpdateDescriptor instead')
const ConAdminProjectUpdate$json = {
  '1': 'ConAdminProjectUpdate',
  '2': [
    {'1': 'request_id', '3': 1, '4': 1, '5': 4, '9': 1, '10': 'requestId', '17': true},
    {'1': 'timestamp', '3': 2, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'timestamp'},
    {'1': 'created', '3': 3, '4': 1, '5': 11, '6': '.datahub.v1.ProjectCreated', '9': 0, '10': 'created'},
    {'1': 'updated', '3': 4, '4': 1, '5': 11, '6': '.datahub.v1.ProjectUpdated', '9': 0, '10': 'updated'},
    {'1': 'removed', '3': 5, '4': 1, '5': 11, '6': '.datahub.v1.ProjectRemoved', '9': 0, '10': 'removed'},
  ],
  '8': [
    {'1': 'type'},
    {'1': '_request_id'},
  ],
};

/// Descriptor for `ConAdminProjectUpdate`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List conAdminProjectUpdateDescriptor = $convert.base64Decode(
    'ChVDb25BZG1pblByb2plY3RVcGRhdGUSIgoKcmVxdWVzdF9pZBgBIAEoBEgBUglyZXF1ZXN0SW'
    'SIAQESOAoJdGltZXN0YW1wGAIgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIJdGlt'
    'ZXN0YW1wEjYKB2NyZWF0ZWQYAyABKAsyGi5kYXRhaHViLnYxLlByb2plY3RDcmVhdGVkSABSB2'
    'NyZWF0ZWQSNgoHdXBkYXRlZBgEIAEoCzIaLmRhdGFodWIudjEuUHJvamVjdFVwZGF0ZWRIAFIH'
    'dXBkYXRlZBI2CgdyZW1vdmVkGAUgASgLMhouZGF0YWh1Yi52MS5Qcm9qZWN0UmVtb3ZlZEgAUg'
    'dyZW1vdmVkQgYKBHR5cGVCDQoLX3JlcXVlc3RfaWQ=');

@$core.Deprecated('Use conAdminRoadEventUpdateDescriptor instead')
const ConAdminRoadEventUpdate$json = {
  '1': 'ConAdminRoadEventUpdate',
  '2': [
    {'1': 'request_id', '3': 1, '4': 1, '5': 4, '9': 1, '10': 'requestId', '17': true},
    {'1': 'timestamp', '3': 2, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'timestamp'},
    {'1': 'created', '3': 3, '4': 1, '5': 11, '6': '.datahub.v1.RoadEventCreated', '9': 0, '10': 'created'},
    {'1': 'updated', '3': 4, '4': 1, '5': 11, '6': '.datahub.v1.RoadEventUpdated', '9': 0, '10': 'updated'},
    {'1': 'removed', '3': 5, '4': 1, '5': 11, '6': '.datahub.v1.RoadEventRemoved', '9': 0, '10': 'removed'},
  ],
  '8': [
    {'1': 'type'},
    {'1': '_request_id'},
  ],
};

/// Descriptor for `ConAdminRoadEventUpdate`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List conAdminRoadEventUpdateDescriptor = $convert.base64Decode(
    'ChdDb25BZG1pblJvYWRFdmVudFVwZGF0ZRIiCgpyZXF1ZXN0X2lkGAEgASgESAFSCXJlcXVlc3'
    'RJZIgBARI4Cgl0aW1lc3RhbXAYAiABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgl0'
    'aW1lc3RhbXASOAoHY3JlYXRlZBgDIAEoCzIcLmRhdGFodWIudjEuUm9hZEV2ZW50Q3JlYXRlZE'
    'gAUgdjcmVhdGVkEjgKB3VwZGF0ZWQYBCABKAsyHC5kYXRhaHViLnYxLlJvYWRFdmVudFVwZGF0'
    'ZWRIAFIHdXBkYXRlZBI4CgdyZW1vdmVkGAUgASgLMhwuZGF0YWh1Yi52MS5Sb2FkRXZlbnRSZW'
    '1vdmVkSABSB3JlbW92ZWRCBgoEdHlwZUINCgtfcmVxdWVzdF9pZA==');

@$core.Deprecated('Use conAdminRoadEventApprovalDescriptor instead')
const ConAdminRoadEventApproval$json = {
  '1': 'ConAdminRoadEventApproval',
  '2': [
    {'1': 'request_id', '3': 1, '4': 1, '5': 4, '9': 1, '10': 'requestId', '17': true},
    {'1': 'timestamp', '3': 2, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'timestamp'},
    {'1': 'approved', '3': 3, '4': 1, '5': 11, '6': '.datahub.v1.RoadEventUpdateApproved', '9': 0, '10': 'approved'},
    {'1': 'rejected', '3': 4, '4': 1, '5': 11, '6': '.datahub.v1.RoadEventUpdateRejected', '9': 0, '10': 'rejected'},
  ],
  '8': [
    {'1': 'type'},
    {'1': '_request_id'},
  ],
};

/// Descriptor for `ConAdminRoadEventApproval`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List conAdminRoadEventApprovalDescriptor = $convert.base64Decode(
    'ChlDb25BZG1pblJvYWRFdmVudEFwcHJvdmFsEiIKCnJlcXVlc3RfaWQYASABKARIAVIJcmVxdW'
    'VzdElkiAEBEjgKCXRpbWVzdGFtcBgCIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi5UaW1lc3RhbXBS'
    'CXRpbWVzdGFtcBJBCghhcHByb3ZlZBgDIAEoCzIjLmRhdGFodWIudjEuUm9hZEV2ZW50VXBkYX'
    'RlQXBwcm92ZWRIAFIIYXBwcm92ZWQSQQoIcmVqZWN0ZWQYBCABKAsyIy5kYXRhaHViLnYxLlJv'
    'YWRFdmVudFVwZGF0ZVJlamVjdGVkSABSCHJlamVjdGVkQgYKBHR5cGVCDQoLX3JlcXVlc3RfaW'
    'Q=');

@$core.Deprecated('Use projectCreatedDescriptor instead')
const ProjectCreated$json = {
  '1': 'ProjectCreated',
  '2': [
    {'1': 'project', '3': 1, '4': 1, '5': 11, '6': '.datahub.v1.Project', '10': 'project'},
  ],
};

/// Descriptor for `ProjectCreated`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List projectCreatedDescriptor = $convert.base64Decode(
    'Cg5Qcm9qZWN0Q3JlYXRlZBItCgdwcm9qZWN0GAEgASgLMhMuZGF0YWh1Yi52MS5Qcm9qZWN0Ug'
    'dwcm9qZWN0');

@$core.Deprecated('Use projectUpdatedDescriptor instead')
const ProjectUpdated$json = {
  '1': 'ProjectUpdated',
  '2': [
    {'1': 'project', '3': 1, '4': 1, '5': 11, '6': '.datahub.v1.Project', '10': 'project'},
  ],
};

/// Descriptor for `ProjectUpdated`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List projectUpdatedDescriptor = $convert.base64Decode(
    'Cg5Qcm9qZWN0VXBkYXRlZBItCgdwcm9qZWN0GAEgASgLMhMuZGF0YWh1Yi52MS5Qcm9qZWN0Ug'
    'dwcm9qZWN0');

@$core.Deprecated('Use projectRemovedDescriptor instead')
const ProjectRemoved$json = {
  '1': 'ProjectRemoved',
  '2': [
    {'1': 'project_id', '3': 2, '4': 1, '5': 4, '10': 'projectId'},
  ],
  '9': [
    {'1': 1, '2': 2},
  ],
};

/// Descriptor for `ProjectRemoved`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List projectRemovedDescriptor = $convert.base64Decode(
    'Cg5Qcm9qZWN0UmVtb3ZlZBIdCgpwcm9qZWN0X2lkGAIgASgEUglwcm9qZWN0SWRKBAgBEAI=');

@$core.Deprecated('Use roadEventCreatedDescriptor instead')
const RoadEventCreated$json = {
  '1': 'RoadEventCreated',
  '2': [
    {'1': 'road_event', '3': 1, '4': 1, '5': 11, '6': '.datahub.v1.RoadEvent', '10': 'roadEvent'},
    {'1': 'road_sub_events', '3': 3, '4': 3, '5': 11, '6': '.datahub.v1.RoadSubEvent', '10': 'roadSubEvents'},
  ],
  '9': [
    {'1': 2, '2': 3},
  ],
};

/// Descriptor for `RoadEventCreated`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List roadEventCreatedDescriptor = $convert.base64Decode(
    'ChBSb2FkRXZlbnRDcmVhdGVkEjQKCnJvYWRfZXZlbnQYASABKAsyFS5kYXRhaHViLnYxLlJvYW'
    'RFdmVudFIJcm9hZEV2ZW50EkAKD3JvYWRfc3ViX2V2ZW50cxgDIAMoCzIYLmRhdGFodWIudjEu'
    'Um9hZFN1YkV2ZW50Ug1yb2FkU3ViRXZlbnRzSgQIAhAD');

@$core.Deprecated('Use roadEventUpdatedDescriptor instead')
const RoadEventUpdated$json = {
  '1': 'RoadEventUpdated',
  '2': [
    {'1': 'road_event', '3': 1, '4': 1, '5': 11, '6': '.datahub.v1.RoadEvent', '10': 'roadEvent'},
    {'1': 'road_sub_events', '3': 5, '4': 3, '5': 11, '6': '.datahub.v1.RoadSubEvent', '10': 'roadSubEvents'},
  ],
  '9': [
    {'1': 2, '2': 3},
    {'1': 3, '2': 4},
    {'1': 4, '2': 5},
  ],
};

/// Descriptor for `RoadEventUpdated`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List roadEventUpdatedDescriptor = $convert.base64Decode(
    'ChBSb2FkRXZlbnRVcGRhdGVkEjQKCnJvYWRfZXZlbnQYASABKAsyFS5kYXRhaHViLnYxLlJvYW'
    'RFdmVudFIJcm9hZEV2ZW50EkAKD3JvYWRfc3ViX2V2ZW50cxgFIAMoCzIYLmRhdGFodWIudjEu'
    'Um9hZFN1YkV2ZW50Ug1yb2FkU3ViRXZlbnRzSgQIAhADSgQIAxAESgQIBBAF');

@$core.Deprecated('Use roadEventRemovedDescriptor instead')
const RoadEventRemoved$json = {
  '1': 'RoadEventRemoved',
  '2': [
    {'1': 'road_event_id', '3': 3, '4': 1, '5': 4, '10': 'roadEventId'},
  ],
  '9': [
    {'1': 1, '2': 2},
    {'1': 2, '2': 3},
  ],
};

/// Descriptor for `RoadEventRemoved`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List roadEventRemovedDescriptor = $convert.base64Decode(
    'ChBSb2FkRXZlbnRSZW1vdmVkEiIKDXJvYWRfZXZlbnRfaWQYAyABKARSC3JvYWRFdmVudElkSg'
    'QIARACSgQIAhAD');

@$core.Deprecated('Use roadEventUpdateApprovedDescriptor instead')
const RoadEventUpdateApproved$json = {
  '1': 'RoadEventUpdateApproved',
  '2': [
    {'1': 'original_request_id', '3': 1, '4': 1, '5': 4, '10': 'originalRequestId'},
    {'1': 'road_event', '3': 2, '4': 1, '5': 11, '6': '.datahub.v1.RoadEvent', '10': 'roadEvent'},
    {'1': 'road_sub_events', '3': 3, '4': 3, '5': 11, '6': '.datahub.v1.RoadSubEvent', '10': 'roadSubEvents'},
  ],
};

/// Descriptor for `RoadEventUpdateApproved`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List roadEventUpdateApprovedDescriptor = $convert.base64Decode(
    'ChdSb2FkRXZlbnRVcGRhdGVBcHByb3ZlZBIuChNvcmlnaW5hbF9yZXF1ZXN0X2lkGAEgASgEUh'
    'FvcmlnaW5hbFJlcXVlc3RJZBI0Cgpyb2FkX2V2ZW50GAIgASgLMhUuZGF0YWh1Yi52MS5Sb2Fk'
    'RXZlbnRSCXJvYWRFdmVudBJACg9yb2FkX3N1Yl9ldmVudHMYAyADKAsyGC5kYXRhaHViLnYxLl'
    'JvYWRTdWJFdmVudFINcm9hZFN1YkV2ZW50cw==');

@$core.Deprecated('Use roadEventUpdateRejectedDescriptor instead')
const RoadEventUpdateRejected$json = {
  '1': 'RoadEventUpdateRejected',
  '2': [
    {'1': 'original_request_id', '3': 1, '4': 1, '5': 4, '10': 'originalRequestId'},
  ],
};

/// Descriptor for `RoadEventUpdateRejected`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List roadEventUpdateRejectedDescriptor = $convert.base64Decode(
    'ChdSb2FkRXZlbnRVcGRhdGVSZWplY3RlZBIuChNvcmlnaW5hbF9yZXF1ZXN0X2lkGAEgASgEUh'
    'FvcmlnaW5hbFJlcXVlc3RJZA==');

