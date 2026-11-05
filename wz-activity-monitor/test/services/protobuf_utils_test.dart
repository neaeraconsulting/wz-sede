import 'package:fixnum/fixnum.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wzam/services/protobuf_utils.dart';
import 'package:wzam/models/generated/google/protobuf/timestamp.pb.dart';
import 'package:wzam/models/generated/google/type/date.pb.dart';
import 'package:wzam/models/generated/google/type/timeofday.pb.dart' as tod;
import 'package:flutter/material.dart';

void main() {
  group('ProtobufUtils', () {
    test('Timestamp to and from', () {
      int millis = 1672531200500;
      DateTime dt = DateTime.fromMillisecondsSinceEpoch(millis, isUtc: true);
      int outMillis = dt.toUtc().millisecondsSinceEpoch;
      expect(outMillis, millis);
    });

    test('fromTimestamp converts Timestamp to DateTime correctly', () {
      final timestamp = Timestamp(
        seconds: Int64(1672531200), // Equivalent to 2023-01-01T00:00:00Z
        nanos: 500000000, // 500 milliseconds
      );

      final dateTime = ProtobufUtils.fromTimestamp(timestamp);

      expect(dateTime.year, 2023);
      expect(dateTime.month, 1);
      expect(dateTime.day, 1);
      expect(dateTime.hour, 0);
      expect(dateTime.minute, 0);
      expect(dateTime.second, 0);
      expect(dateTime.millisecond, 500);
    });

    test('toTimestamp converts DateTime to Timestamp correctly', () {
      final dateTime =
          DateTime.utc(2023, 1, 1, 0, 0, 0, 500); // 2023-01-01T00:00:00.500Z

      final timestamp = ProtobufUtils.toTimestamp(dateTime);
      expect(dateTime.toUtc().millisecondsSinceEpoch,
          1672531200500); // Seconds since epoch

      expect(timestamp.seconds.toInt(), 1672531200); // Seconds since epoch
      expect(timestamp.nanos, 500000000); // Nanoseconds
    });

    test('toDate converts DateTime to Date correctly', () {
      final dateTime = DateTime.utc(2023, 1, 1);

      final date = ProtobufUtils.toDate(dateTime);

      expect(date.year, 2023);
      expect(date.month, 1);
      expect(date.day, 1);
    });

    test('fromDate converts Date to DateTime correctly', () {
      final date = Date()
        ..year = 2023
        ..month = 1
        ..day = 1;

      final dateTime = ProtobufUtils.fromDate(date);

      expect(dateTime.year, 2023);
      expect(dateTime.month, 1);
      expect(dateTime.day, 1);
    });

    test('toTimeOfDay converts TimeOfDay to Protobuf TimeOfDay correctly', () {
      const timeOfDay = TimeOfDay(hour: 8, minute: 30);

      final protoTimeOfDay = ProtobufUtils.toTimeOfDay(timeOfDay);

      expect(protoTimeOfDay.hours, 8);
      expect(protoTimeOfDay.minutes, 30);
    });

    test('fromTimeOfDay converts Protobuf TimeOfDay to TimeOfDay correctly',
        () {
      final protoTimeOfDay = tod.TimeOfDay()
        ..hours = 8
        ..minutes = 30;

      final timeOfDay = ProtobufUtils.fromTimeOfDay(protoTimeOfDay);

      expect(timeOfDay.hour, 8);
      expect(timeOfDay.minute, 30);
    });
  });
}
