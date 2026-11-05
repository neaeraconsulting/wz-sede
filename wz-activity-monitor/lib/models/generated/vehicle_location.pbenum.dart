//
//  Generated code. Do not modify.
//  source: vehicle_location.proto
//
// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class VehicleLocation_VehicleOperationType extends $pb.ProtobufEnum {
  static const VehicleLocation_VehicleOperationType VEHICLE_OPERATION_STRIPING = VehicleLocation_VehicleOperationType._(0, _omitEnumNames ? '' : 'VEHICLE_OPERATION_STRIPING');
  static const VehicleLocation_VehicleOperationType VEHICLE_OPERATION_PLOWING = VehicleLocation_VehicleOperationType._(1, _omitEnumNames ? '' : 'VEHICLE_OPERATION_PLOWING');
  static const VehicleLocation_VehicleOperationType VEHICLE_OPERATION_MOWING = VehicleLocation_VehicleOperationType._(2, _omitEnumNames ? '' : 'VEHICLE_OPERATION_MOWING');
  static const VehicleLocation_VehicleOperationType VEHICLE_OPERATION_GENERAL_ACTIVE = VehicleLocation_VehicleOperationType._(3, _omitEnumNames ? '' : 'VEHICLE_OPERATION_GENERAL_ACTIVE');
  static const VehicleLocation_VehicleOperationType VEHICLE_OPERATION_GENERAL_INACTIVE = VehicleLocation_VehicleOperationType._(4, _omitEnumNames ? '' : 'VEHICLE_OPERATION_GENERAL_INACTIVE');
  static const VehicleLocation_VehicleOperationType VEHICLE_OPERATION_UNKNOWN = VehicleLocation_VehicleOperationType._(5, _omitEnumNames ? '' : 'VEHICLE_OPERATION_UNKNOWN');

  static const $core.List<VehicleLocation_VehicleOperationType> values = <VehicleLocation_VehicleOperationType> [
    VEHICLE_OPERATION_STRIPING,
    VEHICLE_OPERATION_PLOWING,
    VEHICLE_OPERATION_MOWING,
    VEHICLE_OPERATION_GENERAL_ACTIVE,
    VEHICLE_OPERATION_GENERAL_INACTIVE,
    VEHICLE_OPERATION_UNKNOWN,
  ];

  static final $core.List<VehicleLocation_VehicleOperationType?> _byValue = $pb.ProtobufEnum.$_initByValueList(values, 5);
  static VehicleLocation_VehicleOperationType? valueOf($core.int value) =>  value < 0 || value >= _byValue.length ? null : _byValue[value];

  const VehicleLocation_VehicleOperationType._(super.v, super.n);
}


const _omitEnumNames = $core.bool.fromEnvironment('protobuf.omit_enum_names');
