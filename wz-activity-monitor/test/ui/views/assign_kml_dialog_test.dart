import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:wzam/ui/views/assign_kml_dialog.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('marker selection stays active when the map tap handler runs next', () {
    final controller = KmlController();
    controller.mappableKmlPoints.add(
      MappableKmlPoint(
        description: 'Test point',
        point: const LatLng(45.0, -93.0),
      ),
    );

    controller.selectPointFromMarker(0);

    expect(controller.selectedObjectId.value, 0);

    controller.handleMapTap();

    expect(controller.selectedObjectId.value, 0);
  });

  test(
      'selecting the first interval point previews the start marker immediately',
      () {
    final controller = KmlController();
    controller.assignmentStage.value = AssignmentStage.intervalMarking;
    controller.activeIntervalType.value = IntervalMarkingType.speedLimit;
    controller.activeIntervalSelectionPhase.value =
        IntervalSelectionPhase.selectStart;
    controller.resolvedRankByPoint[0] = 0;
    controller.mappableKmlPoints.add(
      MappableKmlPoint(
        description: 'Zone start',
        point: const LatLng(45.0, -93.0),
      ),
    );

    controller.selectPointFromMarker(0);

    expect(controller.activeIntervalSelectionPhase.value,
        IntervalSelectionPhase.selectEnd);
    expect(controller.intervalSelectionPreviewCategories[0],
        WaypointCategory.speedLimitMarker);
    expect(controller.effectivePointCategory(0),
        WaypointCategory.speedLimitMarker);
    expect(controller.intervalSelectionInstruction,
        'Select the end point for this zone.');
  });

  test('point can have multiple zone categories at the same time', () {
    final controller = KmlController();
    controller.mappableKmlPoints.add(
      MappableKmlPoint(
        description: 'Overlap point',
        point: const LatLng(45.0, -93.0),
      ),
    );
    controller.mappableKmlPoints[0].categories
      ..add(WaypointCategory.startWorkerZone)
      ..add(WaypointCategory.laneClosed);

    final categories = controller.effectivePointCategories(0);
    expect(categories.contains(WaypointCategory.startWorkerZone), isTrue);
    expect(categories.contains(WaypointCategory.laneClosed), isTrue);
  });
}
