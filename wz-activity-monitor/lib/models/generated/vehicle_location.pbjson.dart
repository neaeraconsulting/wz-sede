//
//  Generated code. Do not modify.
//  source: vehicle_location.proto
//
// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use vehicleLocationDescriptor instead')
const VehicleLocation$json = {
  '1': 'VehicleLocation',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 4, '10': 'id'},
    {'1': 'license_plate', '3': 2, '4': 1, '5': 9, '10': 'licensePlate'},
    {'1': 'operation_type', '3': 3, '4': 1, '5': 14, '6': '.datahub.v1.VehicleLocation.VehicleOperationType', '10': 'operationType'},
    {'1': 'location', '3': 4, '4': 1, '5': 11, '6': '.datahub.v1.PointGeometry', '10': 'location'},
    {'1': 'velocity_kph', '3': 5, '4': 1, '5': 1, '10': 'velocityKph'},
    {'1': 'heading', '3': 6, '4': 1, '5': 1, '10': 'heading'},
    {'1': 'request_id', '3': 7, '4': 1, '5': 4, '10': 'requestId'},
  ],
  '4': [VehicleLocation_VehicleOperationType$json],
};

@$core.Deprecated('Use vehicleLocationDescriptor instead')
const VehicleLocation_VehicleOperationType$json = {
  '1': 'VehicleOperationType',
  '2': [
    {'1': 'VEHICLE_OPERATION_STRIPING', '2': 0},
    {'1': 'VEHICLE_OPERATION_PLOWING', '2': 1},
    {'1': 'VEHICLE_OPERATION_MOWING', '2': 2},
    {'1': 'VEHICLE_OPERATION_GENERAL_ACTIVE', '2': 3},
    {'1': 'VEHICLE_OPERATION_GENERAL_INACTIVE', '2': 4},
    {'1': 'VEHICLE_OPERATION_UNKNOWN', '2': 5},
  ],
};

/// Descriptor for `VehicleLocation`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List vehicleLocationDescriptor = $convert.base64Decode(
    'Cg9WZWhpY2xlTG9jYXRpb24SDgoCaWQYASABKARSAmlkEiMKDWxpY2Vuc2VfcGxhdGUYAiABKA'
    'lSDGxpY2Vuc2VQbGF0ZRJXCg5vcGVyYXRpb25fdHlwZRgDIAEoDjIwLmRhdGFodWIudjEuVmVo'
    'aWNsZUxvY2F0aW9uLlZlaGljbGVPcGVyYXRpb25UeXBlUg1vcGVyYXRpb25UeXBlEjUKCGxvY2'
    'F0aW9uGAQgASgLMhkuZGF0YWh1Yi52MS5Qb2ludEdlb21ldHJ5Ughsb2NhdGlvbhIhCgx2ZWxv'
    'Y2l0eV9rcGgYBSABKAFSC3ZlbG9jaXR5S3BoEhgKB2hlYWRpbmcYBiABKAFSB2hlYWRpbmcSHQ'
    'oKcmVxdWVzdF9pZBgHIAEoBFIJcmVxdWVzdElkIuABChRWZWhpY2xlT3BlcmF0aW9uVHlwZRIe'
    'ChpWRUhJQ0xFX09QRVJBVElPTl9TVFJJUElORxAAEh0KGVZFSElDTEVfT1BFUkFUSU9OX1BMT1'
    'dJTkcQARIcChhWRUhJQ0xFX09QRVJBVElPTl9NT1dJTkcQAhIkCiBWRUhJQ0xFX09QRVJBVElP'
    'Tl9HRU5FUkFMX0FDVElWRRADEiYKIlZFSElDTEVfT1BFUkFUSU9OX0dFTkVSQUxfSU5BQ1RJVk'
    'UQBBIdChlWRUhJQ0xFX09QRVJBVElPTl9VTktOT1dOEAU=');

