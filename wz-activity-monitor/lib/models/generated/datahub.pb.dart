// This is a generated file - do not edit.
//
// Generated from datahub.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import 'common.pb.dart' as $4;
import 'field_device.pb.dart' as $1;
import 'google/protobuf/timestamp.pb.dart' as $0;
import 'road_event.pb.dart' as $2;
import 'road_sub_event.pb.dart' as $3;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

enum DataHubFieldDeviceUpdate_Type {
  created, 
  updated, 
  notSet
}

/// Interface Messages
class DataHubFieldDeviceUpdate extends $pb.GeneratedMessage {
  factory DataHubFieldDeviceUpdate({
    $fixnum.Int64? requestId,
    $0.Timestamp? timestamp,
    CreateFieldDevice? created,
    UpdateFieldDevice? updated,
  }) {
    final result = create();
    if (requestId != null) result.requestId = requestId;
    if (timestamp != null) result.timestamp = timestamp;
    if (created != null) result.created = created;
    if (updated != null) result.updated = updated;
    return result;
  }

  DataHubFieldDeviceUpdate._();

  factory DataHubFieldDeviceUpdate.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(data, registry);
  factory DataHubFieldDeviceUpdate.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, DataHubFieldDeviceUpdate_Type> _DataHubFieldDeviceUpdate_TypeByTag = {
    3 : DataHubFieldDeviceUpdate_Type.created,
    4 : DataHubFieldDeviceUpdate_Type.updated,
    0 : DataHubFieldDeviceUpdate_Type.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'DataHubFieldDeviceUpdate', package: const $pb.PackageName(_omitMessageNames ? '' : 'datahub.v1'), createEmptyInstance: create)
    ..oo(0, [3, 4])
    ..a<$fixnum.Int64>(1, _omitFieldNames ? '' : 'requestId', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOM<$0.Timestamp>(2, _omitFieldNames ? '' : 'timestamp', subBuilder: $0.Timestamp.create)
    ..aOM<CreateFieldDevice>(3, _omitFieldNames ? '' : 'created', subBuilder: CreateFieldDevice.create)
    ..aOM<UpdateFieldDevice>(4, _omitFieldNames ? '' : 'updated', subBuilder: UpdateFieldDevice.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DataHubFieldDeviceUpdate clone() => DataHubFieldDeviceUpdate()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DataHubFieldDeviceUpdate copyWith(void Function(DataHubFieldDeviceUpdate) updates) => super.copyWith((message) => updates(message as DataHubFieldDeviceUpdate)) as DataHubFieldDeviceUpdate;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DataHubFieldDeviceUpdate create() => DataHubFieldDeviceUpdate._();
  @$core.override
  DataHubFieldDeviceUpdate createEmptyInstance() => create();
  static $pb.PbList<DataHubFieldDeviceUpdate> createRepeated() => $pb.PbList<DataHubFieldDeviceUpdate>();
  @$core.pragma('dart2js:noInline')
  static DataHubFieldDeviceUpdate getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DataHubFieldDeviceUpdate>(create);
  static DataHubFieldDeviceUpdate? _defaultInstance;

  DataHubFieldDeviceUpdate_Type whichType() => _DataHubFieldDeviceUpdate_TypeByTag[$_whichOneof(0)]!;
  void clearType() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  $fixnum.Int64 get requestId => $_getI64(0);
  @$pb.TagNumber(1)
  set requestId($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRequestId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRequestId() => $_clearField(1);

  @$pb.TagNumber(2)
  $0.Timestamp get timestamp => $_getN(1);
  @$pb.TagNumber(2)
  set timestamp($0.Timestamp value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasTimestamp() => $_has(1);
  @$pb.TagNumber(2)
  void clearTimestamp() => $_clearField(2);
  @$pb.TagNumber(2)
  $0.Timestamp ensureTimestamp() => $_ensure(1);

  @$pb.TagNumber(3)
  CreateFieldDevice get created => $_getN(2);
  @$pb.TagNumber(3)
  set created(CreateFieldDevice value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasCreated() => $_has(2);
  @$pb.TagNumber(3)
  void clearCreated() => $_clearField(3);
  @$pb.TagNumber(3)
  CreateFieldDevice ensureCreated() => $_ensure(2);

  @$pb.TagNumber(4)
  UpdateFieldDevice get updated => $_getN(3);
  @$pb.TagNumber(4)
  set updated(UpdateFieldDevice value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasUpdated() => $_has(3);
  @$pb.TagNumber(4)
  void clearUpdated() => $_clearField(4);
  @$pb.TagNumber(4)
  UpdateFieldDevice ensureUpdated() => $_ensure(3);
}

enum DataHubRoadEventUpdate_Type {
  created, 
  updated, 
  notSet
}

class DataHubRoadEventUpdate extends $pb.GeneratedMessage {
  factory DataHubRoadEventUpdate({
    $fixnum.Int64? requestId,
    $0.Timestamp? timestamp,
    CreateRoadEvent? created,
    UpdateRoadEvent? updated,
  }) {
    final result = create();
    if (requestId != null) result.requestId = requestId;
    if (timestamp != null) result.timestamp = timestamp;
    if (created != null) result.created = created;
    if (updated != null) result.updated = updated;
    return result;
  }

  DataHubRoadEventUpdate._();

  factory DataHubRoadEventUpdate.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(data, registry);
  factory DataHubRoadEventUpdate.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, DataHubRoadEventUpdate_Type> _DataHubRoadEventUpdate_TypeByTag = {
    3 : DataHubRoadEventUpdate_Type.created,
    4 : DataHubRoadEventUpdate_Type.updated,
    0 : DataHubRoadEventUpdate_Type.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'DataHubRoadEventUpdate', package: const $pb.PackageName(_omitMessageNames ? '' : 'datahub.v1'), createEmptyInstance: create)
    ..oo(0, [3, 4])
    ..a<$fixnum.Int64>(1, _omitFieldNames ? '' : 'requestId', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOM<$0.Timestamp>(2, _omitFieldNames ? '' : 'timestamp', subBuilder: $0.Timestamp.create)
    ..aOM<CreateRoadEvent>(3, _omitFieldNames ? '' : 'created', subBuilder: CreateRoadEvent.create)
    ..aOM<UpdateRoadEvent>(4, _omitFieldNames ? '' : 'updated', subBuilder: UpdateRoadEvent.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DataHubRoadEventUpdate clone() => DataHubRoadEventUpdate()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DataHubRoadEventUpdate copyWith(void Function(DataHubRoadEventUpdate) updates) => super.copyWith((message) => updates(message as DataHubRoadEventUpdate)) as DataHubRoadEventUpdate;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DataHubRoadEventUpdate create() => DataHubRoadEventUpdate._();
  @$core.override
  DataHubRoadEventUpdate createEmptyInstance() => create();
  static $pb.PbList<DataHubRoadEventUpdate> createRepeated() => $pb.PbList<DataHubRoadEventUpdate>();
  @$core.pragma('dart2js:noInline')
  static DataHubRoadEventUpdate getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DataHubRoadEventUpdate>(create);
  static DataHubRoadEventUpdate? _defaultInstance;

  DataHubRoadEventUpdate_Type whichType() => _DataHubRoadEventUpdate_TypeByTag[$_whichOneof(0)]!;
  void clearType() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  $fixnum.Int64 get requestId => $_getI64(0);
  @$pb.TagNumber(1)
  set requestId($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasRequestId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRequestId() => $_clearField(1);

  @$pb.TagNumber(2)
  $0.Timestamp get timestamp => $_getN(1);
  @$pb.TagNumber(2)
  set timestamp($0.Timestamp value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasTimestamp() => $_has(1);
  @$pb.TagNumber(2)
  void clearTimestamp() => $_clearField(2);
  @$pb.TagNumber(2)
  $0.Timestamp ensureTimestamp() => $_ensure(1);

  @$pb.TagNumber(3)
  CreateRoadEvent get created => $_getN(2);
  @$pb.TagNumber(3)
  set created(CreateRoadEvent value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasCreated() => $_has(2);
  @$pb.TagNumber(3)
  void clearCreated() => $_clearField(3);
  @$pb.TagNumber(3)
  CreateRoadEvent ensureCreated() => $_ensure(2);

  @$pb.TagNumber(4)
  UpdateRoadEvent get updated => $_getN(3);
  @$pb.TagNumber(4)
  set updated(UpdateRoadEvent value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasUpdated() => $_has(3);
  @$pb.TagNumber(4)
  void clearUpdated() => $_clearField(4);
  @$pb.TagNumber(4)
  UpdateRoadEvent ensureUpdated() => $_ensure(3);
}

/// Action Types - not to be used outside of the Interface Types defined above.
class CreateFieldDevice extends $pb.GeneratedMessage {
  factory CreateFieldDevice({
    $1.FieldDevice? fieldDevice,
  }) {
    final result = create();
    if (fieldDevice != null) result.fieldDevice = fieldDevice;
    return result;
  }

  CreateFieldDevice._();

  factory CreateFieldDevice.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(data, registry);
  factory CreateFieldDevice.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CreateFieldDevice', package: const $pb.PackageName(_omitMessageNames ? '' : 'datahub.v1'), createEmptyInstance: create)
    ..aOM<$1.FieldDevice>(1, _omitFieldNames ? '' : 'fieldDevice', subBuilder: $1.FieldDevice.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateFieldDevice clone() => CreateFieldDevice()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateFieldDevice copyWith(void Function(CreateFieldDevice) updates) => super.copyWith((message) => updates(message as CreateFieldDevice)) as CreateFieldDevice;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CreateFieldDevice create() => CreateFieldDevice._();
  @$core.override
  CreateFieldDevice createEmptyInstance() => create();
  static $pb.PbList<CreateFieldDevice> createRepeated() => $pb.PbList<CreateFieldDevice>();
  @$core.pragma('dart2js:noInline')
  static CreateFieldDevice getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CreateFieldDevice>(create);
  static CreateFieldDevice? _defaultInstance;

  @$pb.TagNumber(1)
  $1.FieldDevice get fieldDevice => $_getN(0);
  @$pb.TagNumber(1)
  set fieldDevice($1.FieldDevice value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasFieldDevice() => $_has(0);
  @$pb.TagNumber(1)
  void clearFieldDevice() => $_clearField(1);
  @$pb.TagNumber(1)
  $1.FieldDevice ensureFieldDevice() => $_ensure(0);
}

class UpdateFieldDevice extends $pb.GeneratedMessage {
  factory UpdateFieldDevice({
    $1.FieldDevice? fieldDevice,
  }) {
    final result = create();
    if (fieldDevice != null) result.fieldDevice = fieldDevice;
    return result;
  }

  UpdateFieldDevice._();

  factory UpdateFieldDevice.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(data, registry);
  factory UpdateFieldDevice.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'UpdateFieldDevice', package: const $pb.PackageName(_omitMessageNames ? '' : 'datahub.v1'), createEmptyInstance: create)
    ..aOM<$1.FieldDevice>(1, _omitFieldNames ? '' : 'fieldDevice', subBuilder: $1.FieldDevice.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateFieldDevice clone() => UpdateFieldDevice()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateFieldDevice copyWith(void Function(UpdateFieldDevice) updates) => super.copyWith((message) => updates(message as UpdateFieldDevice)) as UpdateFieldDevice;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpdateFieldDevice create() => UpdateFieldDevice._();
  @$core.override
  UpdateFieldDevice createEmptyInstance() => create();
  static $pb.PbList<UpdateFieldDevice> createRepeated() => $pb.PbList<UpdateFieldDevice>();
  @$core.pragma('dart2js:noInline')
  static UpdateFieldDevice getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UpdateFieldDevice>(create);
  static UpdateFieldDevice? _defaultInstance;

  @$pb.TagNumber(1)
  $1.FieldDevice get fieldDevice => $_getN(0);
  @$pb.TagNumber(1)
  set fieldDevice($1.FieldDevice value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasFieldDevice() => $_has(0);
  @$pb.TagNumber(1)
  void clearFieldDevice() => $_clearField(1);
  @$pb.TagNumber(1)
  $1.FieldDevice ensureFieldDevice() => $_ensure(0);
}

class CreateRoadEvent extends $pb.GeneratedMessage {
  factory CreateRoadEvent({
    $2.RoadEvent? roadEvent,
    DataHubUpdateSource? source,
    $core.Iterable<$3.RoadSubEvent>? roadSubEvents,
  }) {
    final result = create();
    if (roadEvent != null) result.roadEvent = roadEvent;
    if (source != null) result.source = source;
    if (roadSubEvents != null) result.roadSubEvents.addAll(roadSubEvents);
    return result;
  }

  CreateRoadEvent._();

  factory CreateRoadEvent.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(data, registry);
  factory CreateRoadEvent.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'CreateRoadEvent', package: const $pb.PackageName(_omitMessageNames ? '' : 'datahub.v1'), createEmptyInstance: create)
    ..aOM<$2.RoadEvent>(1, _omitFieldNames ? '' : 'roadEvent', subBuilder: $2.RoadEvent.create)
    ..aOM<DataHubUpdateSource>(2, _omitFieldNames ? '' : 'source', subBuilder: DataHubUpdateSource.create)
    ..pc<$3.RoadSubEvent>(4, _omitFieldNames ? '' : 'roadSubEvents', $pb.PbFieldType.PM, subBuilder: $3.RoadSubEvent.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateRoadEvent clone() => CreateRoadEvent()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateRoadEvent copyWith(void Function(CreateRoadEvent) updates) => super.copyWith((message) => updates(message as CreateRoadEvent)) as CreateRoadEvent;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CreateRoadEvent create() => CreateRoadEvent._();
  @$core.override
  CreateRoadEvent createEmptyInstance() => create();
  static $pb.PbList<CreateRoadEvent> createRepeated() => $pb.PbList<CreateRoadEvent>();
  @$core.pragma('dart2js:noInline')
  static CreateRoadEvent getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<CreateRoadEvent>(create);
  static CreateRoadEvent? _defaultInstance;

  @$pb.TagNumber(1)
  $2.RoadEvent get roadEvent => $_getN(0);
  @$pb.TagNumber(1)
  set roadEvent($2.RoadEvent value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasRoadEvent() => $_has(0);
  @$pb.TagNumber(1)
  void clearRoadEvent() => $_clearField(1);
  @$pb.TagNumber(1)
  $2.RoadEvent ensureRoadEvent() => $_ensure(0);

  @$pb.TagNumber(2)
  DataHubUpdateSource get source => $_getN(1);
  @$pb.TagNumber(2)
  set source(DataHubUpdateSource value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasSource() => $_has(1);
  @$pb.TagNumber(2)
  void clearSource() => $_clearField(2);
  @$pb.TagNumber(2)
  DataHubUpdateSource ensureSource() => $_ensure(1);

  @$pb.TagNumber(4)
  $pb.PbList<$3.RoadSubEvent> get roadSubEvents => $_getList(2);
}

class UpdateRoadEvent extends $pb.GeneratedMessage {
  factory UpdateRoadEvent({
    $2.RoadEvent? roadEvent,
    DataHubUpdateSource? source,
    $core.Iterable<$3.RoadSubEvent>? roadSubEvents,
  }) {
    final result = create();
    if (roadEvent != null) result.roadEvent = roadEvent;
    if (source != null) result.source = source;
    if (roadSubEvents != null) result.roadSubEvents.addAll(roadSubEvents);
    return result;
  }

  UpdateRoadEvent._();

  factory UpdateRoadEvent.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(data, registry);
  factory UpdateRoadEvent.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'UpdateRoadEvent', package: const $pb.PackageName(_omitMessageNames ? '' : 'datahub.v1'), createEmptyInstance: create)
    ..aOM<$2.RoadEvent>(1, _omitFieldNames ? '' : 'roadEvent', subBuilder: $2.RoadEvent.create)
    ..aOM<DataHubUpdateSource>(2, _omitFieldNames ? '' : 'source', subBuilder: DataHubUpdateSource.create)
    ..pc<$3.RoadSubEvent>(6, _omitFieldNames ? '' : 'roadSubEvents', $pb.PbFieldType.PM, subBuilder: $3.RoadSubEvent.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateRoadEvent clone() => UpdateRoadEvent()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateRoadEvent copyWith(void Function(UpdateRoadEvent) updates) => super.copyWith((message) => updates(message as UpdateRoadEvent)) as UpdateRoadEvent;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpdateRoadEvent create() => UpdateRoadEvent._();
  @$core.override
  UpdateRoadEvent createEmptyInstance() => create();
  static $pb.PbList<UpdateRoadEvent> createRepeated() => $pb.PbList<UpdateRoadEvent>();
  @$core.pragma('dart2js:noInline')
  static UpdateRoadEvent getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UpdateRoadEvent>(create);
  static UpdateRoadEvent? _defaultInstance;

  @$pb.TagNumber(1)
  $2.RoadEvent get roadEvent => $_getN(0);
  @$pb.TagNumber(1)
  set roadEvent($2.RoadEvent value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasRoadEvent() => $_has(0);
  @$pb.TagNumber(1)
  void clearRoadEvent() => $_clearField(1);
  @$pb.TagNumber(1)
  $2.RoadEvent ensureRoadEvent() => $_ensure(0);

  @$pb.TagNumber(2)
  DataHubUpdateSource get source => $_getN(1);
  @$pb.TagNumber(2)
  set source(DataHubUpdateSource value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasSource() => $_has(1);
  @$pb.TagNumber(2)
  void clearSource() => $_clearField(2);
  @$pb.TagNumber(2)
  DataHubUpdateSource ensureSource() => $_ensure(1);

  @$pb.TagNumber(6)
  $pb.PbList<$3.RoadSubEvent> get roadSubEvents => $_getList(2);
}

/// Data Types
class ReportSummary extends $pb.GeneratedMessage {
  factory ReportSummary({
    $fixnum.Int64? id,
    $core.String? name,
    $core.String? description,
    $0.Timestamp? timestamp,
    $4.ContactInfo? contactInfo,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (name != null) result.name = name;
    if (description != null) result.description = description;
    if (timestamp != null) result.timestamp = timestamp;
    if (contactInfo != null) result.contactInfo = contactInfo;
    return result;
  }

  ReportSummary._();

  factory ReportSummary.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(data, registry);
  factory ReportSummary.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ReportSummary', package: const $pb.PackageName(_omitMessageNames ? '' : 'datahub.v1'), createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, _omitFieldNames ? '' : 'id', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aOS(3, _omitFieldNames ? '' : 'description')
    ..aOM<$0.Timestamp>(4, _omitFieldNames ? '' : 'timestamp', subBuilder: $0.Timestamp.create)
    ..aOM<$4.ContactInfo>(7, _omitFieldNames ? '' : 'contactInfo', subBuilder: $4.ContactInfo.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReportSummary clone() => ReportSummary()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ReportSummary copyWith(void Function(ReportSummary) updates) => super.copyWith((message) => updates(message as ReportSummary)) as ReportSummary;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ReportSummary create() => ReportSummary._();
  @$core.override
  ReportSummary createEmptyInstance() => create();
  static $pb.PbList<ReportSummary> createRepeated() => $pb.PbList<ReportSummary>();
  @$core.pragma('dart2js:noInline')
  static ReportSummary getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ReportSummary>(create);
  static ReportSummary? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get id => $_getI64(0);
  @$pb.TagNumber(1)
  set id($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get description => $_getSZ(2);
  @$pb.TagNumber(3)
  set description($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDescription() => $_has(2);
  @$pb.TagNumber(3)
  void clearDescription() => $_clearField(3);

  @$pb.TagNumber(4)
  $0.Timestamp get timestamp => $_getN(3);
  @$pb.TagNumber(4)
  set timestamp($0.Timestamp value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasTimestamp() => $_has(3);
  @$pb.TagNumber(4)
  void clearTimestamp() => $_clearField(4);
  @$pb.TagNumber(4)
  $0.Timestamp ensureTimestamp() => $_ensure(3);

  @$pb.TagNumber(7)
  $4.ContactInfo get contactInfo => $_getN(4);
  @$pb.TagNumber(7)
  set contactInfo($4.ContactInfo value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasContactInfo() => $_has(4);
  @$pb.TagNumber(7)
  void clearContactInfo() => $_clearField(7);
  @$pb.TagNumber(7)
  $4.ContactInfo ensureContactInfo() => $_ensure(4);
}

class RecordingSummary extends $pb.GeneratedMessage {
  factory RecordingSummary({
    $fixnum.Int64? id,
    $core.String? name,
    $core.String? description,
    $0.Timestamp? timestamp,
    $core.double? lengthMeters,
    $core.double? positionAccuracyMeters,
    $4.ContactInfo? contactInfo,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (name != null) result.name = name;
    if (description != null) result.description = description;
    if (timestamp != null) result.timestamp = timestamp;
    if (lengthMeters != null) result.lengthMeters = lengthMeters;
    if (positionAccuracyMeters != null) result.positionAccuracyMeters = positionAccuracyMeters;
    if (contactInfo != null) result.contactInfo = contactInfo;
    return result;
  }

  RecordingSummary._();

  factory RecordingSummary.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(data, registry);
  factory RecordingSummary.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'RecordingSummary', package: const $pb.PackageName(_omitMessageNames ? '' : 'datahub.v1'), createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, _omitFieldNames ? '' : 'id', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aOS(3, _omitFieldNames ? '' : 'description')
    ..aOM<$0.Timestamp>(4, _omitFieldNames ? '' : 'timestamp', subBuilder: $0.Timestamp.create)
    ..a<$core.double>(5, _omitFieldNames ? '' : 'lengthMeters', $pb.PbFieldType.OD)
    ..a<$core.double>(6, _omitFieldNames ? '' : 'positionAccuracyMeters', $pb.PbFieldType.OD)
    ..aOM<$4.ContactInfo>(7, _omitFieldNames ? '' : 'contactInfo', subBuilder: $4.ContactInfo.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordingSummary clone() => RecordingSummary()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RecordingSummary copyWith(void Function(RecordingSummary) updates) => super.copyWith((message) => updates(message as RecordingSummary)) as RecordingSummary;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RecordingSummary create() => RecordingSummary._();
  @$core.override
  RecordingSummary createEmptyInstance() => create();
  static $pb.PbList<RecordingSummary> createRepeated() => $pb.PbList<RecordingSummary>();
  @$core.pragma('dart2js:noInline')
  static RecordingSummary getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RecordingSummary>(create);
  static RecordingSummary? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get id => $_getI64(0);
  @$pb.TagNumber(1)
  set id($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get description => $_getSZ(2);
  @$pb.TagNumber(3)
  set description($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDescription() => $_has(2);
  @$pb.TagNumber(3)
  void clearDescription() => $_clearField(3);

  @$pb.TagNumber(4)
  $0.Timestamp get timestamp => $_getN(3);
  @$pb.TagNumber(4)
  set timestamp($0.Timestamp value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasTimestamp() => $_has(3);
  @$pb.TagNumber(4)
  void clearTimestamp() => $_clearField(4);
  @$pb.TagNumber(4)
  $0.Timestamp ensureTimestamp() => $_ensure(3);

  @$pb.TagNumber(5)
  $core.double get lengthMeters => $_getN(4);
  @$pb.TagNumber(5)
  set lengthMeters($core.double value) => $_setDouble(4, value);
  @$pb.TagNumber(5)
  $core.bool hasLengthMeters() => $_has(4);
  @$pb.TagNumber(5)
  void clearLengthMeters() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.double get positionAccuracyMeters => $_getN(5);
  @$pb.TagNumber(6)
  set positionAccuracyMeters($core.double value) => $_setDouble(5, value);
  @$pb.TagNumber(6)
  $core.bool hasPositionAccuracyMeters() => $_has(5);
  @$pb.TagNumber(6)
  void clearPositionAccuracyMeters() => $_clearField(6);

  @$pb.TagNumber(7)
  $4.ContactInfo get contactInfo => $_getN(6);
  @$pb.TagNumber(7)
  set contactInfo($4.ContactInfo value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasContactInfo() => $_has(6);
  @$pb.TagNumber(7)
  void clearContactInfo() => $_clearField(7);
  @$pb.TagNumber(7)
  $4.ContactInfo ensureContactInfo() => $_ensure(6);
}

class FieldDeviceSummaryArray extends $pb.GeneratedMessage {
  factory FieldDeviceSummaryArray({
    $core.Iterable<FieldDeviceSummary>? fieldDeviceSummary,
  }) {
    final result = create();
    if (fieldDeviceSummary != null) result.fieldDeviceSummary.addAll(fieldDeviceSummary);
    return result;
  }

  FieldDeviceSummaryArray._();

  factory FieldDeviceSummaryArray.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(data, registry);
  factory FieldDeviceSummaryArray.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'FieldDeviceSummaryArray', package: const $pb.PackageName(_omitMessageNames ? '' : 'datahub.v1'), createEmptyInstance: create)
    ..pc<FieldDeviceSummary>(1, _omitFieldNames ? '' : 'fieldDeviceSummary', $pb.PbFieldType.PM, subBuilder: FieldDeviceSummary.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FieldDeviceSummaryArray clone() => FieldDeviceSummaryArray()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FieldDeviceSummaryArray copyWith(void Function(FieldDeviceSummaryArray) updates) => super.copyWith((message) => updates(message as FieldDeviceSummaryArray)) as FieldDeviceSummaryArray;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FieldDeviceSummaryArray create() => FieldDeviceSummaryArray._();
  @$core.override
  FieldDeviceSummaryArray createEmptyInstance() => create();
  static $pb.PbList<FieldDeviceSummaryArray> createRepeated() => $pb.PbList<FieldDeviceSummaryArray>();
  @$core.pragma('dart2js:noInline')
  static FieldDeviceSummaryArray getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<FieldDeviceSummaryArray>(create);
  static FieldDeviceSummaryArray? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<FieldDeviceSummary> get fieldDeviceSummary => $_getList(0);
}

class FieldDeviceSummary extends $pb.GeneratedMessage {
  factory FieldDeviceSummary({
    $fixnum.Int64? id,
    $1.FieldDevice? device,
    $0.Timestamp? updateDate,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (device != null) result.device = device;
    if (updateDate != null) result.updateDate = updateDate;
    return result;
  }

  FieldDeviceSummary._();

  factory FieldDeviceSummary.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(data, registry);
  factory FieldDeviceSummary.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'FieldDeviceSummary', package: const $pb.PackageName(_omitMessageNames ? '' : 'datahub.v1'), createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, _omitFieldNames ? '' : 'id', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOM<$1.FieldDevice>(2, _omitFieldNames ? '' : 'device', subBuilder: $1.FieldDevice.create)
    ..aOM<$0.Timestamp>(3, _omitFieldNames ? '' : 'updateDate', subBuilder: $0.Timestamp.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FieldDeviceSummary clone() => FieldDeviceSummary()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FieldDeviceSummary copyWith(void Function(FieldDeviceSummary) updates) => super.copyWith((message) => updates(message as FieldDeviceSummary)) as FieldDeviceSummary;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FieldDeviceSummary create() => FieldDeviceSummary._();
  @$core.override
  FieldDeviceSummary createEmptyInstance() => create();
  static $pb.PbList<FieldDeviceSummary> createRepeated() => $pb.PbList<FieldDeviceSummary>();
  @$core.pragma('dart2js:noInline')
  static FieldDeviceSummary getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<FieldDeviceSummary>(create);
  static FieldDeviceSummary? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get id => $_getI64(0);
  @$pb.TagNumber(1)
  set id($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $1.FieldDevice get device => $_getN(1);
  @$pb.TagNumber(2)
  set device($1.FieldDevice value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasDevice() => $_has(1);
  @$pb.TagNumber(2)
  void clearDevice() => $_clearField(2);
  @$pb.TagNumber(2)
  $1.FieldDevice ensureDevice() => $_ensure(1);

  @$pb.TagNumber(3)
  $0.Timestamp get updateDate => $_getN(2);
  @$pb.TagNumber(3)
  set updateDate($0.Timestamp value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasUpdateDate() => $_has(2);
  @$pb.TagNumber(3)
  void clearUpdateDate() => $_clearField(3);
  @$pb.TagNumber(3)
  $0.Timestamp ensureUpdateDate() => $_ensure(2);
}

enum DataHubUpdateSource_Source {
  reportSummary, 
  recordingSummary, 
  fieldDeviceSummaries, 
  notSet
}

class DataHubUpdateSource extends $pb.GeneratedMessage {
  factory DataHubUpdateSource({
    ReportSummary? reportSummary,
    RecordingSummary? recordingSummary,
    FieldDeviceSummaryArray? fieldDeviceSummaries,
  }) {
    final result = create();
    if (reportSummary != null) result.reportSummary = reportSummary;
    if (recordingSummary != null) result.recordingSummary = recordingSummary;
    if (fieldDeviceSummaries != null) result.fieldDeviceSummaries = fieldDeviceSummaries;
    return result;
  }

  DataHubUpdateSource._();

  factory DataHubUpdateSource.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(data, registry);
  factory DataHubUpdateSource.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, DataHubUpdateSource_Source> _DataHubUpdateSource_SourceByTag = {
    1 : DataHubUpdateSource_Source.reportSummary,
    2 : DataHubUpdateSource_Source.recordingSummary,
    3 : DataHubUpdateSource_Source.fieldDeviceSummaries,
    0 : DataHubUpdateSource_Source.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'DataHubUpdateSource', package: const $pb.PackageName(_omitMessageNames ? '' : 'datahub.v1'), createEmptyInstance: create)
    ..oo(0, [1, 2, 3])
    ..aOM<ReportSummary>(1, _omitFieldNames ? '' : 'reportSummary', subBuilder: ReportSummary.create)
    ..aOM<RecordingSummary>(2, _omitFieldNames ? '' : 'recordingSummary', subBuilder: RecordingSummary.create)
    ..aOM<FieldDeviceSummaryArray>(3, _omitFieldNames ? '' : 'fieldDeviceSummaries', subBuilder: FieldDeviceSummaryArray.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DataHubUpdateSource clone() => DataHubUpdateSource()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DataHubUpdateSource copyWith(void Function(DataHubUpdateSource) updates) => super.copyWith((message) => updates(message as DataHubUpdateSource)) as DataHubUpdateSource;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DataHubUpdateSource create() => DataHubUpdateSource._();
  @$core.override
  DataHubUpdateSource createEmptyInstance() => create();
  static $pb.PbList<DataHubUpdateSource> createRepeated() => $pb.PbList<DataHubUpdateSource>();
  @$core.pragma('dart2js:noInline')
  static DataHubUpdateSource getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DataHubUpdateSource>(create);
  static DataHubUpdateSource? _defaultInstance;

  DataHubUpdateSource_Source whichSource() => _DataHubUpdateSource_SourceByTag[$_whichOneof(0)]!;
  void clearSource() => $_clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  ReportSummary get reportSummary => $_getN(0);
  @$pb.TagNumber(1)
  set reportSummary(ReportSummary value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasReportSummary() => $_has(0);
  @$pb.TagNumber(1)
  void clearReportSummary() => $_clearField(1);
  @$pb.TagNumber(1)
  ReportSummary ensureReportSummary() => $_ensure(0);

  @$pb.TagNumber(2)
  RecordingSummary get recordingSummary => $_getN(1);
  @$pb.TagNumber(2)
  set recordingSummary(RecordingSummary value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasRecordingSummary() => $_has(1);
  @$pb.TagNumber(2)
  void clearRecordingSummary() => $_clearField(2);
  @$pb.TagNumber(2)
  RecordingSummary ensureRecordingSummary() => $_ensure(1);

  @$pb.TagNumber(3)
  FieldDeviceSummaryArray get fieldDeviceSummaries => $_getN(2);
  @$pb.TagNumber(3)
  set fieldDeviceSummaries(FieldDeviceSummaryArray value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasFieldDeviceSummaries() => $_has(2);
  @$pb.TagNumber(3)
  void clearFieldDeviceSummaries() => $_clearField(3);
  @$pb.TagNumber(3)
  FieldDeviceSummaryArray ensureFieldDeviceSummaries() => $_ensure(2);
}


const $core.bool _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
