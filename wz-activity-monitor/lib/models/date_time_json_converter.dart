import 'package:flutter/material.dart';
import 'package:wzam/models/generated/google/type/timeofday.pb.dart'
    as pb_time_of_day;
import 'package:wzam/models/generated/google/type/date.pb.dart' as pb_date;

class DateTimeJsonConverter {
  static DateTime? fromJsonNullable(int? json) {
    return json != null
        ? DateTime.fromMillisecondsSinceEpoch(json, isUtc: true)
        : null;
  }

  static int? toJsonNullable(DateTime? object) {
    return object?.toUtc().millisecondsSinceEpoch;
  }

  static DateTime fromJson(int json) {
    return DateTime.fromMillisecondsSinceEpoch(json, isUtc: true);
  }

  static int toJson(DateTime object) {
    return object.toUtc().millisecondsSinceEpoch;
  }

  static TimeOfDay fromTimeOfDayJson(String json) {
    // Assuming the format is "HH:mm"
    final parts = json.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);
    return TimeOfDay(hour: hour, minute: minute);
  }

  static TimeOfDay fromTimeOfDayProto(pb_time_of_day.TimeOfDay proto) {
    return TimeOfDay(hour: proto.hours, minute: proto.minutes);
  }

  static String toTimeOfDayJson(TimeOfDay time) {
    return "${time.hour}:${time.minute}";
  }

  static DateTime fromDateJson(String json) {
    return DateTime.parse(json); // Parses the string into a DateTime object
  }

  static DateTime fromDateProto(pb_date.Date proto) {
    return DateTime(proto.year, proto.month, proto.day);
  }

  static String? toDateJson(DateTime? date) {
    if (date == null) {
      return null;
    }
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}"; // Formats the DateTime as "YYYY-MM-DD";
  }
}
