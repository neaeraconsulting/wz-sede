import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart' as map;
import 'package:wzam/controllers/dashboard_controller.dart';
import 'package:wzam/models/wrappers/road_event_wrapper.dart';
import 'package:wzam/models/wrappers/road_sub_event_wrapper.dart';
import 'package:wzam/ui/styles/app_colors.dart';
import 'package:wzam/ui/styles/spacing.dart';

const int _initialLineStringPointCount = 20;
const int _lineStringPointPageSize = 50;

class DashboardRoadEventInfoWidget extends StatelessWidget {
  final RoadEventWrapper roadEventWrapper;

  const DashboardRoadEventInfoWidget({
    super.key,
    required this.roadEventWrapper,
  });

  @override
  Widget build(BuildContext context) {
    final roadEvent = roadEventWrapper.roadEvent;
    final roadSubEvents = roadEventWrapper.roadSubEvents;
    final observations = roadEventWrapper.observations ?? <Map<String, dynamic>>[];

    return Theme(
      data: Theme.of(context).copyWith(
        dividerColor: Colors.black,
        expansionTileTheme: ExpansionTileThemeData(
          iconColor: textPrimaryColor,
          collapsedIconColor: textPrimaryColor,
          textColor: textPrimaryColor,
          collapsedTextColor: textPrimaryColor,
          backgroundColor: extraLightGrey,
          collapsedBackgroundColor: extraLightGrey,
        ),
      ),
      child: DefaultTextStyle(
        style: TextStyle(color: textPrimaryColor),
        child: IconTheme(
          data: IconThemeData(color: textPrimaryColor),
          child: SelectableRegion(
            focusNode: FocusNode(),
            selectionControls: MaterialTextSelectionControls(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  roadEvent.name.toUpperCase(),
                  style: TextStyle(
                    color: textPrimaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
                verticalSpaceSmall,
                ExpansionTile(
                  initiallyExpanded: true,
                  title: _sectionTitle('Road Event Properties'),
                  children: [
                    _kv('ID', roadEvent.id.toString()),
                    _kv('Name', roadEvent.name),
                    _kv('Description',
                        roadEvent.hasDescription() ? roadEvent.description : 'None'),
                    _kv(
                        'Status',
                        roadEvent.status.name
                            .toString()
                            .replaceAll('ROAD_EVENT_ACTIVE_STATUS_', '')),
                    _kv('Start Date', _formatProtoTimestamp(roadEvent.startDate)),
                    _kv('End Date',
                        roadEvent.hasEndDate() ? _formatProtoTimestamp(roadEvent.endDate) : 'Ongoing'),
                    _kv(
                        'Area Type',
                        roadEvent.areaType.name
                            .toString()
                            .replaceAll('WORK_ZONE_TYPE_', '')),
                    _kv(
                      'Types of Work',
                      roadEvent.typesOfWork.isEmpty
                          ? 'None'
                          : roadEvent.typesOfWork
                              .map((v) => v.typeName)
                              .join(', ')
                              .replaceAll('WORK_TYPE_NAME_', ''),
                    ),
                    _kv(
                      'Default Schedule',
                      roadEvent.hasDefaultSchedule()
                          ? _formatJson(roadEvent.defaultSchedule.toProto3Json())
                          : 'None',
                    ),
                    _kv(
                      'Linked Field Device IDs',
                      roadEvent.linkedFieldDeviceIds.isEmpty
                          ? 'None'
                          : roadEvent.linkedFieldDeviceIds.join(', '),
                    ),
                    if (roadEvent.hasLineString())
                      _LineStringPointsTile(
                        pointCount:
                            roadEvent.lineString.coordinates.coordinates.length,
                        titleBuilder: (visibleCount) => _sectionTitle(
                          'Line String Points (${roadEvent.lineString.coordinates.coordinates.length})'
                          '${visibleCount < roadEvent.lineString.coordinates.coordinates.length ? ' - showing $visibleCount' : ''}',
                        ),
                        pointRowBuilder: (i) => _pointRow(
                          'Point ${i + 1}',
                          map.LatLng(
                            roadEvent
                                .lineString.coordinates.coordinates[i].latitude,
                            roadEvent.lineString.coordinates.coordinates[i]
                                .longitude,
                          ),
                        ),
                      ),
                  ],
                ),
                ExpansionTile(
                  title: _sectionTitle('Road Sub Events (${roadSubEvents.length})'),
                  children: [
                    if (roadSubEvents.isEmpty)
                      _kv('Info', 'No road sub events available')
                    else
                      for (final roadSubEventWrapper in roadSubEvents)
                        _buildRoadSubEventTile(roadSubEventWrapper),
                  ],
                ),
                ExpansionTile(
                  title: _sectionTitle('Observations (${observations.length})'),
                  children: [
                    if (observations.isEmpty)
                      _kv('Info', 'No observations available')
                    else
                      for (final observation in observations)
                        _buildObservationTile(observation),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoadSubEventTile(RoadSubEventWrapper wrapper) {
    final roadSubEvent = wrapper.roadSubEvent;
    final layerTitle = _layerSummary(roadSubEvent);
    final routeId = roadSubEvent.routeId;
    final milepostRange = _formatMilepostRange(
      roadSubEvent.beginningMilepost,
      roadSubEvent.endingMilepost,
    );

    return ExpansionTile(
      title: _sectionTitle('$layerTitle | $routeId | $milepostRange'),
      children: [
        _kv('ID', roadSubEvent.id.toString()),
        _kv('Layer Type', _layerType(roadSubEvent)),
        ..._layerDetails(roadSubEvent),
        _kv('Beginning Milepost', roadSubEvent.beginningMilepost.toStringAsFixed(2)),
        _kv('Ending Milepost', roadSubEvent.endingMilepost.toStringAsFixed(2)),
        _kv('Route ID', roadSubEvent.routeId),
        _kv(
            'Direction',
            roadSubEvent.direction.name
                .toString()
                .replaceAll('ROADWAY_DIRECTION_', '')),
        _kv('Road Names', roadSubEvent.roadNames.isEmpty ? 'None' : roadSubEvent.roadNames.join(', ')),
        _kv('Beginning Cross Street',
            roadSubEvent.hasBeginningCrossStreet() ? roadSubEvent.beginningCrossStreet : 'None'),
        _kv('Ending Cross Street',
            roadSubEvent.hasEndingCrossStreet() ? roadSubEvent.endingCrossStreet : 'None'),
        _kv('Start Location Type',
            roadSubEvent.hasStartLocationType()
                ? roadSubEvent.startLocationType.name
                    .toString()
                    .replaceAll('MARKED_LOCATION_TYPE_', '')
                : 'None'),
        _kv('End Location Type',
            roadSubEvent.hasEndLocationType()
                ? roadSubEvent.endLocationType.name
                    .toString()
                    .replaceAll('MARKED_LOCATION_TYPE_', '')
                : 'None'),
        _kv('Schedule', roadSubEvent.hasSchedule() ? _formatJson(roadSubEvent.schedule.toProto3Json()) : 'None'),
        if (roadSubEvent.hasLineString())
          _LineStringPointsTile(
            pointCount: roadSubEvent.lineString.coordinates.coordinates.length,
            titleBuilder: (visibleCount) => _sectionTitle(
              'Line String Points (${roadSubEvent.lineString.coordinates.coordinates.length})'
              '${visibleCount < roadSubEvent.lineString.coordinates.coordinates.length ? ' - showing $visibleCount' : ''}',
            ),
            pointRowBuilder: (i) => _pointRow(
              'Point ${i + 1}',
              map.LatLng(
                roadSubEvent.lineString.coordinates.coordinates[i].latitude,
                roadSubEvent.lineString.coordinates.coordinates[i].longitude,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildObservationTile(Map<String, dynamic> observation) {
    final source = _safeString(observation['source']);
    final type = _safeString(observation['type']);
    final routeAndMeasureRange = _extractRouteAndMeasureRange(observation);
    final routeId = _safeString(routeAndMeasureRange['routeId']);
    final startMeasure =
        _safeStringForDouble(routeAndMeasureRange['startMeasure'], 2);
    final endMeasure =
        _safeStringForDouble(routeAndMeasureRange['endMeasure'], 2);

    final startPoint = _extractStartPoint(observation);
    final endPoint = _extractEndPoint(observation);

    return ExpansionTile(
      title: _sectionTitle('$source | $type | $routeId $startMeasure-$endMeasure'),
      children: [
        _kv('Source ID', _safeString(observation['sourceId'])),
        _kv('Update ID', _safeString(observation['updateId'])),
        _kv('Source', source),
        _kv('Type', type),
        _kv('Timestamp', _formatDateTime(observation['timestamp'])),
        _kv('Last Updated', _formatDateTime(observation['lastUpdated'])),
        _kv('Valid From', _formatDateTime(observation['validFrom'])),
        _kv('Valid To', _formatDateTime(observation['validTo'])),
        _kv('Confidence', _safeString(observation['confidence'])),
        _kv('Route ID', routeId),
        _kv('Mileposts', '$startMeasure - $endMeasure'),
        _pointRow('Start Point', startPoint),
        _pointRow('End Point', endPoint),
        _kv('Value', _formatJson(observation['value'])),
      ],
    );
  }

  Widget _pointRow(String label, map.LatLng? point) {
    if (point == null) {
      return _kv(label, 'None');
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 145, child: Text('$label:')),
          Expanded(
            child: Text(
              '${point.longitude.toStringAsFixed(6)}, ${point.latitude.toStringAsFixed(6)}',
              style: TextStyle(color: textPrimaryColor),
            ),
          ),
          OutlinedButton(
            onPressed: () => _centerMap(point.latitude, point.longitude),
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(28, 28),
              padding: EdgeInsets.zero,
              visualDensity: VisualDensity.compact,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Icon(Icons.map, size: 16, color: textPrimaryColor),
          ),
        ],
      ),
    );
  }

  void _centerMap(double latitude, double longitude) {
    final controller = Get.find<DashboardController>();
    controller.mapController?.move(
      map.LatLng(latitude, longitude),
      controller.currentZoom.value,
    );
  }

  String _layerType(dynamic roadSubEvent) {
    if (roadSubEvent.hasBaseLayer()) {
      return 'BASE_LAYER';
    }
    if (roadSubEvent.hasSpeedReductionLayer()) {
      return 'SPEED_REDUCTION_LAYER';
    }
    if (roadSubEvent.hasWorkerPresenceLayer()) {
      return 'WORKER_PRESENCE_LAYER';
    }
    return 'UNKNOWN';
  }

  String _layerSummary(dynamic roadSubEvent) {
    if (roadSubEvent.hasBaseLayer()) {
      return 'Base: ${roadSubEvent.baseLayer.vehicleImpact.name.toString().replaceAll('VEHICLE_IMPACT_', '')}';
    }
    if (roadSubEvent.hasSpeedReductionLayer()) {
      final mph = roadSubEvent.speedReductionLayer.reducedSpeedLimitKph * 0.621371;
      return 'Speed: ${mph.toStringAsFixed(0)} MPH';
    }
    if (roadSubEvent.hasWorkerPresenceLayer()) {
      return 'Workers Present';
    }
    return 'Layer: Unknown';
  }

  List<Widget> _layerDetails(dynamic roadSubEvent) {
    if (roadSubEvent.hasBaseLayer()) {
      return [
        _kv(
            'Vehicle Impact',
            roadSubEvent.baseLayer.vehicleImpact.name
                .toString()
                .replaceAll('VEHICLE_IMPACT_', '')),
        _kv('Lanes',
            roadSubEvent.baseLayer.lanes.isEmpty
                ? 'None'
                : roadSubEvent.baseLayer.lanes
                    .map((v) => v.toProto3Json().toString())
                    .join(', ')
                    .replaceAll('LANE_STATUS_', '')),
        _kv('Restrictions', roadSubEvent.baseLayer.restrictions.isEmpty
            ? 'None'
            : roadSubEvent.baseLayer.restrictions.map((v) => v.toProto3Json().toString()).join(', ')),
      ];
    }
    if (roadSubEvent.hasSpeedReductionLayer()) {
      final mph = roadSubEvent.speedReductionLayer.reducedSpeedLimitKph * 0.621371;
      return [_kv('Reduced Speed Limit', '${mph.toStringAsFixed(0)} MPH')];
    }
    if (roadSubEvent.hasWorkerPresenceLayer()) {
      return [
        _kv('Worker Presence',
            _formatJson(roadSubEvent.workerPresenceLayer.workerPresence.toProto3Json())),
      ];
    }
    return <Widget>[];
  }

  Map<String, dynamic> _extractRouteAndMeasureRange(Map<String, dynamic> observation) {
    final dynamic range =
        observation['routeAndMeasureRange'] ?? observation['RouteAndMeasureRange'];
    if (range is Map<String, dynamic>) {
      return range;
    }
    if (range is Map) {
      return Map<String, dynamic>.from(range);
    }
    return <String, dynamic>{};
  }

  map.LatLng? _extractStartPoint(Map<String, dynamic> observation) {
    final dynamic rawGeometry = observation['rawGeometry'];
    if (rawGeometry is Map) {
      final dynamic first = rawGeometry['first'] ?? rawGeometry['start'];
      return _parsePoint(first);
    }
    if (rawGeometry is List && rawGeometry.isNotEmpty) {
      return _parsePoint(rawGeometry.first);
    }
    return null;
  }

  map.LatLng? _extractEndPoint(Map<String, dynamic> observation) {
    final dynamic rawGeometry = observation['rawGeometry'];
    if (rawGeometry is Map) {
      final dynamic second = rawGeometry['second'] ?? rawGeometry['end'];
      return _parsePoint(second);
    }
    if (rawGeometry is List && rawGeometry.length > 1) {
      return _parsePoint(rawGeometry[1]);
    }
    return null;
  }

  map.LatLng? _parsePoint(dynamic value) {
    if (value is Map) {
      final dynamic latValue = value['latitude'] ?? value['lat'];
      final dynamic lngValue = value['longitude'] ?? value['lng'];
      final double? lat = _toDouble(latValue);
      final double? lng = _toDouble(lngValue);
      if (lat != null && lng != null) {
        return map.LatLng(lat, lng);
      }
    }
    return null;
  }

  double? _toDouble(dynamic value) {
    if (value is double) {
      return value;
    }
    if (value is int) {
      return value.toDouble();
    }
    if (value is String) {
      return double.tryParse(value);
    }
    return null;
  }

  String _formatMilepostRange(double start, double end) {
    return '${start.toStringAsFixed(2)} - ${end.toStringAsFixed(2)}';
  }

  String _formatDateTime(dynamic value) {
    if (value == null) {
      return 'None';
    }

    DateTime? parsed;
    if (value is int) {
      parsed = value > 1000000000000
          ? DateTime.fromMillisecondsSinceEpoch(value)
          : DateTime.fromMillisecondsSinceEpoch(value * 1000);
    } else if (value is String) {
      parsed = DateTime.tryParse(value);
    } else if (value is DateTime) {
      parsed = value;
    }

    if (parsed == null) {
      return value.toString();
    }

    return DateFormat.yMd().add_jm().format(parsed.toLocal());
  }

  String _formatProtoTimestamp(dynamic timestamp) {
    try {
      final int seconds = timestamp.seconds.toInt();
      return DateFormat.yMd().add_jm().format(
            DateTime.fromMillisecondsSinceEpoch(seconds * 1000),
          );
    } catch (_) {
      return 'None';
    }
  }

  String _formatJson(dynamic value) {
    if (value == null) {
      return 'None';
    }
    if (value is String) {
      return value;
    }
    try {
      return const JsonEncoder.withIndent('  ').convert(value);
    } catch (_) {
      return value.toString();
    }
  }

  String _safeString(dynamic value) {
    if (value == null) {
      return 'None';
    }
    return value.toString();
  }

  String _safeStringForDouble(dynamic value, int numDigits) {
    if (value == null) {
      return 'None';
    }
    if (value is double) {
      return value.toStringAsFixed(numDigits);
    }
    if (value is int) {
      return value.toDouble().toStringAsFixed(numDigits);
    }
    if (value is String) {
      final double? parsed = double.tryParse(value);
      if (parsed != null) {
        return parsed.toStringAsFixed(numDigits);
      }
    }
    return value.toString();
  }

  Widget _kv(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 145,
            child: Text(
              '$label:',
              style: TextStyle(
                color: textPrimaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(color: textPrimaryColor),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Text(
      text,
      style: TextStyle(
        color: textPrimaryColor,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class _LineStringPointsTile extends StatefulWidget {
  final int pointCount;
  final Widget Function(int visibleCount) titleBuilder;
  final Widget Function(int index) pointRowBuilder;

  const _LineStringPointsTile({
    required this.pointCount,
    required this.titleBuilder,
    required this.pointRowBuilder,
  });

  @override
  State<_LineStringPointsTile> createState() => _LineStringPointsTileState();
}

class _LineStringPointsTileState extends State<_LineStringPointsTile> {
  late int _visibleCount;

  @override
  void initState() {
    super.initState();
    _visibleCount = _initialVisibleCount(widget.pointCount);
  }

  @override
  void didUpdateWidget(covariant _LineStringPointsTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.pointCount != oldWidget.pointCount) {
      _visibleCount = _initialVisibleCount(widget.pointCount);
    }
  }

  int _initialVisibleCount(int totalCount) {
    return totalCount < _initialLineStringPointCount
        ? totalCount
        : _initialLineStringPointCount;
  }

  void _loadMore() {
    if (_visibleCount >= widget.pointCount) {
      return;
    }

    setState(() {
      final int nextVisible = _visibleCount + _lineStringPointPageSize;
      _visibleCount =
          nextVisible > widget.pointCount ? widget.pointCount : nextVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    final int hiddenCount = widget.pointCount - _visibleCount;

    return ExpansionTile(
      title: widget.titleBuilder(_visibleCount),
      children: [
        for (int i = 0; i < _visibleCount; i++) widget.pointRowBuilder(i),
        if (hiddenCount > 0)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 6, 16, 10),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    '$hiddenCount more points not rendered yet',
                    style: TextStyle(color: textPrimaryColor),
                  ),
                ),
                OutlinedButton(
                  onPressed: _loadMore,
                  child: Text(
                      'Load ${hiddenCount > _lineStringPointPageSize ? _lineStringPointPageSize : hiddenCount} more'),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
