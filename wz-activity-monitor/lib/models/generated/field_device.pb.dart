// This is a generated file - do not edit.
//
// Generated from field_device.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import 'common.pb.dart' as $0;
import 'field_device.pbenum.dart';
import 'google/protobuf/timestamp.pb.dart' as $1;
import 'wzdx.pbenum.dart' as $2;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'field_device.pbenum.dart';

class FieldDevice_FieldDeviceCoreDetails extends $pb.GeneratedMessage {
  factory FieldDevice_FieldDeviceCoreDetails({
    FieldDevice_FieldDeviceStatus? deviceStatus,
    $core.bool? hasAutomaticLocation,
    $2.RoadwayDirection? roadDirection,
    $core.Iterable<$core.String>? roadNames,
    $core.String? name,
    $core.String? description,
    $core.Iterable<$core.String>? statusMessages,
    $core.bool? isMoving,
    $core.double? milepost,
    $core.String? make,
    $core.String? model,
    $core.String? serialNumber,
    $core.String? firmwareVersion,
    $core.double? velocityKph,
  }) {
    final result = create();
    if (deviceStatus != null) result.deviceStatus = deviceStatus;
    if (hasAutomaticLocation != null) result.hasAutomaticLocation = hasAutomaticLocation;
    if (roadDirection != null) result.roadDirection = roadDirection;
    if (roadNames != null) result.roadNames.addAll(roadNames);
    if (name != null) result.name = name;
    if (description != null) result.description = description;
    if (statusMessages != null) result.statusMessages.addAll(statusMessages);
    if (isMoving != null) result.isMoving = isMoving;
    if (milepost != null) result.milepost = milepost;
    if (make != null) result.make = make;
    if (model != null) result.model = model;
    if (serialNumber != null) result.serialNumber = serialNumber;
    if (firmwareVersion != null) result.firmwareVersion = firmwareVersion;
    if (velocityKph != null) result.velocityKph = velocityKph;
    return result;
  }

  FieldDevice_FieldDeviceCoreDetails._();

  factory FieldDevice_FieldDeviceCoreDetails.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(data, registry);
  factory FieldDevice_FieldDeviceCoreDetails.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'FieldDevice.FieldDeviceCoreDetails', package: const $pb.PackageName(_omitMessageNames ? '' : 'datahub.v1'), createEmptyInstance: create)
    ..e<FieldDevice_FieldDeviceStatus>(1, _omitFieldNames ? '' : 'deviceStatus', $pb.PbFieldType.OE, defaultOrMaker: FieldDevice_FieldDeviceStatus.FIELD_DEVICE_STATUS_UNKNOWN, valueOf: FieldDevice_FieldDeviceStatus.valueOf, enumValues: FieldDevice_FieldDeviceStatus.values)
    ..aOB(2, _omitFieldNames ? '' : 'hasAutomaticLocation')
    ..e<$2.RoadwayDirection>(3, _omitFieldNames ? '' : 'roadDirection', $pb.PbFieldType.OE, defaultOrMaker: $2.RoadwayDirection.ROADWAY_DIRECTION_UNKNOWN, valueOf: $2.RoadwayDirection.valueOf, enumValues: $2.RoadwayDirection.values)
    ..pPS(4, _omitFieldNames ? '' : 'roadNames')
    ..aOS(5, _omitFieldNames ? '' : 'name')
    ..aOS(6, _omitFieldNames ? '' : 'description')
    ..pPS(7, _omitFieldNames ? '' : 'statusMessages')
    ..aOB(8, _omitFieldNames ? '' : 'isMoving')
    ..a<$core.double>(12, _omitFieldNames ? '' : 'milepost', $pb.PbFieldType.OD)
    ..aOS(13, _omitFieldNames ? '' : 'make')
    ..aOS(14, _omitFieldNames ? '' : 'model')
    ..aOS(15, _omitFieldNames ? '' : 'serialNumber')
    ..aOS(16, _omitFieldNames ? '' : 'firmwareVersion')
    ..a<$core.double>(17, _omitFieldNames ? '' : 'velocityKph', $pb.PbFieldType.OD)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FieldDevice_FieldDeviceCoreDetails clone() => FieldDevice_FieldDeviceCoreDetails()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FieldDevice_FieldDeviceCoreDetails copyWith(void Function(FieldDevice_FieldDeviceCoreDetails) updates) => super.copyWith((message) => updates(message as FieldDevice_FieldDeviceCoreDetails)) as FieldDevice_FieldDeviceCoreDetails;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FieldDevice_FieldDeviceCoreDetails create() => FieldDevice_FieldDeviceCoreDetails._();
  @$core.override
  FieldDevice_FieldDeviceCoreDetails createEmptyInstance() => create();
  static $pb.PbList<FieldDevice_FieldDeviceCoreDetails> createRepeated() => $pb.PbList<FieldDevice_FieldDeviceCoreDetails>();
  @$core.pragma('dart2js:noInline')
  static FieldDevice_FieldDeviceCoreDetails getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<FieldDevice_FieldDeviceCoreDetails>(create);
  static FieldDevice_FieldDeviceCoreDetails? _defaultInstance;

  @$pb.TagNumber(1)
  FieldDevice_FieldDeviceStatus get deviceStatus => $_getN(0);
  @$pb.TagNumber(1)
  set deviceStatus(FieldDevice_FieldDeviceStatus value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasDeviceStatus() => $_has(0);
  @$pb.TagNumber(1)
  void clearDeviceStatus() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get hasAutomaticLocation => $_getBF(1);
  @$pb.TagNumber(2)
  set hasAutomaticLocation($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasHasAutomaticLocation() => $_has(1);
  @$pb.TagNumber(2)
  void clearHasAutomaticLocation() => $_clearField(2);

  @$pb.TagNumber(3)
  $2.RoadwayDirection get roadDirection => $_getN(2);
  @$pb.TagNumber(3)
  set roadDirection($2.RoadwayDirection value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasRoadDirection() => $_has(2);
  @$pb.TagNumber(3)
  void clearRoadDirection() => $_clearField(3);

  @$pb.TagNumber(4)
  $pb.PbList<$core.String> get roadNames => $_getList(3);

  @$pb.TagNumber(5)
  $core.String get name => $_getSZ(4);
  @$pb.TagNumber(5)
  set name($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasName() => $_has(4);
  @$pb.TagNumber(5)
  void clearName() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get description => $_getSZ(5);
  @$pb.TagNumber(6)
  set description($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasDescription() => $_has(5);
  @$pb.TagNumber(6)
  void clearDescription() => $_clearField(6);

  @$pb.TagNumber(7)
  $pb.PbList<$core.String> get statusMessages => $_getList(6);

  @$pb.TagNumber(8)
  $core.bool get isMoving => $_getBF(7);
  @$pb.TagNumber(8)
  set isMoving($core.bool value) => $_setBool(7, value);
  @$pb.TagNumber(8)
  $core.bool hasIsMoving() => $_has(7);
  @$pb.TagNumber(8)
  void clearIsMoving() => $_clearField(8);

  @$pb.TagNumber(12)
  $core.double get milepost => $_getN(8);
  @$pb.TagNumber(12)
  set milepost($core.double value) => $_setDouble(8, value);
  @$pb.TagNumber(12)
  $core.bool hasMilepost() => $_has(8);
  @$pb.TagNumber(12)
  void clearMilepost() => $_clearField(12);

  @$pb.TagNumber(13)
  $core.String get make => $_getSZ(9);
  @$pb.TagNumber(13)
  set make($core.String value) => $_setString(9, value);
  @$pb.TagNumber(13)
  $core.bool hasMake() => $_has(9);
  @$pb.TagNumber(13)
  void clearMake() => $_clearField(13);

  @$pb.TagNumber(14)
  $core.String get model => $_getSZ(10);
  @$pb.TagNumber(14)
  set model($core.String value) => $_setString(10, value);
  @$pb.TagNumber(14)
  $core.bool hasModel() => $_has(10);
  @$pb.TagNumber(14)
  void clearModel() => $_clearField(14);

  @$pb.TagNumber(15)
  $core.String get serialNumber => $_getSZ(11);
  @$pb.TagNumber(15)
  set serialNumber($core.String value) => $_setString(11, value);
  @$pb.TagNumber(15)
  $core.bool hasSerialNumber() => $_has(11);
  @$pb.TagNumber(15)
  void clearSerialNumber() => $_clearField(15);

  @$pb.TagNumber(16)
  $core.String get firmwareVersion => $_getSZ(12);
  @$pb.TagNumber(16)
  set firmwareVersion($core.String value) => $_setString(12, value);
  @$pb.TagNumber(16)
  $core.bool hasFirmwareVersion() => $_has(12);
  @$pb.TagNumber(16)
  void clearFirmwareVersion() => $_clearField(16);

  @$pb.TagNumber(17)
  $core.double get velocityKph => $_getN(13);
  @$pb.TagNumber(17)
  set velocityKph($core.double value) => $_setDouble(13, value);
  @$pb.TagNumber(17)
  $core.bool hasVelocityKph() => $_has(13);
  @$pb.TagNumber(17)
  void clearVelocityKph() => $_clearField(17);
}

class FieldDevice_ArrowBoard extends $pb.GeneratedMessage {
  factory FieldDevice_ArrowBoard({
    FieldDevice_ArrowBoard_ArrowBoardPattern? pattern,
    FieldDevice_ArrowBoard_ArrowBoardTransportPosition? isInTransportPosition,
  }) {
    final result = create();
    if (pattern != null) result.pattern = pattern;
    if (isInTransportPosition != null) result.isInTransportPosition = isInTransportPosition;
    return result;
  }

  FieldDevice_ArrowBoard._();

  factory FieldDevice_ArrowBoard.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(data, registry);
  factory FieldDevice_ArrowBoard.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'FieldDevice.ArrowBoard', package: const $pb.PackageName(_omitMessageNames ? '' : 'datahub.v1'), createEmptyInstance: create)
    ..e<FieldDevice_ArrowBoard_ArrowBoardPattern>(2, _omitFieldNames ? '' : 'pattern', $pb.PbFieldType.OE, defaultOrMaker: FieldDevice_ArrowBoard_ArrowBoardPattern.ARROW_BOARD_PATTERN_UNKNOWN, valueOf: FieldDevice_ArrowBoard_ArrowBoardPattern.valueOf, enumValues: FieldDevice_ArrowBoard_ArrowBoardPattern.values)
    ..e<FieldDevice_ArrowBoard_ArrowBoardTransportPosition>(4, _omitFieldNames ? '' : 'isInTransportPosition', $pb.PbFieldType.OE, defaultOrMaker: FieldDevice_ArrowBoard_ArrowBoardTransportPosition.ARROW_BOARD_TRANSPORT_POSITION_UNKNOWN, valueOf: FieldDevice_ArrowBoard_ArrowBoardTransportPosition.valueOf, enumValues: FieldDevice_ArrowBoard_ArrowBoardTransportPosition.values)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FieldDevice_ArrowBoard clone() => FieldDevice_ArrowBoard()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FieldDevice_ArrowBoard copyWith(void Function(FieldDevice_ArrowBoard) updates) => super.copyWith((message) => updates(message as FieldDevice_ArrowBoard)) as FieldDevice_ArrowBoard;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FieldDevice_ArrowBoard create() => FieldDevice_ArrowBoard._();
  @$core.override
  FieldDevice_ArrowBoard createEmptyInstance() => create();
  static $pb.PbList<FieldDevice_ArrowBoard> createRepeated() => $pb.PbList<FieldDevice_ArrowBoard>();
  @$core.pragma('dart2js:noInline')
  static FieldDevice_ArrowBoard getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<FieldDevice_ArrowBoard>(create);
  static FieldDevice_ArrowBoard? _defaultInstance;

  @$pb.TagNumber(2)
  FieldDevice_ArrowBoard_ArrowBoardPattern get pattern => $_getN(0);
  @$pb.TagNumber(2)
  set pattern(FieldDevice_ArrowBoard_ArrowBoardPattern value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasPattern() => $_has(0);
  @$pb.TagNumber(2)
  void clearPattern() => $_clearField(2);

  @$pb.TagNumber(4)
  FieldDevice_ArrowBoard_ArrowBoardTransportPosition get isInTransportPosition => $_getN(1);
  @$pb.TagNumber(4)
  set isInTransportPosition(FieldDevice_ArrowBoard_ArrowBoardTransportPosition value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasIsInTransportPosition() => $_has(1);
  @$pb.TagNumber(4)
  void clearIsInTransportPosition() => $_clearField(4);
}

class FieldDevice_Camera extends $pb.GeneratedMessage {
  factory FieldDevice_Camera({
    $core.String? imageUrl,
    $1.Timestamp? imageTimestamp,
  }) {
    final result = create();
    if (imageUrl != null) result.imageUrl = imageUrl;
    if (imageTimestamp != null) result.imageTimestamp = imageTimestamp;
    return result;
  }

  FieldDevice_Camera._();

  factory FieldDevice_Camera.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(data, registry);
  factory FieldDevice_Camera.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'FieldDevice.Camera', package: const $pb.PackageName(_omitMessageNames ? '' : 'datahub.v1'), createEmptyInstance: create)
    ..aOS(2, _omitFieldNames ? '' : 'imageUrl')
    ..aOM<$1.Timestamp>(3, _omitFieldNames ? '' : 'imageTimestamp', subBuilder: $1.Timestamp.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FieldDevice_Camera clone() => FieldDevice_Camera()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FieldDevice_Camera copyWith(void Function(FieldDevice_Camera) updates) => super.copyWith((message) => updates(message as FieldDevice_Camera)) as FieldDevice_Camera;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FieldDevice_Camera create() => FieldDevice_Camera._();
  @$core.override
  FieldDevice_Camera createEmptyInstance() => create();
  static $pb.PbList<FieldDevice_Camera> createRepeated() => $pb.PbList<FieldDevice_Camera>();
  @$core.pragma('dart2js:noInline')
  static FieldDevice_Camera getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<FieldDevice_Camera>(create);
  static FieldDevice_Camera? _defaultInstance;

  @$pb.TagNumber(2)
  $core.String get imageUrl => $_getSZ(0);
  @$pb.TagNumber(2)
  set imageUrl($core.String value) => $_setString(0, value);
  @$pb.TagNumber(2)
  $core.bool hasImageUrl() => $_has(0);
  @$pb.TagNumber(2)
  void clearImageUrl() => $_clearField(2);

  @$pb.TagNumber(3)
  $1.Timestamp get imageTimestamp => $_getN(1);
  @$pb.TagNumber(3)
  set imageTimestamp($1.Timestamp value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasImageTimestamp() => $_has(1);
  @$pb.TagNumber(3)
  void clearImageTimestamp() => $_clearField(3);
  @$pb.TagNumber(3)
  $1.Timestamp ensureImageTimestamp() => $_ensure(1);
}

class FieldDevice_DynamicMessageSign extends $pb.GeneratedMessage {
  factory FieldDevice_DynamicMessageSign({
    $core.String? messageMultiString,
  }) {
    final result = create();
    if (messageMultiString != null) result.messageMultiString = messageMultiString;
    return result;
  }

  FieldDevice_DynamicMessageSign._();

  factory FieldDevice_DynamicMessageSign.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(data, registry);
  factory FieldDevice_DynamicMessageSign.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'FieldDevice.DynamicMessageSign', package: const $pb.PackageName(_omitMessageNames ? '' : 'datahub.v1'), createEmptyInstance: create)
    ..aOS(2, _omitFieldNames ? '' : 'messageMultiString')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FieldDevice_DynamicMessageSign clone() => FieldDevice_DynamicMessageSign()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FieldDevice_DynamicMessageSign copyWith(void Function(FieldDevice_DynamicMessageSign) updates) => super.copyWith((message) => updates(message as FieldDevice_DynamicMessageSign)) as FieldDevice_DynamicMessageSign;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FieldDevice_DynamicMessageSign create() => FieldDevice_DynamicMessageSign._();
  @$core.override
  FieldDevice_DynamicMessageSign createEmptyInstance() => create();
  static $pb.PbList<FieldDevice_DynamicMessageSign> createRepeated() => $pb.PbList<FieldDevice_DynamicMessageSign>();
  @$core.pragma('dart2js:noInline')
  static FieldDevice_DynamicMessageSign getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<FieldDevice_DynamicMessageSign>(create);
  static FieldDevice_DynamicMessageSign? _defaultInstance;

  /// The MULTI (Mark-Up Language for Transportation Information, see NTCIP 1203 v03) formatted string describing the message currently posted to the sign.
  @$pb.TagNumber(2)
  $core.String get messageMultiString => $_getSZ(0);
  @$pb.TagNumber(2)
  set messageMultiString($core.String value) => $_setString(0, value);
  @$pb.TagNumber(2)
  $core.bool hasMessageMultiString() => $_has(0);
  @$pb.TagNumber(2)
  void clearMessageMultiString() => $_clearField(2);
}

class FieldDevice_FlashingBeacon extends $pb.GeneratedMessage {
  factory FieldDevice_FlashingBeacon({
    FieldDevice_FlashingBeacon_FlashingBeaconFunction? function,
    $core.bool? isFlashing,
    $core.String? signText,
  }) {
    final result = create();
    if (function != null) result.function = function;
    if (isFlashing != null) result.isFlashing = isFlashing;
    if (signText != null) result.signText = signText;
    return result;
  }

  FieldDevice_FlashingBeacon._();

  factory FieldDevice_FlashingBeacon.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(data, registry);
  factory FieldDevice_FlashingBeacon.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'FieldDevice.FlashingBeacon', package: const $pb.PackageName(_omitMessageNames ? '' : 'datahub.v1'), createEmptyInstance: create)
    ..e<FieldDevice_FlashingBeacon_FlashingBeaconFunction>(2, _omitFieldNames ? '' : 'function', $pb.PbFieldType.OE, defaultOrMaker: FieldDevice_FlashingBeacon_FlashingBeaconFunction.FLASHING_BEACON_FUNCTION_UNKNOWN, valueOf: FieldDevice_FlashingBeacon_FlashingBeaconFunction.valueOf, enumValues: FieldDevice_FlashingBeacon_FlashingBeaconFunction.values)
    ..aOB(3, _omitFieldNames ? '' : 'isFlashing')
    ..aOS(4, _omitFieldNames ? '' : 'signText')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FieldDevice_FlashingBeacon clone() => FieldDevice_FlashingBeacon()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FieldDevice_FlashingBeacon copyWith(void Function(FieldDevice_FlashingBeacon) updates) => super.copyWith((message) => updates(message as FieldDevice_FlashingBeacon)) as FieldDevice_FlashingBeacon;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FieldDevice_FlashingBeacon create() => FieldDevice_FlashingBeacon._();
  @$core.override
  FieldDevice_FlashingBeacon createEmptyInstance() => create();
  static $pb.PbList<FieldDevice_FlashingBeacon> createRepeated() => $pb.PbList<FieldDevice_FlashingBeacon>();
  @$core.pragma('dart2js:noInline')
  static FieldDevice_FlashingBeacon getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<FieldDevice_FlashingBeacon>(create);
  static FieldDevice_FlashingBeacon? _defaultInstance;

  @$pb.TagNumber(2)
  FieldDevice_FlashingBeacon_FlashingBeaconFunction get function => $_getN(0);
  @$pb.TagNumber(2)
  set function(FieldDevice_FlashingBeacon_FlashingBeaconFunction value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasFunction() => $_has(0);
  @$pb.TagNumber(2)
  void clearFunction() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.bool get isFlashing => $_getBF(1);
  @$pb.TagNumber(3)
  set isFlashing($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(3)
  $core.bool hasIsFlashing() => $_has(1);
  @$pb.TagNumber(3)
  void clearIsFlashing() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get signText => $_getSZ(2);
  @$pb.TagNumber(4)
  set signText($core.String value) => $_setString(2, value);
  @$pb.TagNumber(4)
  $core.bool hasSignText() => $_has(2);
  @$pb.TagNumber(4)
  void clearSignText() => $_clearField(4);
}

class FieldDevice_HybridSign extends $pb.GeneratedMessage {
  factory FieldDevice_HybridSign({
    FieldDevice_HybridSign_HybridSignDynamicMessageFunction? dynamicMessageFunction,
    $core.String? dynamicMessageText,
    $core.String? staticSignText,
  }) {
    final result = create();
    if (dynamicMessageFunction != null) result.dynamicMessageFunction = dynamicMessageFunction;
    if (dynamicMessageText != null) result.dynamicMessageText = dynamicMessageText;
    if (staticSignText != null) result.staticSignText = staticSignText;
    return result;
  }

  FieldDevice_HybridSign._();

  factory FieldDevice_HybridSign.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(data, registry);
  factory FieldDevice_HybridSign.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'FieldDevice.HybridSign', package: const $pb.PackageName(_omitMessageNames ? '' : 'datahub.v1'), createEmptyInstance: create)
    ..e<FieldDevice_HybridSign_HybridSignDynamicMessageFunction>(2, _omitFieldNames ? '' : 'dynamicMessageFunction', $pb.PbFieldType.OE, defaultOrMaker: FieldDevice_HybridSign_HybridSignDynamicMessageFunction.HYBRID_SIGN_DYNAMIC_MESSAGE_FUNCTION_UNKNOWN, valueOf: FieldDevice_HybridSign_HybridSignDynamicMessageFunction.valueOf, enumValues: FieldDevice_HybridSign_HybridSignDynamicMessageFunction.values)
    ..aOS(3, _omitFieldNames ? '' : 'dynamicMessageText')
    ..aOS(4, _omitFieldNames ? '' : 'staticSignText')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FieldDevice_HybridSign clone() => FieldDevice_HybridSign()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FieldDevice_HybridSign copyWith(void Function(FieldDevice_HybridSign) updates) => super.copyWith((message) => updates(message as FieldDevice_HybridSign)) as FieldDevice_HybridSign;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FieldDevice_HybridSign create() => FieldDevice_HybridSign._();
  @$core.override
  FieldDevice_HybridSign createEmptyInstance() => create();
  static $pb.PbList<FieldDevice_HybridSign> createRepeated() => $pb.PbList<FieldDevice_HybridSign>();
  @$core.pragma('dart2js:noInline')
  static FieldDevice_HybridSign getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<FieldDevice_HybridSign>(create);
  static FieldDevice_HybridSign? _defaultInstance;

  @$pb.TagNumber(2)
  FieldDevice_HybridSign_HybridSignDynamicMessageFunction get dynamicMessageFunction => $_getN(0);
  @$pb.TagNumber(2)
  set dynamicMessageFunction(FieldDevice_HybridSign_HybridSignDynamicMessageFunction value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasDynamicMessageFunction() => $_has(0);
  @$pb.TagNumber(2)
  void clearDynamicMessageFunction() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get dynamicMessageText => $_getSZ(1);
  @$pb.TagNumber(3)
  set dynamicMessageText($core.String value) => $_setString(1, value);
  @$pb.TagNumber(3)
  $core.bool hasDynamicMessageText() => $_has(1);
  @$pb.TagNumber(3)
  void clearDynamicMessageText() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get staticSignText => $_getSZ(2);
  @$pb.TagNumber(4)
  set staticSignText($core.String value) => $_setString(2, value);
  @$pb.TagNumber(4)
  $core.bool hasStaticSignText() => $_has(2);
  @$pb.TagNumber(4)
  void clearStaticSignText() => $_clearField(4);
}

class FieldDevice_LocationMarker extends $pb.GeneratedMessage {
  factory FieldDevice_LocationMarker() => create();

  FieldDevice_LocationMarker._();

  factory FieldDevice_LocationMarker.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(data, registry);
  factory FieldDevice_LocationMarker.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'FieldDevice.LocationMarker', package: const $pb.PackageName(_omitMessageNames ? '' : 'datahub.v1'), createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FieldDevice_LocationMarker clone() => FieldDevice_LocationMarker()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FieldDevice_LocationMarker copyWith(void Function(FieldDevice_LocationMarker) updates) => super.copyWith((message) => updates(message as FieldDevice_LocationMarker)) as FieldDevice_LocationMarker;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FieldDevice_LocationMarker create() => FieldDevice_LocationMarker._();
  @$core.override
  FieldDevice_LocationMarker createEmptyInstance() => create();
  static $pb.PbList<FieldDevice_LocationMarker> createRepeated() => $pb.PbList<FieldDevice_LocationMarker>();
  @$core.pragma('dart2js:noInline')
  static FieldDevice_LocationMarker getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<FieldDevice_LocationMarker>(create);
  static FieldDevice_LocationMarker? _defaultInstance;
}

class FieldDevice_TrafficSensor_TrafficSensorLaneData extends $pb.GeneratedMessage {
  factory FieldDevice_TrafficSensor_TrafficSensorLaneData({
    $core.int? laneOrder,
    $fixnum.Int64? roadEventId,
    $core.double? averageSpeedKph,
    $core.double? volumeKph,
    $core.double? occupancyPercent,
  }) {
    final result = create();
    if (laneOrder != null) result.laneOrder = laneOrder;
    if (roadEventId != null) result.roadEventId = roadEventId;
    if (averageSpeedKph != null) result.averageSpeedKph = averageSpeedKph;
    if (volumeKph != null) result.volumeKph = volumeKph;
    if (occupancyPercent != null) result.occupancyPercent = occupancyPercent;
    return result;
  }

  FieldDevice_TrafficSensor_TrafficSensorLaneData._();

  factory FieldDevice_TrafficSensor_TrafficSensorLaneData.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(data, registry);
  factory FieldDevice_TrafficSensor_TrafficSensorLaneData.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'FieldDevice.TrafficSensor.TrafficSensorLaneData', package: const $pb.PackageName(_omitMessageNames ? '' : 'datahub.v1'), createEmptyInstance: create)
    ..a<$core.int>(1, _omitFieldNames ? '' : 'laneOrder', $pb.PbFieldType.OU3)
    ..a<$fixnum.Int64>(2, _omitFieldNames ? '' : 'roadEventId', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$core.double>(3, _omitFieldNames ? '' : 'averageSpeedKph', $pb.PbFieldType.OD)
    ..a<$core.double>(4, _omitFieldNames ? '' : 'volumeKph', $pb.PbFieldType.OD)
    ..a<$core.double>(5, _omitFieldNames ? '' : 'occupancyPercent', $pb.PbFieldType.OD)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FieldDevice_TrafficSensor_TrafficSensorLaneData clone() => FieldDevice_TrafficSensor_TrafficSensorLaneData()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FieldDevice_TrafficSensor_TrafficSensorLaneData copyWith(void Function(FieldDevice_TrafficSensor_TrafficSensorLaneData) updates) => super.copyWith((message) => updates(message as FieldDevice_TrafficSensor_TrafficSensorLaneData)) as FieldDevice_TrafficSensor_TrafficSensorLaneData;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FieldDevice_TrafficSensor_TrafficSensorLaneData create() => FieldDevice_TrafficSensor_TrafficSensorLaneData._();
  @$core.override
  FieldDevice_TrafficSensor_TrafficSensorLaneData createEmptyInstance() => create();
  static $pb.PbList<FieldDevice_TrafficSensor_TrafficSensorLaneData> createRepeated() => $pb.PbList<FieldDevice_TrafficSensor_TrafficSensorLaneData>();
  @$core.pragma('dart2js:noInline')
  static FieldDevice_TrafficSensor_TrafficSensorLaneData getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<FieldDevice_TrafficSensor_TrafficSensorLaneData>(create);
  static FieldDevice_TrafficSensor_TrafficSensorLaneData? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get laneOrder => $_getIZ(0);
  @$pb.TagNumber(1)
  set laneOrder($core.int value) => $_setUnsignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasLaneOrder() => $_has(0);
  @$pb.TagNumber(1)
  void clearLaneOrder() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get roadEventId => $_getI64(1);
  @$pb.TagNumber(2)
  set roadEventId($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRoadEventId() => $_has(1);
  @$pb.TagNumber(2)
  void clearRoadEventId() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.double get averageSpeedKph => $_getN(2);
  @$pb.TagNumber(3)
  set averageSpeedKph($core.double value) => $_setDouble(2, value);
  @$pb.TagNumber(3)
  $core.bool hasAverageSpeedKph() => $_has(2);
  @$pb.TagNumber(3)
  void clearAverageSpeedKph() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.double get volumeKph => $_getN(3);
  @$pb.TagNumber(4)
  set volumeKph($core.double value) => $_setDouble(3, value);
  @$pb.TagNumber(4)
  $core.bool hasVolumeKph() => $_has(3);
  @$pb.TagNumber(4)
  void clearVolumeKph() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.double get occupancyPercent => $_getN(4);
  @$pb.TagNumber(5)
  set occupancyPercent($core.double value) => $_setDouble(4, value);
  @$pb.TagNumber(5)
  $core.bool hasOccupancyPercent() => $_has(4);
  @$pb.TagNumber(5)
  void clearOccupancyPercent() => $_clearField(5);
}

class FieldDevice_TrafficSensor extends $pb.GeneratedMessage {
  factory FieldDevice_TrafficSensor({
    $1.Timestamp? collectionIntervalStartDate,
    $1.Timestamp? collectionIntervalEndDate,
    $core.double? averageSpeedKph,
    $core.double? volumeKph,
    $core.double? occupancyPercent,
    $core.Iterable<FieldDevice_TrafficSensor_TrafficSensorLaneData>? laneData,
  }) {
    final result = create();
    if (collectionIntervalStartDate != null) result.collectionIntervalStartDate = collectionIntervalStartDate;
    if (collectionIntervalEndDate != null) result.collectionIntervalEndDate = collectionIntervalEndDate;
    if (averageSpeedKph != null) result.averageSpeedKph = averageSpeedKph;
    if (volumeKph != null) result.volumeKph = volumeKph;
    if (occupancyPercent != null) result.occupancyPercent = occupancyPercent;
    if (laneData != null) result.laneData.addAll(laneData);
    return result;
  }

  FieldDevice_TrafficSensor._();

  factory FieldDevice_TrafficSensor.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(data, registry);
  factory FieldDevice_TrafficSensor.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'FieldDevice.TrafficSensor', package: const $pb.PackageName(_omitMessageNames ? '' : 'datahub.v1'), createEmptyInstance: create)
    ..aOM<$1.Timestamp>(2, _omitFieldNames ? '' : 'collectionIntervalStartDate', subBuilder: $1.Timestamp.create)
    ..aOM<$1.Timestamp>(3, _omitFieldNames ? '' : 'collectionIntervalEndDate', subBuilder: $1.Timestamp.create)
    ..a<$core.double>(4, _omitFieldNames ? '' : 'averageSpeedKph', $pb.PbFieldType.OD)
    ..a<$core.double>(5, _omitFieldNames ? '' : 'volumeKph', $pb.PbFieldType.OD)
    ..a<$core.double>(6, _omitFieldNames ? '' : 'occupancyPercent', $pb.PbFieldType.OD)
    ..pc<FieldDevice_TrafficSensor_TrafficSensorLaneData>(7, _omitFieldNames ? '' : 'laneData', $pb.PbFieldType.PM, subBuilder: FieldDevice_TrafficSensor_TrafficSensorLaneData.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FieldDevice_TrafficSensor clone() => FieldDevice_TrafficSensor()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FieldDevice_TrafficSensor copyWith(void Function(FieldDevice_TrafficSensor) updates) => super.copyWith((message) => updates(message as FieldDevice_TrafficSensor)) as FieldDevice_TrafficSensor;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FieldDevice_TrafficSensor create() => FieldDevice_TrafficSensor._();
  @$core.override
  FieldDevice_TrafficSensor createEmptyInstance() => create();
  static $pb.PbList<FieldDevice_TrafficSensor> createRepeated() => $pb.PbList<FieldDevice_TrafficSensor>();
  @$core.pragma('dart2js:noInline')
  static FieldDevice_TrafficSensor getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<FieldDevice_TrafficSensor>(create);
  static FieldDevice_TrafficSensor? _defaultInstance;

  @$pb.TagNumber(2)
  $1.Timestamp get collectionIntervalStartDate => $_getN(0);
  @$pb.TagNumber(2)
  set collectionIntervalStartDate($1.Timestamp value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasCollectionIntervalStartDate() => $_has(0);
  @$pb.TagNumber(2)
  void clearCollectionIntervalStartDate() => $_clearField(2);
  @$pb.TagNumber(2)
  $1.Timestamp ensureCollectionIntervalStartDate() => $_ensure(0);

  @$pb.TagNumber(3)
  $1.Timestamp get collectionIntervalEndDate => $_getN(1);
  @$pb.TagNumber(3)
  set collectionIntervalEndDate($1.Timestamp value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasCollectionIntervalEndDate() => $_has(1);
  @$pb.TagNumber(3)
  void clearCollectionIntervalEndDate() => $_clearField(3);
  @$pb.TagNumber(3)
  $1.Timestamp ensureCollectionIntervalEndDate() => $_ensure(1);

  @$pb.TagNumber(4)
  $core.double get averageSpeedKph => $_getN(2);
  @$pb.TagNumber(4)
  set averageSpeedKph($core.double value) => $_setDouble(2, value);
  @$pb.TagNumber(4)
  $core.bool hasAverageSpeedKph() => $_has(2);
  @$pb.TagNumber(4)
  void clearAverageSpeedKph() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.double get volumeKph => $_getN(3);
  @$pb.TagNumber(5)
  set volumeKph($core.double value) => $_setDouble(3, value);
  @$pb.TagNumber(5)
  $core.bool hasVolumeKph() => $_has(3);
  @$pb.TagNumber(5)
  void clearVolumeKph() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.double get occupancyPercent => $_getN(4);
  @$pb.TagNumber(6)
  set occupancyPercent($core.double value) => $_setDouble(4, value);
  @$pb.TagNumber(6)
  $core.bool hasOccupancyPercent() => $_has(4);
  @$pb.TagNumber(6)
  void clearOccupancyPercent() => $_clearField(6);

  @$pb.TagNumber(7)
  $pb.PbList<FieldDevice_TrafficSensor_TrafficSensorLaneData> get laneData => $_getList(5);
}

class FieldDevice_TrafficSignal extends $pb.GeneratedMessage {
  factory FieldDevice_TrafficSignal({
    FieldDevice_TrafficSignal_TrafficSignalMode? mode,
  }) {
    final result = create();
    if (mode != null) result.mode = mode;
    return result;
  }

  FieldDevice_TrafficSignal._();

  factory FieldDevice_TrafficSignal.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(data, registry);
  factory FieldDevice_TrafficSignal.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'FieldDevice.TrafficSignal', package: const $pb.PackageName(_omitMessageNames ? '' : 'datahub.v1'), createEmptyInstance: create)
    ..e<FieldDevice_TrafficSignal_TrafficSignalMode>(2, _omitFieldNames ? '' : 'mode', $pb.PbFieldType.OE, defaultOrMaker: FieldDevice_TrafficSignal_TrafficSignalMode.TRAFFIC_SIGNAL_MODE_UNKNOWN, valueOf: FieldDevice_TrafficSignal_TrafficSignalMode.valueOf, enumValues: FieldDevice_TrafficSignal_TrafficSignalMode.values)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FieldDevice_TrafficSignal clone() => FieldDevice_TrafficSignal()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FieldDevice_TrafficSignal copyWith(void Function(FieldDevice_TrafficSignal) updates) => super.copyWith((message) => updates(message as FieldDevice_TrafficSignal)) as FieldDevice_TrafficSignal;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FieldDevice_TrafficSignal create() => FieldDevice_TrafficSignal._();
  @$core.override
  FieldDevice_TrafficSignal createEmptyInstance() => create();
  static $pb.PbList<FieldDevice_TrafficSignal> createRepeated() => $pb.PbList<FieldDevice_TrafficSignal>();
  @$core.pragma('dart2js:noInline')
  static FieldDevice_TrafficSignal getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<FieldDevice_TrafficSignal>(create);
  static FieldDevice_TrafficSignal? _defaultInstance;

  @$pb.TagNumber(2)
  FieldDevice_TrafficSignal_TrafficSignalMode get mode => $_getN(0);
  @$pb.TagNumber(2)
  set mode(FieldDevice_TrafficSignal_TrafficSignalMode value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasMode() => $_has(0);
  @$pb.TagNumber(2)
  void clearMode() => $_clearField(2);
}

class FieldDevice_MobileVehicle extends $pb.GeneratedMessage {
  factory FieldDevice_MobileVehicle({
    FieldDevice_MobileVehicle_VehicleOperationType? operationType,
    $core.String? licensePlate,
    $core.int? heading,
  }) {
    final result = create();
    if (operationType != null) result.operationType = operationType;
    if (licensePlate != null) result.licensePlate = licensePlate;
    if (heading != null) result.heading = heading;
    return result;
  }

  FieldDevice_MobileVehicle._();

  factory FieldDevice_MobileVehicle.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(data, registry);
  factory FieldDevice_MobileVehicle.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'FieldDevice.MobileVehicle', package: const $pb.PackageName(_omitMessageNames ? '' : 'datahub.v1'), createEmptyInstance: create)
    ..e<FieldDevice_MobileVehicle_VehicleOperationType>(1, _omitFieldNames ? '' : 'operationType', $pb.PbFieldType.OE, defaultOrMaker: FieldDevice_MobileVehicle_VehicleOperationType.VEHICLE_OPERATION_UNKNOWN, valueOf: FieldDevice_MobileVehicle_VehicleOperationType.valueOf, enumValues: FieldDevice_MobileVehicle_VehicleOperationType.values)
    ..aOS(2, _omitFieldNames ? '' : 'licensePlate')
    ..a<$core.int>(3, _omitFieldNames ? '' : 'heading', $pb.PbFieldType.OU3)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FieldDevice_MobileVehicle clone() => FieldDevice_MobileVehicle()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FieldDevice_MobileVehicle copyWith(void Function(FieldDevice_MobileVehicle) updates) => super.copyWith((message) => updates(message as FieldDevice_MobileVehicle)) as FieldDevice_MobileVehicle;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FieldDevice_MobileVehicle create() => FieldDevice_MobileVehicle._();
  @$core.override
  FieldDevice_MobileVehicle createEmptyInstance() => create();
  static $pb.PbList<FieldDevice_MobileVehicle> createRepeated() => $pb.PbList<FieldDevice_MobileVehicle>();
  @$core.pragma('dart2js:noInline')
  static FieldDevice_MobileVehicle getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<FieldDevice_MobileVehicle>(create);
  static FieldDevice_MobileVehicle? _defaultInstance;

  @$pb.TagNumber(1)
  FieldDevice_MobileVehicle_VehicleOperationType get operationType => $_getN(0);
  @$pb.TagNumber(1)
  set operationType(FieldDevice_MobileVehicle_VehicleOperationType value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasOperationType() => $_has(0);
  @$pb.TagNumber(1)
  void clearOperationType() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get licensePlate => $_getSZ(1);
  @$pb.TagNumber(2)
  set licensePlate($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasLicensePlate() => $_has(1);
  @$pb.TagNumber(2)
  void clearLicensePlate() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get heading => $_getIZ(2);
  @$pb.TagNumber(3)
  set heading($core.int value) => $_setUnsignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasHeading() => $_has(2);
  @$pb.TagNumber(3)
  void clearHeading() => $_clearField(3);
}

class FieldDevice_FieldWorker extends $pb.GeneratedMessage {
  factory FieldDevice_FieldWorker({
    FieldDevice_FieldWorker_OperationType? operationType,
  }) {
    final result = create();
    if (operationType != null) result.operationType = operationType;
    return result;
  }

  FieldDevice_FieldWorker._();

  factory FieldDevice_FieldWorker.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(data, registry);
  factory FieldDevice_FieldWorker.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'FieldDevice.FieldWorker', package: const $pb.PackageName(_omitMessageNames ? '' : 'datahub.v1'), createEmptyInstance: create)
    ..e<FieldDevice_FieldWorker_OperationType>(1, _omitFieldNames ? '' : 'operationType', $pb.PbFieldType.OE, defaultOrMaker: FieldDevice_FieldWorker_OperationType.OPERATION_TYPE_UNKNOWN, valueOf: FieldDevice_FieldWorker_OperationType.valueOf, enumValues: FieldDevice_FieldWorker_OperationType.values)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FieldDevice_FieldWorker clone() => FieldDevice_FieldWorker()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FieldDevice_FieldWorker copyWith(void Function(FieldDevice_FieldWorker) updates) => super.copyWith((message) => updates(message as FieldDevice_FieldWorker)) as FieldDevice_FieldWorker;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FieldDevice_FieldWorker create() => FieldDevice_FieldWorker._();
  @$core.override
  FieldDevice_FieldWorker createEmptyInstance() => create();
  static $pb.PbList<FieldDevice_FieldWorker> createRepeated() => $pb.PbList<FieldDevice_FieldWorker>();
  @$core.pragma('dart2js:noInline')
  static FieldDevice_FieldWorker getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<FieldDevice_FieldWorker>(create);
  static FieldDevice_FieldWorker? _defaultInstance;

  @$pb.TagNumber(1)
  FieldDevice_FieldWorker_OperationType get operationType => $_getN(0);
  @$pb.TagNumber(1)
  set operationType(FieldDevice_FieldWorker_OperationType value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasOperationType() => $_has(0);
  @$pb.TagNumber(1)
  void clearOperationType() => $_clearField(1);
}

enum FieldDevice_Device {
  arrowBoard, 
  camera, 
  dynamicMessageSign, 
  flashingBeacon, 
  hybridSign, 
  locationMarker, 
  trafficSensor, 
  trafficSignal, 
  mobileVehicle, 
  fieldWorker, 
  notSet
}

class FieldDevice extends $pb.GeneratedMessage {
  factory FieldDevice({
    FieldDevice_ArrowBoard? arrowBoard,
    FieldDevice_Camera? camera,
    FieldDevice_DynamicMessageSign? dynamicMessageSign,
    FieldDevice_FlashingBeacon? flashingBeacon,
    FieldDevice_HybridSign? hybridSign,
    FieldDevice_LocationMarker? locationMarker,
    FieldDevice_TrafficSensor? trafficSensor,
    FieldDevice_TrafficSignal? trafficSignal,
    $fixnum.Int64? projectId,
    $fixnum.Int64? roadEventId,
    $0.MarkedLocationType? locationType,
    $0.PointGeometry? geometry,
    $0.BoundingBox? bbox,
    FieldDevice_FieldDeviceCoreDetails? coreDetails,
    FieldDevice_MobileVehicle? mobileVehicle,
    FieldDevice_FieldWorker? fieldWorker,
    $core.String? id,
  }) {
    final result = create();
    if (arrowBoard != null) result.arrowBoard = arrowBoard;
    if (camera != null) result.camera = camera;
    if (dynamicMessageSign != null) result.dynamicMessageSign = dynamicMessageSign;
    if (flashingBeacon != null) result.flashingBeacon = flashingBeacon;
    if (hybridSign != null) result.hybridSign = hybridSign;
    if (locationMarker != null) result.locationMarker = locationMarker;
    if (trafficSensor != null) result.trafficSensor = trafficSensor;
    if (trafficSignal != null) result.trafficSignal = trafficSignal;
    if (projectId != null) result.projectId = projectId;
    if (roadEventId != null) result.roadEventId = roadEventId;
    if (locationType != null) result.locationType = locationType;
    if (geometry != null) result.geometry = geometry;
    if (bbox != null) result.bbox = bbox;
    if (coreDetails != null) result.coreDetails = coreDetails;
    if (mobileVehicle != null) result.mobileVehicle = mobileVehicle;
    if (fieldWorker != null) result.fieldWorker = fieldWorker;
    if (id != null) result.id = id;
    return result;
  }

  FieldDevice._();

  factory FieldDevice.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(data, registry);
  factory FieldDevice.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, FieldDevice_Device> _FieldDevice_DeviceByTag = {
    1 : FieldDevice_Device.arrowBoard,
    2 : FieldDevice_Device.camera,
    3 : FieldDevice_Device.dynamicMessageSign,
    4 : FieldDevice_Device.flashingBeacon,
    5 : FieldDevice_Device.hybridSign,
    6 : FieldDevice_Device.locationMarker,
    7 : FieldDevice_Device.trafficSensor,
    8 : FieldDevice_Device.trafficSignal,
    16 : FieldDevice_Device.mobileVehicle,
    17 : FieldDevice_Device.fieldWorker,
    0 : FieldDevice_Device.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'FieldDevice', package: const $pb.PackageName(_omitMessageNames ? '' : 'datahub.v1'), createEmptyInstance: create)
    ..oo(0, [1, 2, 3, 4, 5, 6, 7, 8, 16, 17])
    ..aOM<FieldDevice_ArrowBoard>(1, _omitFieldNames ? '' : 'arrowBoard', subBuilder: FieldDevice_ArrowBoard.create)
    ..aOM<FieldDevice_Camera>(2, _omitFieldNames ? '' : 'camera', subBuilder: FieldDevice_Camera.create)
    ..aOM<FieldDevice_DynamicMessageSign>(3, _omitFieldNames ? '' : 'dynamicMessageSign', subBuilder: FieldDevice_DynamicMessageSign.create)
    ..aOM<FieldDevice_FlashingBeacon>(4, _omitFieldNames ? '' : 'flashingBeacon', subBuilder: FieldDevice_FlashingBeacon.create)
    ..aOM<FieldDevice_HybridSign>(5, _omitFieldNames ? '' : 'hybridSign', subBuilder: FieldDevice_HybridSign.create)
    ..aOM<FieldDevice_LocationMarker>(6, _omitFieldNames ? '' : 'locationMarker', subBuilder: FieldDevice_LocationMarker.create)
    ..aOM<FieldDevice_TrafficSensor>(7, _omitFieldNames ? '' : 'trafficSensor', subBuilder: FieldDevice_TrafficSensor.create)
    ..aOM<FieldDevice_TrafficSignal>(8, _omitFieldNames ? '' : 'trafficSignal', subBuilder: FieldDevice_TrafficSignal.create)
    ..a<$fixnum.Int64>(10, _omitFieldNames ? '' : 'projectId', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(11, _omitFieldNames ? '' : 'roadEventId', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..e<$0.MarkedLocationType>(12, _omitFieldNames ? '' : 'locationType', $pb.PbFieldType.OE, defaultOrMaker: $0.MarkedLocationType.MARKED_LOCATION_TYPE_UNKNOWN, valueOf: $0.MarkedLocationType.valueOf, enumValues: $0.MarkedLocationType.values)
    ..aOM<$0.PointGeometry>(13, _omitFieldNames ? '' : 'geometry', subBuilder: $0.PointGeometry.create)
    ..aOM<$0.BoundingBox>(14, _omitFieldNames ? '' : 'bbox', subBuilder: $0.BoundingBox.create)
    ..aOM<FieldDevice_FieldDeviceCoreDetails>(15, _omitFieldNames ? '' : 'coreDetails', subBuilder: FieldDevice_FieldDeviceCoreDetails.create)
    ..aOM<FieldDevice_MobileVehicle>(16, _omitFieldNames ? '' : 'mobileVehicle', subBuilder: FieldDevice_MobileVehicle.create)
    ..aOM<FieldDevice_FieldWorker>(17, _omitFieldNames ? '' : 'fieldWorker', subBuilder: FieldDevice_FieldWorker.create)
    ..aOS(18, _omitFieldNames ? '' : 'id')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FieldDevice clone() => FieldDevice()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FieldDevice copyWith(void Function(FieldDevice) updates) => super.copyWith((message) => updates(message as FieldDevice)) as FieldDevice;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FieldDevice create() => FieldDevice._();
  @$core.override
  FieldDevice createEmptyInstance() => create();
  static $pb.PbList<FieldDevice> createRepeated() => $pb.PbList<FieldDevice>();
  @$core.pragma('dart2js:noInline')
  static FieldDevice getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<FieldDevice>(create);
  static FieldDevice? _defaultInstance;

  FieldDevice_Device whichDevice() => _FieldDevice_DeviceByTag[$_whichOneof(0)]!;
  void clearDevice() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  FieldDevice_ArrowBoard get arrowBoard => $_getN(0);
  @$pb.TagNumber(1)
  set arrowBoard(FieldDevice_ArrowBoard value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasArrowBoard() => $_has(0);
  @$pb.TagNumber(1)
  void clearArrowBoard() => $_clearField(1);
  @$pb.TagNumber(1)
  FieldDevice_ArrowBoard ensureArrowBoard() => $_ensure(0);

  @$pb.TagNumber(2)
  FieldDevice_Camera get camera => $_getN(1);
  @$pb.TagNumber(2)
  set camera(FieldDevice_Camera value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasCamera() => $_has(1);
  @$pb.TagNumber(2)
  void clearCamera() => $_clearField(2);
  @$pb.TagNumber(2)
  FieldDevice_Camera ensureCamera() => $_ensure(1);

  @$pb.TagNumber(3)
  FieldDevice_DynamicMessageSign get dynamicMessageSign => $_getN(2);
  @$pb.TagNumber(3)
  set dynamicMessageSign(FieldDevice_DynamicMessageSign value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasDynamicMessageSign() => $_has(2);
  @$pb.TagNumber(3)
  void clearDynamicMessageSign() => $_clearField(3);
  @$pb.TagNumber(3)
  FieldDevice_DynamicMessageSign ensureDynamicMessageSign() => $_ensure(2);

  @$pb.TagNumber(4)
  FieldDevice_FlashingBeacon get flashingBeacon => $_getN(3);
  @$pb.TagNumber(4)
  set flashingBeacon(FieldDevice_FlashingBeacon value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasFlashingBeacon() => $_has(3);
  @$pb.TagNumber(4)
  void clearFlashingBeacon() => $_clearField(4);
  @$pb.TagNumber(4)
  FieldDevice_FlashingBeacon ensureFlashingBeacon() => $_ensure(3);

  @$pb.TagNumber(5)
  FieldDevice_HybridSign get hybridSign => $_getN(4);
  @$pb.TagNumber(5)
  set hybridSign(FieldDevice_HybridSign value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasHybridSign() => $_has(4);
  @$pb.TagNumber(5)
  void clearHybridSign() => $_clearField(5);
  @$pb.TagNumber(5)
  FieldDevice_HybridSign ensureHybridSign() => $_ensure(4);

  @$pb.TagNumber(6)
  FieldDevice_LocationMarker get locationMarker => $_getN(5);
  @$pb.TagNumber(6)
  set locationMarker(FieldDevice_LocationMarker value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasLocationMarker() => $_has(5);
  @$pb.TagNumber(6)
  void clearLocationMarker() => $_clearField(6);
  @$pb.TagNumber(6)
  FieldDevice_LocationMarker ensureLocationMarker() => $_ensure(5);

  @$pb.TagNumber(7)
  FieldDevice_TrafficSensor get trafficSensor => $_getN(6);
  @$pb.TagNumber(7)
  set trafficSensor(FieldDevice_TrafficSensor value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasTrafficSensor() => $_has(6);
  @$pb.TagNumber(7)
  void clearTrafficSensor() => $_clearField(7);
  @$pb.TagNumber(7)
  FieldDevice_TrafficSensor ensureTrafficSensor() => $_ensure(6);

  @$pb.TagNumber(8)
  FieldDevice_TrafficSignal get trafficSignal => $_getN(7);
  @$pb.TagNumber(8)
  set trafficSignal(FieldDevice_TrafficSignal value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasTrafficSignal() => $_has(7);
  @$pb.TagNumber(8)
  void clearTrafficSignal() => $_clearField(8);
  @$pb.TagNumber(8)
  FieldDevice_TrafficSignal ensureTrafficSignal() => $_ensure(7);

  @$pb.TagNumber(10)
  $fixnum.Int64 get projectId => $_getI64(8);
  @$pb.TagNumber(10)
  set projectId($fixnum.Int64 value) => $_setInt64(8, value);
  @$pb.TagNumber(10)
  $core.bool hasProjectId() => $_has(8);
  @$pb.TagNumber(10)
  void clearProjectId() => $_clearField(10);

  @$pb.TagNumber(11)
  $fixnum.Int64 get roadEventId => $_getI64(9);
  @$pb.TagNumber(11)
  set roadEventId($fixnum.Int64 value) => $_setInt64(9, value);
  @$pb.TagNumber(11)
  $core.bool hasRoadEventId() => $_has(9);
  @$pb.TagNumber(11)
  void clearRoadEventId() => $_clearField(11);

  @$pb.TagNumber(12)
  $0.MarkedLocationType get locationType => $_getN(10);
  @$pb.TagNumber(12)
  set locationType($0.MarkedLocationType value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasLocationType() => $_has(10);
  @$pb.TagNumber(12)
  void clearLocationType() => $_clearField(12);

  @$pb.TagNumber(13)
  $0.PointGeometry get geometry => $_getN(11);
  @$pb.TagNumber(13)
  set geometry($0.PointGeometry value) => $_setField(13, value);
  @$pb.TagNumber(13)
  $core.bool hasGeometry() => $_has(11);
  @$pb.TagNumber(13)
  void clearGeometry() => $_clearField(13);
  @$pb.TagNumber(13)
  $0.PointGeometry ensureGeometry() => $_ensure(11);

  @$pb.TagNumber(14)
  $0.BoundingBox get bbox => $_getN(12);
  @$pb.TagNumber(14)
  set bbox($0.BoundingBox value) => $_setField(14, value);
  @$pb.TagNumber(14)
  $core.bool hasBbox() => $_has(12);
  @$pb.TagNumber(14)
  void clearBbox() => $_clearField(14);
  @$pb.TagNumber(14)
  $0.BoundingBox ensureBbox() => $_ensure(12);

  @$pb.TagNumber(15)
  FieldDevice_FieldDeviceCoreDetails get coreDetails => $_getN(13);
  @$pb.TagNumber(15)
  set coreDetails(FieldDevice_FieldDeviceCoreDetails value) => $_setField(15, value);
  @$pb.TagNumber(15)
  $core.bool hasCoreDetails() => $_has(13);
  @$pb.TagNumber(15)
  void clearCoreDetails() => $_clearField(15);
  @$pb.TagNumber(15)
  FieldDevice_FieldDeviceCoreDetails ensureCoreDetails() => $_ensure(13);

  @$pb.TagNumber(16)
  FieldDevice_MobileVehicle get mobileVehicle => $_getN(14);
  @$pb.TagNumber(16)
  set mobileVehicle(FieldDevice_MobileVehicle value) => $_setField(16, value);
  @$pb.TagNumber(16)
  $core.bool hasMobileVehicle() => $_has(14);
  @$pb.TagNumber(16)
  void clearMobileVehicle() => $_clearField(16);
  @$pb.TagNumber(16)
  FieldDevice_MobileVehicle ensureMobileVehicle() => $_ensure(14);

  @$pb.TagNumber(17)
  FieldDevice_FieldWorker get fieldWorker => $_getN(15);
  @$pb.TagNumber(17)
  set fieldWorker(FieldDevice_FieldWorker value) => $_setField(17, value);
  @$pb.TagNumber(17)
  $core.bool hasFieldWorker() => $_has(15);
  @$pb.TagNumber(17)
  void clearFieldWorker() => $_clearField(17);
  @$pb.TagNumber(17)
  FieldDevice_FieldWorker ensureFieldWorker() => $_ensure(15);

  @$pb.TagNumber(18)
  $core.String get id => $_getSZ(16);
  @$pb.TagNumber(18)
  set id($core.String value) => $_setString(16, value);
  @$pb.TagNumber(18)
  $core.bool hasId() => $_has(16);
  @$pb.TagNumber(18)
  void clearId() => $_clearField(18);
}


const $core.bool _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
