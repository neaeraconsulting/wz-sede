import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:latlong2/latlong.dart';
import 'package:wzam/models/date_time_json_converter.dart';
import 'package:wzam/models/event_status.dart';
import 'package:wzam/models/lat_lng_json_converter.dart';
import 'package:wzam/models/wzdx_models.dart';
import 'package:wzam/models/generated/road_event.pb.dart' as pb_road_event;

part 'report.g.dart';

@JsonSerializable()
class Report {
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
  @JsonKey(name: 'workers_present')
  final bool workersPresent;
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
  @JsonKey(name: 'speed_limit_mph')
  final double? speedLimitMph;
  @JsonKey(name: 'geometry_type')
  final GeometryType geometryType;
  @JsonKey(
      name: 'geometry',
      fromJson: LatLngJsonConverter.fromJsonList,
      toJson: LatLngJsonConverter.toJsonList)
  final List<LatLng> geometry;
  @JsonKey(name: 'geometry_line_width')
  final double? geometryLineWidth;
  @JsonKey(name: 'vehicle_impact')
  final VehicleImpact? vehicleImpact;
  @JsonKey(name: 'surface_type')
  final RoadSegmentSurfaceType? surfaceType;
  @JsonKey(name: 'user_id')
  final String? userId;
  @JsonKey(name: 'event_schedule')
  final EventRecurrence? eventSchedule;
  @JsonKey(name: 'worker_presence_schedule')
  final EventRecurrence? workerPresenceSchedule;
  @JsonKey(name: 'linked_field_device_ids')  
  final List<String>? linkedFieldDeviceIds;

  @JsonKey(
      includeFromJson: false, includeToJson: false) // Non json-serialized field
  final EventStatus status;


  Report(
      {this.projectId,
      this.roadEventId,
      required this.name,
      this.description,
      required this.typesOfWork,
      this.roadName,
      this.direction,
      required this.workersPresent,
      this.startDate,
      this.endDate,
      required this.timestamp,
      required this.areaType,
      this.speedLimitMph,
      required this.geometryType,
      required this.geometry,
      this.geometryLineWidth,
      this.vehicleImpact,
      this.surfaceType,
      this.userId,
      this.eventSchedule,
      this.workerPresenceSchedule,
      this.linkedFieldDeviceIds})
      : status = EventStatus.fromDates(startDate, startDate);

  Report copyWith({
    int? projectId,
    int? roadEventId,
    String? name,
    String? description,
    List<TypeOfWork>? typesOfWork,
    String? roadName,
    RoadwayDirection? direction,
    bool? workersPresent,
    DateTime? startDate,
    DateTime? endDate,
    DateTime? timestamp,
    WorkZoneType? areaType,
    double? speedLimitMph,
    GeometryType? geometryType,
    List<LatLng>? geometry,
    double? geometryLineWidth,
    String? licensePlate,
    VehicleImpact? vehicleImpact,
    RoadSegmentSurfaceType? surfaceType,
    String? userId,
    EventRecurrence? eventSchedule,
    EventRecurrence? workerPresenceSchedule,
    List<String>? linkedFieldDeviceIds,
  }) {
    return Report(
      projectId: projectId ?? this.projectId,
      roadEventId: roadEventId ?? this.roadEventId,
      name: name ?? this.name,
      description: description ?? this.description,
      typesOfWork: typesOfWork ?? this.typesOfWork,
      roadName: roadName ?? this.roadName,
      direction: direction ?? this.direction,
      workersPresent: workersPresent ?? this.workersPresent,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      timestamp: timestamp ?? this.timestamp,
      areaType: areaType ?? this.areaType,
      speedLimitMph: speedLimitMph ?? this.speedLimitMph,
      geometryType: geometryType ?? this.geometryType,
      geometry: geometry ?? this.geometry,
      geometryLineWidth: geometryLineWidth ?? this.geometryLineWidth,
      vehicleImpact: vehicleImpact ?? this.vehicleImpact,
      surfaceType: surfaceType ?? this.surfaceType,
      userId: userId ?? this.userId,
      eventSchedule: eventSchedule ?? this.eventSchedule,
      workerPresenceSchedule:
          workerPresenceSchedule ?? this.workerPresenceSchedule,
      linkedFieldDeviceIds: linkedFieldDeviceIds ?? this.linkedFieldDeviceIds,
    );
  }

  String getUniqueName() {
    return 'Report_${name}_${userId}_$timestamp';
  }

  static DateTime? dateTimeFromJson(int? json) {
    return json != null
        ? DateTime.fromMillisecondsSinceEpoch(json, isUtc: true)
        : null;
  }

  static int? dateTimeToJson(DateTime? object) {
    return object?.toUtc().millisecondsSinceEpoch;
  }

  factory Report.fromJson(Map<String, dynamic> json) => _$ReportFromJson(json);

  Map<String, dynamic> toJson() => _$ReportToJson(this);
}

@JsonSerializable()
class ReportWithId extends Report {
  final int id;

  ReportWithId({
    required this.id,
    super.projectId,
    super.roadEventId,
    required super.name,
    super.description,
    required super.typesOfWork,
    super.roadName,
    super.direction,
    required super.workersPresent,
    super.startDate,
    super.endDate,
    required super.timestamp,
    required super.areaType,
    super.speedLimitMph,
    required super.geometryType,
    required super.geometry,
    super.geometryLineWidth,
    super.vehicleImpact,
    super.surfaceType,
    super.userId,
    super.eventSchedule,
    super.workerPresenceSchedule,
    super.linkedFieldDeviceIds,
  });

  // New constructor that takes an id and a Report
  ReportWithId.fromReport({
    required Report report,
    required this.id,
  }) : super(
          projectId: report.projectId,
          roadEventId: report.roadEventId,
          name: report.name,
          description: report.description,
          typesOfWork: report.typesOfWork,
          roadName: report.roadName,
          direction: report.direction,
          workersPresent: report.workersPresent,
          startDate: report.startDate,
          endDate: report.endDate,
          timestamp: report.timestamp,
          areaType: report.areaType,
          speedLimitMph: report.speedLimitMph,
          geometryType: report.geometryType,
          geometry: report.geometry,
          geometryLineWidth: report.geometryLineWidth,
          surfaceType: report.surfaceType,
          userId: report.userId,
          eventSchedule: report.eventSchedule,
          workerPresenceSchedule: report.workerPresenceSchedule,
          linkedFieldDeviceIds: report.linkedFieldDeviceIds,
        );

  @override
  ReportWithId copyWith({
    int? id,
    int? projectId,
    int? roadEventId,
    String? name,
    String? description,
    List<TypeOfWork>? typesOfWork,
    String? roadName,
    RoadwayDirection? direction,
    bool? workersPresent,
    DateTime? startDate,
    DateTime? endDate,
    DateTime? timestamp,
    WorkZoneType? areaType,
    double? speedLimitMph,
    GeometryType? geometryType,
    List<LatLng>? geometry,
    double? geometryLineWidth,
    String? licensePlate,
    VehicleImpact? vehicleImpact,
    RoadSegmentSurfaceType? surfaceType,
    String? userId,
    EventRecurrence? eventSchedule,
    EventRecurrence? workerPresenceSchedule,
    List<String>? linkedFieldDeviceIds,
  }) {
    return ReportWithId(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      roadEventId: roadEventId ?? this.roadEventId,
      name: name ?? this.name,
      description: description ?? this.description,
      typesOfWork: typesOfWork ?? this.typesOfWork,
      roadName: roadName ?? this.roadName,
      direction: direction ?? this.direction,
      workersPresent: workersPresent ?? this.workersPresent,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      timestamp: timestamp ?? this.timestamp,
      areaType: areaType ?? this.areaType,
      speedLimitMph: speedLimitMph ?? this.speedLimitMph,
      geometryType: geometryType ?? this.geometryType,
      geometry: geometry ?? this.geometry,
      geometryLineWidth: geometryLineWidth ?? this.geometryLineWidth,
      vehicleImpact: vehicleImpact ?? this.vehicleImpact,
      surfaceType: surfaceType ?? this.surfaceType,
      userId: userId ?? this.userId,
      eventSchedule: eventSchedule ?? this.eventSchedule,
      workerPresenceSchedule:
          workerPresenceSchedule ?? this.workerPresenceSchedule,
      linkedFieldDeviceIds: linkedFieldDeviceIds ?? this.linkedFieldDeviceIds,
    );
  }

  factory ReportWithId.fromJson(Map<String, dynamic> json) =>
      _$ReportWithIdFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$ReportWithIdToJson(this);
}

enum GeometryType {
  @JsonValue('multipoint')
  multipoint,
  @JsonValue('linestring')
  linestring,
  @JsonValue('polygon')
  polygon,
}

@JsonSerializable()
class EventRecurrence {
  @JsonKey(
      name: 'start_time',
      fromJson: DateTimeJsonConverter.fromTimeOfDayJson,
      toJson: DateTimeJsonConverter.toTimeOfDayJson)
  final TimeOfDay startTime;
  @JsonKey(
      name: 'end_time',
      fromJson: DateTimeJsonConverter.fromTimeOfDayJson,
      toJson: DateTimeJsonConverter.toTimeOfDayJson)
  final TimeOfDay endTime;
  @JsonKey(
      name: 'start_date',
      fromJson: DateTimeJsonConverter.fromDateJson,
      toJson: DateTimeJsonConverter.toDateJson)
  final DateTime startDate;
  @JsonKey(
      name: 'end_date',
      fromJson: DateTimeJsonConverter.fromDateJson,
      toJson: DateTimeJsonConverter.toDateJson)
  final DateTime endDate;
  @JsonKey(name: 'days_of_week')
  final List<int> daysOfWeek;
  @JsonKey(name: 'exclusion')
  final bool exclusion;

  EventRecurrence({
    required this.startTime,
    required this.endTime,
    required this.startDate,
    required this.endDate,
    required this.daysOfWeek,
    this.exclusion = false,
  });

  static List<int> _daysOfWeekFromProto(pb_road_event.EventRecurrence proto) {
    List<int> days = [];

    if (proto.sunday) days.add(0);
    if (proto.monday) days.add(1);
    if (proto.tuesday) days.add(2);
    if (proto.wednesday) days.add(3);
    if (proto.thursday) days.add(4);
    if (proto.friday) days.add(5);
    if (proto.saturday) days.add(6);

    return days;
  }

  static fromProto(pb_road_event.EventRecurrence proto) {
    return EventRecurrence(
      startTime: DateTimeJsonConverter.fromTimeOfDayProto(proto.startTime),
      endTime: DateTimeJsonConverter.fromTimeOfDayProto(proto.endTime),
      startDate: DateTimeJsonConverter.fromDateProto(proto.startDate),
      endDate: DateTimeJsonConverter.fromDateProto(proto.endDate),
      daysOfWeek: _daysOfWeekFromProto(proto),
      exclusion: proto.exclusion,
    );
  }

  factory EventRecurrence.fromJson(Map<String, dynamic> json) =>
      _$EventRecurrenceFromJson(json);

  Map<String, dynamic> toJson() => _$EventRecurrenceToJson(this);
}
