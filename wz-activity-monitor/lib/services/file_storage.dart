import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wzam/controllers/reports_controller.dart';
import 'package:wzam/controllers/view_recordings_controller.dart';
import 'package:wzam/models/archive_directory.dart';
import 'package:wzam/models/mixed_report.dart';
import 'package:wzam/models/notification_model.dart';
import 'package:wzam/models/recording.dart';
import 'package:wzam/models/report.dart';
import 'package:wzam/services/wzam_api.dart';

class FileStorageService extends GetxService {
  final RxList<MixedReportLocal> localReports = <MixedReportLocal>[].obs;
  final RxList<Recording> localRecordings = <Recording>[].obs;
  final RxBool hasLocalReports = false.obs;
  final RxBool hasLocalRecordings = false.obs;
  final String localReportDirectory = 'reports_local';
  final String localRecordingDirectory = 'recordings_local';

  StreamSubscription<FileSystemEvent>? _reportsLocalWatcher;
  StreamSubscription<FileSystemEvent>? _recordingsLocalWatcher;
  Timer? _localFilesPollingTimer;
  Timer? _localRefreshDebounceTimer;

  @override
  void onInit() {
    super.onInit();
    unawaited(_initializeLocalFileSync());
  }

  @override
  void onClose() {
    _reportsLocalWatcher?.cancel();
    _recordingsLocalWatcher?.cancel();
    _localFilesPollingTimer?.cancel();
    _localRefreshDebounceTimer?.cancel();
    super.onClose();
  }

  Future<void> _initializeLocalFileSync() async {
    await refreshLocalUploadState();
    await _startLocalDirectoryWatchers();
    _startLocalPollingFallback();
  }

  Future<void> _startLocalDirectoryWatchers() async {
    final String? reportsPath =
        await _getDownloadsDirectory(subdirectory: localReportDirectory);
    if (reportsPath != null) {
      final Directory reportsDir = Directory(reportsPath);
      if (!await reportsDir.exists()) {
        await reportsDir.create(recursive: true);
      }
      _reportsLocalWatcher = reportsDir.watch().listen(
            (_) => _scheduleLocalUploadStateRefresh(),
          );
    }

    final String? recordingsPath =
        await _getDownloadsDirectory(subdirectory: localRecordingDirectory);
    if (recordingsPath != null) {
      final Directory recordingsDir = Directory(recordingsPath);
      if (!await recordingsDir.exists()) {
        await recordingsDir.create(recursive: true);
      }
      _recordingsLocalWatcher = recordingsDir.watch().listen(
            (_) => _scheduleLocalUploadStateRefresh(),
          );
    }
  }

  void _startLocalPollingFallback() {
    _localFilesPollingTimer?.cancel();
    _localFilesPollingTimer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => unawaited(refreshLocalUploadState()),
    );
  }

  void _scheduleLocalUploadStateRefresh() {
    _localRefreshDebounceTimer?.cancel();
    _localRefreshDebounceTimer = Timer(
      const Duration(milliseconds: 250),
      () => unawaited(refreshLocalUploadState()),
    );
  }

  Future<void> refreshLocalUploadState() async {
    final List<MixedReportLocal> refreshedLocalReports =
        await _getLocalReportFiles();
    final List<Recording> refreshedLocalRecordings =
        await _getLocalRecordingFiles();

    localReports.value = refreshedLocalReports;
    localRecordings.value = refreshedLocalRecordings;
    hasLocalReports.value = refreshedLocalReports.isNotEmpty;
    hasLocalRecordings.value = refreshedLocalRecordings.isNotEmpty;

    if (Get.isRegistered<ReportsController>()) {
      final ReportsController reportsController = Get.find<ReportsController>();
      reportsController.localReports.value = refreshedLocalReports;
      reportsController.areThereLocalReports.value = hasLocalReports.value;
    }

    if (Get.isRegistered<ViewRecordingsController>()) {
      final ViewRecordingsController viewRecordingsController =
          Get.find<ViewRecordingsController>();
      viewRecordingsController.unUploadedRecordings.value =
          refreshedLocalRecordings;
      viewRecordingsController.areThereLocalRecordings.value =
          hasLocalRecordings.value;
    }
  }

  static Future<String> _getDocsDir(
      {String subdirectory = "road-config"}) async {
    final directory = await getApplicationDocumentsDirectory();
    final path = "${directory.path}/$subdirectory";
    return path;
  }

  static Future<String?> _getDownloadsDirectory(
      {String subdirectory = ""}) async {
    final directory = await getDownloadsDirectory();
    if (directory == null) {
      return null;
    }
    final path = "${directory.path}/$subdirectory";
    return path;
  }

  static Future<String> _getTempDir(
      {String subdirectory = "road-config"}) async {
    final directory = await getTemporaryDirectory();
    final path = "${directory.path}/$subdirectory";
    return path;
  }

  static Future<String> _getDirectory(
      ArchiveDirectory directory, String subdirectory) async {
    // defaults to application documents
    switch (directory) {
      case ArchiveDirectory.APPLICATION_DOCUMENTS:
        return _getDocsDir(subdirectory: subdirectory);
      case ArchiveDirectory.DOWNLOADS:
        return await _getDownloadsDirectory(subdirectory: subdirectory) ??
            _getDocsDir(subdirectory: subdirectory);
      case ArchiveDirectory.TEMPORARY:
        return _getTempDir(subdirectory: subdirectory);
    }
  }

  Future<String> _getFilePath(
      String name, ArchiveDirectory directory, String subdirectory) async {
    String path = await _getDirectory(directory, subdirectory);
    return '$path/$name';
  }

  Future<List<File>> listFiles(ArchiveDirectory directory,
      {String? subdirectory}) async {
    final path = await _getDirectory(directory, subdirectory ?? "");
    final dir = Directory(path);
    if (!await dir.exists()) {
      return [];
    }
    return dir.list().where((v) => v is File).map((v) => v as File).toList();
  }

  Future<String> _createFile(String fileName,
      {ArchiveDirectory directory = ArchiveDirectory.DOWNLOADS,
      String subdirectory = ""}) async {
    final String filePath =
        await _getFilePath(fileName, directory, subdirectory);
    File file = File(filePath);
    if (!await file.exists()) {
      await file.create(recursive: true);
    }
    return fileName;
  }

  Future<void> _writeToFile(
      String fileName, String data, String subdirectory) async {
    var path = await _getDownloadsDirectory(subdirectory: subdirectory);
    path = '$path/$fileName';
    File file = File(path);
    await file.writeAsString(data);
  }

  Future<void> saveLocalReport(MixedReportLocal report) async {
    final String reportJson = jsonEncode(report);
    final String fileName =
        'report_${report.name}_${DateTime.now().toUtc().toIso8601String()}.json';
    await _createFile(fileName, subdirectory: localReportDirectory)
        .then((fileName) async {
      await _writeToFile(fileName, reportJson, localReportDirectory);
    });
    await refreshLocalUploadState();
  }

  Future<List<MixedReportLocal>> _getLocalReportFiles() async {
    final String directoryPath =
        await _getDownloadsDirectory(subdirectory: localReportDirectory) ?? "";
    final dir = Directory(directoryPath);
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    final List<FileSystemEntity> entities = await dir.list().toList();
    final List<File> files = entities.whereType<File>().toList();
    List<MixedReportLocal> reports = _convertFilesToReports(files);
    return reports;
  }

  Future<List<Recording>> _getLocalRecordingFiles() async {
    final String directoryPath =
        await _getDownloadsDirectory(subdirectory: localRecordingDirectory) ??
            "";
    final dir = Directory(directoryPath);
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    } else {
      final List<FileSystemEntity> entities = await dir.list().toList();
      final List<File> files = entities.whereType<File>().toList();
      List<Recording> recordings = _convertFilesToRecordings(files);
      return recordings;
    }
    return [];
  }

  List<MixedReportLocal> _convertFilesToReports(List<File> files) {
    List<MixedReportLocal> reports = [];
    for (File file in files) {
      String reportJson = file.readAsStringSync();
      Map<String, dynamic> reportMap = jsonDecode(reportJson);
      MixedReportLocal report = MixedReportLocal.fromJson(reportMap);
      reports.add(report);
    }
    return reports;
  }

  Future<bool> uploadLocalRecordings() async {
    List<Recording> recordings = await _getLocalRecordingFiles();
    bool success = true;
    for (Recording recording in recordings) {
      bool individualSuccess = await _uploadRecording(recording);
      if (!individualSuccess) {
        success = false;
      }
    }
    await refreshLocalUploadState();
    return success;
  }

  Future<bool> uploadLocalReports() async {
    List<MixedReportLocal> reports = await _getLocalReportFiles();
    bool success = true;
    for (MixedReportLocal report in reports) {
      bool individualSuccess = await _uploadReport(report);
      if (!individualSuccess) {
        success = false;
      }
    }
    await refreshLocalUploadState();
    return success;
  }

  Future<bool> clearLocalReports() async {
    List<File> files = await listFiles(ArchiveDirectory.DOWNLOADS,
        subdirectory: localReportDirectory);
    for (File file in files) {
      await file.delete();
    }
    await refreshLocalUploadState();
    return true;
  }

  Future<bool> clearLocalRecordings() async {
    List<File> files = await listFiles(ArchiveDirectory.DOWNLOADS,
        subdirectory: 'recordings_local');
    for (File file in files) {
      await file.delete();
    }
    await refreshLocalUploadState();
    return true;
  }

  Future<bool> _uploadRecording(Recording recording) async {
    RecordingWithId? recordingWithId = await WzamApi.createRecording(recording,
        onErrorNotification: NotificationModel.simple(
            "Recording Upload Failed", 'Failed to upload recording'));
    if (recordingWithId != null) {
      await _deleteLocalRecording(recording);
      return true;
    }
    return false;
  }

  Future<bool> _uploadReport(MixedReportLocal report) async {
    if (report.isFullReport) {
      ReportWithId? reportWithId = await WzamApi.createReport(report.report!,
          onErrorNotification: NotificationModel.simple(
              "Report Upload Failed", 'Failed to upload Report'));

      if (reportWithId != null) {
        await _deleteLocalReport(report);
        return true;
      }
    } else {
      bool reportPatch = await WzamApi.updateReport(report.reportPatch!,
          onErrorNotification: NotificationModel.simple(
              "Report Upload Failed", 'Failed to upload Report'));

      if (reportPatch) {
        await _deleteLocalReport(report);
        return true;
      }
    }
    return false;
  }

  Future _deleteLocalReport(MixedReportLocal report) async {
    String path =
        await _getDownloadsDirectory(subdirectory: localReportDirectory) ?? "";
    final dir = Directory(path);
    if (!dir.existsSync()) {
      return;
    }
    dir.listSync().forEach((file) {
      if (file is File) {
        if (file.path.contains(report.name)) {
          file.deleteSync();
        }
      }
    });
    await refreshLocalUploadState();
  }

  Future _deleteLocalRecording(Recording recording) async {
    String path =
        await _getDownloadsDirectory(subdirectory: localRecordingDirectory) ??
            "";
    final dir = Directory(path);
    if (!dir.existsSync()) {
      return;
    }
    dir.listSync().forEach((file) {
      if (file is File) {
        if (file.path.contains(recording.name)) {
          file.deleteSync();
        }
      }
    });
    await refreshLocalUploadState();
  }

  List<Recording> _convertFilesToRecordings(List<File> files) {
    List<Recording> recordings = [];
    for (File file in files) {
      String recordingJson = file.readAsStringSync();
      Map<String, dynamic> reportMap = jsonDecode(recordingJson);
      Recording report = Recording.fromJson(reportMap);
      recordings.add(report);
    }
    return recordings;
  }
}
