// This is a generated file - do not edit.
//
// Generated from road_event.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import 'common.pb.dart' as $2;
import 'google/protobuf/timestamp.pb.dart' as $0;
import 'google/type/date.pb.dart' as $4;
import 'google/type/timeofday.pb.dart' as $3;
import 'road_event.pbenum.dart';
import 'wzdx.pb.dart' as $1;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'road_event.pbenum.dart';

enum RoadEvent_Geometry {
  point, 
  lineString, 
  polygon, 
  notSet
}

class RoadEvent extends $pb.GeneratedMessage {
  factory RoadEvent({
    $fixnum.Int64? id,
    $fixnum.Int64? projectId,
    $core.String? name,
    $core.String? description,
    RoadEvent_RoadEventActiveStatus? status,
    $0.Timestamp? startDate,
    $0.Timestamp? endDate,
    $1.WorkZoneType? areaType,
    $core.Iterable<$1.TypeOfWork>? typesOfWork,
    $2.PointGeometry? point,
    $2.LineStringGeometry? lineString,
    $2.PolygonGeometry? polygon,
    $2.BoundingBox? bbox,
    EventRecurrence? defaultSchedule,
    $core.Iterable<$core.String>? linkedFieldDeviceIds,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (projectId != null) result.projectId = projectId;
    if (name != null) result.name = name;
    if (description != null) result.description = description;
    if (status != null) result.status = status;
    if (startDate != null) result.startDate = startDate;
    if (endDate != null) result.endDate = endDate;
    if (areaType != null) result.areaType = areaType;
    if (typesOfWork != null) result.typesOfWork.addAll(typesOfWork);
    if (point != null) result.point = point;
    if (lineString != null) result.lineString = lineString;
    if (polygon != null) result.polygon = polygon;
    if (bbox != null) result.bbox = bbox;
    if (defaultSchedule != null) result.defaultSchedule = defaultSchedule;
    if (linkedFieldDeviceIds != null) result.linkedFieldDeviceIds.addAll(linkedFieldDeviceIds);
    return result;
  }

  RoadEvent._();

  factory RoadEvent.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(data, registry);
  factory RoadEvent.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, RoadEvent_Geometry> _RoadEvent_GeometryByTag = {
    12 : RoadEvent_Geometry.point,
    13 : RoadEvent_Geometry.lineString,
    14 : RoadEvent_Geometry.polygon,
    0 : RoadEvent_Geometry.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'RoadEvent', package: const $pb.PackageName(_omitMessageNames ? '' : 'datahub.v1'), createEmptyInstance: create)
    ..oo(0, [12, 13, 14])
    ..a<$fixnum.Int64>(1, _omitFieldNames ? '' : 'id', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(2, _omitFieldNames ? '' : 'projectId', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOS(4, _omitFieldNames ? '' : 'name')
    ..aOS(5, _omitFieldNames ? '' : 'description')
    ..e<RoadEvent_RoadEventActiveStatus>(6, _omitFieldNames ? '' : 'status', $pb.PbFieldType.OE, defaultOrMaker: RoadEvent_RoadEventActiveStatus.ROAD_EVENT_ACTIVE_STATUS_UNKNOWN, valueOf: RoadEvent_RoadEventActiveStatus.valueOf, enumValues: RoadEvent_RoadEventActiveStatus.values)
    ..aOM<$0.Timestamp>(7, _omitFieldNames ? '' : 'startDate', subBuilder: $0.Timestamp.create)
    ..aOM<$0.Timestamp>(8, _omitFieldNames ? '' : 'endDate', subBuilder: $0.Timestamp.create)
    ..e<$1.WorkZoneType>(9, _omitFieldNames ? '' : 'areaType', $pb.PbFieldType.OE, defaultOrMaker: $1.WorkZoneType.WORK_ZONE_TYPE_UNKNOWN, valueOf: $1.WorkZoneType.valueOf, enumValues: $1.WorkZoneType.values)
    ..pc<$1.TypeOfWork>(10, _omitFieldNames ? '' : 'typesOfWork', $pb.PbFieldType.PM, subBuilder: $1.TypeOfWork.create)
    ..aOM<$2.PointGeometry>(12, _omitFieldNames ? '' : 'point', subBuilder: $2.PointGeometry.create)
    ..aOM<$2.LineStringGeometry>(13, _omitFieldNames ? '' : 'lineString', subBuilder: $2.LineStringGeometry.create)
    ..aOM<$2.PolygonGeometry>(14, _omitFieldNames ? '' : 'polygon', subBuilder: $2.PolygonGeometry.create)
    ..aOM<$2.BoundingBox>(15, _omitFieldNames ? '' : 'bbox', subBuilder: $2.BoundingBox.create)
    ..aOM<EventRecurrence>(18, _omitFieldNames ? '' : 'defaultSchedule', subBuilder: EventRecurrence.create)
    ..pPS(19, _omitFieldNames ? '' : 'linkedFieldDeviceIds')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RoadEvent clone() => RoadEvent()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RoadEvent copyWith(void Function(RoadEvent) updates) => super.copyWith((message) => updates(message as RoadEvent)) as RoadEvent;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RoadEvent create() => RoadEvent._();
  @$core.override
  RoadEvent createEmptyInstance() => create();
  static $pb.PbList<RoadEvent> createRepeated() => $pb.PbList<RoadEvent>();
  @$core.pragma('dart2js:noInline')
  static RoadEvent getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RoadEvent>(create);
  static RoadEvent? _defaultInstance;

  RoadEvent_Geometry whichGeometry() => _RoadEvent_GeometryByTag[$_whichOneof(0)]!;
  void clearGeometry() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  $fixnum.Int64 get id => $_getI64(0);
  @$pb.TagNumber(1)
  set id($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $fixnum.Int64 get projectId => $_getI64(1);
  @$pb.TagNumber(2)
  set projectId($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasProjectId() => $_has(1);
  @$pb.TagNumber(2)
  void clearProjectId() => $_clearField(2);

  @$pb.TagNumber(4)
  $core.String get name => $_getSZ(2);
  @$pb.TagNumber(4)
  set name($core.String value) => $_setString(2, value);
  @$pb.TagNumber(4)
  $core.bool hasName() => $_has(2);
  @$pb.TagNumber(4)
  void clearName() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get description => $_getSZ(3);
  @$pb.TagNumber(5)
  set description($core.String value) => $_setString(3, value);
  @$pb.TagNumber(5)
  $core.bool hasDescription() => $_has(3);
  @$pb.TagNumber(5)
  void clearDescription() => $_clearField(5);

  @$pb.TagNumber(6)
  RoadEvent_RoadEventActiveStatus get status => $_getN(4);
  @$pb.TagNumber(6)
  set status(RoadEvent_RoadEventActiveStatus value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasStatus() => $_has(4);
  @$pb.TagNumber(6)
  void clearStatus() => $_clearField(6);

  @$pb.TagNumber(7)
  $0.Timestamp get startDate => $_getN(5);
  @$pb.TagNumber(7)
  set startDate($0.Timestamp value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasStartDate() => $_has(5);
  @$pb.TagNumber(7)
  void clearStartDate() => $_clearField(7);
  @$pb.TagNumber(7)
  $0.Timestamp ensureStartDate() => $_ensure(5);

  @$pb.TagNumber(8)
  $0.Timestamp get endDate => $_getN(6);
  @$pb.TagNumber(8)
  set endDate($0.Timestamp value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasEndDate() => $_has(6);
  @$pb.TagNumber(8)
  void clearEndDate() => $_clearField(8);
  @$pb.TagNumber(8)
  $0.Timestamp ensureEndDate() => $_ensure(6);

  @$pb.TagNumber(9)
  $1.WorkZoneType get areaType => $_getN(7);
  @$pb.TagNumber(9)
  set areaType($1.WorkZoneType value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasAreaType() => $_has(7);
  @$pb.TagNumber(9)
  void clearAreaType() => $_clearField(9);

  @$pb.TagNumber(10)
  $pb.PbList<$1.TypeOfWork> get typesOfWork => $_getList(8);

  @$pb.TagNumber(12)
  $2.PointGeometry get point => $_getN(9);
  @$pb.TagNumber(12)
  set point($2.PointGeometry value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasPoint() => $_has(9);
  @$pb.TagNumber(12)
  void clearPoint() => $_clearField(12);
  @$pb.TagNumber(12)
  $2.PointGeometry ensurePoint() => $_ensure(9);

  @$pb.TagNumber(13)
  $2.LineStringGeometry get lineString => $_getN(10);
  @$pb.TagNumber(13)
  set lineString($2.LineStringGeometry value) => $_setField(13, value);
  @$pb.TagNumber(13)
  $core.bool hasLineString() => $_has(10);
  @$pb.TagNumber(13)
  void clearLineString() => $_clearField(13);
  @$pb.TagNumber(13)
  $2.LineStringGeometry ensureLineString() => $_ensure(10);

  @$pb.TagNumber(14)
  $2.PolygonGeometry get polygon => $_getN(11);
  @$pb.TagNumber(14)
  set polygon($2.PolygonGeometry value) => $_setField(14, value);
  @$pb.TagNumber(14)
  $core.bool hasPolygon() => $_has(11);
  @$pb.TagNumber(14)
  void clearPolygon() => $_clearField(14);
  @$pb.TagNumber(14)
  $2.PolygonGeometry ensurePolygon() => $_ensure(11);

  @$pb.TagNumber(15)
  $2.BoundingBox get bbox => $_getN(12);
  @$pb.TagNumber(15)
  set bbox($2.BoundingBox value) => $_setField(15, value);
  @$pb.TagNumber(15)
  $core.bool hasBbox() => $_has(12);
  @$pb.TagNumber(15)
  void clearBbox() => $_clearField(15);
  @$pb.TagNumber(15)
  $2.BoundingBox ensureBbox() => $_ensure(12);

  @$pb.TagNumber(18)
  EventRecurrence get defaultSchedule => $_getN(13);
  @$pb.TagNumber(18)
  set defaultSchedule(EventRecurrence value) => $_setField(18, value);
  @$pb.TagNumber(18)
  $core.bool hasDefaultSchedule() => $_has(13);
  @$pb.TagNumber(18)
  void clearDefaultSchedule() => $_clearField(18);
  @$pb.TagNumber(18)
  EventRecurrence ensureDefaultSchedule() => $_ensure(13);

  /// Else, refer to the EventRecurrence included on each road_sub_event
  @$pb.TagNumber(19)
  $pb.PbList<$core.String> get linkedFieldDeviceIds => $_getList(14);
}

class EventRecurrence extends $pb.GeneratedMessage {
  factory EventRecurrence({
    $3.TimeOfDay? startTime,
    $3.TimeOfDay? endTime,
    $4.Date? startDate,
    $4.Date? endDate,
    $core.bool? monday,
    $core.bool? tuesday,
    $core.bool? wednesday,
    $core.bool? thursday,
    $core.bool? friday,
    $core.bool? saturday,
    $core.bool? sunday,
    $core.bool? exclusion,
  }) {
    final result = create();
    if (startTime != null) result.startTime = startTime;
    if (endTime != null) result.endTime = endTime;
    if (startDate != null) result.startDate = startDate;
    if (endDate != null) result.endDate = endDate;
    if (monday != null) result.monday = monday;
    if (tuesday != null) result.tuesday = tuesday;
    if (wednesday != null) result.wednesday = wednesday;
    if (thursday != null) result.thursday = thursday;
    if (friday != null) result.friday = friday;
    if (saturday != null) result.saturday = saturday;
    if (sunday != null) result.sunday = sunday;
    if (exclusion != null) result.exclusion = exclusion;
    return result;
  }

  EventRecurrence._();

  factory EventRecurrence.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(data, registry);
  factory EventRecurrence.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'EventRecurrence', package: const $pb.PackageName(_omitMessageNames ? '' : 'datahub.v1'), createEmptyInstance: create)
    ..aOM<$3.TimeOfDay>(1, _omitFieldNames ? '' : 'startTime', subBuilder: $3.TimeOfDay.create)
    ..aOM<$3.TimeOfDay>(2, _omitFieldNames ? '' : 'endTime', subBuilder: $3.TimeOfDay.create)
    ..aOM<$4.Date>(3, _omitFieldNames ? '' : 'startDate', subBuilder: $4.Date.create)
    ..aOM<$4.Date>(4, _omitFieldNames ? '' : 'endDate', subBuilder: $4.Date.create)
    ..aOB(5, _omitFieldNames ? '' : 'monday')
    ..aOB(6, _omitFieldNames ? '' : 'tuesday')
    ..aOB(7, _omitFieldNames ? '' : 'wednesday')
    ..aOB(8, _omitFieldNames ? '' : 'thursday')
    ..aOB(9, _omitFieldNames ? '' : 'friday')
    ..aOB(10, _omitFieldNames ? '' : 'saturday')
    ..aOB(11, _omitFieldNames ? '' : 'sunday')
    ..aOB(12, _omitFieldNames ? '' : 'exclusion')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EventRecurrence clone() => EventRecurrence()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EventRecurrence copyWith(void Function(EventRecurrence) updates) => super.copyWith((message) => updates(message as EventRecurrence)) as EventRecurrence;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static EventRecurrence create() => EventRecurrence._();
  @$core.override
  EventRecurrence createEmptyInstance() => create();
  static $pb.PbList<EventRecurrence> createRepeated() => $pb.PbList<EventRecurrence>();
  @$core.pragma('dart2js:noInline')
  static EventRecurrence getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<EventRecurrence>(create);
  static EventRecurrence? _defaultInstance;

  /// the time of day the event becomes active
  @$pb.TagNumber(1)
  $3.TimeOfDay get startTime => $_getN(0);
  @$pb.TagNumber(1)
  set startTime($3.TimeOfDay value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasStartTime() => $_has(0);
  @$pb.TagNumber(1)
  void clearStartTime() => $_clearField(1);
  @$pb.TagNumber(1)
  $3.TimeOfDay ensureStartTime() => $_ensure(0);

  /// the time of day the event becomes inactive
  @$pb.TagNumber(2)
  $3.TimeOfDay get endTime => $_getN(1);
  @$pb.TagNumber(2)
  set endTime($3.TimeOfDay value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasEndTime() => $_has(1);
  @$pb.TagNumber(2)
  void clearEndTime() => $_clearField(2);
  @$pb.TagNumber(2)
  $3.TimeOfDay ensureEndTime() => $_ensure(1);

  /// the date the event becomes active
  @$pb.TagNumber(3)
  $4.Date get startDate => $_getN(2);
  @$pb.TagNumber(3)
  set startDate($4.Date value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasStartDate() => $_has(2);
  @$pb.TagNumber(3)
  void clearStartDate() => $_clearField(3);
  @$pb.TagNumber(3)
  $4.Date ensureStartDate() => $_ensure(2);

  /// the date teh event becomes inactive
  @$pb.TagNumber(4)
  $4.Date get endDate => $_getN(3);
  @$pb.TagNumber(4)
  set endDate($4.Date value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasEndDate() => $_has(3);
  @$pb.TagNumber(4)
  void clearEndDate() => $_clearField(4);
  @$pb.TagNumber(4)
  $4.Date ensureEndDate() => $_ensure(3);

  @$pb.TagNumber(5)
  $core.bool get monday => $_getBF(4);
  @$pb.TagNumber(5)
  set monday($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasMonday() => $_has(4);
  @$pb.TagNumber(5)
  void clearMonday() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.bool get tuesday => $_getBF(5);
  @$pb.TagNumber(6)
  set tuesday($core.bool value) => $_setBool(5, value);
  @$pb.TagNumber(6)
  $core.bool hasTuesday() => $_has(5);
  @$pb.TagNumber(6)
  void clearTuesday() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.bool get wednesday => $_getBF(6);
  @$pb.TagNumber(7)
  set wednesday($core.bool value) => $_setBool(6, value);
  @$pb.TagNumber(7)
  $core.bool hasWednesday() => $_has(6);
  @$pb.TagNumber(7)
  void clearWednesday() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.bool get thursday => $_getBF(7);
  @$pb.TagNumber(8)
  set thursday($core.bool value) => $_setBool(7, value);
  @$pb.TagNumber(8)
  $core.bool hasThursday() => $_has(7);
  @$pb.TagNumber(8)
  void clearThursday() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.bool get friday => $_getBF(8);
  @$pb.TagNumber(9)
  set friday($core.bool value) => $_setBool(8, value);
  @$pb.TagNumber(9)
  $core.bool hasFriday() => $_has(8);
  @$pb.TagNumber(9)
  void clearFriday() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.bool get saturday => $_getBF(9);
  @$pb.TagNumber(10)
  set saturday($core.bool value) => $_setBool(9, value);
  @$pb.TagNumber(10)
  $core.bool hasSaturday() => $_has(9);
  @$pb.TagNumber(10)
  void clearSaturday() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.bool get sunday => $_getBF(10);
  @$pb.TagNumber(11)
  set sunday($core.bool value) => $_setBool(10, value);
  @$pb.TagNumber(11)
  $core.bool hasSunday() => $_has(10);
  @$pb.TagNumber(11)
  void clearSunday() => $_clearField(11);

  @$pb.TagNumber(12)
  $core.bool get exclusion => $_getBF(11);
  @$pb.TagNumber(12)
  set exclusion($core.bool value) => $_setBool(11, value);
  @$pb.TagNumber(12)
  $core.bool hasExclusion() => $_has(11);
  @$pb.TagNumber(12)
  void clearExclusion() => $_clearField(12);
}


const $core.bool _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
