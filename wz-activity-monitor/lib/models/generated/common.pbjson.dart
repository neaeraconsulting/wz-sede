// This is a generated file - do not edit.
//
// Generated from common.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use roadSurfaceTypeDescriptor instead')
const RoadSurfaceType$json = {
  '1': 'RoadSurfaceType',
  '2': [
    {'1': 'ROAD_SURFACE_UNKNOWN', '2': 0},
    {'1': 'ROAD_SURFACE_TYPE_PAVED', '2': 1},
    {'1': 'ROAD_SURFACE_TYPE_GRAVEL', '2': 2},
    {'1': 'ROAD_SURFACE_TYPE_DIRT', '2': 3},
    {'1': 'ROAD_SURFACE_TYPE_GROOVED', '2': 4},
  ],
};

/// Descriptor for `RoadSurfaceType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List roadSurfaceTypeDescriptor = $convert.base64Decode(
    'Cg9Sb2FkU3VyZmFjZVR5cGUSGAoUUk9BRF9TVVJGQUNFX1VOS05PV04QABIbChdST0FEX1NVUk'
    'ZBQ0VfVFlQRV9QQVZFRBABEhwKGFJPQURfU1VSRkFDRV9UWVBFX0dSQVZFTBACEhoKFlJPQURf'
    'U1VSRkFDRV9UWVBFX0RJUlQQAxIdChlST0FEX1NVUkZBQ0VfVFlQRV9HUk9PVkVEEAQ=');

@$core.Deprecated('Use markedLocationTypeDescriptor instead')
const MarkedLocationType$json = {
  '1': 'MarkedLocationType',
  '2': [
    {'1': 'MARKED_LOCATION_TYPE_UNKNOWN', '2': 0},
    {'1': 'MARKED_LOCATION_TYPE_GENERIC', '2': 1},
    {'1': 'MARKED_LOCATION_TYPE_FLAGGER', '2': 2},
    {'1': 'MARKED_LOCATION_TYPE_LANE_CLOSURE_START', '2': 3},
    {'1': 'MARKED_LOCATION_TYPE_LANE_CLOSURE_END', '2': 4},
    {'1': 'MARKED_LOCATION_TYPE_WORKER_PRESENCE_START', '2': 5},
    {'1': 'MARKED_LOCATION_TYPE_WORKER_PRESENCE_END', '2': 6},
    {'1': 'MARKED_LOCATION_TYPE_WORKER_POSITION', '2': 7},
    {'1': 'MARKED_LOCATION_TYPE_ROAD_CLOSURE_START', '2': 8},
    {'1': 'MARKED_LOCATION_TYPE_ROAD_CLOSURE_END', '2': 9},
    {'1': 'MARKED_LOCATION_TYPE_ROAD_EVENT_START', '2': 10},
    {'1': 'MARKED_LOCATION_TYPE_ROAD_EVENT_END', '2': 11},
    {'1': 'MARKED_LOCATION_TYPE_SPEED_REDUCTION_START', '2': 12},
    {'1': 'MARKED_LOCATION_TYPE_SPEED_REDUCTION_END', '2': 13},
    {'1': 'MARKED_LOCATION_TYPE_INCIDENT_START', '2': 14},
    {'1': 'MARKED_LOCATION_TYPE_INCIDENT_END', '2': 15},
    {'1': 'MARKED_LOCATION_TYPE_APPROACH_REGION', '2': 16},
  ],
};

/// Descriptor for `MarkedLocationType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List markedLocationTypeDescriptor = $convert.base64Decode(
    'ChJNYXJrZWRMb2NhdGlvblR5cGUSIAocTUFSS0VEX0xPQ0FUSU9OX1RZUEVfVU5LTk9XThAAEi'
    'AKHE1BUktFRF9MT0NBVElPTl9UWVBFX0dFTkVSSUMQARIgChxNQVJLRURfTE9DQVRJT05fVFlQ'
    'RV9GTEFHR0VSEAISKwonTUFSS0VEX0xPQ0FUSU9OX1RZUEVfTEFORV9DTE9TVVJFX1NUQVJUEA'
    'MSKQolTUFSS0VEX0xPQ0FUSU9OX1RZUEVfTEFORV9DTE9TVVJFX0VORBAEEi4KKk1BUktFRF9M'
    'T0NBVElPTl9UWVBFX1dPUktFUl9QUkVTRU5DRV9TVEFSVBAFEiwKKE1BUktFRF9MT0NBVElPTl'
    '9UWVBFX1dPUktFUl9QUkVTRU5DRV9FTkQQBhIoCiRNQVJLRURfTE9DQVRJT05fVFlQRV9XT1JL'
    'RVJfUE9TSVRJT04QBxIrCidNQVJLRURfTE9DQVRJT05fVFlQRV9ST0FEX0NMT1NVUkVfU1RBUl'
    'QQCBIpCiVNQVJLRURfTE9DQVRJT05fVFlQRV9ST0FEX0NMT1NVUkVfRU5EEAkSKQolTUFSS0VE'
    'X0xPQ0FUSU9OX1RZUEVfUk9BRF9FVkVOVF9TVEFSVBAKEicKI01BUktFRF9MT0NBVElPTl9UWV'
    'BFX1JPQURfRVZFTlRfRU5EEAsSLgoqTUFSS0VEX0xPQ0FUSU9OX1RZUEVfU1BFRURfUkVEVUNU'
    'SU9OX1NUQVJUEAwSLAooTUFSS0VEX0xPQ0FUSU9OX1RZUEVfU1BFRURfUkVEVUNUSU9OX0VORB'
    'ANEicKI01BUktFRF9MT0NBVElPTl9UWVBFX0lOQ0lERU5UX1NUQVJUEA4SJQohTUFSS0VEX0xP'
    'Q0FUSU9OX1RZUEVfSU5DSURFTlRfRU5EEA8SKAokTUFSS0VEX0xPQ0FUSU9OX1RZUEVfQVBQUk'
    '9BQ0hfUkVHSU9OEBA=');

@$core.Deprecated('Use contactInfoDescriptor instead')
const ContactInfo$json = {
  '1': 'ContactInfo',
  '2': [
    {'1': 'first_name', '3': 1, '4': 1, '5': 9, '10': 'firstName'},
    {'1': 'last_name', '3': 2, '4': 1, '5': 9, '10': 'lastName'},
    {'1': 'email', '3': 3, '4': 1, '5': 9, '10': 'email'},
    {'1': 'phone_number', '3': 4, '4': 1, '5': 11, '6': '.datahub.v1.PhoneNumber', '10': 'phoneNumber'},
  ],
};

/// Descriptor for `ContactInfo`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List contactInfoDescriptor = $convert.base64Decode(
    'CgtDb250YWN0SW5mbxIdCgpmaXJzdF9uYW1lGAEgASgJUglmaXJzdE5hbWUSGwoJbGFzdF9uYW'
    '1lGAIgASgJUghsYXN0TmFtZRIUCgVlbWFpbBgDIAEoCVIFZW1haWwSOgoMcGhvbmVfbnVtYmVy'
    'GAQgASgLMhcuZGF0YWh1Yi52MS5QaG9uZU51bWJlclILcGhvbmVOdW1iZXI=');

@$core.Deprecated('Use phoneNumberDescriptor instead')
const PhoneNumber$json = {
  '1': 'PhoneNumber',
  '2': [
    {'1': 'country_code', '3': 1, '4': 1, '5': 5, '10': 'countryCode'},
    {'1': 'area_code', '3': 2, '4': 1, '5': 5, '10': 'areaCode'},
    {'1': 'number', '3': 3, '4': 1, '5': 9, '10': 'number'},
  ],
};

/// Descriptor for `PhoneNumber`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List phoneNumberDescriptor = $convert.base64Decode(
    'CgtQaG9uZU51bWJlchIhCgxjb3VudHJ5X2NvZGUYASABKAVSC2NvdW50cnlDb2RlEhsKCWFyZW'
    'FfY29kZRgCIAEoBVIIYXJlYUNvZGUSFgoGbnVtYmVyGAMgASgJUgZudW1iZXI=');

@$core.Deprecated('Use geometryDescriptor instead')
const Geometry$json = {
  '1': 'Geometry',
  '2': [
    {'1': 'point', '3': 1, '4': 1, '5': 11, '6': '.datahub.v1.PointGeometry', '9': 0, '10': 'point'},
    {'1': 'multi_point', '3': 2, '4': 1, '5': 11, '6': '.datahub.v1.MultiPointGeometry', '9': 0, '10': 'multiPoint'},
    {'1': 'line_strings', '3': 3, '4': 1, '5': 11, '6': '.datahub.v1.MultiLineStringGeometry', '9': 0, '10': 'lineStrings'},
    {'1': 'polygons', '3': 4, '4': 1, '5': 11, '6': '.datahub.v1.MultiPolygonGeometry', '9': 0, '10': 'polygons'},
  ],
  '8': [
    {'1': 'geometry'},
  ],
};

/// Descriptor for `Geometry`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List geometryDescriptor = $convert.base64Decode(
    'CghHZW9tZXRyeRIxCgVwb2ludBgBIAEoCzIZLmRhdGFodWIudjEuUG9pbnRHZW9tZXRyeUgAUg'
    'Vwb2ludBJBCgttdWx0aV9wb2ludBgCIAEoCzIeLmRhdGFodWIudjEuTXVsdGlQb2ludEdlb21l'
    'dHJ5SABSCm11bHRpUG9pbnQSSAoMbGluZV9zdHJpbmdzGAMgASgLMiMuZGF0YWh1Yi52MS5NdW'
    'x0aUxpbmVTdHJpbmdHZW9tZXRyeUgAUgtsaW5lU3RyaW5ncxI+Cghwb2x5Z29ucxgEIAEoCzIg'
    'LmRhdGFodWIudjEuTXVsdGlQb2x5Z29uR2VvbWV0cnlIAFIIcG9seWdvbnNCCgoIZ2VvbWV0cn'
    'k=');

@$core.Deprecated('Use pointGeometryDescriptor instead')
const PointGeometry$json = {
  '1': 'PointGeometry',
  '2': [
    {'1': 'coordinates', '3': 1, '4': 1, '5': 11, '6': '.google.type.LatLng', '10': 'coordinates'},
  ],
};

/// Descriptor for `PointGeometry`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List pointGeometryDescriptor = $convert.base64Decode(
    'Cg1Qb2ludEdlb21ldHJ5EjUKC2Nvb3JkaW5hdGVzGAEgASgLMhMuZ29vZ2xlLnR5cGUuTGF0TG'
    '5nUgtjb29yZGluYXRlcw==');

@$core.Deprecated('Use multiPolygonGeometryDescriptor instead')
const MultiPolygonGeometry$json = {
  '1': 'MultiPolygonGeometry',
  '2': [
    {'1': 'polygons', '3': 1, '4': 3, '5': 11, '6': '.datahub.v1.PolygonGeometry', '10': 'polygons'},
  ],
};

/// Descriptor for `MultiPolygonGeometry`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List multiPolygonGeometryDescriptor = $convert.base64Decode(
    'ChRNdWx0aVBvbHlnb25HZW9tZXRyeRI3Cghwb2x5Z29ucxgBIAMoCzIbLmRhdGFodWIudjEuUG'
    '9seWdvbkdlb21ldHJ5Ughwb2x5Z29ucw==');

@$core.Deprecated('Use polygonGeometryDescriptor instead')
const PolygonGeometry$json = {
  '1': 'PolygonGeometry',
  '2': [
    {'1': 'coordinates', '3': 1, '4': 1, '5': 11, '6': '.datahub.v1.PointArray', '10': 'coordinates'},
  ],
};

/// Descriptor for `PolygonGeometry`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List polygonGeometryDescriptor = $convert.base64Decode(
    'Cg9Qb2x5Z29uR2VvbWV0cnkSOAoLY29vcmRpbmF0ZXMYASABKAsyFi5kYXRhaHViLnYxLlBvaW'
    '50QXJyYXlSC2Nvb3JkaW5hdGVz');

@$core.Deprecated('Use multiLineStringGeometryDescriptor instead')
const MultiLineStringGeometry$json = {
  '1': 'MultiLineStringGeometry',
  '2': [
    {'1': 'line_strings', '3': 1, '4': 3, '5': 11, '6': '.datahub.v1.LineStringGeometry', '10': 'lineStrings'},
  ],
};

/// Descriptor for `MultiLineStringGeometry`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List multiLineStringGeometryDescriptor = $convert.base64Decode(
    'ChdNdWx0aUxpbmVTdHJpbmdHZW9tZXRyeRJBCgxsaW5lX3N0cmluZ3MYASADKAsyHi5kYXRhaH'
    'ViLnYxLkxpbmVTdHJpbmdHZW9tZXRyeVILbGluZVN0cmluZ3M=');

@$core.Deprecated('Use lineStringGeometryDescriptor instead')
const LineStringGeometry$json = {
  '1': 'LineStringGeometry',
  '2': [
    {'1': 'coordinates', '3': 1, '4': 1, '5': 11, '6': '.datahub.v1.PointArray', '10': 'coordinates'},
    {'1': 'line_width_m', '3': 2, '4': 1, '5': 2, '9': 0, '10': 'lineWidthM', '17': true},
  ],
  '8': [
    {'1': '_line_width_m'},
  ],
};

/// Descriptor for `LineStringGeometry`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List lineStringGeometryDescriptor = $convert.base64Decode(
    'ChJMaW5lU3RyaW5nR2VvbWV0cnkSOAoLY29vcmRpbmF0ZXMYASABKAsyFi5kYXRhaHViLnYxLl'
    'BvaW50QXJyYXlSC2Nvb3JkaW5hdGVzEiUKDGxpbmVfd2lkdGhfbRgCIAEoAkgAUgpsaW5lV2lk'
    'dGhNiAEBQg8KDV9saW5lX3dpZHRoX20=');

@$core.Deprecated('Use multiPointGeometryDescriptor instead')
const MultiPointGeometry$json = {
  '1': 'MultiPointGeometry',
  '2': [
    {'1': 'coordinates', '3': 1, '4': 3, '5': 11, '6': '.google.type.LatLng', '10': 'coordinates'},
  ],
};

/// Descriptor for `MultiPointGeometry`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List multiPointGeometryDescriptor = $convert.base64Decode(
    'ChJNdWx0aVBvaW50R2VvbWV0cnkSNQoLY29vcmRpbmF0ZXMYASADKAsyEy5nb29nbGUudHlwZS'
    '5MYXRMbmdSC2Nvb3JkaW5hdGVz');

@$core.Deprecated('Use pointArrayDescriptor instead')
const PointArray$json = {
  '1': 'PointArray',
  '2': [
    {'1': 'coordinates', '3': 1, '4': 3, '5': 11, '6': '.google.type.LatLng', '10': 'coordinates'},
  ],
};

/// Descriptor for `PointArray`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List pointArrayDescriptor = $convert.base64Decode(
    'CgpQb2ludEFycmF5EjUKC2Nvb3JkaW5hdGVzGAEgAygLMhMuZ29vZ2xlLnR5cGUuTGF0TG5nUg'
    'tjb29yZGluYXRlcw==');

@$core.Deprecated('Use boundingBoxDescriptor instead')
const BoundingBox$json = {
  '1': 'BoundingBox',
  '2': [
    {'1': 'lower_left', '3': 1, '4': 1, '5': 11, '6': '.google.type.LatLng', '10': 'lowerLeft'},
    {'1': 'upper_right', '3': 2, '4': 1, '5': 11, '6': '.google.type.LatLng', '10': 'upperRight'},
  ],
};

/// Descriptor for `BoundingBox`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List boundingBoxDescriptor = $convert.base64Decode(
    'CgtCb3VuZGluZ0JveBIyCgpsb3dlcl9sZWZ0GAEgASgLMhMuZ29vZ2xlLnR5cGUuTGF0TG5nUg'
    'lsb3dlckxlZnQSNAoLdXBwZXJfcmlnaHQYAiABKAsyEy5nb29nbGUudHlwZS5MYXRMbmdSCnVw'
    'cGVyUmlnaHQ=');

