// This is a generated file - do not edit.
//
// Generated from project.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use projectDescriptor instead')
const Project$json = {
  '1': 'Project',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 4, '10': 'id'},
    {'1': 'name', '3': 2, '4': 1, '5': 9, '10': 'name'},
    {'1': 'description', '3': 3, '4': 1, '5': 9, '10': 'description'},
    {'1': 'active_status', '3': 4, '4': 1, '5': 14, '6': '.datahub.v1.Project.ProjectActiveStatus', '10': 'activeStatus'},
    {'1': 'creation_date', '3': 5, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'creationDate'},
    {'1': 'start_date', '3': 6, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'startDate'},
    {'1': 'end_date', '3': 7, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'endDate'},
  ],
  '4': [Project_ProjectActiveStatus$json],
};

@$core.Deprecated('Use projectDescriptor instead')
const Project_ProjectActiveStatus$json = {
  '1': 'ProjectActiveStatus',
  '2': [
    {'1': 'PROJECT_ACTIVE_STATUS_UNKNOWN', '2': 0},
    {'1': 'PROJECT_ACTIVE_STATUS_ACTIVE', '2': 1},
    {'1': 'PROJECT_ACTIVE_STATUS_SUSPENDED', '2': 2},
  ],
};

/// Descriptor for `Project`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List projectDescriptor = $convert.base64Decode(
    'CgdQcm9qZWN0Eg4KAmlkGAEgASgEUgJpZBISCgRuYW1lGAIgASgJUgRuYW1lEiAKC2Rlc2NyaX'
    'B0aW9uGAMgASgJUgtkZXNjcmlwdGlvbhJMCg1hY3RpdmVfc3RhdHVzGAQgASgOMicuZGF0YWh1'
    'Yi52MS5Qcm9qZWN0LlByb2plY3RBY3RpdmVTdGF0dXNSDGFjdGl2ZVN0YXR1cxI/Cg1jcmVhdG'
    'lvbl9kYXRlGAUgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIMY3JlYXRpb25EYXRl'
    'EjkKCnN0YXJ0X2RhdGUYBiABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUglzdGFydE'
    'RhdGUSNQoIZW5kX2RhdGUYByABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgdlbmRE'
    'YXRlIn8KE1Byb2plY3RBY3RpdmVTdGF0dXMSIQodUFJPSkVDVF9BQ1RJVkVfU1RBVFVTX1VOS0'
    '5PV04QABIgChxQUk9KRUNUX0FDVElWRV9TVEFUVVNfQUNUSVZFEAESIwofUFJPSkVDVF9BQ1RJ'
    'VkVfU1RBVFVTX1NVU1BFTkRFRBAC');

