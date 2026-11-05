import 'package:json_annotation/json_annotation.dart';
import 'package:wzam/models/date_time_json_converter.dart';
import 'package:wzam/models/report.dart';
import 'package:wzam/models/wzdx_models.dart';

part 'recording.g.dart';

@JsonSerializable()
class Recording {
  @JsonKey(name: 'project_id')
  final int? projectId;
  @JsonKey(name: 'road_event_id')
  final int? roadEventId;
  @JsonKey(name: 'name')
  final String name;
  @JsonKey(name: 'description')
  final String? description;
  @JsonKey(name: 'types_of_work')
  final List<TypeOfWork> typesOfWork;
  @JsonKey(name: 'road_name')
  final String? roadName;
  @JsonKey(name: 'direction')
  final RoadwayDirection? direction;
  @JsonKey(
      name: 'start_date',
      fromJson: DateTimeJsonConverter.fromJsonNullable,
      toJson: DateTimeJsonConverter.toJsonNullable)
  final DateTime? startDate;
  @JsonKey(
      name: 'end_date',
      fromJson: DateTimeJsonConverter.fromJsonNullable,
      toJson: DateTimeJsonConverter.toJsonNullable)
  final DateTime? endDate;
  @JsonKey(
      name: 'timestamp',
      fromJson: DateTimeJsonConverter.fromJson,
      toJson: DateTimeJsonConverter.toJson)
  final DateTime timestamp;
  @JsonKey(name: 'area_type')
  final WorkZoneType areaType;
  @JsonKey(name: 'vehicle_impact')
  final VehicleImpact? vehicleImpact;
  @JsonKey(name: 'surface_type')
  final RoadSegmentSurfaceType? surfaceType;
  @JsonKey(name: 'points')
  final List<RecordingPoint> points;
  @JsonKey(name: 'user_id')
  final String? userId;
  @JsonKey(name: 'event_schedule')
  final EventRecurrence? eventSchedule;
  @JsonKey(name: 'worker_presence_schedule')
  final EventRecurrence? workerPresenceSchedule;
  @JsonKey(name: 'recording_start_timestamp')
  final DateTime? recordingStartTimestamp;
  @JsonKey(name: 'recording_end_timestamp')
  final DateTime? recordingEndTimestamp;
  @JsonKey(name: 'linked_field_device_ids')
  final List<String>? linkedFieldDeviceIds;
  @JsonKey(name: 'source_type')
  final RecordingSourceType? sourceType;

  Recording(
      {this.projectId,
      this.roadEventId,
      required this.name,
      this.description,
      required this.typesOfWork,
      this.roadName,
      this.direction,
      this.startDate,
      this.endDate,
      required this.timestamp,
      required this.areaType,
      this.vehicleImpact,
      this.surfaceType,
      required this.points,
      this.userId,
      this.eventSchedule,
      this.workerPresenceSchedule,
      this.recordingStartTimestamp,
      this.recordingEndTimestamp,
    this.linkedFieldDeviceIds,
    this.sourceType,
  });

  Recording copyWith({
    int? projectId,
    int? roadEventId,
    String? name,
    String? description,
    List<TypeOfWork>? typesOfWork,
    String? roadName,
    RoadwayDirection? direction,
    DateTime? startDate,
    DateTime? endDate,
    DateTime? timestamp,
    WorkZoneType? areaType,
    VehicleImpact? vehicleImpact,
    RoadSegmentSurfaceType? surfaceType,
    List<RecordingPoint>? points,
    String? userId,
    EventRecurrence? eventSchedule,
    EventRecurrence? workerPresenceSchedule,
    DateTime? recordingStartTimestamp,
    DateTime? recordingEndTimestamp,
    List<String>? linkedFieldDeviceIds,
    RecordingSourceType? sourceType,
  }) {
    return Recording(
      projectId: projectId ?? this.projectId,
      roadEventId: roadEventId ?? this.roadEventId,
      name: name ?? this.name,
      description: description ?? this.description,
      typesOfWork: typesOfWork ?? this.typesOfWork,
      roadName: roadName ?? this.roadName,
      direction: direction ?? this.direction,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      timestamp: timestamp ?? this.timestamp,
      areaType: areaType ?? this.areaType,
      vehicleImpact: vehicleImpact ?? this.vehicleImpact,
      surfaceType: surfaceType ?? this.surfaceType,
      points: points ?? this.points,
      userId: userId ?? this.userId,
      eventSchedule: eventSchedule ?? this.eventSchedule,
      workerPresenceSchedule:
          workerPresenceSchedule ?? this.workerPresenceSchedule,
      recordingStartTimestamp: recordingStartTimestamp ?? this.recordingStartTimestamp,
      recordingEndTimestamp: recordingEndTimestamp ?? this.recordingEndTimestamp,
      linkedFieldDeviceIds: linkedFieldDeviceIds ?? this.linkedFieldDeviceIds,
      sourceType: sourceType ?? this.sourceType,
    );
  }

  String getUniqueName() {
    return 'Recording_${name}_${userId}_$timestamp';
  }

  factory Recording.fromJson(Map<String, dynamic> json) =>
      _$RecordingFromJson(json);
  Map<String, dynamic> toJson() => _$RecordingToJson(this);
}

@JsonSerializable()
class RecordingWithId extends Recording {
  final int id;

  RecordingWithId(
      {required this.id,
      super.projectId,
      super.roadEventId,
      required super.name,
      super.description,
      required super.typesOfWork,
      super.roadName,
      super.direction,
      super.startDate,
      super.endDate,
      required super.timestamp,
      required super.areaType,
      super.vehicleImpact,
      super.surfaceType,
      required super.points,
      super.userId,
      super.eventSchedule,
      super.workerPresenceSchedule,
      super.recordingStartTimestamp,
      super.recordingEndTimestamp,
    super.linkedFieldDeviceIds,
    super.sourceType,
  });

  RecordingWithId.fromRecording({
    required Recording recording,
    required this.id,
  }) : super(
          projectId: recording.projectId,
          roadEventId: recording.roadEventId,
          name: recording.name,
          description: recording.description,
          typesOfWork: recording.typesOfWork,
          roadName: recording.roadName,
          direction: recording.direction,
          startDate: recording.startDate,
          endDate: recording.endDate,
          timestamp: recording.timestamp,
          areaType: recording.areaType,
          surfaceType: recording.surfaceType,
          points: recording.points,
          userId: recording.userId,
          eventSchedule: recording.eventSchedule,
          workerPresenceSchedule: recording.workerPresenceSchedule,
          recordingStartTimestamp: recording.recordingStartTimestamp,
          recordingEndTimestamp: recording.recordingEndTimestamp,
          linkedFieldDeviceIds: recording.linkedFieldDeviceIds,
          sourceType: recording.sourceType,
        );

  @override
  RecordingWithId copyWith({
    int? id,
    int? projectId,
    int? roadEventId,
    String? name,
    String? description,
    List<TypeOfWork>? typesOfWork,
    String? roadName,
    RoadwayDirection? direction,
    DateTime? startDate,
    DateTime? endDate,
    DateTime? timestamp,
    WorkZoneType? areaType,
    VehicleImpact? vehicleImpact,
    RoadSegmentSurfaceType? surfaceType,
    List<RecordingPoint>? points,
    String? userId,
    EventRecurrence? eventSchedule,
    EventRecurrence? workerPresenceSchedule,
    DateTime? recordingStartTimestamp,
    DateTime? recordingEndTimestamp,
    List<String>? linkedFieldDeviceIds,
    RecordingSourceType? sourceType,
  }) {
    return RecordingWithId(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      roadEventId: roadEventId ?? this.roadEventId,
      name: name ?? this.name,
      description: description ?? this.description,
      typesOfWork: typesOfWork ?? this.typesOfWork,
      roadName: roadName ?? this.roadName,
      direction: direction ?? this.direction,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      timestamp: timestamp ?? this.timestamp,
      areaType: areaType ?? this.areaType,
      vehicleImpact: vehicleImpact ?? this.vehicleImpact,
      surfaceType: surfaceType ?? this.surfaceType,
      points: points ?? this.points,
      userId: userId ?? this.userId,
      eventSchedule: eventSchedule ?? this.eventSchedule,
      workerPresenceSchedule:
          workerPresenceSchedule ?? this.workerPresenceSchedule,
      recordingStartTimestamp: recordingStartTimestamp ?? this.recordingStartTimestamp,
      recordingEndTimestamp: recordingEndTimestamp ?? this.recordingEndTimestamp,
      linkedFieldDeviceIds: linkedFieldDeviceIds ?? this.linkedFieldDeviceIds,
      sourceType: sourceType ?? this.sourceType,
    );
  }

  factory RecordingWithId.fromJson(Map<String, dynamic> json) =>
      _$RecordingWithIdFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$RecordingWithIdToJson(this);
}

@JsonSerializable()
class RecordingMarking {
  @JsonKey(name: 'ref_pt')
  final bool? refPt;
  @JsonKey(name: 'lanes')
  final List<Lane>? lanes;
  @JsonKey(name: 'workers_present')
  final bool? workersPresent;
  @JsonKey(name: 'speed_limit_mph')
  final int? speedLimitMph;

  RecordingMarking(
      {this.refPt, this.lanes, this.workersPresent, this.speedLimitMph});

  RecordingMarking copyWithMarking(RecordingMarking marking) {
    return RecordingMarking(
      refPt: marking.refPt ?? refPt,
      lanes: marking.lanes ?? lanes,
      workersPresent: marking.workersPresent ?? workersPresent,
      speedLimitMph: marking.speedLimitMph ?? speedLimitMph,
    );
  }

  RecordingMarking copyWith({
    bool? refPt,
    List<Lane>? lanes,
    bool? workersPresent,
    int? speedLimitMph,
  }) {
    return RecordingMarking(
      refPt: refPt ?? this.refPt,
      lanes: lanes ?? this.lanes,
      workersPresent: workersPresent ?? this.workersPresent,
      speedLimitMph: speedLimitMph ?? this.speedLimitMph,
    );
  }

  factory RecordingMarking.fromJson(Map<String, dynamic> json) =>
      _$RecordingMarkingFromJson(json);
  Map<String, dynamic> toJson() => _$RecordingMarkingToJson(this);
}

@JsonSerializable()
class RecordingPoint {
  @JsonKey(name: 'timestamp')
  final int timestamp;
  @JsonKey(name: 'num_satellites')
  final int numSatellites;
  @JsonKey(name: 'accuracy')
  final double accuracy;
  @JsonKey(name: 'latitude')
  final double latitude;
  @JsonKey(name: 'longitude')
  final double longitude;
  @JsonKey(name: 'altitude')
  final double altitude;
  @JsonKey(name: 'speed')
  final double speed;
  @JsonKey(name: 'heading')
  final double heading;
  @JsonKey(name: 'marking')
  final RecordingMarking? marking;

  RecordingPoint(
      {required this.timestamp,
      required this.numSatellites,
      required this.accuracy,
      required this.latitude,
      required this.longitude,
      required this.altitude,
      required this.speed,
      required this.heading,
      required this.marking});

  RecordingPoint copyWith(
      {int? timestamp,
      int? numSatellites,
      double? accuracy,
      double? latitude,
      double? longitude,
      double? altitude,
      double? speed,
      double? heading,
      RecordingMarking? marking}) {
    return RecordingPoint(
      timestamp: timestamp ?? this.timestamp,
      numSatellites: numSatellites ?? this.numSatellites,
      accuracy: accuracy ?? this.accuracy,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      altitude: altitude ?? this.altitude,
      speed: speed ?? this.speed,
      heading: heading ?? this.heading,
      marking: marking ?? this.marking,
    );
  }

  factory RecordingPoint.fromJson(Map<String, dynamic> json) =>
      _$RecordingPointFromJson(json);
  Map<String, dynamic> toJson() => _$RecordingPointToJson(this);
}

enum RecordingSourceType {
  @JsonValue('drive')
  drive,
  @JsonValue('kml-upload')
  kmlUpload,
}
