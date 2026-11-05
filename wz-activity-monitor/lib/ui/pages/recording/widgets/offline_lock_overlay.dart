import 'package:flutter/material.dart';
import 'package:wzam/controllers/recording_controller.dart';
import 'package:wzam/services/location_health_monitor_service.dart';

Widget buildRecordingOfflineLockOverlay(
    BuildContext context, RecordingController controller) {
  return Positioned.fill(
    child: Container(
      color: Colors.black.withValues(alpha: 0.72),
      child: Center(
        child: StreamBuilder<int>(
          stream: Stream<int>.periodic(const Duration(seconds: 1), (x) => x),
          builder: (context, _) {
            final DateTime? lastUpdate = controller.lastLocationUpdate?.value;
            final int secondsSinceLastUpdate = lastUpdate == null
                ? -1
                : DateTime.now().difference(lastUpdate).inSeconds;
            final String lastUpdateText = lastUpdate == null
                ? 'No location update received in this session'
                : lastUpdate.toLocal().toString();
            final String reasonText =
                locationHealthReasonMessage(controller.locationHealthReason.value);
            final String guidance =
                locationHealthReasonGuidance(controller.locationHealthReason.value);

            return Container(
              width: MediaQuery.of(context).size.width * 0.9,
              constraints: BoxConstraints(
                maxWidth: 620,
                maxHeight: MediaQuery.of(context).size.height * 0.85,
              ),
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.red.shade900,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.white70, width: 1.2),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.gps_off, color: Colors.white, size: 26),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Location Offline: Recording Paused',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      reasonText,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 14),
                    _metricRow('Last location update', lastUpdateText),
                    _metricRow(
                        'Seconds since last update',
                        secondsSinceLastUpdate < 0
                            ? 'Unavailable'
                            : '$secondsSinceLastUpdate seconds'),
                    _metricRow('Stale threshold',
                        '${controller.locationStaleThresholdSeconds} seconds'),
                    const SizedBox(height: 14),
                    const Text(
                      'Potential solutions',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _solutionLine(guidance),
                    _solutionLine('Move to an open area with clear sky view.'),
                    _solutionLine(
                        'Ensure device location services are enabled and precise location is allowed.'),
                    _solutionLine(
                        'Disable battery saver/background restrictions for this app.'),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          controller.stopWorkZoneRecording(save: false);
                        },
                        icon: const Icon(Icons.stop_circle_outlined),
                        label: const Text('Quit recording'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.red.shade900,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    ),
  );
}

Widget _metricRow(String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 3),
    child: RichText(
      text: TextSpan(
        style: const TextStyle(color: Colors.white, fontSize: 14),
        children: [
          TextSpan(
            text: '$label: ',
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          TextSpan(text: value),
        ],
      ),
    ),
  );
}

Widget _solutionLine(String text) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 2),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '\u2022 ',
          style: TextStyle(color: Colors.white, fontSize: 14),
        ),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
        ),
      ],
    ),
  );
}
