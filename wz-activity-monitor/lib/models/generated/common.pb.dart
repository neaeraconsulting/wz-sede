// This is a generated file - do not edit.
//
// Generated from common.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'google/type/latlng.pb.dart' as $0;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'common.pbenum.dart';

class ContactInfo extends $pb.GeneratedMessage {
  factory ContactInfo({
    $core.String? firstName,
    $core.String? lastName,
    $core.String? email,
    PhoneNumber? phoneNumber,
  }) {
    final result = create();
    if (firstName != null) result.firstName = firstName;
    if (lastName != null) result.lastName = lastName;
    if (email != null) result.email = email;
    if (phoneNumber != null) result.phoneNumber = phoneNumber;
    return result;
  }

  ContactInfo._();

  factory ContactInfo.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(data, registry);
  factory ContactInfo.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ContactInfo', package: const $pb.PackageName(_omitMessageNames ? '' : 'datahub.v1'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'firstName')
    ..aOS(2, _omitFieldNames ? '' : 'lastName')
    ..aOS(3, _omitFieldNames ? '' : 'email')
    ..aOM<PhoneNumber>(4, _omitFieldNames ? '' : 'phoneNumber', subBuilder: PhoneNumber.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ContactInfo clone() => ContactInfo()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ContactInfo copyWith(void Function(ContactInfo) updates) => super.copyWith((message) => updates(message as ContactInfo)) as ContactInfo;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ContactInfo create() => ContactInfo._();
  @$core.override
  ContactInfo createEmptyInstance() => create();
  static $pb.PbList<ContactInfo> createRepeated() => $pb.PbList<ContactInfo>();
  @$core.pragma('dart2js:noInline')
  static ContactInfo getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ContactInfo>(create);
  static ContactInfo? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get firstName => $_getSZ(0);
  @$pb.TagNumber(1)
  set firstName($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasFirstName() => $_has(0);
  @$pb.TagNumber(1)
  void clearFirstName() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get lastName => $_getSZ(1);
  @$pb.TagNumber(2)
  set lastName($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasLastName() => $_has(1);
  @$pb.TagNumber(2)
  void clearLastName() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get email => $_getSZ(2);
  @$pb.TagNumber(3)
  set email($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasEmail() => $_has(2);
  @$pb.TagNumber(3)
  void clearEmail() => $_clearField(3);

  @$pb.TagNumber(4)
  PhoneNumber get phoneNumber => $_getN(3);
  @$pb.TagNumber(4)
  set phoneNumber(PhoneNumber value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasPhoneNumber() => $_has(3);
  @$pb.TagNumber(4)
  void clearPhoneNumber() => $_clearField(4);
  @$pb.TagNumber(4)
  PhoneNumber ensurePhoneNumber() => $_ensure(3);
}

class PhoneNumber extends $pb.GeneratedMessage {
  factory PhoneNumber({
    $core.int? countryCode,
    $core.int? areaCode,
    $core.String? number,
  }) {
    final result = create();
    if (countryCode != null) result.countryCode = countryCode;
    if (areaCode != null) result.areaCode = areaCode;
    if (number != null) result.number = number;
    return result;
  }

  PhoneNumber._();

  factory PhoneNumber.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(data, registry);
  factory PhoneNumber.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'PhoneNumber', package: const $pb.PackageName(_omitMessageNames ? '' : 'datahub.v1'), createEmptyInstance: create)
    ..a<$core.int>(1, _omitFieldNames ? '' : 'countryCode', $pb.PbFieldType.O3)
    ..a<$core.int>(2, _omitFieldNames ? '' : 'areaCode', $pb.PbFieldType.O3)
    ..aOS(3, _omitFieldNames ? '' : 'number')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PhoneNumber clone() => PhoneNumber()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PhoneNumber copyWith(void Function(PhoneNumber) updates) => super.copyWith((message) => updates(message as PhoneNumber)) as PhoneNumber;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PhoneNumber create() => PhoneNumber._();
  @$core.override
  PhoneNumber createEmptyInstance() => create();
  static $pb.PbList<PhoneNumber> createRepeated() => $pb.PbList<PhoneNumber>();
  @$core.pragma('dart2js:noInline')
  static PhoneNumber getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PhoneNumber>(create);
  static PhoneNumber? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get countryCode => $_getIZ(0);
  @$pb.TagNumber(1)
  set countryCode($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasCountryCode() => $_has(0);
  @$pb.TagNumber(1)
  void clearCountryCode() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get areaCode => $_getIZ(1);
  @$pb.TagNumber(2)
  set areaCode($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasAreaCode() => $_has(1);
  @$pb.TagNumber(2)
  void clearAreaCode() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get number => $_getSZ(2);
  @$pb.TagNumber(3)
  set number($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasNumber() => $_has(2);
  @$pb.TagNumber(3)
  void clearNumber() => $_clearField(3);
}

enum Geometry_Geometry {
  point, 
  multiPoint, 
  lineStrings, 
  polygons, 
  notSet
}

/// ------------ GeoJSON Types ------------
class Geometry extends $pb.GeneratedMessage {
  factory Geometry({
    PointGeometry? point,
    MultiPointGeometry? multiPoint,
    MultiLineStringGeometry? lineStrings,
    MultiPolygonGeometry? polygons,
  }) {
    final result = create();
    if (point != null) result.point = point;
    if (multiPoint != null) result.multiPoint = multiPoint;
    if (lineStrings != null) result.lineStrings = lineStrings;
    if (polygons != null) result.polygons = polygons;
    return result;
  }

  Geometry._();

  factory Geometry.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(data, registry);
  factory Geometry.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, Geometry_Geometry> _Geometry_GeometryByTag = {
    1 : Geometry_Geometry.point,
    2 : Geometry_Geometry.multiPoint,
    3 : Geometry_Geometry.lineStrings,
    4 : Geometry_Geometry.polygons,
    0 : Geometry_Geometry.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Geometry', package: const $pb.PackageName(_omitMessageNames ? '' : 'datahub.v1'), createEmptyInstance: create)
    ..oo(0, [1, 2, 3, 4])
    ..aOM<PointGeometry>(1, _omitFieldNames ? '' : 'point', subBuilder: PointGeometry.create)
    ..aOM<MultiPointGeometry>(2, _omitFieldNames ? '' : 'multiPoint', subBuilder: MultiPointGeometry.create)
    ..aOM<MultiLineStringGeometry>(3, _omitFieldNames ? '' : 'lineStrings', subBuilder: MultiLineStringGeometry.create)
    ..aOM<MultiPolygonGeometry>(4, _omitFieldNames ? '' : 'polygons', subBuilder: MultiPolygonGeometry.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Geometry clone() => Geometry()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Geometry copyWith(void Function(Geometry) updates) => super.copyWith((message) => updates(message as Geometry)) as Geometry;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Geometry create() => Geometry._();
  @$core.override
  Geometry createEmptyInstance() => create();
  static $pb.PbList<Geometry> createRepeated() => $pb.PbList<Geometry>();
  @$core.pragma('dart2js:noInline')
  static Geometry getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Geometry>(create);
  static Geometry? _defaultInstance;

  Geometry_Geometry whichGeometry() => _Geometry_GeometryByTag[$_whichOneof(0)]!;
  void clearGeometry() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  PointGeometry get point => $_getN(0);
  @$pb.TagNumber(1)
  set point(PointGeometry value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasPoint() => $_has(0);
  @$pb.TagNumber(1)
  void clearPoint() => $_clearField(1);
  @$pb.TagNumber(1)
  PointGeometry ensurePoint() => $_ensure(0);

  @$pb.TagNumber(2)
  MultiPointGeometry get multiPoint => $_getN(1);
  @$pb.TagNumber(2)
  set multiPoint(MultiPointGeometry value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasMultiPoint() => $_has(1);
  @$pb.TagNumber(2)
  void clearMultiPoint() => $_clearField(2);
  @$pb.TagNumber(2)
  MultiPointGeometry ensureMultiPoint() => $_ensure(1);

  @$pb.TagNumber(3)
  MultiLineStringGeometry get lineStrings => $_getN(2);
  @$pb.TagNumber(3)
  set lineStrings(MultiLineStringGeometry value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasLineStrings() => $_has(2);
  @$pb.TagNumber(3)
  void clearLineStrings() => $_clearField(3);
  @$pb.TagNumber(3)
  MultiLineStringGeometry ensureLineStrings() => $_ensure(2);

  @$pb.TagNumber(4)
  MultiPolygonGeometry get polygons => $_getN(3);
  @$pb.TagNumber(4)
  set polygons(MultiPolygonGeometry value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasPolygons() => $_has(3);
  @$pb.TagNumber(4)
  void clearPolygons() => $_clearField(4);
  @$pb.TagNumber(4)
  MultiPolygonGeometry ensurePolygons() => $_ensure(3);
}

class PointGeometry extends $pb.GeneratedMessage {
  factory PointGeometry({
    $0.LatLng? coordinates,
  }) {
    final result = create();
    if (coordinates != null) result.coordinates = coordinates;
    return result;
  }

  PointGeometry._();

  factory PointGeometry.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(data, registry);
  factory PointGeometry.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'PointGeometry', package: const $pb.PackageName(_omitMessageNames ? '' : 'datahub.v1'), createEmptyInstance: create)
    ..aOM<$0.LatLng>(1, _omitFieldNames ? '' : 'coordinates', subBuilder: $0.LatLng.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PointGeometry clone() => PointGeometry()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PointGeometry copyWith(void Function(PointGeometry) updates) => super.copyWith((message) => updates(message as PointGeometry)) as PointGeometry;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PointGeometry create() => PointGeometry._();
  @$core.override
  PointGeometry createEmptyInstance() => create();
  static $pb.PbList<PointGeometry> createRepeated() => $pb.PbList<PointGeometry>();
  @$core.pragma('dart2js:noInline')
  static PointGeometry getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PointGeometry>(create);
  static PointGeometry? _defaultInstance;

  @$pb.TagNumber(1)
  $0.LatLng get coordinates => $_getN(0);
  @$pb.TagNumber(1)
  set coordinates($0.LatLng value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasCoordinates() => $_has(0);
  @$pb.TagNumber(1)
  void clearCoordinates() => $_clearField(1);
  @$pb.TagNumber(1)
  $0.LatLng ensureCoordinates() => $_ensure(0);
}

class MultiPolygonGeometry extends $pb.GeneratedMessage {
  factory MultiPolygonGeometry({
    $core.Iterable<PolygonGeometry>? polygons,
  }) {
    final result = create();
    if (polygons != null) result.polygons.addAll(polygons);
    return result;
  }

  MultiPolygonGeometry._();

  factory MultiPolygonGeometry.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(data, registry);
  factory MultiPolygonGeometry.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'MultiPolygonGeometry', package: const $pb.PackageName(_omitMessageNames ? '' : 'datahub.v1'), createEmptyInstance: create)
    ..pc<PolygonGeometry>(1, _omitFieldNames ? '' : 'polygons', $pb.PbFieldType.PM, subBuilder: PolygonGeometry.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MultiPolygonGeometry clone() => MultiPolygonGeometry()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MultiPolygonGeometry copyWith(void Function(MultiPolygonGeometry) updates) => super.copyWith((message) => updates(message as MultiPolygonGeometry)) as MultiPolygonGeometry;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MultiPolygonGeometry create() => MultiPolygonGeometry._();
  @$core.override
  MultiPolygonGeometry createEmptyInstance() => create();
  static $pb.PbList<MultiPolygonGeometry> createRepeated() => $pb.PbList<MultiPolygonGeometry>();
  @$core.pragma('dart2js:noInline')
  static MultiPolygonGeometry getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MultiPolygonGeometry>(create);
  static MultiPolygonGeometry? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<PolygonGeometry> get polygons => $_getList(0);
}

class PolygonGeometry extends $pb.GeneratedMessage {
  factory PolygonGeometry({
    PointArray? coordinates,
  }) {
    final result = create();
    if (coordinates != null) result.coordinates = coordinates;
    return result;
  }

  PolygonGeometry._();

  factory PolygonGeometry.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(data, registry);
  factory PolygonGeometry.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'PolygonGeometry', package: const $pb.PackageName(_omitMessageNames ? '' : 'datahub.v1'), createEmptyInstance: create)
    ..aOM<PointArray>(1, _omitFieldNames ? '' : 'coordinates', subBuilder: PointArray.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PolygonGeometry clone() => PolygonGeometry()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PolygonGeometry copyWith(void Function(PolygonGeometry) updates) => super.copyWith((message) => updates(message as PolygonGeometry)) as PolygonGeometry;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PolygonGeometry create() => PolygonGeometry._();
  @$core.override
  PolygonGeometry createEmptyInstance() => create();
  static $pb.PbList<PolygonGeometry> createRepeated() => $pb.PbList<PolygonGeometry>();
  @$core.pragma('dart2js:noInline')
  static PolygonGeometry getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PolygonGeometry>(create);
  static PolygonGeometry? _defaultInstance;

  @$pb.TagNumber(1)
  PointArray get coordinates => $_getN(0);
  @$pb.TagNumber(1)
  set coordinates(PointArray value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasCoordinates() => $_has(0);
  @$pb.TagNumber(1)
  void clearCoordinates() => $_clearField(1);
  @$pb.TagNumber(1)
  PointArray ensureCoordinates() => $_ensure(0);
}

class MultiLineStringGeometry extends $pb.GeneratedMessage {
  factory MultiLineStringGeometry({
    $core.Iterable<LineStringGeometry>? lineStrings,
  }) {
    final result = create();
    if (lineStrings != null) result.lineStrings.addAll(lineStrings);
    return result;
  }

  MultiLineStringGeometry._();

  factory MultiLineStringGeometry.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(data, registry);
  factory MultiLineStringGeometry.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'MultiLineStringGeometry', package: const $pb.PackageName(_omitMessageNames ? '' : 'datahub.v1'), createEmptyInstance: create)
    ..pc<LineStringGeometry>(1, _omitFieldNames ? '' : 'lineStrings', $pb.PbFieldType.PM, subBuilder: LineStringGeometry.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MultiLineStringGeometry clone() => MultiLineStringGeometry()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MultiLineStringGeometry copyWith(void Function(MultiLineStringGeometry) updates) => super.copyWith((message) => updates(message as MultiLineStringGeometry)) as MultiLineStringGeometry;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MultiLineStringGeometry create() => MultiLineStringGeometry._();
  @$core.override
  MultiLineStringGeometry createEmptyInstance() => create();
  static $pb.PbList<MultiLineStringGeometry> createRepeated() => $pb.PbList<MultiLineStringGeometry>();
  @$core.pragma('dart2js:noInline')
  static MultiLineStringGeometry getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MultiLineStringGeometry>(create);
  static MultiLineStringGeometry? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<LineStringGeometry> get lineStrings => $_getList(0);
}

class LineStringGeometry extends $pb.GeneratedMessage {
  factory LineStringGeometry({
    PointArray? coordinates,
    $core.double? lineWidthM,
  }) {
    final result = create();
    if (coordinates != null) result.coordinates = coordinates;
    if (lineWidthM != null) result.lineWidthM = lineWidthM;
    return result;
  }

  LineStringGeometry._();

  factory LineStringGeometry.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(data, registry);
  factory LineStringGeometry.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'LineStringGeometry', package: const $pb.PackageName(_omitMessageNames ? '' : 'datahub.v1'), createEmptyInstance: create)
    ..aOM<PointArray>(1, _omitFieldNames ? '' : 'coordinates', subBuilder: PointArray.create)
    ..a<$core.double>(2, _omitFieldNames ? '' : 'lineWidthM', $pb.PbFieldType.OF)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LineStringGeometry clone() => LineStringGeometry()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  LineStringGeometry copyWith(void Function(LineStringGeometry) updates) => super.copyWith((message) => updates(message as LineStringGeometry)) as LineStringGeometry;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LineStringGeometry create() => LineStringGeometry._();
  @$core.override
  LineStringGeometry createEmptyInstance() => create();
  static $pb.PbList<LineStringGeometry> createRepeated() => $pb.PbList<LineStringGeometry>();
  @$core.pragma('dart2js:noInline')
  static LineStringGeometry getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LineStringGeometry>(create);
  static LineStringGeometry? _defaultInstance;

  @$pb.TagNumber(1)
  PointArray get coordinates => $_getN(0);
  @$pb.TagNumber(1)
  set coordinates(PointArray value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasCoordinates() => $_has(0);
  @$pb.TagNumber(1)
  void clearCoordinates() => $_clearField(1);
  @$pb.TagNumber(1)
  PointArray ensureCoordinates() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.double get lineWidthM => $_getN(1);
  @$pb.TagNumber(2)
  set lineWidthM($core.double value) => $_setFloat(1, value);
  @$pb.TagNumber(2)
  $core.bool hasLineWidthM() => $_has(1);
  @$pb.TagNumber(2)
  void clearLineWidthM() => $_clearField(2);
}

class MultiPointGeometry extends $pb.GeneratedMessage {
  factory MultiPointGeometry({
    $core.Iterable<$0.LatLng>? coordinates,
  }) {
    final result = create();
    if (coordinates != null) result.coordinates.addAll(coordinates);
    return result;
  }

  MultiPointGeometry._();

  factory MultiPointGeometry.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(data, registry);
  factory MultiPointGeometry.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'MultiPointGeometry', package: const $pb.PackageName(_omitMessageNames ? '' : 'datahub.v1'), createEmptyInstance: create)
    ..pc<$0.LatLng>(1, _omitFieldNames ? '' : 'coordinates', $pb.PbFieldType.PM, subBuilder: $0.LatLng.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MultiPointGeometry clone() => MultiPointGeometry()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  MultiPointGeometry copyWith(void Function(MultiPointGeometry) updates) => super.copyWith((message) => updates(message as MultiPointGeometry)) as MultiPointGeometry;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MultiPointGeometry create() => MultiPointGeometry._();
  @$core.override
  MultiPointGeometry createEmptyInstance() => create();
  static $pb.PbList<MultiPointGeometry> createRepeated() => $pb.PbList<MultiPointGeometry>();
  @$core.pragma('dart2js:noInline')
  static MultiPointGeometry getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MultiPointGeometry>(create);
  static MultiPointGeometry? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$0.LatLng> get coordinates => $_getList(0);
}

class PointArray extends $pb.GeneratedMessage {
  factory PointArray({
    $core.Iterable<$0.LatLng>? coordinates,
  }) {
    final result = create();
    if (coordinates != null) result.coordinates.addAll(coordinates);
    return result;
  }

  PointArray._();

  factory PointArray.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(data, registry);
  factory PointArray.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'PointArray', package: const $pb.PackageName(_omitMessageNames ? '' : 'datahub.v1'), createEmptyInstance: create)
    ..pc<$0.LatLng>(1, _omitFieldNames ? '' : 'coordinates', $pb.PbFieldType.PM, subBuilder: $0.LatLng.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PointArray clone() => PointArray()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PointArray copyWith(void Function(PointArray) updates) => super.copyWith((message) => updates(message as PointArray)) as PointArray;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PointArray create() => PointArray._();
  @$core.override
  PointArray createEmptyInstance() => create();
  static $pb.PbList<PointArray> createRepeated() => $pb.PbList<PointArray>();
  @$core.pragma('dart2js:noInline')
  static PointArray getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<PointArray>(create);
  static PointArray? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$0.LatLng> get coordinates => $_getList(0);
}

class BoundingBox extends $pb.GeneratedMessage {
  factory BoundingBox({
    $0.LatLng? lowerLeft,
    $0.LatLng? upperRight,
  }) {
    final result = create();
    if (lowerLeft != null) result.lowerLeft = lowerLeft;
    if (upperRight != null) result.upperRight = upperRight;
    return result;
  }

  BoundingBox._();

  factory BoundingBox.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(data, registry);
  factory BoundingBox.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'BoundingBox', package: const $pb.PackageName(_omitMessageNames ? '' : 'datahub.v1'), createEmptyInstance: create)
    ..aOM<$0.LatLng>(1, _omitFieldNames ? '' : 'lowerLeft', subBuilder: $0.LatLng.create)
    ..aOM<$0.LatLng>(2, _omitFieldNames ? '' : 'upperRight', subBuilder: $0.LatLng.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BoundingBox clone() => BoundingBox()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  BoundingBox copyWith(void Function(BoundingBox) updates) => super.copyWith((message) => updates(message as BoundingBox)) as BoundingBox;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static BoundingBox create() => BoundingBox._();
  @$core.override
  BoundingBox createEmptyInstance() => create();
  static $pb.PbList<BoundingBox> createRepeated() => $pb.PbList<BoundingBox>();
  @$core.pragma('dart2js:noInline')
  static BoundingBox getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<BoundingBox>(create);
  static BoundingBox? _defaultInstance;

  @$pb.TagNumber(1)
  $0.LatLng get lowerLeft => $_getN(0);
  @$pb.TagNumber(1)
  set lowerLeft($0.LatLng value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasLowerLeft() => $_has(0);
  @$pb.TagNumber(1)
  void clearLowerLeft() => $_clearField(1);
  @$pb.TagNumber(1)
  $0.LatLng ensureLowerLeft() => $_ensure(0);

  @$pb.TagNumber(2)
  $0.LatLng get upperRight => $_getN(1);
  @$pb.TagNumber(2)
  set upperRight($0.LatLng value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasUpperRight() => $_has(1);
  @$pb.TagNumber(2)
  void clearUpperRight() => $_clearField(2);
  @$pb.TagNumber(2)
  $0.LatLng ensureUpperRight() => $_ensure(1);
}


const $core.bool _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
