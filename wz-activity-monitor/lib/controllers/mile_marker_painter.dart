import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MilepostPainter extends CustomPainter {
  final List<dynamic> features;
  final MapCamera camera;

  MilepostPainter(this.features, this.camera);

  @override
  void paint(Canvas canvas, Size size) {
    // Keep track of where we've already drawn to prevent overlaps
    final occupiedSpots = <Rect>[];

    final paintBg = Paint()..color = Colors.white;
    final paintBorder = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    for (var feature in features) {
      final coords = feature['geometry']['coordinates'];
      final String label = feature['properties']['label'] ?? "";
      final latLng = LatLng(coords[1], coords[0]);

      // 1. Convert LatLng to Screen Offset
      final offset = camera.getOffsetFromOrigin(latLng);

      // 2. Culling: Skip if off-screen
      if (offset.dx < 0 || offset.dy < 0 || offset.dx > size.width || offset.dy > size.height) {
        continue;
      }

      // 3. Prepare Text
      final textPainter = TextPainter(
        text: TextSpan(
          text: label,
          style: const TextStyle(color: Colors.black, fontSize: 10, fontWeight: FontWeight.bold),
        ),
        textDirection: TextDirection.ltr,
      )..layout();

      // 4. Collision Detection (Hide Overlapping)
      final rect = Rect.fromCenter(
        center: offset,
        width: textPainter.width + 10,
        height: textPainter.height + 6,
      );
      final rectBbox = Rect.fromCenter(
        center: offset,
        width: textPainter.width + 30,
        height: textPainter.height + 25,
      );

      // Check if this new rect overlaps any existing rects
      bool overlaps = occupiedSpots.any((spot) => spot.overlaps(rect));
      if (overlaps) continue; // Skip drawing this marker

      // 5. Draw the Square and Text
      canvas.drawRect(rect, paintBg);
      canvas.drawRect(rect, paintBorder);
      textPainter.paint(canvas, offset - Offset(textPainter.width / 2, textPainter.height / 2));

      // Add to occupied list to block this area for future markers
      occupiedSpots.add(rectBbox);
    }
  }

  @override
  bool shouldRepaint(covariant MilepostPainter oldDelegate) => 
      oldDelegate.camera != camera || oldDelegate.features != features;
}