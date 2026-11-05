import 'package:fixnum/fixnum.dart';
import 'package:flutter/material.dart';
import 'package:wzam/models/generated/google/protobuf/timestamp.pb.dart';
import 'package:wzam/models/generated/google/type/date.pb.dart';
import 'package:wzam/models/generated/google/type/timeofday.pb.dart' as tod;

class ProtobufUtils {
  static DateTime fromTimestamp(Timestamp timestamp) {
    return DateTime.fromMillisecondsSinceEpoch(
        timestamp.seconds.toInt() * 1000 + (timestamp.nanos / 1000000).round(),
        isUtc: true);
  }

  static Timestamp toTimestamp(DateTime dateTime) {
    return Timestamp(
      seconds: Int64(dateTime.toUtc().millisecondsSinceEpoch ~/ 1000),
      nanos: (dateTime.microsecondsSinceEpoch % 1000000 * 1000).toInt(),
    );
  }

  static DateTimeRange? getDateTimeRangeForProto(Date? d1, Date? d2) {
    if (d1 == null || d2 == null) {
      return null;
    }
    return DateTimeRange(
      start: DateTime.utc(d1.year, d1.month, d1.day),
      end: DateTime.utc(d2.year, d2.month, d2.day),
    );
  }

  static DateTimeRange? getDateTimeRange(DateTime? d1, DateTime? d2) {
    if (d1 == null || d2 == null) {
      return null;
    }
    return DateTimeRange(
      start: d1,
      end: d2,
    );
  }

  static Date toDate(DateTime dt) {
    Date date = Date.create();
    date.day = dt.day;
    date.month = dt.month;
    date.year = dt.year;
    return date;
  }

  static DateTime fromDate(Date date) {
    return DateTime.utc(date.year, date.month, date.day);
  }

  static tod.TimeOfDay toTimeOfDay(TimeOfDay time) {
    tod.TimeOfDay timeOfDay = tod.TimeOfDay.create();
    timeOfDay.hours = time.hour;
    timeOfDay.minutes = time.minute;
    return timeOfDay;
  }

  static TimeOfDay fromTimeOfDay(tod.TimeOfDay timeOfDay) {
    return TimeOfDay(hour: timeOfDay.hours, minute: timeOfDay.minutes);
  }
}
