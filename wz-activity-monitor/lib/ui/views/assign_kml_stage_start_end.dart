part of 'assign_kml_dialog.dart';

mixin AssignKmlStartEndStage on StatelessWidget {
  Widget _stageControlPanel(KmlController controller) {
    return Obx(() {
      final AssignmentStage stage = controller.assignmentStage.value;

      if (stage == AssignmentStage.startEndSelection) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Stage 1/2: Select Road Event Start + End',
                  style: TextStyle(
                    color: textPrimaryColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  controller.roadwayStartPointIndex.value == null
                      ? 'Start: not selected'
                      : 'Start: ${controller.pointDisplayName(controller.roadwayStartPointIndex.value!)}',
                ),
                Text(
                  controller.roadwayEndPointIndex.value == null
                      ? 'End: not selected'
                      : 'End: ${controller.pointDisplayName(controller.roadwayEndPointIndex.value!)}',
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ElevatedButton(
                      onPressed: controller.canAdvanceStartEnd &&
                              !controller.routeResolutionInProgress.value
                          ? () => controller
                              .resolveRoadwayAndAdvanceToMarkingStage()
                          : null,
                      child: controller.canAdvanceStartEnd
                          ? (controller.routeResolutionInProgress.value
                              ? const Text('Resolving...')
                              : const Text('Resolve Route and Continue'))
                          : const Text('Complete Start and End Points'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }

      return Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Stage 2/2: Create Marking Intervals',
                style: TextStyle(
                  color: textPrimaryColor,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text('Route: ${controller.canonicalRouteId.value}'),
              Text(
                  'Resolved points: ${controller.orderedResolvedPointIndexes.length} | Excluded: ${controller.excludedPointCount}'),
              if (controller.isSelectingInterval) ...[
                const SizedBox(height: 6),
                Text(
                  controller.activeIntervalSelectionPhase.value ==
                          IntervalSelectionPhase.selectStart
                      ? 'Select START for ${controller.activeIntervalType.value!.label}'
                      : 'Select END for ${controller.activeIntervalType.value!.label}',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ],
          ),
        ),
      );
    });
  }
}
