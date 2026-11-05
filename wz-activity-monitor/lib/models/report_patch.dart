import 'package:json_annotation/json_annotation.dart';
import 'package:latlong2/latlong.dart';
import 'package:wzam/models/date_time_json_converter.dart';
import 'package:wzam/models/event_status.dart';
import 'package:wzam/models/lat_lng_json_converter.dart';
import 'package:wzam/models/report.dart';
import 'package:wzam/models/wzdx_models.dart';

part 'report_patch.g.dart';

@JsonSerializable()
class ReportPatch {
  // Required fields
  @JsonKey(name: 'id')
  final int id;
  @JsonKey(name: 'road_event_id')
  final int roadEventId;
  @JsonKey(
      name: 'timestamp',
      fromJson: DateTimeJsonConverter.fromJson,
      toJson: DateTimeJsonConverter.toJson)
  final DateTime timestamp;
  @JsonKey(name: 'user_id')
  final String userId;

  // Optional fields for patching
  @JsonKey(name: 'name')
  final String? name;
  @JsonKey(name: 'description')
  final String? description;
  @JsonKey(name: 'types_of_work')
  final List<TypeOfWork>? typesOfWork;
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
  @JsonKey(name: 'geometry_type')
  final GeometryType? geometryType;
  @JsonKey(
      name: 'geometry',
      fromJson: LatLngJsonConverter.fromJsonListNullable,
      toJson: LatLngJsonConverter.toJsonListNullable)
  final List<LatLng>? geometry;
  @JsonKey(name: 'license_plate')
  final String? licensePlate;
  @JsonKey(name: 'event_schedule')
  final EventRecurrence? eventSchedule;
  @JsonKey(name: 'linked_field_device_ids')  
  final List<String>? linkedFieldDeviceIds;

  @JsonKey(
      includeFromJson: false, includeToJson: false) // Non json-serialized field
  final EventStatus? status;

  ReportPatch(
      {required this.id,
        required this.roadEventId,
        required this.timestamp,
        required this.userId,
      this.name,
      this.description,
      this.typesOfWork,
      this.roadName,
      this.direction,
      this.startDate,
      this.endDate,
      this.geometryType,
      this.geometry,
      this.licensePlate,
      this.eventSchedule,
      this.linkedFieldDeviceIds})
      : status = EventStatus.fromDates(startDate, startDate);

  ReportPatch copyWith({
    int? id,
    int? roadEventId,
    DateTime? timestamp,
    String? userId,
    String? name,
    String? description,
    List<TypeOfWork>? typesOfWork,
    String? roadName,
    RoadwayDirection? direction,
    DateTime? startDate,
    DateTime? endDate,
    List<LatLng>? geometry,
    double? geometryLineWidth,
    String? licensePlate,
    EventRecurrence? eventSchedule,
    List<String>? linkedFieldDeviceIds,
  }) {
    return ReportPatch(
      id: id ?? this.id,
      roadEventId: roadEventId ?? this.roadEventId,
      timestamp: timestamp ?? this.timestamp,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      description: description ?? this.description,
      typesOfWork: typesOfWork ?? this.typesOfWork,
      roadName: roadName ?? this.roadName,
      direction: direction ?? this.direction,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      geometryType: geometryType ?? this.geometryType,
      geometry: geometry ?? this.geometry,
      eventSchedule: eventSchedule ?? this.eventSchedule,
      linkedFieldDeviceIds: linkedFieldDeviceIds ?? this.linkedFieldDeviceIds,
    );
  }

  String getUniqueName() {
    return 'ReportPatch_${name}_${userId}_$timestamp';
  }

  static DateTime? dateTimeFromJson(int? json) {
    return json != null
        ? DateTime.fromMillisecondsSinceEpoch(json, isUtc: true)
        : null;
  }

  static int? dateTimeToJson(DateTime? object) {
    return object?.toUtc().millisecondsSinceEpoch;
  }

  factory ReportPatch.fromJson(Map<String, dynamic> json) => _$ReportPatchFromJson(json);

  Map<String, dynamic> toJson() => _$ReportPatchToJson(this);
}
