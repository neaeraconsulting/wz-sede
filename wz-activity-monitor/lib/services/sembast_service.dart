import 'dart:async';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:sembast_web/sembast_web.dart';
import 'package:wzam/models/mixed_report.dart';
import 'package:wzam/models/recording.dart';
import 'package:wzam/models/report.dart';
import 'package:wzam/models/wrappers/field_device_reading.dart';
import 'package:wzam/models/wrappers/project_wrapper.dart';
import 'package:wzam/models/wrappers/road_event_wrapper.dart';

class SembastService extends GetxService {
  static const String dbName = 'wzam.db';
  static const String storeNameFieldDevice = 'field_devices';
  static const String storeNameRoadEvent = 'road_events';
  static const String storeNameProject = 'projects';
  static const String storeNameLocalReports = 'localReports';
  static const String storeNameReports = 'reports';
  static const String storeNameLocalRecordings = 'localRecordings';
  static const String storeNameRecordings = 'recordings';

  late Database _db;
  late StoreRef<String, Map<String, Object?>> _fieldDeviceStore;
  late StoreRef<int, Map<String, Object?>> _roadEventStore;
  late StoreRef<int, Map<String, Object?>> _projectStore;
  late StoreRef<String, Map<String, Object?>> _localReportStore;
  late StoreRef<int, Map<String, Object?>> _reportStore;
  late StoreRef<String, Map<String, Object?>> _localRecordingStore;
  late StoreRef<int, Map<String, Object?>> _recordingStore;

  final Completer<void> _initCompleter = Completer<void>();

  @override
  void onInit() async {
    super.onInit();
    await init();
  }

  Future<void> init({retry = true}) async {
    try {
      if (kIsWeb) {
        // Use sembast_web for web platform
        _db = await databaseFactoryWeb.openDatabase(dbName);
      } else {
        // Use sembast_io for native platforms
        final directory = await getApplicationCacheDirectory();
        final dbPath = join(directory.path, dbName);
        _db = await databaseFactoryIo.openDatabase(dbPath);
      }

      // Initialize stores
      _fieldDeviceStore = stringMapStoreFactory.store(storeNameFieldDevice);
      _roadEventStore = intMapStoreFactory.store(storeNameRoadEvent);
      _projectStore = intMapStoreFactory.store(storeNameProject);
      _localReportStore = stringMapStoreFactory.store(storeNameLocalReports);
      _reportStore = intMapStoreFactory.store(storeNameReports);
      _localRecordingStore =
          stringMapStoreFactory.store(storeNameLocalRecordings);
      _recordingStore = intMapStoreFactory.store(storeNameRecordings);

      print("Sembast database initialized successfully");
      _initCompleter.complete();
    } catch (e) {
      print("Error initializing Sembast: $e");
      if (retry) {
        await removeAllBoxes();
        await init(retry: false);
      } else {
        _initCompleter.completeError(e);
      }
    }
  }

  Future<void> removeAllBoxes() async {
    try {
      await _db.close();
      if (kIsWeb) {
        await databaseFactoryWeb.deleteDatabase(dbName);
      } else {
        final directory = await getApplicationCacheDirectory();
        final dbPath = join(directory.path, dbName);
        await databaseFactoryIo.deleteDatabase(dbPath);
      }
    } catch (e) {
      print("Error removing database: $e");
    }
  }

  Future<Map<String, FieldDeviceReading>> getFieldDevices() async {
    await _initCompleter.future;
    final records = await _fieldDeviceStore.find(_db);
    return Map.fromEntries(
      records.map((record) => MapEntry(
            record.key,
            FieldDeviceReading.fromJson(record.value),
          )),
    );
  }

  Future<void> writeFieldDevices(List<FieldDeviceReading> deviceReadings,
      {bool clear = true}) async {
    print("Writing ${deviceReadings.length} field devices to Sembast");
    await _initCompleter.future;
    if (clear) {
      await _fieldDeviceStore.delete(_db);
    }
    await _db.transaction((txn) async {
      for (var deviceReading in deviceReadings) {
        await _fieldDeviceStore.record(deviceReading.device.id).put(
              txn,
              deviceReading.toJson(),
            );
      }
    });
  }

  Future<Map<int, RoadEventWrapper>> getRoadEvents() async {
    await _initCompleter.future;
    final records = await _roadEventStore.find(_db);
    return Map.fromEntries(
      records.map((record) => MapEntry(
            record.key,
            RoadEventWrapper.fromJson(record.value),
          )),
    );
  }

  Future<void> writeRoadEvents(List<RoadEventWrapper> roadEvents,
      {bool clear = true}) async {
    print("Writing ${roadEvents.length} road events to Sembast");
    await _initCompleter.future;
    if (clear) {
      await _roadEventStore.delete(_db);
    }
    await _db.transaction((txn) async {
      for (var roadEvent in roadEvents) {
        await _roadEventStore.record(roadEvent.roadEvent.id.toInt()).put(
              txn,
              roadEvent.toJson(),
            );
      }
    });
  }

  Future<Map<int, ProjectWrapper>> getProjects() async {
    await _initCompleter.future;
    final records = await _projectStore.find(_db);
    return Map.fromEntries(
      records.map((record) => MapEntry(
            record.key,
            ProjectWrapper.fromJson(record.value),
          )),
    );
  }

  Future<void> writeProjects(List<ProjectWrapper> projects,
      {bool clear = true}) async {
    print("Writing ${projects.length} projects to Sembast");
    await _initCompleter.future;
    if (clear) {
      await _projectStore.delete(_db);
    }
    await _db.transaction((txn) async {
      for (var project in projects) {
        await _projectStore.record(project.project.id.toInt()).put(
              txn,
              project.toJson(),
            );
      }
    });
  }

  Future<Map<String, Report>> getLocalReports() async {
    await _initCompleter.future;
    final records = await _localReportStore.find(_db);
    return Map.fromEntries(
      records.map((record) => MapEntry(
            record.key,
            Report.fromJson(record.value),
          )),
    );
  }

  Future<void> writeLocalReports(List<Report> reports,
      {bool clear = true}) async {
    print("Writing ${reports.length} local reports to Sembast");
    await _initCompleter.future;
    if (clear) {
      await _localReportStore.delete(_db);
    }
    await _db.transaction((txn) async {
      for (var report in reports) {
        await _localReportStore.record(report.getUniqueName()).put(
              txn,
              report.toJson(),
            );
      }
    });
  }

  Future<void> deleteLocalReports(List<Report> reportsToClear) async {
    await _initCompleter.future;
    await _localReportStore.records(
      reportsToClear.map((r) => r.getUniqueName()),
    ).delete(_db);
  }

  Future<void> clearLocalReports() async {
    await _initCompleter.future;
    await _localReportStore.delete(_db);
  }

  Future<Map<int, MixedReport>> getReports() async {
    await _initCompleter.future;
    final records = await _reportStore.find(_db);
    return Map.fromEntries(
      records.map((record) => MapEntry(
            record.key,
            MixedReport.fromJson(record.value),
          )),
    );
  }

  Future<void> writeReports(List<MixedReport> reports,
      {bool clear = true}) async {
    print("Writing ${reports.length} reports to Sembast");
    await _initCompleter.future;
    if (clear) {
      await _reportStore.delete(_db);
    }
    await _db.transaction((txn) async {
      for (var report in reports) {
        await _reportStore.record(report.id).put(txn, report.toJson());
      }
    });
  }

  Future<Map<String, Recording>> getLocalRecordings() async {
    await _initCompleter.future;
    final records = await _localRecordingStore.find(_db);
    return Map.fromEntries(
      records.map((record) => MapEntry(
            record.key,
            Recording.fromJson(record.value),
          )),
    );
  }

  Future<void> writeLocalRecordings(List<Recording> recordings,
      {bool clear = true}) async {
    print("Writing ${recordings.length} local recordings to Sembast");
    await _initCompleter.future;
    if (clear) {
      await _localRecordingStore.delete(_db);
    }
    await _db.transaction((txn) async {
      for (var recording in recordings) {
        await _localRecordingStore.record(recording.getUniqueName()).put(
              txn,
              recording.toJson(),
            );
      }
    });
  }

  Future<void> deleteLocalRecordings(List<Recording> recordingsToClear) async {
    await _initCompleter.future;
    await _localRecordingStore.records(
      recordingsToClear.map((r) => r.getUniqueName()),
    ).delete(_db);
  }

  Future<void> clearLocalRecordings() async {
    await _initCompleter.future;
    await _localRecordingStore.delete(_db);
  }

  Future<Map<int, RecordingWithId>> getRecordings() async {
    await _initCompleter.future;
    final records = await _recordingStore.find(_db);
    return Map.fromEntries(
      records.map((record) => MapEntry(
            record.key,
            RecordingWithId.fromJson(record.value),
          )),
    );
  }

  Future<void> writeRecordings(List<RecordingWithId> recordings,
      {bool clear = true}) async {
    print("Writing ${recordings.length} recordings to Sembast");
    await _initCompleter.future;
    if (clear) {
      await _recordingStore.delete(_db);
    }
    await _db.transaction((txn) async {
      for (var recording in recordings) {
        await _recordingStore.record(recording.id).put(txn, recording.toJson());
      }
    });
  }
}
