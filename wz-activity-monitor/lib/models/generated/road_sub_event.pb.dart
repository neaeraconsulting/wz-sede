// This is a generated file - do not edit.
//
// Generated from road_sub_event.proto.

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
import 'road_event.pb.dart' as $1;
import 'road_sub_event.pbenum.dart';
import 'wzdx.pb.dart' as $2;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'road_sub_event.pbenum.dart';

/// BaseLayer RoadSubEvent fields must cover the entire length of the RoadEvent
class RoadSubEvent_BaseLayer extends $pb.GeneratedMessage {
  factory RoadSubEvent_BaseLayer({
    $2.VehicleImpact? vehicleImpact,
    $core.Iterable<$2.Lane>? lanes,
    $core.Iterable<$2.Restriction>? restrictions,
    $0.RoadSurfaceType? surfaceType,
  }) {
    final result = create();
    if (vehicleImpact != null) result.vehicleImpact = vehicleImpact;
    if (lanes != null) result.lanes.addAll(lanes);
    if (restrictions != null) result.restrictions.addAll(restrictions);
    if (surfaceType != null) result.surfaceType = surfaceType;
    return result;
  }

  RoadSubEvent_BaseLayer._();

  factory RoadSubEvent_BaseLayer.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(data, registry);
  factory RoadSubEvent_BaseLayer.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'RoadSubEvent.BaseLayer', package: const $pb.PackageName(_omitMessageNames ? '' : 'datahub.v1'), createEmptyInstance: create)
    ..e<$2.VehicleImpact>(1, _omitFieldNames ? '' : 'vehicleImpact', $pb.PbFieldType.OE, defaultOrMaker: $2.VehicleImpact.VEHICLE_IMPACT_UNKNOWN, valueOf: $2.VehicleImpact.valueOf, enumValues: $2.VehicleImpact.values)
    ..pc<$2.Lane>(2, _omitFieldNames ? '' : 'lanes', $pb.PbFieldType.PM, subBuilder: $2.Lane.create)
    ..pc<$2.Restriction>(3, _omitFieldNames ? '' : 'restrictions', $pb.PbFieldType.PM, subBuilder: $2.Restriction.create)
    ..e<$0.RoadSurfaceType>(4, _omitFieldNames ? '' : 'surfaceType', $pb.PbFieldType.OE, defaultOrMaker: $0.RoadSurfaceType.ROAD_SURFACE_UNKNOWN, valueOf: $0.RoadSurfaceType.valueOf, enumValues: $0.RoadSurfaceType.values)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RoadSubEvent_BaseLayer clone() => RoadSubEvent_BaseLayer()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RoadSubEvent_BaseLayer copyWith(void Function(RoadSubEvent_BaseLayer) updates) => super.copyWith((message) => updates(message as RoadSubEvent_BaseLayer)) as RoadSubEvent_BaseLayer;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RoadSubEvent_BaseLayer create() => RoadSubEvent_BaseLayer._();
  @$core.override
  RoadSubEvent_BaseLayer createEmptyInstance() => create();
  static $pb.PbList<RoadSubEvent_BaseLayer> createRepeated() => $pb.PbList<RoadSubEvent_BaseLayer>();
  @$core.pragma('dart2js:noInline')
  static RoadSubEvent_BaseLayer getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RoadSubEvent_BaseLayer>(create);
  static RoadSubEvent_BaseLayer? _defaultInstance;

  @$pb.TagNumber(1)
  $2.VehicleImpact get vehicleImpact => $_getN(0);
  @$pb.TagNumber(1)
  set vehicleImpact($2.VehicleImpact value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasVehicleImpact() => $_has(0);
  @$pb.TagNumber(1)
  void clearVehicleImpact() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<$2.Lane> get lanes => $_getList(1);

  @$pb.TagNumber(3)
  $pb.PbList<$2.Restriction> get restrictions => $_getList(2);

  @$pb.TagNumber(4)
  $0.RoadSurfaceType get surfaceType => $_getN(3);
  @$pb.TagNumber(4)
  set surfaceType($0.RoadSurfaceType value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasSurfaceType() => $_has(3);
  @$pb.TagNumber(4)
  void clearSurfaceType() => $_clearField(4);
}

class RoadSubEvent_SpeedReductionLayer extends $pb.GeneratedMessage {
  factory RoadSubEvent_SpeedReductionLayer({
    $core.double? reducedSpeedLimitKph,
  }) {
    final result = create();
    if (reducedSpeedLimitKph != null) result.reducedSpeedLimitKph = reducedSpeedLimitKph;
    return result;
  }

  RoadSubEvent_SpeedReductionLayer._();

  factory RoadSubEvent_SpeedReductionLayer.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(data, registry);
  factory RoadSubEvent_SpeedReductionLayer.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'RoadSubEvent.SpeedReductionLayer', package: const $pb.PackageName(_omitMessageNames ? '' : 'datahub.v1'), createEmptyInstance: create)
    ..a<$core.double>(1, _omitFieldNames ? '' : 'reducedSpeedLimitKph', $pb.PbFieldType.OF)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RoadSubEvent_SpeedReductionLayer clone() => RoadSubEvent_SpeedReductionLayer()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RoadSubEvent_SpeedReductionLayer copyWith(void Function(RoadSubEvent_SpeedReductionLayer) updates) => super.copyWith((message) => updates(message as RoadSubEvent_SpeedReductionLayer)) as RoadSubEvent_SpeedReductionLayer;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RoadSubEvent_SpeedReductionLayer create() => RoadSubEvent_SpeedReductionLayer._();
  @$core.override
  RoadSubEvent_SpeedReductionLayer createEmptyInstance() => create();
  static $pb.PbList<RoadSubEvent_SpeedReductionLayer> createRepeated() => $pb.PbList<RoadSubEvent_SpeedReductionLayer>();
  @$core.pragma('dart2js:noInline')
  static RoadSubEvent_SpeedReductionLayer getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RoadSubEvent_SpeedReductionLayer>(create);
  static RoadSubEvent_SpeedReductionLayer? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get reducedSpeedLimitKph => $_getN(0);
  @$pb.TagNumber(1)
  set reducedSpeedLimitKph($core.double value) => $_setFloat(0, value);
  @$pb.TagNumber(1)
  $core.bool hasReducedSpeedLimitKph() => $_has(0);
  @$pb.TagNumber(1)
  void clearReducedSpeedLimitKph() => $_clearField(1);
}

class RoadSubEvent_WorkerPresenceLayer extends $pb.GeneratedMessage {
  factory RoadSubEvent_WorkerPresenceLayer({
    $2.WorkerPresence? workerPresence,
  }) {
    final result = create();
    if (workerPresence != null) result.workerPresence = workerPresence;
    return result;
  }

  RoadSubEvent_WorkerPresenceLayer._();

  factory RoadSubEvent_WorkerPresenceLayer.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(data, registry);
  factory RoadSubEvent_WorkerPresenceLayer.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'RoadSubEvent.WorkerPresenceLayer', package: const $pb.PackageName(_omitMessageNames ? '' : 'datahub.v1'), createEmptyInstance: create)
    ..aOM<$2.WorkerPresence>(1, _omitFieldNames ? '' : 'workerPresence', subBuilder: $2.WorkerPresence.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RoadSubEvent_WorkerPresenceLayer clone() => RoadSubEvent_WorkerPresenceLayer()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RoadSubEvent_WorkerPresenceLayer copyWith(void Function(RoadSubEvent_WorkerPresenceLayer) updates) => super.copyWith((message) => updates(message as RoadSubEvent_WorkerPresenceLayer)) as RoadSubEvent_WorkerPresenceLayer;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RoadSubEvent_WorkerPresenceLayer create() => RoadSubEvent_WorkerPresenceLayer._();
  @$core.override
  RoadSubEvent_WorkerPresenceLayer createEmptyInstance() => create();
  static $pb.PbList<RoadSubEvent_WorkerPresenceLayer> createRepeated() => $pb.PbList<RoadSubEvent_WorkerPresenceLayer>();
  @$core.pragma('dart2js:noInline')
  static RoadSubEvent_WorkerPresenceLayer getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RoadSubEvent_WorkerPresenceLayer>(create);
  static RoadSubEvent_WorkerPresenceLayer? _defaultInstance;

  @$pb.TagNumber(1)
  $2.WorkerPresence get workerPresence => $_getN(0);
  @$pb.TagNumber(1)
  set workerPresence($2.WorkerPresence value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasWorkerPresence() => $_has(0);
  @$pb.TagNumber(1)
  void clearWorkerPresence() => $_clearField(1);
  @$pb.TagNumber(1)
  $2.WorkerPresence ensureWorkerPresence() => $_ensure(0);
}

/// This message type serves to link related RoadSubEvents together similarly to a Singly Linked List
class RoadSubEvent_RoadSubEventLink extends $pb.GeneratedMessage {
  factory RoadSubEvent_RoadSubEventLink({
    $fixnum.Int64? linkedRoadSubEventId,
    RoadSubEvent_RoadSubEventLink_RoadSubEventLinkType? roadSubEventLinkType,
  }) {
    final result = create();
    if (linkedRoadSubEventId != null) result.linkedRoadSubEventId = linkedRoadSubEventId;
    if (roadSubEventLinkType != null) result.roadSubEventLinkType = roadSubEventLinkType;
    return result;
  }

  RoadSubEvent_RoadSubEventLink._();

  factory RoadSubEvent_RoadSubEventLink.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(data, registry);
  factory RoadSubEvent_RoadSubEventLink.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'RoadSubEvent.RoadSubEventLink', package: const $pb.PackageName(_omitMessageNames ? '' : 'datahub.v1'), createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, _omitFieldNames ? '' : 'linkedRoadSubEventId', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..e<RoadSubEvent_RoadSubEventLink_RoadSubEventLinkType>(2, _omitFieldNames ? '' : 'roadSubEventLinkType', $pb.PbFieldType.OE, defaultOrMaker: RoadSubEvent_RoadSubEventLink_RoadSubEventLinkType.ROAD_SUB_EVENT_LINK_TYPE_UNKNOWN, valueOf: RoadSubEvent_RoadSubEventLink_RoadSubEventLinkType.valueOf, enumValues: RoadSubEvent_RoadSubEventLink_RoadSubEventLinkType.values)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RoadSubEvent_RoadSubEventLink clone() => RoadSubEvent_RoadSubEventLink()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RoadSubEvent_RoadSubEventLink copyWith(void Function(RoadSubEvent_RoadSubEventLink) updates) => super.copyWith((message) => updates(message as RoadSubEvent_RoadSubEventLink)) as RoadSubEvent_RoadSubEventLink;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RoadSubEvent_RoadSubEventLink create() => RoadSubEvent_RoadSubEventLink._();
  @$core.override
  RoadSubEvent_RoadSubEventLink createEmptyInstance() => create();
  static $pb.PbList<RoadSubEvent_RoadSubEventLink> createRepeated() => $pb.PbList<RoadSubEvent_RoadSubEventLink>();
  @$core.pragma('dart2js:noInline')
  static RoadSubEvent_RoadSubEventLink getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RoadSubEvent_RoadSubEventLink>(create);
  static RoadSubEvent_RoadSubEventLink? _defaultInstance;

  /// linked_road_sub_event_id is populated in the following scenarios:
  ///  - the containing RoadSubEvent is the first in a sequence, the value should be the id of the NEXT_IN_SEQUENCE
  ///  - the containing RoadSubEvent is the next in a sequence, the value should be the id of the NEXT_IN_SEQUENCE
  ///  - the containing RoadSubEvent has a related RoadSubEvent not in its sequence, the value should be the id of the related RoadSubEvent
  ///     (for example, a BaseLayer has a related SpeedReductionLayer)
  ///  - the containing RoadSubEvent has a related detour, the value should be the id of the RoadSubEvent representing the detour
  ///
  /// linked_road_sub_event_id is not populated in the following scenarios:
  ///  - the containing RoadSubEvent is the last in a sequence
  ///  - the containing RoadSubEvent is an active or planned moving operation
  @$pb.TagNumber(1)
  $fixnum.Int64 get linkedRoadSubEventId => $_getI64(0);
  @$pb.TagNumber(1)
  set linkedRoadSubEventId($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasLinkedRoadSubEventId() => $_has(0);
  @$pb.TagNumber(1)
  void clearLinkedRoadSubEventId() => $_clearField(1);

  @$pb.TagNumber(2)
  RoadSubEvent_RoadSubEventLink_RoadSubEventLinkType get roadSubEventLinkType => $_getN(1);
  @$pb.TagNumber(2)
  set roadSubEventLinkType(RoadSubEvent_RoadSubEventLink_RoadSubEventLinkType value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasRoadSubEventLinkType() => $_has(1);
  @$pb.TagNumber(2)
  void clearRoadSubEventLinkType() => $_clearField(2);
}

enum RoadSubEvent_Geometry {
  point, 
  lineString, 
  polygon, 
  notSet
}

enum RoadSubEvent_Layer {
  baseLayer, 
  speedReductionLayer, 
  workerPresenceLayer, 
  notSet
}

class RoadSubEvent extends $pb.GeneratedMessage {
  factory RoadSubEvent({
    $fixnum.Int64? id,
    $fixnum.Int64? projectId,
    $fixnum.Int64? roadEventId,
    $2.RoadwayDirection? direction,
    $core.Iterable<$core.String>? roadNames,
    $core.String? beginningCrossStreet,
    $core.String? endingCrossStreet,
    $core.double? beginningMilepost,
    $core.double? endingMilepost,
    $0.MarkedLocationType? startLocationType,
    $0.MarkedLocationType? endLocationType,
    $0.PointGeometry? point,
    $0.LineStringGeometry? lineString,
    $0.PolygonGeometry? polygon,
    $0.BoundingBox? bbox,
    $core.String? routeId,
    $1.EventRecurrence? schedule,
    RoadSubEvent_BaseLayer? baseLayer,
    RoadSubEvent_SpeedReductionLayer? speedReductionLayer,
    RoadSubEvent_WorkerPresenceLayer? workerPresenceLayer,
    $core.Iterable<RoadSubEvent_RoadSubEventLink>? linkedEvents,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (projectId != null) result.projectId = projectId;
    if (roadEventId != null) result.roadEventId = roadEventId;
    if (direction != null) result.direction = direction;
    if (roadNames != null) result.roadNames.addAll(roadNames);
    if (beginningCrossStreet != null) result.beginningCrossStreet = beginningCrossStreet;
    if (endingCrossStreet != null) result.endingCrossStreet = endingCrossStreet;
    if (beginningMilepost != null) result.beginningMilepost = beginningMilepost;
    if (endingMilepost != null) result.endingMilepost = endingMilepost;
    if (startLocationType != null) result.startLocationType = startLocationType;
    if (endLocationType != null) result.endLocationType = endLocationType;
    if (point != null) result.point = point;
    if (lineString != null) result.lineString = lineString;
    if (polygon != null) result.polygon = polygon;
    if (bbox != null) result.bbox = bbox;
    if (routeId != null) result.routeId = routeId;
    if (schedule != null) result.schedule = schedule;
    if (baseLayer != null) result.baseLayer = baseLayer;
    if (speedReductionLayer != null) result.speedReductionLayer = speedReductionLayer;
    if (workerPresenceLayer != null) result.workerPresenceLayer = workerPresenceLayer;
    if (linkedEvents != null) result.linkedEvents.addAll(linkedEvents);
    return result;
  }

  RoadSubEvent._();

  factory RoadSubEvent.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(data, registry);
  factory RoadSubEvent.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, RoadSubEvent_Geometry> _RoadSubEvent_GeometryByTag = {
    19 : RoadSubEvent_Geometry.point,
    20 : RoadSubEvent_Geometry.lineString,
    21 : RoadSubEvent_Geometry.polygon,
    0 : RoadSubEvent_Geometry.notSet
  };
  static const $core.Map<$core.int, RoadSubEvent_Layer> _RoadSubEvent_LayerByTag = {
    26 : RoadSubEvent_Layer.baseLayer,
    27 : RoadSubEvent_Layer.speedReductionLayer,
    28 : RoadSubEvent_Layer.workerPresenceLayer,
    0 : RoadSubEvent_Layer.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'RoadSubEvent', package: const $pb.PackageName(_omitMessageNames ? '' : 'datahub.v1'), createEmptyInstance: create)
    ..oo(0, [19, 20, 21])
    ..oo(1, [26, 27, 28])
    ..a<$fixnum.Int64>(1, _omitFieldNames ? '' : 'id', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(2, _omitFieldNames ? '' : 'projectId', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$fixnum.Int64>(3, _omitFieldNames ? '' : 'roadEventId', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..e<$2.RoadwayDirection>(4, _omitFieldNames ? '' : 'direction', $pb.PbFieldType.OE, defaultOrMaker: $2.RoadwayDirection.ROADWAY_DIRECTION_UNKNOWN, valueOf: $2.RoadwayDirection.valueOf, enumValues: $2.RoadwayDirection.values)
    ..pPS(7, _omitFieldNames ? '' : 'roadNames')
    ..aOS(8, _omitFieldNames ? '' : 'beginningCrossStreet')
    ..aOS(9, _omitFieldNames ? '' : 'endingCrossStreet')
    ..a<$core.double>(10, _omitFieldNames ? '' : 'beginningMilepost', $pb.PbFieldType.OD)
    ..a<$core.double>(11, _omitFieldNames ? '' : 'endingMilepost', $pb.PbFieldType.OD)
    ..e<$0.MarkedLocationType>(17, _omitFieldNames ? '' : 'startLocationType', $pb.PbFieldType.OE, defaultOrMaker: $0.MarkedLocationType.MARKED_LOCATION_TYPE_UNKNOWN, valueOf: $0.MarkedLocationType.valueOf, enumValues: $0.MarkedLocationType.values)
    ..e<$0.MarkedLocationType>(18, _omitFieldNames ? '' : 'endLocationType', $pb.PbFieldType.OE, defaultOrMaker: $0.MarkedLocationType.MARKED_LOCATION_TYPE_UNKNOWN, valueOf: $0.MarkedLocationType.valueOf, enumValues: $0.MarkedLocationType.values)
    ..aOM<$0.PointGeometry>(19, _omitFieldNames ? '' : 'point', subBuilder: $0.PointGeometry.create)
    ..aOM<$0.LineStringGeometry>(20, _omitFieldNames ? '' : 'lineString', subBuilder: $0.LineStringGeometry.create)
    ..aOM<$0.PolygonGeometry>(21, _omitFieldNames ? '' : 'polygon', subBuilder: $0.PolygonGeometry.create)
    ..aOM<$0.BoundingBox>(22, _omitFieldNames ? '' : 'bbox', subBuilder: $0.BoundingBox.create)
    ..aOS(23, _omitFieldNames ? '' : 'routeId')
    ..aOM<$1.EventRecurrence>(24, _omitFieldNames ? '' : 'schedule', subBuilder: $1.EventRecurrence.create)
    ..aOM<RoadSubEvent_BaseLayer>(26, _omitFieldNames ? '' : 'baseLayer', subBuilder: RoadSubEvent_BaseLayer.create)
    ..aOM<RoadSubEvent_SpeedReductionLayer>(27, _omitFieldNames ? '' : 'speedReductionLayer', subBuilder: RoadSubEvent_SpeedReductionLayer.create)
    ..aOM<RoadSubEvent_WorkerPresenceLayer>(28, _omitFieldNames ? '' : 'workerPresenceLayer', subBuilder: RoadSubEvent_WorkerPresenceLayer.create)
    ..pc<RoadSubEvent_RoadSubEventLink>(30, _omitFieldNames ? '' : 'linkedEvents', $pb.PbFieldType.PM, subBuilder: RoadSubEvent_RoadSubEventLink.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RoadSubEvent clone() => RoadSubEvent()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RoadSubEvent copyWith(void Function(RoadSubEvent) updates) => super.copyWith((message) => updates(message as RoadSubEvent)) as RoadSubEvent;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RoadSubEvent create() => RoadSubEvent._();
  @$core.override
  RoadSubEvent createEmptyInstance() => create();
  static $pb.PbList<RoadSubEvent> createRepeated() => $pb.PbList<RoadSubEvent>();
  @$core.pragma('dart2js:noInline')
  static RoadSubEvent getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RoadSubEvent>(create);
  static RoadSubEvent? _defaultInstance;

  RoadSubEvent_Geometry whichGeometry() => _RoadSubEvent_GeometryByTag[$_whichOneof(0)]!;
  void clearGeometry() => $_clearField($_whichOneof(0));

  RoadSubEvent_Layer whichLayer() => _RoadSubEvent_LayerByTag[$_whichOneof(1)]!;
  void clearLayer() => $_clearField($_whichOneof(1));

  @$pb.TagNumber(1)
  $fixnum.Int64 get id => $_getI64(0);
  @$pb.TagNumber(1)
  set id($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  /// When managed from the Datahub, there may not be a project in ConAdmin to associate this RSE with
  @$pb.TagNumber(2)
  $fixnum.Int64 get projectId => $_getI64(1);
  @$pb.TagNumber(2)
  set projectId($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasProjectId() => $_has(1);
  @$pb.TagNumber(2)
  void clearProjectId() => $_clearField(2);

  @$pb.TagNumber(3)
  $fixnum.Int64 get roadEventId => $_getI64(2);
  @$pb.TagNumber(3)
  set roadEventId($fixnum.Int64 value) => $_setInt64(2, value);
  @$pb.TagNumber(3)
  $core.bool hasRoadEventId() => $_has(2);
  @$pb.TagNumber(3)
  void clearRoadEventId() => $_clearField(3);

  @$pb.TagNumber(4)
  $2.RoadwayDirection get direction => $_getN(3);
  @$pb.TagNumber(4)
  set direction($2.RoadwayDirection value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasDirection() => $_has(3);
  @$pb.TagNumber(4)
  void clearDirection() => $_clearField(4);

  /// the human-readable names of the roadway(s) associated with the route_id
  @$pb.TagNumber(7)
  $pb.PbList<$core.String> get roadNames => $_getList(4);

  @$pb.TagNumber(8)
  $core.String get beginningCrossStreet => $_getSZ(5);
  @$pb.TagNumber(8)
  set beginningCrossStreet($core.String value) => $_setString(5, value);
  @$pb.TagNumber(8)
  $core.bool hasBeginningCrossStreet() => $_has(5);
  @$pb.TagNumber(8)
  void clearBeginningCrossStreet() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.String get endingCrossStreet => $_getSZ(6);
  @$pb.TagNumber(9)
  set endingCrossStreet($core.String value) => $_setString(6, value);
  @$pb.TagNumber(9)
  $core.bool hasEndingCrossStreet() => $_has(6);
  @$pb.TagNumber(9)
  void clearEndingCrossStreet() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.double get beginningMilepost => $_getN(7);
  @$pb.TagNumber(10)
  set beginningMilepost($core.double value) => $_setDouble(7, value);
  @$pb.TagNumber(10)
  $core.bool hasBeginningMilepost() => $_has(7);
  @$pb.TagNumber(10)
  void clearBeginningMilepost() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.double get endingMilepost => $_getN(8);
  @$pb.TagNumber(11)
  set endingMilepost($core.double value) => $_setDouble(8, value);
  @$pb.TagNumber(11)
  $core.bool hasEndingMilepost() => $_has(8);
  @$pb.TagNumber(11)
  void clearEndingMilepost() => $_clearField(11);

  @$pb.TagNumber(17)
  $0.MarkedLocationType get startLocationType => $_getN(9);
  @$pb.TagNumber(17)
  set startLocationType($0.MarkedLocationType value) => $_setField(17, value);
  @$pb.TagNumber(17)
  $core.bool hasStartLocationType() => $_has(9);
  @$pb.TagNumber(17)
  void clearStartLocationType() => $_clearField(17);

  @$pb.TagNumber(18)
  $0.MarkedLocationType get endLocationType => $_getN(10);
  @$pb.TagNumber(18)
  set endLocationType($0.MarkedLocationType value) => $_setField(18, value);
  @$pb.TagNumber(18)
  $core.bool hasEndLocationType() => $_has(10);
  @$pb.TagNumber(18)
  void clearEndLocationType() => $_clearField(18);

  @$pb.TagNumber(19)
  $0.PointGeometry get point => $_getN(11);
  @$pb.TagNumber(19)
  set point($0.PointGeometry value) => $_setField(19, value);
  @$pb.TagNumber(19)
  $core.bool hasPoint() => $_has(11);
  @$pb.TagNumber(19)
  void clearPoint() => $_clearField(19);
  @$pb.TagNumber(19)
  $0.PointGeometry ensurePoint() => $_ensure(11);

  @$pb.TagNumber(20)
  $0.LineStringGeometry get lineString => $_getN(12);
  @$pb.TagNumber(20)
  set lineString($0.LineStringGeometry value) => $_setField(20, value);
  @$pb.TagNumber(20)
  $core.bool hasLineString() => $_has(12);
  @$pb.TagNumber(20)
  void clearLineString() => $_clearField(20);
  @$pb.TagNumber(20)
  $0.LineStringGeometry ensureLineString() => $_ensure(12);

  @$pb.TagNumber(21)
  $0.PolygonGeometry get polygon => $_getN(13);
  @$pb.TagNumber(21)
  set polygon($0.PolygonGeometry value) => $_setField(21, value);
  @$pb.TagNumber(21)
  $core.bool hasPolygon() => $_has(13);
  @$pb.TagNumber(21)
  void clearPolygon() => $_clearField(21);
  @$pb.TagNumber(21)
  $0.PolygonGeometry ensurePolygon() => $_ensure(13);

  @$pb.TagNumber(22)
  $0.BoundingBox get bbox => $_getN(14);
  @$pb.TagNumber(22)
  set bbox($0.BoundingBox value) => $_setField(22, value);
  @$pb.TagNumber(22)
  $core.bool hasBbox() => $_has(14);
  @$pb.TagNumber(22)
  void clearBbox() => $_clearField(22);
  @$pb.TagNumber(22)
  $0.BoundingBox ensureBbox() => $_ensure(14);

  /// The route id from WYDOT's ESRI/GIS system. Ex: ML25B or ML2000B
  /// Without a route id, other WYDOT systems will not know how to determine which roadway the event relates to
  /// because there are cases where the same road name and milepost refer to different lat/longs.
  @$pb.TagNumber(23)
  $core.String get routeId => $_getSZ(15);
  @$pb.TagNumber(23)
  set routeId($core.String value) => $_setString(15, value);
  @$pb.TagNumber(23)
  $core.bool hasRouteId() => $_has(15);
  @$pb.TagNumber(23)
  void clearRouteId() => $_clearField(23);

  /// If included, this road_sub_event has a different schedule than the default
  /// provided in the parent Road Event.
  /// Else, refer to the parent Road Event's default_schedule for the recurrence of this road sub event
  @$pb.TagNumber(24)
  $1.EventRecurrence get schedule => $_getN(16);
  @$pb.TagNumber(24)
  set schedule($1.EventRecurrence value) => $_setField(24, value);
  @$pb.TagNumber(24)
  $core.bool hasSchedule() => $_has(16);
  @$pb.TagNumber(24)
  void clearSchedule() => $_clearField(24);
  @$pb.TagNumber(24)
  $1.EventRecurrence ensureSchedule() => $_ensure(16);

  @$pb.TagNumber(26)
  RoadSubEvent_BaseLayer get baseLayer => $_getN(17);
  @$pb.TagNumber(26)
  set baseLayer(RoadSubEvent_BaseLayer value) => $_setField(26, value);
  @$pb.TagNumber(26)
  $core.bool hasBaseLayer() => $_has(17);
  @$pb.TagNumber(26)
  void clearBaseLayer() => $_clearField(26);
  @$pb.TagNumber(26)
  RoadSubEvent_BaseLayer ensureBaseLayer() => $_ensure(17);

  @$pb.TagNumber(27)
  RoadSubEvent_SpeedReductionLayer get speedReductionLayer => $_getN(18);
  @$pb.TagNumber(27)
  set speedReductionLayer(RoadSubEvent_SpeedReductionLayer value) => $_setField(27, value);
  @$pb.TagNumber(27)
  $core.bool hasSpeedReductionLayer() => $_has(18);
  @$pb.TagNumber(27)
  void clearSpeedReductionLayer() => $_clearField(27);
  @$pb.TagNumber(27)
  RoadSubEvent_SpeedReductionLayer ensureSpeedReductionLayer() => $_ensure(18);

  @$pb.TagNumber(28)
  RoadSubEvent_WorkerPresenceLayer get workerPresenceLayer => $_getN(19);
  @$pb.TagNumber(28)
  set workerPresenceLayer(RoadSubEvent_WorkerPresenceLayer value) => $_setField(28, value);
  @$pb.TagNumber(28)
  $core.bool hasWorkerPresenceLayer() => $_has(19);
  @$pb.TagNumber(28)
  void clearWorkerPresenceLayer() => $_clearField(28);
  @$pb.TagNumber(28)
  RoadSubEvent_WorkerPresenceLayer ensureWorkerPresenceLayer() => $_ensure(19);

  @$pb.TagNumber(30)
  $pb.PbList<RoadSubEvent_RoadSubEventLink> get linkedEvents => $_getList(20);
}


const $core.bool _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
