import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart' as map;
import 'package:protobuf/protobuf.dart';
import 'package:wzam/controllers/notification_controller.dart';
import 'package:wzam/models/generated/google/type/latlng.pb.dart' as pb;
import 'package:wzam/models/generated/road_event.pb.dart' hide EventRecurrence;
import 'package:wzam/models/generated/road_sub_event.pb.dart';
import 'package:wzam/models/generated/wzdx.pb.dart' as wzdxpb;
import 'package:wzam/models/mixed_report.dart'; 
import 'package:wzam/models/notification_model.dart';
import 'package:wzam/models/pair.dart';
import 'package:wzam/models/report.dart';
import 'package:wzam/models/report_patch.dart';
import 'package:wzam/models/wrappers/road_event_wrapper.dart';
import 'package:wzam/models/wrappers/road_sub_event_wrapper.dart';
import 'package:wzam/models/wzdx_extensions.dart';
import 'package:wzam/models/wzdx_models.dart';
import 'package:wzam/services/auth_service.dart';
import 'package:wzam/services/file_storage.dart';
import 'package:wzam/services/push_notification_service.dart';
import 'package:wzam/services/wzam_api.dart';
import 'package:wzam/ui/pages/home.dart';
import 'package:wzam/ui/styles/app_colors.dart';
import 'package:wzam/ui/pages/field_device_list.dart';
import 'package:wzam/ui/pages/reports/report_location_selection.dart';
import 'package:wzam/ui/styles/screen_size.dart';
import 'package:wzam/ui/styles/spacing.dart';
import 'package:wzam/ui/styles/widgets/wzam_app_bar.dart';
import 'package:intl/intl.dart';

class EditReportPageController extends GetxController {
  late RoadEventWrapper originalRoadEvent;
  RoadSubEvent_BaseLayer? baseLayer;
  RxList<map.LatLng> points = <map.LatLng>[].obs;
  RxList<String> selectedFieldDeviceIds = <String>[].obs;
  Rx<RoadwayDirection?> roadDirection = Rx<RoadwayDirection?>(null);
  RoadwayDirection? originalRoadDirection;
  Rx<int> roadEventId = Rx<int>(0);
  Rx<EventRecurrence?> recurrence = Rx<EventRecurrence?>(null); 
  double lineWidth = 30.0;
  
  RxBool isNew = false.obs;
  RxBool isInitialized = false.obs;


  FileStorageService fileStorageService = Get.find<FileStorageService>();
  AuthService authService = Get.find<AuthService>();
  List<Widget> formFields = [];
  TextEditingController reportNameController = TextEditingController();
  TextEditingController reportDescriptionController =
      TextEditingController();
  Rx<List<Pair<Rx<WorkTypeName?>, Rx<bool>>>> workTypeList =
      Rx<List<Pair<Rx<WorkTypeName?>, Rx<bool>>>>(
          [Pair(Rx<WorkTypeName?>(null), Rx<bool>(false))]);
  RxBool workTypeListChanged = false.obs;
  TextEditingController startDateController = TextEditingController(
      text: DateFormat.yMd().add_jm().format(DateTime.now()));
  TextEditingController endDateController = TextEditingController();
  TextEditingController roadNameController = TextEditingController();
  String originalRoadName = "";


  Rx<DateTime> startDate = Rx<DateTime>(DateTime.now());
  Rx<DateTime?> endDate = Rx<DateTime?>(null);

  PushNotificationService pushNotificationService = Get.find<PushNotificationService>();

  Future<void> initialize({required RoadEventWrapper roadEventWrapper}) async {
    originalRoadEvent = roadEventWrapper;
    if (isInitialized.value) return; // Prevent re-initialization
      RoadEvent roadEvent = roadEventWrapper.roadEvent;
    roadEventId.value = roadEvent.id.toInt();
      reportNameController.text = roadEvent.name;
      reportDescriptionController.text = roadEvent.description;
      startDate.value = roadEvent.startDate.toDateTime();
      startDateController.text =
          DateFormat.yMd().add_jm().format(roadEvent.startDate.toDateTime());
      if (roadEvent.hasEndDate()) {
        endDate.value = roadEvent.endDate.toDateTime();
        endDateController.text =
            DateFormat.yMd().add_jm().format(roadEvent.endDate.toDateTime());
      }
      points.addAll(roadEvent.lineString.coordinates.coordinates.map((coord) => map.LatLng(coord.latitude, coord.longitude)));
      workTypeList.value = [];
      workTypeListChanged.value = false;
      roadEvent.typesOfWork.forEach((workType) {
        workTypeList.value.add(
            Pair(
            Rx<WorkTypeName>(WorkTypeName.fromProto(workType.typeName)),
            Rx<bool>(workType.isArchitecturalChange)));
      });
      baseLayer = roadEventWrapper.roadSubEvents.isNotEmpty
          ? roadEventWrapper.roadSubEvents.first.roadSubEvent.baseLayer
          : null;
      List<RoadSubEventWrapper> subEvents = roadEventWrapper.roadSubEvents;
      if (subEvents.isNotEmpty) {
        for (RoadSubEventWrapper subEventWrapper in subEvents) {
          if (subEventWrapper.roadSubEvent.hasBaseLayer()) {
            baseLayer = subEventWrapper.roadSubEvent.baseLayer;
            break;
          }
        }
        for (RoadSubEventWrapper subEventWrapper in subEvents) {
          PbList<String> roadNames = subEventWrapper.roadSubEvent.roadNames;
          wzdxpb.RoadwayDirection direction = subEventWrapper.roadSubEvent.direction;
          if (roadNames.isNotEmpty) {
            for (String roadName in roadNames) {
              if (roadName.isNotEmpty) {
                originalRoadName += "$roadName, ";
              }
            }
          }
        }
        if (originalRoadName.isNotEmpty) {
          originalRoadName = originalRoadName.substring(0, originalRoadName.length - 2);
          roadNameController.text = originalRoadName;
        }
      }
    
    isInitialized.value = true; // Mark as initialized
  }

  void sendSuccessNotification (String title, String body) {
    pushNotificationService.showSimpleNotification(
      title: title,
      body: body,
      payload: title,
      id: 0,
    );
  }

  Future<void> updateReport(List<List> changes) async {
    // Flatten changes to get field names
    final Set<EditReportField> fieldsToPatch =
        changes.map((c) => c[0] as EditReportField).toSet();
    final id = roadEventId.value;
    final roadEventIdVal = roadEventId.value;
    ReportPatch report = ReportPatch(
      id: id,
      roadEventId: roadEventIdVal,
      timestamp: DateTime.now(),
      userId: (await authService.getUserId())!,
      name: fieldsToPatch.contains(EditReportField.eventName)
          ? reportNameController.text
          : null,
      description: fieldsToPatch.contains(EditReportField.description)
        ? (reportDescriptionController.text != "" ? reportDescriptionController.text : null)
        : null,
      typesOfWork: fieldsToPatch.contains(EditReportField.typesOfWork)
        ? workTypeList.value.where((v) => v.first.value != null).map((v) {
          return TypeOfWork(
            typeName: v.first.value!, isArchitecturalChange: v.last.value);
        }).toList()
        : null,
      roadName: fieldsToPatch.contains(EditReportField.roadName)
        ? (roadNameController.text != "" ? roadNameController.text : null)
        : null,
      direction: fieldsToPatch.contains(EditReportField.roadDirection)
          ? roadDirection.value
          : null,
      startDate: fieldsToPatch.contains(EditReportField.startDate)
          ? startDate.value
          : null,
      endDate: fieldsToPatch.contains(EditReportField.endDate)
          ? endDate.value
          : null,
      geometry:
          fieldsToPatch.contains(EditReportField.location) ? points : null,
      linkedFieldDeviceIds: fieldsToPatch.contains(EditReportField.fieldDevices)
          ? selectedFieldDeviceIds
          : null,
    );

    NotificationController().sendNotificationWithPromise<void>(
      task: () async {
        bool result = await postUpdatedReport(report);
        if (!result) {
          throw Exception("Report upload failed");
        }
      },
      loadingTitle: "Uploading Report",
      loadingMessage: "Please wait while your report is uploaded...",
      successTitle: "Report Uploaded",
      successMessage: "Your report has been successfully uploaded.",
      onErrorSendPushNotification: true,
      errorTitle: "Report Upload Failed",
      errorMessageBuilder: (error) =>
          "There was an error uploading your report. Please try again later.",
    );
    Get.offAll(Home());
  }

  Future<bool> postUpdatedReport(ReportPatch reportPatch) async {
    bool? success = await WzamApi.updateReport(reportPatch);
    if (success) {
      return true;
    } else {
      await fileStorageService
          .saveLocalReport(MixedReportLocal(reportPatch: reportPatch));
      await fileStorageService.refreshLocalUploadState();
    }
    return false;
  }

  getChanges() {
    List<List> changes = [];
    if (reportNameController.text != originalRoadEvent.roadEvent.name) {
      changes.add([EditReportField.eventName, originalRoadEvent.roadEvent.name, reportNameController.text]);
    }  
    if (reportDescriptionController.text != originalRoadEvent.roadEvent.description) {
      changes.add([EditReportField.description, originalRoadEvent.roadEvent.hasDescription() ? originalRoadEvent.roadEvent.description : "", reportDescriptionController.text]);
    }
    if (startDate.value != originalRoadEvent.roadEvent.startDate.toDateTime()) {
      changes.add([EditReportField.startDate, DateFormat.yMd().add_jm().format(originalRoadEvent.roadEvent.startDate.toDateTime()), DateFormat.yMd().add_jm().format(startDate.value)]);
    }
    if (endDate.value != originalRoadEvent.roadEvent.endDate.toDateTime() && endDate.value != null) {
      changes.add([EditReportField.endDate, DateFormat.yMd().add_jm().format(originalRoadEvent.roadEvent.endDate.toDateTime()), DateFormat.yMd().add_jm().format(endDate.value!)]);
    }
    
    Rx<List<Pair<Rx<WorkTypeName?>, Rx<bool>>>> originalWorkTypeList =
      Rx<List<Pair<Rx<WorkTypeName?>, Rx<bool>>>>([]);

    originalRoadEvent.roadEvent.typesOfWork.forEach((workType) {
        originalWorkTypeList.value.add(
            Pair(
            Rx<WorkTypeName>(WorkTypeName.fromProto(workType.typeName)),
            Rx<bool>(workType.isArchitecturalChange)));
      });
    bool workTypeListChanged = false;
    if (originalWorkTypeList.value.length != workTypeList.value.length) {
      workTypeListChanged = true;
    } else {
      for (int i = 0; i < originalWorkTypeList.value.length; i++) {
        if (originalWorkTypeList.value[i].first.value != workTypeList.value[i].first.value ||
            originalWorkTypeList.value[i].last.value != workTypeList.value[i].last.value) {
          workTypeListChanged = true;
          break;
        }
      }
    }
    if (workTypeListChanged) {
      changes.add([EditReportField.typesOfWork, originalWorkTypeList.value.map((v) => "${v.first.value?.displayName} \n(Architectural Change: ${v.last.value})").join(", "), workTypeList.value.map((v) => "${v.first.value?.displayName} (Architectural Change: ${v.last.value})").join(", ")]);
    }
    

    PbList<String> originalFieldDeviceIds = originalRoadEvent.roadEvent.linkedFieldDeviceIds;
    bool fieldDevicesChanged = false;
    if (originalFieldDeviceIds.length != selectedFieldDeviceIds.length) {
      fieldDevicesChanged = true;
    } else {
      for (String id in originalFieldDeviceIds) {
        if (!selectedFieldDeviceIds.contains(id)) {
          fieldDevicesChanged = true;
          break;
        }
      }
    }
    if (fieldDevicesChanged) { 
      changes.add([EditReportField.fieldDevices, originalFieldDeviceIds.join(", "), selectedFieldDeviceIds.join(", ")]);
    }

    if (originalRoadName != roadNameController.text) {
      changes.add([EditReportField.roadName, originalRoadName, roadNameController.text]);
    }

    if (originalRoadDirection.toString() != roadDirection.value.toString()) {
      changes.add([EditReportField.roadDirection, originalRoadDirection.toString().split('.').last, roadDirection.value.toString().split('.').last]);
    }

    //check location change by comparing points
    bool locationChanged = false;
    if (originalRoadEvent.roadEvent.hasLineString() && points.length == originalRoadEvent.roadEvent.lineString.coordinates.coordinates.length) {
      for (int i = 0; i < points.length; i++) {
        pb.LatLng originalPt = originalRoadEvent.roadEvent.lineString.coordinates.coordinates[i];
        if (points[i].latitude != originalPt.latitude || points[i].longitude != originalPt.longitude) {
          locationChanged = true;
          break;
        }
      }
    } else if (points.isNotEmpty || originalRoadEvent.roadEvent.hasLineString()) {
      locationChanged = true;
    }

    if (locationChanged) {
      String oldString = "No location";
      if (originalRoadEvent.roadEvent.hasLineString()) {
        final coords = originalRoadEvent.roadEvent.lineString.coordinates.coordinates;
        if (coords.isNotEmpty) {
          if (coords.length == 1) {
            oldString = "(${coords.first.latitude.toStringAsFixed(4)}, ${coords.first.longitude.toStringAsFixed(4)})";
          } else {
            oldString = "(${coords.first.latitude.toStringAsFixed(4)}, ${coords.first.longitude.toStringAsFixed(4)}) - (${coords.last.latitude.toStringAsFixed(4)}, ${coords.last.longitude.toStringAsFixed(4)})";
          }
        }
      }
      String newString = "No location";
      if (points.isNotEmpty) {
        if (points.length == 1) {
          newString = "(${points.first.latitude.toStringAsFixed(4)}, ${points.first.longitude.toStringAsFixed(4)})";
        } else {
          newString = "(${points.first.latitude.toStringAsFixed(4)}, ${points.first.longitude.toStringAsFixed(4)}) - (${points.last.latitude.toStringAsFixed(4)}, ${points.last.longitude.toStringAsFixed(4)})";
        }
      }
      changes.add([EditReportField.location, oldString, newString]);
    }


    return changes;
  }
}

enum EditReportField {
  eventName,
  description,
  startDate,
  endDate,
  typesOfWork,
  surfaceType,
  vehicleImpact,
  fieldDevices,
  roadName,
  roadDirection,
  areaType,
  location;

  @override
  String toString() {
    switch (this) {
      case EditReportField.eventName:
        return 'Event Name';
      case EditReportField.description:
        return 'Description';
      case EditReportField.startDate:
        return 'Start Date';
      case EditReportField.endDate:
        return 'End Date';
      case EditReportField.typesOfWork:
        return 'Types of Work';
      case EditReportField.surfaceType:
        return 'Surface Type';
      case EditReportField.vehicleImpact:
        return 'Vehicle Impact';
      case EditReportField.fieldDevices:
        return 'Field Devices';
      case EditReportField.roadName:
        return 'Road Name';
      case EditReportField.roadDirection:
        return 'Roadway Direction';
      case EditReportField.areaType:
        return 'Area Type';
      case EditReportField.location:
        return 'Location';
    }
  }
}

class EditReportPage extends StatelessWidget {
  EditReportPageController controller = Get.put(EditReportPageController());
  RoadEventWrapper existingRoadEvent;

  EditReportPage({super.key, required this.existingRoadEvent});
  @override
  Widget build(BuildContext context) {
    controller.initialize(roadEventWrapper: existingRoadEvent);
    return Scaffold(
        appBar: const WZAMAppBar(
          title: "Edit Report",
        ),
        body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Obx(() => Stack(
                    children: [
                      ListView(children: [
                        _sectionTitle("Edit Report",
                            paddingTop: 0,
                            helpText:
                                "Reports are used to quickly and accurately document work zones and events on the roadway."
                                "They keep the TMC operators and automated systems aware of work occurring on the ground, "
                                "so that they can provide accurate information to the traveling public."
                                "\nSubmitted reports will be automatically processed and validated, and are always verified "
                                "by a TMC operator before warning messages are distributed to the traveling public. "),
                        _inputField("Event Name", controller.reportNameController, controller.originalRoadEvent.roadEvent.name,
                            isRequired: true),
                        verticalSpaceMedium,
                        _inputField("Description", controller.reportDescriptionController, controller.originalRoadEvent.roadEvent.hasDescription() ? controller.originalRoadEvent.roadEvent.description : "",
                            isRequired: false),
                        verticalSpaceMedium,
                        _inputField("Start Date", controller.startDateController, DateFormat.yMd().add_jm().format(controller.originalRoadEvent.roadEvent.startDate.toDateTime()),
                            isDate: true,
                            dateStorage: controller.startDate,
                            context: context,
                            isRequired: true, reportPageController: controller),
                        verticalSpaceMedium,
                        _inputField("End Date", controller.endDateController, DateFormat.yMd().add_jm().format(controller.originalRoadEvent.roadEvent.endDate.toDateTime()),
                            isDate: true,
                            dateStorage: controller.endDate,
                            context: context,
                            isRequired: true, reportPageController: controller),
                        verticalSpaceMedium,
                        ...controller.workTypeList.value.asMap().entries.expand((entry) =>
                        _workTypeSegment(
                            context,
                            WorkTypeNameExtensions.getPairs(),
                            entry.value.first,
                            entry.value.last,
                            controller.workTypeListChanged,
                            entry.key)),
                        verticalSpaceMedium,
                        _sectionTitle("External links",
                            helpText:
                                "Field devices may be selected and will be used to automatically update this report as the devices are used."),
                        verticalSpaceSmall,
                        ElevatedButton.icon(
                          onPressed: () async {
                            int? roadEventId = controller.roadEventId.value;        
                            List<String>? selectedFieldDeviceIds =
                                await Get.to(() => FieldDeviceList(
                                      selectedFieldDeviceIds:
                                          controller.selectedFieldDeviceIds,
                                      selectedRoadEventId: roadEventId,
                                    ));
            
                            if (selectedFieldDeviceIds != null) {
                              controller.selectedFieldDeviceIds.value = selectedFieldDeviceIds;
                            }
                          },
                          icon: const Icon(Icons.map),
                          label: Obx(
                            () => Text(
                                "Select Field Devices (${controller.selectedFieldDeviceIds.length} selected)"),
                          ),
                        ),
            
                        _sectionTitle("Additional Details",
                            helpText: "All fields are optional"
                            "\n- Road Name: The name of the roadway (e.x. I-80)"
                            "\n- Roadway Direction: The direction of the roadway (e.g northbound)"),
                        _inputField("Road Name", controller.roadNameController, controller.originalRoadName), //optional
                        verticalSpaceMedium,
                        dropdownField<RoadwayDirection?>(
                            "Roadway Direction",
                        RoadwayDirectionExtensions.getPairs(),
                            controller.roadDirection, (controller.originalRoadDirection != controller.roadDirection.value).obs,  
                            context), //optional
            
                        _sectionTitle("Location",
                            helpText: "The location of the work zone, as a LineString"),
                        ElevatedButton(
                      onPressed: () async {
                        controller.points = await Get.to(
                            () => ReportLocationSelection(controller.points));
                          },
                          child: controller.points.isEmpty
                              ? const Text("Select Location *")
                              : const Text("Change Location"),
                        ),
                        verticalSpaceSmall,
                        const Divider(thickness: 3),
                        verticalSpaceMedium,
                        _saveChangesButton(context),
                  ]),
                    ],
                  )),
            ));
  }

  Widget _sectionTitle(String title,
      {double paddingTop = 30.0,
      double paddingBottom = 15.0,
      String? helpText}) {
    return Padding(
      padding: EdgeInsets.only(top: paddingTop, bottom: paddingBottom),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              helpText != null
                  ? IconButton(
                      icon: const Icon(Icons.help),
                      onPressed: () {
                        Get.dialog(AlertDialog(
                            title: Text(title), content: Text(helpText)));
                      })
                  : const SizedBox.shrink(),
            ],
          ),
          const Divider(thickness: 2), // Divider between sections
        ],
      ),
    );
  }

  Widget _inputField(String labelText, TextEditingController controller, String originalValue,
      {bool isNumeric = false,
      bool isDate = false,
      Rx<DateTime?>? dateStorage,
      bool isRequired = false,
      bool isDouble = false, EditReportPageController? reportPageController,
      BuildContext? context}) {
    if (isDate) {
      return GetBuilder<EditReportPageController>(
        builder: (_) => TextField(
          decoration: InputDecoration(
            labelText: isRequired ? "$labelText *" : labelText,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: controller.text != originalValue ? Colors.orange : mediumGrey,
                width: controller.text != originalValue ? 2 : 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: controller.text != originalValue ? primaryColor : mediumGrey ,
                width: controller.text != originalValue ? 2 : 1,
              ),
            ),
          ),
          controller: controller,
          keyboardType: isNumeric || isDouble
              ? const TextInputType.numberWithOptions(decimal: true)
              : TextInputType.text,
          inputFormatters: isNumeric
              ? <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly]
              : isDouble
                  ? <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))
                    ]
                  : null,
          readOnly: true,
          onTap: () async {
            DateTime? pickedDate = await showDatePicker(
              context: context!,
              initialDate: DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2101),
            );
            if (pickedDate != null) {
              controller.text = "${pickedDate.toLocal()}".split(' ')[0];
              TimeOfDay? pickedTime = await showTimePicker(
                context: context,
                initialTime: const TimeOfDay(hour: 8, minute: 0),
              );
              if (pickedTime != null) {
                DateTime finalDateTime = DateTime.utc(
                    pickedDate.year,
                    pickedDate.month,
                    pickedDate.day,
                    pickedTime.hour,
                    pickedTime.minute);
                String formattedDate =
                    DateFormat.yMd().add_jm().format(finalDateTime);
                dateStorage?.value = finalDateTime;
                controller.text = formattedDate;
              }
            }
            if (reportPageController != null) {
              reportPageController.update();
            }
          },
          onChanged: (value) async {},
        ),
      );
    } else {
      return TextField(
        decoration: InputDecoration(
          labelText: isRequired ? "$labelText *" : labelText,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: controller.text != originalValue ? primaryColor : mediumGrey,
              width: controller.text != originalValue ? 2 : 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: controller.text != originalValue ? primaryColor : mediumGrey,
              width: controller.text != originalValue ? 2 : 1,
            ),
          ),         
        ),
        controller: controller,
        keyboardType: isNumeric || isDouble
            ? const TextInputType.numberWithOptions(decimal: true)
            : TextInputType.text,
        inputFormatters: isNumeric
            ? <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly]
            : isDouble
                ? <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))
                  ]
                : null,
        readOnly: false,
        onTap: null,
        onChanged: (value) async {},
      );
    }
  }

  static Widget dropdownField<T>(
      String labelText,
      List<Pair<T, String>> options,
      Rx<T> selectedValue,
      Rx<bool> workTypeListChanged,
      BuildContext context) {
    return DropdownButtonFormField(
        initialValue: selectedValue.value,
        decoration: InputDecoration(
          labelText: labelText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: workTypeListChanged.value ? primaryColor : mediumGrey,
              width: workTypeListChanged.value ? 2 : 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: workTypeListChanged.value ? primaryColor : mediumGrey,
              width: workTypeListChanged.value ? 2 : 1,
            ),
          ),
          filled: true,
          fillColor: Theme.of(context).scaffoldBackgroundColor,
        ),
        isExpanded: true,
        menuMaxHeight: screenHeightPercentage(context, percentage: 0.5),
        dropdownColor: Theme.of(context).dialogTheme.backgroundColor,
        items: options
            .map((p) => DropdownMenuItem(
                  value: p.first,
                  child: Text(p.last),
                ))
            .toList(),
        onChanged: (value) async {
          selectedValue.value = value as T;
          workTypeListChanged.value = true;
        });
  }

  List<Widget> _workTypeSegment<T>(
      BuildContext context,
      List<Pair<T, String>> options,
      Rx<T> dropdownValue,
      Rx<bool> architectureValue,
      Rx<bool> workTypeListChanged,
      int index) {
    return [
      Card(
        elevation: 2, // Adds a slight shadow for grouping
        margin: const EdgeInsets.symmetric(
            vertical: 8), // Adds spacing between cards
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              index != 0
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                            child: dropdownField("Type of Work *", options,
                                dropdownValue, workTypeListChanged, context)),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () {
                            controller.workTypeList.value.removeAt(index);
                            controller.workTypeList.value = [
                              ...controller.workTypeList.value,
                            ];
                          },
                        )
                      ],
                    )
                  : dropdownField(
                      "Type of Work *", options, dropdownValue, workTypeListChanged, context),
              verticalSpaceSmall,
              Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween, // Align checkbox and button
                children: [
                  Row(
                    children: [
                      const Text("Architectural Change?"),
                      Obx(() => Checkbox(
                            value: architectureValue.value,
                            onChanged: (value) {
                              architectureValue.value = value ?? false;
                            },
                            visualDensity: VisualDensity.compact,
                          )),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                          onPressed: () {
                            controller.workTypeList.value = [
                              ...controller.workTypeList.value,
                              Pair(Rx<WorkTypeName?>(null), Rx<bool>(false))
                            ];
                          },
                          icon: const Icon(Icons.add))
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    ];
  }

  ElevatedButton _saveChangesButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        Get.dialog(_confirmationDialog(context, controller));
      },
      child: const Text("Save Changes"),
    );
  }

  Dialog _confirmationDialog(BuildContext context, EditReportPageController controller) {
    List<List> changes = controller.getChanges(); 
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "The following changes will be made to the road event:",
              style: TextStyle(fontSize: 20),
            ),
            verticalSpaceMedium,
            SizedBox(
              height: 300, // Set a fixed height or make it dynamic as needed
              child: ListView.builder(
                itemCount: changes.length,
                itemBuilder: (context, index) {
                  final change = changes[index];
                  return change[0] == "Location" ? Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(change[0].toString(), style: const TextStyle(fontWeight: FontWeight.bold)),
                      verticalSpaceSmall,
                      SizedBox(
                        width: screenWidth(context) * 0.6,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Original: ${change[1]}"),
                            Text("New: ${change[2]}"),
                          ],
                        ),
                      ),
                      verticalSpaceSmall,
                    ],
                  ) :Column( 
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(change[0].toString(), style: const TextStyle(fontWeight: FontWeight.bold)),
                      verticalSpaceSmall,
                      SizedBox(
                        width: screenWidth(context) * 0.6,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Original: ${change[1]}"),
                            Text("New: ${change[2]}"),
                          ],
                        ),
                      ),
                      verticalSpaceSmall,
                    ],
                  );
                },
              ),
            ),
            verticalSpaceSmall,
            ElevatedButton(
              onPressed: () async {
                await controller.updateReport(changes);
              },
              child: const Text("Make Update"),
            ),
          ],
        ),
      ),
    );
  }

  bool _fieldsValid() {
    List<String> messages = [];
    if (controller.reportNameController.text.isEmpty) {
      messages.add('- Report name is required');
    }
    if (!controller.workTypeList.value.any((element) => element.first.value != null)) {
      messages.add('- Work zone type is required');
    }
    if (controller.startDateController.text.isEmpty) {
      messages.add('- Start date is required');
    }
    if (controller.endDateController.text.isEmpty) {
      messages.add('- End date is required');
    }
    if (controller.points.isEmpty) {
      messages.add('- Location is required');
    }
    if (messages.isNotEmpty) {
      NotificationController()
          .queueNotification('Invalid Report', messages.join("\n"));
      return false;
    } else {
      return true;
    }
  }
}
