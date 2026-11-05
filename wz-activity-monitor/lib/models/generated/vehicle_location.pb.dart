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

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import 'common.pb.dart' as $8;
import 'vehicle_location.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'vehicle_location.pbenum.dart';

class VehicleLocation extends $pb.GeneratedMessage {
  factory VehicleLocation({
    $fixnum.Int64? id,
    $core.String? licensePlate,
    VehicleLocation_VehicleOperationType? operationType,
    $8.PointGeometry? location,
    $core.double? velocityKph,
    $core.double? heading,
    $fixnum.Int64? requestId,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    if (licensePlate != null) {
      $result.licensePlate = licensePlate;
    }
    if (operationType != null) {
      $result.operationType = operationType;
    }
    if (location != null) {
      $result.location = location;
    }
    if (velocityKph != null) {
      $result.velocityKph = velocityKph;
    }
    if (heading != null) {
      $result.heading = heading;
    }
    if (requestId != null) {
      $result.requestId = requestId;
    }
    return $result;
  }
  VehicleLocation._() : super();
  factory VehicleLocation.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory VehicleLocation.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'VehicleLocation', package: const $pb.PackageName(_omitMessageNames ? '' : 'datahub.v1'), createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, _omitFieldNames ? '' : 'id', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOS(2, _omitFieldNames ? '' : 'licensePlate')
    ..e<VehicleLocation_VehicleOperationType>(3, _omitFieldNames ? '' : 'operationType', $pb.PbFieldType.OE, defaultOrMaker: VehicleLocation_VehicleOperationType.VEHICLE_OPERATION_STRIPING, valueOf: VehicleLocation_VehicleOperationType.valueOf, enumValues: VehicleLocation_VehicleOperationType.values)
    ..aOM<$8.PointGeometry>(4, _omitFieldNames ? '' : 'location', subBuilder: $8.PointGeometry.create)
    ..a<$core.double>(5, _omitFieldNames ? '' : 'velocityKph', $pb.PbFieldType.OD)
    ..a<$core.double>(6, _omitFieldNames ? '' : 'heading', $pb.PbFieldType.OD)
    ..a<$fixnum.Int64>(7, _omitFieldNames ? '' : 'requestId', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VehicleLocation clone() => VehicleLocation()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  VehicleLocation copyWith(void Function(VehicleLocation) updates) => super.copyWith((message) => updates(message as VehicleLocation)) as VehicleLocation;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static VehicleLocation create() => VehicleLocation._();
  VehicleLocation createEmptyInstance() => create();
  static $pb.PbList<VehicleLocation> createRepeated() => $pb.PbList<VehicleLocation>();
  @$core.pragma('dart2js:noInline')
  static VehicleLocation getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<VehicleLocation>(create);
  static VehicleLocation? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get id => $_getI64(0);
  @$pb.TagNumber(1)
  set id($fixnum.Int64 v) { $_setInt64(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get licensePlate => $_getSZ(1);
  @$pb.TagNumber(2)
  set licensePlate($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasLicensePlate() => $_has(1);
  @$pb.TagNumber(2)
  void clearLicensePlate() => $_clearField(2);

  @$pb.TagNumber(3)
  VehicleLocation_VehicleOperationType get operationType => $_getN(2);
  @$pb.TagNumber(3)
  set operationType(VehicleLocation_VehicleOperationType v) { $_setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasOperationType() => $_has(2);
  @$pb.TagNumber(3)
  void clearOperationType() => $_clearField(3);

  @$pb.TagNumber(4)
  $8.PointGeometry get location => $_getN(3);
  @$pb.TagNumber(4)
  set location($8.PointGeometry v) { $_setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasLocation() => $_has(3);
  @$pb.TagNumber(4)
  void clearLocation() => $_clearField(4);
  @$pb.TagNumber(4)
  $8.PointGeometry ensureLocation() => $_ensure(3);

  @$pb.TagNumber(5)
  $core.double get velocityKph => $_getN(4);
  @$pb.TagNumber(5)
  set velocityKph($core.double v) { $_setDouble(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasVelocityKph() => $_has(4);
  @$pb.TagNumber(5)
  void clearVelocityKph() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.double get heading => $_getN(5);
  @$pb.TagNumber(6)
  set heading($core.double v) { $_setDouble(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasHeading() => $_has(5);
  @$pb.TagNumber(6)
  void clearHeading() => $_clearField(6);

  @$pb.TagNumber(7)
  $fixnum.Int64 get requestId => $_getI64(6);
  @$pb.TagNumber(7)
  set requestId($fixnum.Int64 v) { $_setInt64(6, v); }
  @$pb.TagNumber(7)
  $core.bool hasRequestId() => $_has(6);
  @$pb.TagNumber(7)
  void clearRequestId() => $_clearField(7);
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
