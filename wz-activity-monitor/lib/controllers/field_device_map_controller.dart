import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:wzam/models/field_device_type.dart';
import 'package:wzam/models/mappable_field_device.dart';
import 'package:wzam/models/position_extensions.dart';
import 'package:wzam/models/wrappers/field_device_reading.dart';
import 'package:wzam/services/cache_service.dart';
import 'package:wzam/services/location_service.dart';
import 'package:wzam/ui/styles/screen_size.dart';
import 'package:wzam/ui/styles/spacing.dart';
import 'package:wzam/ui/styles/text_styles.dart';
import 'package:wzam/ui/styles/widgets/wzam_text.dart';

class FieldDeviceMapController extends GetxController {
  MapController? mapController;
  LocationService locationService = Get.find<LocationService>();
  CacheService cacheService = Get.find<CacheService>();
  List<StreamSubscription> subscriptions = [];
  List<MappableFieldDevice> completeFieldDeviceList = [];
  Rx<Marker?> userMarker = Rx<Marker?>(null);
  RxList<String> selectedFieldDeviceIds = RxList<String>([]);
  Rx<MarkerLayer> markerLayer = Rx<MarkerLayer>(MarkerLayer(markers: []));

  RxList<FieldDeviceReading> fieldDevices = <FieldDeviceReading>[].obs;
  RxList<MappableFieldDevice> mappableFieldDevices = <MappableFieldDevice>[].obs;
  RxDouble currentZoom = (14.0).obs;
  RxBool isMapFollowingWorker = true.obs;


  //filters
  RxMap<String, RxBool> deviceTypeFilters = <String, RxBool>{}.obs;
  RxMap<String, RxBool> manufacturerFilters = <String, RxBool>{}.obs;
  RxBool isUnlinked = true.obs;
  RxBool isLinked = true.obs;


  Future<void> initialize(
      {required List<String> selectedFieldDevices}) async {
    selectedFieldDeviceIds.addAll(selectedFieldDevices);

    subscriptions.forEach((subscription) => subscription.cancel());
    subscriptions.clear();
    subscriptions.add(cacheService.fieldDevices.listen((fieldDevices) {
      updateFieldDeviceData(fieldDevices.values.toList());
    }));
    await cacheService.updateFieldDevices();

    updateMarkerLayer();
  }

  void updateMarkerLayer() {  
    List<Marker> markers = <Marker>[];
    Position? position = locationService.currentPosition.value;
    if (position != null) {
      markers.add(_createUserMaker(position));
    }
    for (MappableFieldDevice fieldDevice in mappableFieldDevices) {
      if (fieldDevice.marker.marker != null) {
        if (selectedFieldDeviceIds.contains(fieldDevice.id)){
          bool isNotFilteredOut = checkFilters(fieldDevice);
          if (isNotFilteredOut) {
            markers.addAll(fieldDevice.selectedMarker?.marker ?? []);
          }
        } else {
          bool isNotFilteredOut = checkFilters(fieldDevice);
          if (isNotFilteredOut) {
            markers.addAll(fieldDevice.marker.marker!);
          }
        }
      } 
    }
    markerLayer.value = MarkerLayer(markers: markers, rotate: true);
  }

  bool checkFilters(MappableFieldDevice fieldDevice) {
    bool deviceTypeFilter = deviceTypeFilters[fieldDevice.deviceType.name]?.value ?? true;
    bool manufacturerFilter = manufacturerFilters[fieldDevice.make]?.value ?? true;
    bool linkedStatusFilter = (isLinked.value && fieldDevice.fieldDevice.roadEventId != 0) ||
        (isUnlinked.value && fieldDevice.fieldDevice.roadEventId == 0);
    return deviceTypeFilter && manufacturerFilter && linkedStatusFilter;
  }

  void onObjectTap(String id) {
    if (selectedFieldDeviceIds.contains(id)) {
      // If the ID is already selected, remove it
      selectedFieldDeviceIds.remove(id);
    } else {
      // Otherwise, add it to the selection
      selectedFieldDeviceIds.add(id);
    }
    updateMarkerLayer();
  }

  Future<void> updateFieldDeviceData(List<FieldDeviceReading> updatedFieldDevices) async {
    List<FieldDeviceReading> fieldDevicesNoAvl = updatedFieldDevices.where((device) => device.device.coreDetails.make != "WYDOT AVL").toList();
    fieldDevices.value = fieldDevicesNoAvl;
    mappableFieldDevices.value = getFieldDeviceMarkersData();
    manufacturerFilters.value = {};
    for (MappableFieldDevice device in mappableFieldDevices) {
      String manufacturer = device.make;
      if (!manufacturerFilters.containsKey(manufacturer)) {
        manufacturerFilters[manufacturer] = true.obs;
      }
      String deviceType = device.deviceType.name;
      if (!deviceTypeFilters.containsKey(deviceType)) {
        deviceTypeFilters[deviceType] = true.obs;
      }
    }
    updateMarkerLayer();
  }

  List<MappableFieldDevice> getFieldDeviceMarkersData() {
    List<MappableFieldDevice> markerDataList = [];
    for (FieldDeviceReading fieldDevice in fieldDevices) {
      void onTap(String id) {
        onObjectTap(id);
      }

      MappableFieldDevice mappableFieldDevice = MappableFieldDevice.fromFieldDevice(
        fieldDevice, onMarkerTap: onTap
      );
      markerDataList.add(mappableFieldDevice);
    }
    return markerDataList;
  }

  Widget markerShownButton(MappableFieldDevice item) {
    Color iconColor = Colors.orange;
    return GestureDetector(
        child: Icon(Icons.circle, color: iconColor),
        onTap: () {
          Get.dialog(_selectRoadEventDialog(item));
        });
  }

  Widget markerHiddenButton(MappableFieldDevice item) {
    return GestureDetector(
        child: const Icon(Icons.circle, color: Colors.transparent),
        onTap: () {
          Get.dialog(_selectRoadEventDialog(item));
        });
  }

  Marker _createUserMaker(Position position) {
    return Marker(
        point: position.getLatLng(),
        child: Image.asset('assets/images/location_with_border.png',
            width: 25.0, height: 25.0),
        rotate: true);
  }

  RichText _formattedText(String name, String content, BuildContext context) {
    return RichText(
        text: TextSpan(children: [
      TextSpan(
          text: "$name: ",
          style: styleBody.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).textTheme.bodySmall?.color ??
                  Colors.black)),
      TextSpan(
          text: content,
          style: styleBody.copyWith(
              color:
                  Theme.of(context).textTheme.bodySmall?.color ?? Colors.black))
    ]));
  }

  Dialog _selectRoadEventDialog(MappableFieldDevice fieldDevice) {
    BuildContext context = Get.context!;

    // Format the DateTime objects
    String formattedUpdateDate =
        DateFormat.yMd().add_jm().format(fieldDevice.lastUpdated);
    return Dialog(
      insetPadding: const EdgeInsets.all(40.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
        side: const BorderSide(color: Colors.black, width: 1.0),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: screenWidth(context) * 0.8,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                            "${fieldDevice.deviceType.name}: ${fieldDevice.fieldDevice.coreDetails.name.toUpperCase()}",
                            style:
                                styleTwo.copyWith(
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                    verticalSpaceSmall,
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 1.0),
                      ),
                    ),
                    verticalSpaceSmall,
                  ],
                ),
              ),
              SizedBox(
                width: screenWidth(context) * 0.6,
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    _formattedText(
                        "Name", fieldDevice.deviceType.name, context),
                    _formattedText(
                        "Description", fieldDevice.description, context),
                    _formattedText(
                        "Last Updated", formattedUpdateDate, context),
                    verticalSpaceSmall,
                  ],
                ),
              ),
              verticalSpaceSmall,
              Align(
                alignment: Alignment.bottomRight,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ClickableText(
                      text: "Select This Field Device",
                      onTap: () {
                        Get.back(result: fieldDevice);
                      },
                    ),
                    Expanded(child: Container()),
                    ClickableText(
                      text: "Close",
                      onTap: () => Get.back(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
