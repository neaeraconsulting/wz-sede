import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart' as map;
import 'package:protobuf/protobuf.dart';
import 'package:wzam/controllers/notification_controller.dart';
import 'package:wzam/models/generated/google/type/latlng.pb.dart' as pb;
import 'package:wzam/models/generated/road_event.pb.dart' hide EventRecurrence;
import 'package:wzam/models/mixed_report.dart';
import 'package:wzam/models/notification_model.dart';
import 'package:wzam/models/pair.dart';
import 'package:wzam/models/report.dart';
import 'package:wzam/models/wrappers/road_event_wrapper.dart';
import 'package:wzam/models/wzdx_extensions.dart';
import 'package:wzam/models/wzdx_models.dart';
import 'package:wzam/services/auth_service.dart';
import 'package:wzam/services/file_storage.dart';
import 'package:wzam/services/protobuf_utils.dart';
import 'package:wzam/services/push_notification_service.dart';
import 'package:wzam/services/wzam_api.dart';
import 'package:wzam/ui/pages/home.dart';
import 'package:wzam/ui/views/event_recurrence_dialog.dart';
import 'package:wzam/ui/pages/field_device_list.dart';
import 'package:wzam/ui/pages/reports/report_location_selection.dart';
import 'package:wzam/ui/styles/screen_size.dart';
import 'package:wzam/ui/styles/spacing.dart';
import 'package:wzam/ui/styles/widgets/wzam_app_bar.dart';
import 'package:intl/intl.dart';

class ReportConfigurationPageController extends GetxController {
  RxList<map.LatLng> points = <map.LatLng>[].obs;
  Rx<WorkZoneType> areaType = Rx<WorkZoneType>(WorkZoneType.static);
  RxList<String> selectedFieldDeviceIds = <String>[].obs;
  Rx<RoadSegmentSurfaceType> surfaceType =
      Rx<RoadSegmentSurfaceType>(RoadSegmentSurfaceType.paved);
  Rx<RoadwayDirection?> roadDirection = Rx<RoadwayDirection?>(null);
  Rx<VehicleImpact> vehicleImpact =
      Rx<VehicleImpact>(VehicleImpact.allLanesOpen);
  Rx<int?> roadEventId = Rx<int?>(null);
  Rx<int?> projectId = Rx<int?>(null);
  double lineWidth = 30.0;
  RxBool isNew = false.obs;
  RxBool isInitialized = false.obs;

  FileStorageService fileStorageService = Get.find<FileStorageService>();
  AuthService authService = Get.find<AuthService>();
  List<Widget> formFields = [];
  TextEditingController reportNameController = TextEditingController();
  TextEditingController reportDescriptionController = TextEditingController();
  RxBool workersAlwaysPresent = false.obs;
  Rx<EventRecurrence?> workerPresenceSchedule = Rx<EventRecurrence?>(null);
  Rx<List<Pair<Rx<WorkTypeName?>, Rx<bool>>>> workTypeList =
      Rx<List<Pair<Rx<WorkTypeName?>, Rx<bool>>>>(
          [Pair(Rx<WorkTypeName?>(null), Rx<bool>(false))]);
  TextEditingController startDateController = TextEditingController(
      text: DateFormat.yMd().add_jm().format(DateTime.now()));
  TextEditingController endDateController = TextEditingController();
  TextEditingController mobilitySpeedController = TextEditingController();
  TextEditingController roadNameController = TextEditingController();

  Rx<DateTime> startDate = Rx<DateTime>(DateTime.now());
  Rx<DateTime?> endDate = Rx<DateTime?>(null);

  PushNotificationService pushNotificationService =
      Get.find<PushNotificationService>();

  Future<void> initialize({RoadEventWrapper? roadEventWrapper}) async {
    if (isInitialized.value) return; // Prevent re-initialization

    if (roadEventWrapper != null) {
      RoadEvent roadEvent = roadEventWrapper.roadEvent;
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
      workTypeList.value = [];
      roadEvent.typesOfWork.forEach((workType) {
        workTypeList.value.add(Pair(
            Rx<WorkTypeName>(WorkTypeName.fromProto(workType.typeName)),
            Rx<bool>(workType.isArchitecturalChange)));
      });
      projectId.value = roadEvent.projectId.toInt();
      selectedFieldDeviceIds.value =
          roadEventWrapper.roadEvent.linkedFieldDeviceIds;

      //Can't pull surface type from road event
      //Can't pull vehicleImpact from road event
      //vehicleImpact.value = VehicleImpact.fromProtoWithAllowedTypes(roadEvent.vehicleImpact);

      areaType.value =
          WorkZoneType.fromProtoWithAllowedTypes(roadEvent.areaType);
      if (roadEventWrapper.roadEvent.hasLineString()) {
        points.clear();
        PbList<pb.LatLng> coordinates =
            roadEventWrapper.roadEvent.lineString.coordinates.coordinates;
        for (pb.LatLng pt in coordinates) {
          map.LatLng latLng = map.LatLng(pt.latitude, pt.longitude);
          points.add(latLng);
        }
      }
    } else {
      isNew.value = true;
    }

    isInitialized.value = true; // Mark as initialized
  }

  void sendSuccessNotification(String title, String body) {
    pushNotificationService.showSimpleNotification(
      title: title,
      body: body,
      payload: title,
      id: 0,
    );
  }
}

//This is the report page where the user can generate a report
class ReportConfigurationPage extends StatelessWidget {
  final ReportConfigurationPageController controller =
      Get.put(ReportConfigurationPageController());
  //final MappableRoadEvent? roadEvent; // TODO: populate from roadEvent, map roadEvent on report map
  final RoadEventWrapper? existingRoadEvent;

  ReportConfigurationPage({super.key, required this.existingRoadEvent});
  @override
  Widget build(BuildContext context) {
    controller.initialize(roadEventWrapper: existingRoadEvent);
    return Scaffold(
        appBar: const WZAMAppBar(
          title: "Create Report",
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Obx(() => Stack(
                children: [
                  ListView(children: [
                    _sectionTitle(
                        controller.isNew.value ? "New Report" : "Edit Report",
                        paddingTop: 0,
                        helpText:
                            "Reports are used to quickly and accurately document work zones and events on the roadway."
                            "They keep the TMC operators and automated systems aware of work occurring on the ground, "
                            "so that they can provide accurate information to the traveling public."
                            "\nSubmitted reports will be automatically processed and validated, and are always verified "
                            "by a TMC operator before warning messages are distributed to the traveling public. "),
                    _inputField("Event Name", controller.reportNameController,
                        isRequired: true),
                    verticalSpaceMedium,
                    _inputField(
                        "Description", controller.reportDescriptionController),
                    verticalSpaceMedium,
                    _inputField("Start Date", controller.startDateController,
                        isDate: true,
                        dateStorage: controller.startDate,
                        context: context,
                        isRequired: true),
                    verticalSpaceMedium,
                    _inputField("End Date", controller.endDateController,
                        isDate: true,
                        dateStorage: controller.endDate,
                        context: context,
                        isRequired: true),
                    verticalSpaceMedium,
                    ...controller.workTypeList.value.asMap().entries.expand(
                        (entry) => _workTypeSegment(
                            context,
                            WorkTypeNameExtensions.getPairs(),
                            entry.value.first,
                            entry.value.last,
                            entry.key)),
                    verticalSpaceMedium,
                    dropdownField<RoadSegmentSurfaceType?>(
                        "Surface Type *",
                        RoadSegmentSurfaceTypeExtensions.getPairs(),
                        controller.surfaceType,
                        context),
                    verticalSpaceMedium,
                    dropdownField<VehicleImpact?>(
                        "Vehicle Impacts *",
                        VehicleImpactExtensions.getAllowedPairs(),
                        controller.vehicleImpact,
                        context),
                    verticalSpaceMedium,
                    _sectionTitle("Worker Activity",
                        helpText:
                            "Use 'Workers Always Present' if workers are always present at the site. Otherwise, use the Activity Schedule to define when workers are present."),
                    Obx(() => Row(
                          children: [
                            const Text("Workers Always Present"),
                            Checkbox(
                              value: controller.workersAlwaysPresent.value,
                              onChanged: (value) {
                                controller.workersAlwaysPresent.value = value!;
                                if (value) {
                                  controller.workerPresenceSchedule.value =
                                      null;
                                }
                              },
                              visualDensity: VisualDensity.compact,
                            ),
                          ],
                        )),
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 12.0),
                        child: Text(" - OR - "),
                      ),
                    ),
                    Obx(() => InkWell(
                          onTap: () async {
                            controller.workerPresenceSchedule.value =
                                await Get.dialog<EventRecurrence>(
                                    EventRecurrenceDialog(
                              eventStartDate: controller.startDate.value,
                              eventEndDate: controller.endDate.value,
                              initialSchedule:
                                  controller.workerPresenceSchedule.value,
                            ));
                            if (controller.workerPresenceSchedule.value !=
                                null) {
                              controller.workersAlwaysPresent.value = false;
                            }
                          },
                          child: InputDecorator(
                            decoration: const InputDecoration(
                                labelText: "Activity Schedule"),
                            child: Text(getFormattedDateRange(
                                ProtobufUtils.getDateTimeRange(
                                    controller.workerPresenceSchedule.value
                                        ?.startDate,
                                    controller
                                        .workerPresenceSchedule.value?.endDate),
                                defaultText: "Select Activity Schedule")),
                          ),
                        )),
                    verticalSpaceSmall,
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
                          controller.selectedFieldDeviceIds.value =
                              selectedFieldDeviceIds;
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
                            "\n- Reduced Speed Limit: The speed limit reduced from the roadway free speed"
                            "\n- Road Name: The name of the roadway (e.x. I-80)"
                            "\n- Roadway Direction: The direction of the roadway (e.g northbound)"),
                    _inputField("Reduced Speed Limit (MPH)",
                        controller.mobilitySpeedController,
                        isDouble: true), //optional
                    verticalSpaceMedium,
                    _inputField(
                        "Road Name", controller.roadNameController), //optional
                    verticalSpaceMedium,
                    dropdownField<RoadwayDirection?>(
                        "Roadway Direction",
                        RoadwayDirectionExtensions.getPairs(),
                        controller.roadDirection,
                        context), //optional

                    _sectionTitle("Location",
                        helpText: "The type and location of the work zone"
                            "\n- Area Type: Whether the work zone is static or moving. Moving work zones must use 'Planned Moving Area' unless updated by a live location"
                            "\n- Location: The location of the work zone, either a point, lineString, or polygon"),
                    dropdownField(
                        "Area Type *",
                        WorkZoneTypeExtensions.getAllowedPairs(),
                        controller.areaType,
                        context),
                    verticalSpaceMedium,
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
                    _submitButton(context),
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

  Widget _inputField(String labelText, TextEditingController controller,
      {bool isNumeric = false,
      bool isDate = false,
      Rx<DateTime?>? dateStorage,
      bool isRequired = false,
      bool isDouble = false,
      BuildContext? context}) {
    return TextField(
      decoration: InputDecoration(
        labelText: isRequired ? "$labelText *" : labelText,
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
      readOnly: isDate,
      onTap: isDate
          ? () async {
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
            }
          : null,
      onChanged: (value) async {
        // Handle changes if needed
      },
    );
  }

  static Widget dropdownField<T>(
      String labelText,
      List<Pair<T, String>> options,
      Rx<T> selectedValue,
      BuildContext context) {
    return DropdownButtonFormField(
        initialValue: selectedValue.value,
        decoration: InputDecoration(
          labelText: labelText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
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
        });
  }

  List<Widget> _workTypeSegment<T>(
      BuildContext context,
      List<Pair<T, String>> options,
      Rx<T> dropdownValue,
      Rx<bool> architectureValue,
      int index) {
    return [
      Card(
        //color: Colors.blue,
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
                                dropdownValue, context)),
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
                      "Type of Work *", options, dropdownValue, context),
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

  ElevatedButton _submitButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        if (!_fieldsValid()) {
          return;
        }
        await _saveReport();
      },
      child: const Text("Submit Report"),
    );
  }

  bool _fieldsValid() {
    List<String> messages = [];
    if (controller.reportNameController.text.isEmpty) {
      messages.add('- Report name is required');
    }
    if (!controller.workTypeList.value
        .any((element) => element.first.value != null)) {
      // check that at least one is not null
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

  Future<ReportWithId?> _saveReport() async {
    Report report = Report(
        projectId: controller.projectId.value,
        roadEventId: controller.roadEventId.value,
        name: controller.reportNameController.text,
        description: controller.reportDescriptionController.text != ""
            ? controller.reportDescriptionController.text
            : null, //optional field
        typesOfWork: controller.workTypeList.value
            .where((v) => v.first.value != null)
            .map((v) {
          return TypeOfWork(
              typeName: v.first.value!, isArchitecturalChange: v.last.value);
        }).toList(),
        workersPresent: controller.workersAlwaysPresent.value
            ? controller.workersAlwaysPresent.value
            : controller.workerPresenceSchedule.value != null
                ? true
                : false,
        roadName: controller.roadNameController.text != ""
            ? controller.roadNameController.text
            : null, //optional field
        direction: controller.roadDirection.value,
        startDate: controller.startDate.value,
        endDate: controller.endDate.value,
        timestamp: DateTime.now(),
        areaType: controller.areaType.value,
        vehicleImpact: controller.vehicleImpact.value,
        speedLimitMph: controller.mobilitySpeedController.text != ""
            ? double.parse(controller.mobilitySpeedController.text)
            : null, //optional field
        geometryType: GeometryType.linestring,
        geometry: controller.points,
        geometryLineWidth: controller.lineWidth,
        surfaceType: controller.surfaceType.value,
        userId: await controller.authService.getUserId(),
        workerPresenceSchedule: controller.workerPresenceSchedule.value,
        linkedFieldDeviceIds: controller.selectedFieldDeviceIds);
    Get.offAll(Home());
    ReportWithId? newReport = await NotificationController()
        .sendNotificationWithPromise<ReportWithId>(
      task: () async {
        ReportWithId? response = await postReport(report);
        if (response == null) {
          throw Exception("Report upload failed");
        } else {
          return response;
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
    return newReport;
  }

  Future<ReportWithId?> postReport(Report report) async {
    ReportWithId? reportWithId = await WzamApi.createReport(report);
    if (reportWithId != null) {
      return reportWithId;
    } else {
      await controller.fileStorageService
          .saveLocalReport(MixedReportLocal(report: report));
      await controller.fileStorageService.refreshLocalUploadState();
    }
    return null;
  }
}
