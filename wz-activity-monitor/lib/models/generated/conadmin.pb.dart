// This is a generated file - do not edit.
//
// Generated from conadmin.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import 'datahub.pb.dart' as $1;
import 'google/protobuf/timestamp.pb.dart' as $0;
import 'project.pb.dart' as $2;
import 'road_event.pb.dart' as $3;
import 'road_sub_event.pb.dart' as $4;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

enum ConAdminFieldDeviceUpdate_Type {
  updated, 
  notSet
}

/// Interface Messages
class ConAdminFieldDeviceUpdate extends $pb.GeneratedMessage {
  factory ConAdminFieldDeviceUpdate({
    $fixnum.Int64? requestId,
    $0.Timestamp? timestamp,
    $1.UpdateFieldDevice? updated,
  }) {
    final result = create();
    if (requestId != null) result.requestId = requestId;
    if (timestamp != null) result.timestamp = timestamp;
    if (updated != null) result.updated = updated;
    return result;
  }

  ConAdminFieldDeviceUpdate._();

  factory ConAdminFieldDeviceUpdate.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(data, registry);
  factory ConAdminFieldDeviceUpdate.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, ConAdminFieldDeviceUpdate_Type> _ConAdminFieldDeviceUpdate_TypeByTag = {
    4 : ConAdminFieldDeviceUpdate_Type.updated,
    0 : ConAdminFieldDeviceUpdate_Type.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ConAdminFieldDeviceUpdate', package: const $pb.PackageName(_omitMessageNames ? '' : 'datahub.v1'), createEmptyInstance: create)
    ..oo(0, [4])
    ..a<$fixnum.Int64>(1, _omitFieldNames ? '' : 'requestId', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOM<$0.Timestamp>(2, _omitFieldNames ? '' : 'timestamp', subBuilder: $0.Timestamp.create)
    ..aOM<$1.UpdateFieldDevice>(4, _omitFieldNames ? '' : 'updated', subBuilder: $1.UpdateFieldDevice.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ConAdminFieldDeviceUpdate clone() => ConAdminFieldDeviceUpdate()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ConAdminFieldDeviceUpdate copyWith(void Function(ConAdminFieldDeviceUpdate) updates) => super.copyWith((message) => updates(message as ConAdminFieldDeviceUpdate)) as ConAdminFieldDeviceUpdate;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ConAdminFieldDeviceUpdate create() => ConAdminFieldDeviceUpdate._();
  @$core.override
  ConAdminFieldDeviceUpdate createEmptyInstance() => create();
  static $pb.PbList<ConAdminFieldDeviceUpdate> createRepeated() => $pb.PbList<ConAdminFieldDeviceUpdate>();
  @$core.pragma('dart2js:noInline')
  static ConAdminFieldDeviceUpdate getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ConAdminFieldDeviceUpdate>(create);
  static ConAdminFieldDeviceUpdate? _defaultInstance;

  ConAdminFieldDeviceUpdate_Type whichType() => _ConAdminFieldDeviceUpdate_TypeByTag[$_whichOneof(0)]!;
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

  @$pb.TagNumber(4)
  $1.UpdateFieldDevice get updated => $_getN(2);
  @$pb.TagNumber(4)
  set updated($1.UpdateFieldDevice value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasUpdated() => $_has(2);
  @$pb.TagNumber(4)
  void clearUpdated() => $_clearField(4);
  @$pb.TagNumber(4)
  $1.UpdateFieldDevice ensureUpdated() => $_ensure(2);
}

enum ConAdminProjectUpdate_Type {
  created, 
  updated, 
  removed, 
  notSet
}

class ConAdminProjectUpdate extends $pb.GeneratedMessage {
  factory ConAdminProjectUpdate({
    $fixnum.Int64? requestId,
    $0.Timestamp? timestamp,
    ProjectCreated? created,
    ProjectUpdated? updated,
    ProjectRemoved? removed,
  }) {
    final result = create();
    if (requestId != null) result.requestId = requestId;
    if (timestamp != null) result.timestamp = timestamp;
    if (created != null) result.created = created;
    if (updated != null) result.updated = updated;
    if (removed != null) result.removed = removed;
    return result;
  }

  ConAdminProjectUpdate._();

  factory ConAdminProjectUpdate.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(data, registry);
  factory ConAdminProjectUpdate.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, ConAdminProjectUpdate_Type> _ConAdminProjectUpdate_TypeByTag = {
    3 : ConAdminProjectUpdate_Type.created,
    4 : ConAdminProjectUpdate_Type.updated,
    5 : ConAdminProjectUpdate_Type.removed,
    0 : ConAdminProjectUpdate_Type.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ConAdminProjectUpdate', package: const $pb.PackageName(_omitMessageNames ? '' : 'datahub.v1'), createEmptyInstance: create)
    ..oo(0, [3, 4, 5])
    ..a<$fixnum.Int64>(1, _omitFieldNames ? '' : 'requestId', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOM<$0.Timestamp>(2, _omitFieldNames ? '' : 'timestamp', subBuilder: $0.Timestamp.create)
    ..aOM<ProjectCreated>(3, _omitFieldNames ? '' : 'created', subBuilder: ProjectCreated.create)
    ..aOM<ProjectUpdated>(4, _omitFieldNames ? '' : 'updated', subBuilder: ProjectUpdated.create)
    ..aOM<ProjectRemoved>(5, _omitFieldNames ? '' : 'removed', subBuilder: ProjectRemoved.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ConAdminProjectUpdate clone() => ConAdminProjectUpdate()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ConAdminProjectUpdate copyWith(void Function(ConAdminProjectUpdate) updates) => super.copyWith((message) => updates(message as ConAdminProjectUpdate)) as ConAdminProjectUpdate;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ConAdminProjectUpdate create() => ConAdminProjectUpdate._();
  @$core.override
  ConAdminProjectUpdate createEmptyInstance() => create();
  static $pb.PbList<ConAdminProjectUpdate> createRepeated() => $pb.PbList<ConAdminProjectUpdate>();
  @$core.pragma('dart2js:noInline')
  static ConAdminProjectUpdate getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ConAdminProjectUpdate>(create);
  static ConAdminProjectUpdate? _defaultInstance;

  ConAdminProjectUpdate_Type whichType() => _ConAdminProjectUpdate_TypeByTag[$_whichOneof(0)]!;
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
  ProjectCreated get created => $_getN(2);
  @$pb.TagNumber(3)
  set created(ProjectCreated value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasCreated() => $_has(2);
  @$pb.TagNumber(3)
  void clearCreated() => $_clearField(3);
  @$pb.TagNumber(3)
  ProjectCreated ensureCreated() => $_ensure(2);

  @$pb.TagNumber(4)
  ProjectUpdated get updated => $_getN(3);
  @$pb.TagNumber(4)
  set updated(ProjectUpdated value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasUpdated() => $_has(3);
  @$pb.TagNumber(4)
  void clearUpdated() => $_clearField(4);
  @$pb.TagNumber(4)
  ProjectUpdated ensureUpdated() => $_ensure(3);

  @$pb.TagNumber(5)
  ProjectRemoved get removed => $_getN(4);
  @$pb.TagNumber(5)
  set removed(ProjectRemoved value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasRemoved() => $_has(4);
  @$pb.TagNumber(5)
  void clearRemoved() => $_clearField(5);
  @$pb.TagNumber(5)
  ProjectRemoved ensureRemoved() => $_ensure(4);
}

enum ConAdminRoadEventUpdate_Type {
  created, 
  updated, 
  removed, 
  notSet
}

class ConAdminRoadEventUpdate extends $pb.GeneratedMessage {
  factory ConAdminRoadEventUpdate({
    $fixnum.Int64? requestId,
    $0.Timestamp? timestamp,
    RoadEventCreated? created,
    RoadEventUpdated? updated,
    RoadEventRemoved? removed,
  }) {
    final result = create();
    if (requestId != null) result.requestId = requestId;
    if (timestamp != null) result.timestamp = timestamp;
    if (created != null) result.created = created;
    if (updated != null) result.updated = updated;
    if (removed != null) result.removed = removed;
    return result;
  }

  ConAdminRoadEventUpdate._();

  factory ConAdminRoadEventUpdate.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(data, registry);
  factory ConAdminRoadEventUpdate.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, ConAdminRoadEventUpdate_Type> _ConAdminRoadEventUpdate_TypeByTag = {
    3 : ConAdminRoadEventUpdate_Type.created,
    4 : ConAdminRoadEventUpdate_Type.updated,
    5 : ConAdminRoadEventUpdate_Type.removed,
    0 : ConAdminRoadEventUpdate_Type.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ConAdminRoadEventUpdate', package: const $pb.PackageName(_omitMessageNames ? '' : 'datahub.v1'), createEmptyInstance: create)
    ..oo(0, [3, 4, 5])
    ..a<$fixnum.Int64>(1, _omitFieldNames ? '' : 'requestId', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOM<$0.Timestamp>(2, _omitFieldNames ? '' : 'timestamp', subBuilder: $0.Timestamp.create)
    ..aOM<RoadEventCreated>(3, _omitFieldNames ? '' : 'created', subBuilder: RoadEventCreated.create)
    ..aOM<RoadEventUpdated>(4, _omitFieldNames ? '' : 'updated', subBuilder: RoadEventUpdated.create)
    ..aOM<RoadEventRemoved>(5, _omitFieldNames ? '' : 'removed', subBuilder: RoadEventRemoved.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ConAdminRoadEventUpdate clone() => ConAdminRoadEventUpdate()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ConAdminRoadEventUpdate copyWith(void Function(ConAdminRoadEventUpdate) updates) => super.copyWith((message) => updates(message as ConAdminRoadEventUpdate)) as ConAdminRoadEventUpdate;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ConAdminRoadEventUpdate create() => ConAdminRoadEventUpdate._();
  @$core.override
  ConAdminRoadEventUpdate createEmptyInstance() => create();
  static $pb.PbList<ConAdminRoadEventUpdate> createRepeated() => $pb.PbList<ConAdminRoadEventUpdate>();
  @$core.pragma('dart2js:noInline')
  static ConAdminRoadEventUpdate getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ConAdminRoadEventUpdate>(create);
  static ConAdminRoadEventUpdate? _defaultInstance;

  ConAdminRoadEventUpdate_Type whichType() => _ConAdminRoadEventUpdate_TypeByTag[$_whichOneof(0)]!;
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
  RoadEventCreated get created => $_getN(2);
  @$pb.TagNumber(3)
  set created(RoadEventCreated value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasCreated() => $_has(2);
  @$pb.TagNumber(3)
  void clearCreated() => $_clearField(3);
  @$pb.TagNumber(3)
  RoadEventCreated ensureCreated() => $_ensure(2);

  @$pb.TagNumber(4)
  RoadEventUpdated get updated => $_getN(3);
  @$pb.TagNumber(4)
  set updated(RoadEventUpdated value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasUpdated() => $_has(3);
  @$pb.TagNumber(4)
  void clearUpdated() => $_clearField(4);
  @$pb.TagNumber(4)
  RoadEventUpdated ensureUpdated() => $_ensure(3);

  @$pb.TagNumber(5)
  RoadEventRemoved get removed => $_getN(4);
  @$pb.TagNumber(5)
  set removed(RoadEventRemoved value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasRemoved() => $_has(4);
  @$pb.TagNumber(5)
  void clearRemoved() => $_clearField(5);
  @$pb.TagNumber(5)
  RoadEventRemoved ensureRemoved() => $_ensure(4);
}

enum ConAdminRoadEventApproval_Type {
  approved, 
  rejected, 
  notSet
}

/// This message is used to indicate to the Datahub whether the original DataHubRoadEventUpdate message
/// was approved or rejected by the TMC Operator when reviewed in the ConAdmin UI.
class ConAdminRoadEventApproval extends $pb.GeneratedMessage {
  factory ConAdminRoadEventApproval({
    $fixnum.Int64? requestId,
    $0.Timestamp? timestamp,
    RoadEventUpdateApproved? approved,
    RoadEventUpdateRejected? rejected,
  }) {
    final result = create();
    if (requestId != null) result.requestId = requestId;
    if (timestamp != null) result.timestamp = timestamp;
    if (approved != null) result.approved = approved;
    if (rejected != null) result.rejected = rejected;
    return result;
  }

  ConAdminRoadEventApproval._();

  factory ConAdminRoadEventApproval.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(data, registry);
  factory ConAdminRoadEventApproval.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(json, registry);

  static const $core.Map<$core.int, ConAdminRoadEventApproval_Type> _ConAdminRoadEventApproval_TypeByTag = {
    3 : ConAdminRoadEventApproval_Type.approved,
    4 : ConAdminRoadEventApproval_Type.rejected,
    0 : ConAdminRoadEventApproval_Type.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ConAdminRoadEventApproval', package: const $pb.PackageName(_omitMessageNames ? '' : 'datahub.v1'), createEmptyInstance: create)
    ..oo(0, [3, 4])
    ..a<$fixnum.Int64>(1, _omitFieldNames ? '' : 'requestId', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOM<$0.Timestamp>(2, _omitFieldNames ? '' : 'timestamp', subBuilder: $0.Timestamp.create)
    ..aOM<RoadEventUpdateApproved>(3, _omitFieldNames ? '' : 'approved', subBuilder: RoadEventUpdateApproved.create)
    ..aOM<RoadEventUpdateRejected>(4, _omitFieldNames ? '' : 'rejected', subBuilder: RoadEventUpdateRejected.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ConAdminRoadEventApproval clone() => ConAdminRoadEventApproval()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ConAdminRoadEventApproval copyWith(void Function(ConAdminRoadEventApproval) updates) => super.copyWith((message) => updates(message as ConAdminRoadEventApproval)) as ConAdminRoadEventApproval;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ConAdminRoadEventApproval create() => ConAdminRoadEventApproval._();
  @$core.override
  ConAdminRoadEventApproval createEmptyInstance() => create();
  static $pb.PbList<ConAdminRoadEventApproval> createRepeated() => $pb.PbList<ConAdminRoadEventApproval>();
  @$core.pragma('dart2js:noInline')
  static ConAdminRoadEventApproval getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ConAdminRoadEventApproval>(create);
  static ConAdminRoadEventApproval? _defaultInstance;

  ConAdminRoadEventApproval_Type whichType() => _ConAdminRoadEventApproval_TypeByTag[$_whichOneof(0)]!;
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
  RoadEventUpdateApproved get approved => $_getN(2);
  @$pb.TagNumber(3)
  set approved(RoadEventUpdateApproved value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasApproved() => $_has(2);
  @$pb.TagNumber(3)
  void clearApproved() => $_clearField(3);
  @$pb.TagNumber(3)
  RoadEventUpdateApproved ensureApproved() => $_ensure(2);

  @$pb.TagNumber(4)
  RoadEventUpdateRejected get rejected => $_getN(3);
  @$pb.TagNumber(4)
  set rejected(RoadEventUpdateRejected value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasRejected() => $_has(3);
  @$pb.TagNumber(4)
  void clearRejected() => $_clearField(4);
  @$pb.TagNumber(4)
  RoadEventUpdateRejected ensureRejected() => $_ensure(3);
}

/// Action Types - not to be used outside of the Interface Types defined above.
class ProjectCreated extends $pb.GeneratedMessage {
  factory ProjectCreated({
    $2.Project? project,
  }) {
    final result = create();
    if (project != null) result.project = project;
    return result;
  }

  ProjectCreated._();

  factory ProjectCreated.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(data, registry);
  factory ProjectCreated.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ProjectCreated', package: const $pb.PackageName(_omitMessageNames ? '' : 'datahub.v1'), createEmptyInstance: create)
    ..aOM<$2.Project>(1, _omitFieldNames ? '' : 'project', subBuilder: $2.Project.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ProjectCreated clone() => ProjectCreated()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ProjectCreated copyWith(void Function(ProjectCreated) updates) => super.copyWith((message) => updates(message as ProjectCreated)) as ProjectCreated;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ProjectCreated create() => ProjectCreated._();
  @$core.override
  ProjectCreated createEmptyInstance() => create();
  static $pb.PbList<ProjectCreated> createRepeated() => $pb.PbList<ProjectCreated>();
  @$core.pragma('dart2js:noInline')
  static ProjectCreated getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ProjectCreated>(create);
  static ProjectCreated? _defaultInstance;

  @$pb.TagNumber(1)
  $2.Project get project => $_getN(0);
  @$pb.TagNumber(1)
  set project($2.Project value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasProject() => $_has(0);
  @$pb.TagNumber(1)
  void clearProject() => $_clearField(1);
  @$pb.TagNumber(1)
  $2.Project ensureProject() => $_ensure(0);
}

class ProjectUpdated extends $pb.GeneratedMessage {
  factory ProjectUpdated({
    $2.Project? project,
  }) {
    final result = create();
    if (project != null) result.project = project;
    return result;
  }

  ProjectUpdated._();

  factory ProjectUpdated.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(data, registry);
  factory ProjectUpdated.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ProjectUpdated', package: const $pb.PackageName(_omitMessageNames ? '' : 'datahub.v1'), createEmptyInstance: create)
    ..aOM<$2.Project>(1, _omitFieldNames ? '' : 'project', subBuilder: $2.Project.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ProjectUpdated clone() => ProjectUpdated()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ProjectUpdated copyWith(void Function(ProjectUpdated) updates) => super.copyWith((message) => updates(message as ProjectUpdated)) as ProjectUpdated;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ProjectUpdated create() => ProjectUpdated._();
  @$core.override
  ProjectUpdated createEmptyInstance() => create();
  static $pb.PbList<ProjectUpdated> createRepeated() => $pb.PbList<ProjectUpdated>();
  @$core.pragma('dart2js:noInline')
  static ProjectUpdated getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ProjectUpdated>(create);
  static ProjectUpdated? _defaultInstance;

  @$pb.TagNumber(1)
  $2.Project get project => $_getN(0);
  @$pb.TagNumber(1)
  set project($2.Project value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasProject() => $_has(0);
  @$pb.TagNumber(1)
  void clearProject() => $_clearField(1);
  @$pb.TagNumber(1)
  $2.Project ensureProject() => $_ensure(0);
}

class ProjectRemoved extends $pb.GeneratedMessage {
  factory ProjectRemoved({
    $fixnum.Int64? projectId,
  }) {
    final result = create();
    if (projectId != null) result.projectId = projectId;
    return result;
  }

  ProjectRemoved._();

  factory ProjectRemoved.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(data, registry);
  factory ProjectRemoved.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ProjectRemoved', package: const $pb.PackageName(_omitMessageNames ? '' : 'datahub.v1'), createEmptyInstance: create)
    ..a<$fixnum.Int64>(2, _omitFieldNames ? '' : 'projectId', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ProjectRemoved clone() => ProjectRemoved()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ProjectRemoved copyWith(void Function(ProjectRemoved) updates) => super.copyWith((message) => updates(message as ProjectRemoved)) as ProjectRemoved;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ProjectRemoved create() => ProjectRemoved._();
  @$core.override
  ProjectRemoved createEmptyInstance() => create();
  static $pb.PbList<ProjectRemoved> createRepeated() => $pb.PbList<ProjectRemoved>();
  @$core.pragma('dart2js:noInline')
  static ProjectRemoved getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ProjectRemoved>(create);
  static ProjectRemoved? _defaultInstance;

  @$pb.TagNumber(2)
  $fixnum.Int64 get projectId => $_getI64(0);
  @$pb.TagNumber(2)
  set projectId($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(2)
  $core.bool hasProjectId() => $_has(0);
  @$pb.TagNumber(2)
  void clearProjectId() => $_clearField(2);
}

/// Indicates that a RoadEvent was created via the ConAdmin UI
class RoadEventCreated extends $pb.GeneratedMessage {
  factory RoadEventCreated({
    $3.RoadEvent? roadEvent,
    $core.Iterable<$4.RoadSubEvent>? roadSubEvents,
  }) {
    final result = create();
    if (roadEvent != null) result.roadEvent = roadEvent;
    if (roadSubEvents != null) result.roadSubEvents.addAll(roadSubEvents);
    return result;
  }

  RoadEventCreated._();

  factory RoadEventCreated.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(data, registry);
  factory RoadEventCreated.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'RoadEventCreated', package: const $pb.PackageName(_omitMessageNames ? '' : 'datahub.v1'), createEmptyInstance: create)
    ..aOM<$3.RoadEvent>(1, _omitFieldNames ? '' : 'roadEvent', subBuilder: $3.RoadEvent.create)
    ..pc<$4.RoadSubEvent>(3, _omitFieldNames ? '' : 'roadSubEvents', $pb.PbFieldType.PM, subBuilder: $4.RoadSubEvent.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RoadEventCreated clone() => RoadEventCreated()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RoadEventCreated copyWith(void Function(RoadEventCreated) updates) => super.copyWith((message) => updates(message as RoadEventCreated)) as RoadEventCreated;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RoadEventCreated create() => RoadEventCreated._();
  @$core.override
  RoadEventCreated createEmptyInstance() => create();
  static $pb.PbList<RoadEventCreated> createRepeated() => $pb.PbList<RoadEventCreated>();
  @$core.pragma('dart2js:noInline')
  static RoadEventCreated getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RoadEventCreated>(create);
  static RoadEventCreated? _defaultInstance;

  @$pb.TagNumber(1)
  $3.RoadEvent get roadEvent => $_getN(0);
  @$pb.TagNumber(1)
  set roadEvent($3.RoadEvent value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasRoadEvent() => $_has(0);
  @$pb.TagNumber(1)
  void clearRoadEvent() => $_clearField(1);
  @$pb.TagNumber(1)
  $3.RoadEvent ensureRoadEvent() => $_ensure(0);

  @$pb.TagNumber(3)
  $pb.PbList<$4.RoadSubEvent> get roadSubEvents => $_getList(1);
}

/// Indicates that a RoadEvent was updated via the ConAdmin UI
class RoadEventUpdated extends $pb.GeneratedMessage {
  factory RoadEventUpdated({
    $3.RoadEvent? roadEvent,
    $core.Iterable<$4.RoadSubEvent>? roadSubEvents,
  }) {
    final result = create();
    if (roadEvent != null) result.roadEvent = roadEvent;
    if (roadSubEvents != null) result.roadSubEvents.addAll(roadSubEvents);
    return result;
  }

  RoadEventUpdated._();

  factory RoadEventUpdated.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(data, registry);
  factory RoadEventUpdated.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'RoadEventUpdated', package: const $pb.PackageName(_omitMessageNames ? '' : 'datahub.v1'), createEmptyInstance: create)
    ..aOM<$3.RoadEvent>(1, _omitFieldNames ? '' : 'roadEvent', subBuilder: $3.RoadEvent.create)
    ..pc<$4.RoadSubEvent>(5, _omitFieldNames ? '' : 'roadSubEvents', $pb.PbFieldType.PM, subBuilder: $4.RoadSubEvent.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RoadEventUpdated clone() => RoadEventUpdated()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RoadEventUpdated copyWith(void Function(RoadEventUpdated) updates) => super.copyWith((message) => updates(message as RoadEventUpdated)) as RoadEventUpdated;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RoadEventUpdated create() => RoadEventUpdated._();
  @$core.override
  RoadEventUpdated createEmptyInstance() => create();
  static $pb.PbList<RoadEventUpdated> createRepeated() => $pb.PbList<RoadEventUpdated>();
  @$core.pragma('dart2js:noInline')
  static RoadEventUpdated getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RoadEventUpdated>(create);
  static RoadEventUpdated? _defaultInstance;

  @$pb.TagNumber(1)
  $3.RoadEvent get roadEvent => $_getN(0);
  @$pb.TagNumber(1)
  set roadEvent($3.RoadEvent value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasRoadEvent() => $_has(0);
  @$pb.TagNumber(1)
  void clearRoadEvent() => $_clearField(1);
  @$pb.TagNumber(1)
  $3.RoadEvent ensureRoadEvent() => $_ensure(0);

  @$pb.TagNumber(5)
  $pb.PbList<$4.RoadSubEvent> get roadSubEvents => $_getList(1);
}

/// Indicates that a RoadEvent was deleted via the ConAdmin UI
class RoadEventRemoved extends $pb.GeneratedMessage {
  factory RoadEventRemoved({
    $fixnum.Int64? roadEventId,
  }) {
    final result = create();
    if (roadEventId != null) result.roadEventId = roadEventId;
    return result;
  }

  RoadEventRemoved._();

  factory RoadEventRemoved.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(data, registry);
  factory RoadEventRemoved.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'RoadEventRemoved', package: const $pb.PackageName(_omitMessageNames ? '' : 'datahub.v1'), createEmptyInstance: create)
    ..a<$fixnum.Int64>(3, _omitFieldNames ? '' : 'roadEventId', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RoadEventRemoved clone() => RoadEventRemoved()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RoadEventRemoved copyWith(void Function(RoadEventRemoved) updates) => super.copyWith((message) => updates(message as RoadEventRemoved)) as RoadEventRemoved;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RoadEventRemoved create() => RoadEventRemoved._();
  @$core.override
  RoadEventRemoved createEmptyInstance() => create();
  static $pb.PbList<RoadEventRemoved> createRepeated() => $pb.PbList<RoadEventRemoved>();
  @$core.pragma('dart2js:noInline')
  static RoadEventRemoved getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RoadEventRemoved>(create);
  static RoadEventRemoved? _defaultInstance;

  @$pb.TagNumber(3)
  $fixnum.Int64 get roadEventId => $_getI64(0);
  @$pb.TagNumber(3)
  set roadEventId($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(3)
  $core.bool hasRoadEventId() => $_has(0);
  @$pb.TagNumber(3)
  void clearRoadEventId() => $_clearField(3);
}

/// This represents the current state of the approved RoadEvent. It may be different from the original RoadEventUpdate
/// message state as the TMC Operators have the option to edit the incoming RoadEvent and RoadSubEvents before approving.
class RoadEventUpdateApproved extends $pb.GeneratedMessage {
  factory RoadEventUpdateApproved({
    $fixnum.Int64? originalRequestId,
    $3.RoadEvent? roadEvent,
    $core.Iterable<$4.RoadSubEvent>? roadSubEvents,
  }) {
    final result = create();
    if (originalRequestId != null) result.originalRequestId = originalRequestId;
    if (roadEvent != null) result.roadEvent = roadEvent;
    if (roadSubEvents != null) result.roadSubEvents.addAll(roadSubEvents);
    return result;
  }

  RoadEventUpdateApproved._();

  factory RoadEventUpdateApproved.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(data, registry);
  factory RoadEventUpdateApproved.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'RoadEventUpdateApproved', package: const $pb.PackageName(_omitMessageNames ? '' : 'datahub.v1'), createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, _omitFieldNames ? '' : 'originalRequestId', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..aOM<$3.RoadEvent>(2, _omitFieldNames ? '' : 'roadEvent', subBuilder: $3.RoadEvent.create)
    ..pc<$4.RoadSubEvent>(3, _omitFieldNames ? '' : 'roadSubEvents', $pb.PbFieldType.PM, subBuilder: $4.RoadSubEvent.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RoadEventUpdateApproved clone() => RoadEventUpdateApproved()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RoadEventUpdateApproved copyWith(void Function(RoadEventUpdateApproved) updates) => super.copyWith((message) => updates(message as RoadEventUpdateApproved)) as RoadEventUpdateApproved;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RoadEventUpdateApproved create() => RoadEventUpdateApproved._();
  @$core.override
  RoadEventUpdateApproved createEmptyInstance() => create();
  static $pb.PbList<RoadEventUpdateApproved> createRepeated() => $pb.PbList<RoadEventUpdateApproved>();
  @$core.pragma('dart2js:noInline')
  static RoadEventUpdateApproved getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RoadEventUpdateApproved>(create);
  static RoadEventUpdateApproved? _defaultInstance;

  /// the original_request_id is used to relate the DataHubRoadEventUpdate message this approval relates to.
  @$pb.TagNumber(1)
  $fixnum.Int64 get originalRequestId => $_getI64(0);
  @$pb.TagNumber(1)
  set originalRequestId($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasOriginalRequestId() => $_has(0);
  @$pb.TagNumber(1)
  void clearOriginalRequestId() => $_clearField(1);

  @$pb.TagNumber(2)
  $3.RoadEvent get roadEvent => $_getN(1);
  @$pb.TagNumber(2)
  set roadEvent($3.RoadEvent value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasRoadEvent() => $_has(1);
  @$pb.TagNumber(2)
  void clearRoadEvent() => $_clearField(2);
  @$pb.TagNumber(2)
  $3.RoadEvent ensureRoadEvent() => $_ensure(1);

  @$pb.TagNumber(3)
  $pb.PbList<$4.RoadSubEvent> get roadSubEvents => $_getList(2);
}

class RoadEventUpdateRejected extends $pb.GeneratedMessage {
  factory RoadEventUpdateRejected({
    $fixnum.Int64? originalRequestId,
  }) {
    final result = create();
    if (originalRequestId != null) result.originalRequestId = originalRequestId;
    return result;
  }

  RoadEventUpdateRejected._();

  factory RoadEventUpdateRejected.fromBuffer($core.List<$core.int> data, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(data, registry);
  factory RoadEventUpdateRejected.fromJson($core.String json, [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'RoadEventUpdateRejected', package: const $pb.PackageName(_omitMessageNames ? '' : 'datahub.v1'), createEmptyInstance: create)
    ..a<$fixnum.Int64>(1, _omitFieldNames ? '' : 'originalRequestId', $pb.PbFieldType.OU6, defaultOrMaker: $fixnum.Int64.ZERO)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RoadEventUpdateRejected clone() => RoadEventUpdateRejected()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RoadEventUpdateRejected copyWith(void Function(RoadEventUpdateRejected) updates) => super.copyWith((message) => updates(message as RoadEventUpdateRejected)) as RoadEventUpdateRejected;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RoadEventUpdateRejected create() => RoadEventUpdateRejected._();
  @$core.override
  RoadEventUpdateRejected createEmptyInstance() => create();
  static $pb.PbList<RoadEventUpdateRejected> createRepeated() => $pb.PbList<RoadEventUpdateRejected>();
  @$core.pragma('dart2js:noInline')
  static RoadEventUpdateRejected getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RoadEventUpdateRejected>(create);
  static RoadEventUpdateRejected? _defaultInstance;

  /// the original_request_id is used to relate the DataHubRoadEventUpdate message this approval relates to.
  @$pb.TagNumber(1)
  $fixnum.Int64 get originalRequestId => $_getI64(0);
  @$pb.TagNumber(1)
  set originalRequestId($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasOriginalRequestId() => $_has(0);
  @$pb.TagNumber(1)
  void clearOriginalRequestId() => $_clearField(1);
}


const $core.bool _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
