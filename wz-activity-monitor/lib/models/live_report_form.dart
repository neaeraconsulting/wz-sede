import 'package:wzam/models/live_worker_location.dart';

class LiveReportForm {
  WorkerLocationType locationType;
  bool startActive;

  LiveReportForm({
    required this.locationType,
    required this.startActive,
  });
}
