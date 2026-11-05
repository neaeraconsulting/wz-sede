import 'package:flutter/material.dart';
import 'package:wzam/services/location_health_monitor_service.dart';

class LocationHealthBanner extends StatelessWidget {
  const LocationHealthBanner({
    super.key,
    required this.model,
    this.fontSize = 14,
    this.padding = const EdgeInsets.all(12),
    this.compact = false,
  });

  final LocationHealthBannerViewModel model;
  final double fontSize;
  final EdgeInsetsGeometry padding;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final double effectiveFontSize = compact ? fontSize - 2 : fontSize;
    final EdgeInsetsGeometry effectivePadding =
        compact ? const EdgeInsets.symmetric(horizontal: 10, vertical: 8) : padding;
    final double iconSize = compact ? effectiveFontSize + 2 : effectiveFontSize + 4;

    return Container(
      padding: effectivePadding,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6.0),
        color: model.backgroundColor,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(model.icon, color: model.textColor, size: iconSize),
          SizedBox(width: compact ? 6 : 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  model.primaryLine,
                  maxLines: compact ? 2 : 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: effectiveFontSize,
                    fontWeight: FontWeight.bold,
                    color: model.textColor,
                  ),
                ),
                SizedBox(height: compact ? 2 : 4),
                Text(
                  model.secondaryLine,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: effectiveFontSize - 1,
                    fontWeight: FontWeight.w600,
                    color: model.textColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
