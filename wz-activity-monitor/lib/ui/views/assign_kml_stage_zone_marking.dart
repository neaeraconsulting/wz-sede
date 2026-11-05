part of 'assign_kml_dialog.dart';

mixin AssignKmlZoneMarkingStage on StatelessWidget {
  IconData _intervalTypeIcon(IntervalMarkingType? type) {
    switch (type) {
      case IntervalMarkingType.speedLimit:
        return Icons.speed;
      case IntervalMarkingType.workerPresence:
        return Icons.engineering;
      case IntervalMarkingType.laneClosure:
        return Icons.do_not_disturb_on;
      case null:
        return Icons.info_outline;
    }
  }

  Widget _zoneActionBar(KmlController controller) {
    return Obx(() {
      if (controller.assignmentStage.value != AssignmentStage.intervalMarking) {
        return const SizedBox.shrink();
      }

      final IntervalMarkingType? activeType =
          controller.activeIntervalType.value;
      final IntervalSelectionPhase? selectionPhase =
          controller.activeIntervalSelectionPhase.value;
      final bool selectingInterval =
          activeType != null && selectionPhase != null;

      return Card(
        color: Colors.white.withValues(alpha: 0.94),
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final double availableWidth =
                  constraints.maxWidth.isFinite ? constraints.maxWidth : 900;

              final double actionButtonWidth;
              if (availableWidth < 520) {
                actionButtonWidth = availableWidth;
              } else if (availableWidth < 920) {
                actionButtonWidth = (availableWidth - 8) / 2;
              } else {
                actionButtonWidth = 220;
              }

              if (selectingInterval) {
                final String zoneTypeTitle = activeType.label;
                final IconData zoneTypeIcon = _intervalTypeIcon(activeType);
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        color: extraLightGrey,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.black12,
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                zoneTypeIcon,
                                size: 18,
                                color: textPrimaryColor,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'Selecting: $zoneTypeTitle',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            controller.intervalSelectionInstruction,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: controller.cancelIntervalSelection,
                      child: const Text('Cancel Selection'),
                    ),
                  ],
                );
              }

              return Wrap(
                alignment: WrapAlignment.center,
                spacing: 8,
                runSpacing: 8,
                children: [
                  SizedBox(
                    width: actionButtonWidth,
                    child: OutlinedButton(
                      onPressed: () => controller.startIntervalSelection(
                          IntervalMarkingType.speedLimit),
                      child: const Text('Add Speed Reduction'),
                    ),
                  ),
                  SizedBox(
                    width: actionButtonWidth,
                    child: OutlinedButton(
                      onPressed: () => controller.startIntervalSelection(
                          IntervalMarkingType.workerPresence),
                      child: const Text('Add Worker Presence'),
                    ),
                  ),
                  SizedBox(
                    width: actionButtonWidth,
                    child: OutlinedButton(
                      onPressed: () => controller.startIntervalSelection(
                          IntervalMarkingType.laneClosure),
                      child: const Text('Add Lane Closure'),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      );
    });
  }

  Widget _zoneSummaryOverlay(KmlController controller,
      {double maxWidth = 360}) {
    return Obx(() {
      if (controller.assignmentStage.value != AssignmentStage.intervalMarking) {
        return const SizedBox.shrink();
      }

      return SizedBox(
        width: maxWidth,
        child: Card(
          color: Colors.white.withValues(alpha: 0.94),
          margin: EdgeInsets.zero,
          child: ExpansionTile(
            initiallyExpanded: true,
            title: Text(
              'Zone Summary (${controller.intervalMarkings.length})',
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            children: [
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 220),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 10),
                  child: _intervalSummaryPanel(controller),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _stageTopRightPanel(
    KmlController controller, {
    required double rightRegionLeft,
    required double actionBarWidth,
  }) {
    return Positioned(
      top: 14,
      right: 16,
      left: rightRegionLeft,
      child: Obx(() {
        final AssignmentStage stage = controller.assignmentStage.value;
        bool hasStageControls = false;
        Widget stageControls = const SizedBox.shrink();

        if (stage == AssignmentStage.intervalMarking) {
          hasStageControls = true;
          stageControls = SizedBox(
            width: actionBarWidth,
            child: _zoneActionBar(controller),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            stageControls,
            if (hasStageControls) const SizedBox(height: 8),
            _milepostToggleChip(controller),
          ],
        );
      }),
    );
  }

  Widget _milepostToggleChip(KmlController controller) {
    return Obx(
      () => OutlinedButton.icon(
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.white.withValues(alpha: 0.92),
        ),
        onPressed: () {
          controller.showMilepostsInLabels.value =
              !controller.showMilepostsInLabels.value;
        },
        icon: Icon(
          controller.showMilepostsInLabels.value
              ? Icons.straighten
              : Icons.straighten_outlined,
          size: 18,
        ),
        label: Text(
          controller.showMilepostsInLabels.value ? 'MP On' : 'MP Off',
        ),
      ),
    );
  }

  Widget _primaryStageActionButton(KmlController controller) {
    return Obx(() {
      final AssignmentStage stage = controller.assignmentStage.value;

      if (stage == AssignmentStage.startEndSelection) {
        return ElevatedButton(
          onPressed: controller.canAdvanceStartEnd &&
                  !controller.routeResolutionInProgress.value
              ? () async {
                  await controller.resolveRoadwayAndAdvanceToMarkingStage();
                }
              : null,
          child: controller.canAdvanceStartEnd
              ? (controller.routeResolutionInProgress.value
                  ? const Text('Resolving...')
                  : const Text('Resolve Route and Continue'))
              : const Text('Complete Start and End Points'),
        );
      }

      return ElevatedButton(
        onPressed: controller.uploadInProgress.value
            ? null
            : () async {
                bool isValid = controller.checkIfValid();
                if (isValid) {
                  await controller.uploadRecording();
                }
              },
        child: controller.uploadInProgress.value
            ? const Text('Uploading...')
            : const Text('Save and Publish'),
      );
    });
  }

  Widget _stageBottomRightPanel(
    KmlController controller, {
    required double rightRegionLeft,
    required double summaryWidth,
  }) {
    return Positioned(
      right: 20,
      bottom: 84,
      left: rightRegionLeft,
      child: Align(
        alignment: Alignment.bottomRight,
        child: Obx(() {
          if (controller.assignmentStage.value ==
              AssignmentStage.intervalMarking) {
            return _zoneSummaryOverlay(
              controller,
              maxWidth: summaryWidth,
            );
          }
          return const SizedBox.shrink();
        }),
      ),
    );
  }

  Widget _intervalSummaryPanel(KmlController controller) {
    return Obx(() {
      if (controller.assignmentStage.value != AssignmentStage.intervalMarking) {
        return const SizedBox.shrink();
      }

      final intervals = controller.intervalMarkings;
      if (intervals.isEmpty) {
        return const Text('No zones added yet.');
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...List<Widget>.generate(intervals.length, (index) {
            final interval = intervals[index];
            final String startName =
                controller.pointDisplayName(interval.startPointIndex);
            final String endName =
                controller.pointDisplayName(interval.endPointIndex);
            return Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: extraLightGrey,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            '${index + 1}. ${controller.intervalTypeSummary(interval)}',
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                        IconButton(
                          tooltip: 'Delete zone',
                          visualDensity: VisualDensity.compact,
                          icon: const Icon(
                            Icons.delete_outline,
                            size: 18,
                            color: Colors.redAccent,
                          ),
                          onPressed: () => controller.deleteIntervalAt(index),
                        ),
                      ],
                    ),
                    Text(controller.intervalPropertySummary(interval)),
                    Text(controller.intervalMilepostRangeSummary(interval)),
                    Text('From: $startName'),
                    Text('To: $endName'),
                  ],
                ),
              ),
            );
          }),
        ],
      );
    });
  }
}
