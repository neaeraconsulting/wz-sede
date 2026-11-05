import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:latlong2/latlong.dart';
import 'package:wzam/ui/styles/app_colors.dart';

class DashboardCrosshairOverlay extends StatelessWidget {
  const DashboardCrosshairOverlay({
    super.key,
    required this.showCrosshair,
    required this.center,
  });

  final bool showCrosshair;
  final LatLng center;

  @override
  Widget build(BuildContext context) {
    if (!showCrosshair) {
      return const SizedBox.shrink();
    }

    final String value =
        '${center.latitude.toStringAsFixed(6)}, ${center.longitude.toStringAsFixed(6)}';

    return Stack(
      children: [
        Positioned(
          top: 12,
          left: 0,
          right: 0,
          child: Center(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: () async {
                  await Clipboard.setData(ClipboardData(text: value));
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Copied center lat/lng: $value'),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  }
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: extraLightGrey.withValues(alpha: 0.95),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: primaryColor.withValues(alpha: 0.5),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    'Center: $value',
                    style: TextStyle(
                      color: textPrimaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: IgnorePointer(
            child: Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 80,
                    height: 2,
                    color: Colors.black,
                  ),
                  Container(
                    width: 2,
                    height: 80,
                    color: Colors.black,
                  ),
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.9),
                        width: 1,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
