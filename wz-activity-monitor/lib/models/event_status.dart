import 'package:flutter/material.dart';
import 'package:wzam/ui/styles/app_colors.dart';

enum EventStatus {
  pending,
  active,
  recentlyCompleted, // recently completed within the last 7 days
  concluded;

  static fromDates(DateTime? startDate, DateTime? endDate) {
    if (startDate == null) {
      return EventStatus.pending;
    }
    DateTime currDate = DateTime.now();
    if (startDate.isAfter(currDate)) {
      return EventStatus.pending;
    } else if (endDate == null || currDate.isBefore(endDate)) {
      return EventStatus.active;
    } else if (currDate.isBefore(endDate.add(const Duration(days: 7)))) {
      return EventStatus.recentlyCompleted;
    }
    return EventStatus.concluded;
  }

  static fromMillis(int? startMillis, int? endMillis) {
    if (startMillis == null) {
      return EventStatus.pending;
    }
    DateTime startDate = DateTime.fromMillisecondsSinceEpoch(startMillis);
    DateTime? endDate = endMillis != null
        ? DateTime.fromMillisecondsSinceEpoch(endMillis)
        : null;
    return fromDates(startDate, endDate);
  }

  isPending() {
    return this == EventStatus.pending;
  }

  isRecentlyCompleted() {
    return this == EventStatus.recentlyCompleted;
  }

  isActive() {
    return this == EventStatus.active;
  }

  isConcluded() {
    return this == EventStatus.concluded;
  }
}

/// Extension to add a method that returns the associated text for each enum value.
extension EventStatusExtension on EventStatus {
  String get text => switch (this) {
        EventStatus.pending => 'Pending',
        EventStatus.active => 'Active',
        EventStatus.recentlyCompleted => 'Recently Completed',
        EventStatus.concluded => 'Concluded',
      };

  Color get color => switch (this) {
        EventStatus.pending => const Color.fromARGB(255, 255, 238, 0),
        EventStatus.active => primaryColor,
        EventStatus.recentlyCompleted =>
          const Color.fromARGB(255, 168, 0, 0).withValues(alpha: 0.4),
        EventStatus.concluded => Colors.black,
      };

  IconData get iconData => switch (this) {
        EventStatus.pending => Icons.construction,
        EventStatus.active => Icons.construction,
        EventStatus.recentlyCompleted => Icons.construction,
        EventStatus.concluded => Icons.close,
      };
}
