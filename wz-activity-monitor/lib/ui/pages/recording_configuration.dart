import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:wzam/controllers/notification_controller.dart';
import 'package:wzam/models/generated/road_event.pb.dart' hide EventRecurrence;
import 'package:wzam/models/pair.dart';
import 'package:wzam/models/recording.dart';
import 'package:wzam/models/report.dart';
import 'package:wzam/models/wrappers/road_event_wrapper.dart';
import 'package:wzam/models/wzdx_extensions.dart';
import 'package:wzam/models/wzdx_models.dart';
import 'package:wzam/services/auth_service.dart';
import 'package:wzam/services/file_storage.dart';
import 'package:wzam/services/protobuf_utils.dart';
import 'package:wzam/ui/pages/recording/work_zone_recording.dart';
import 'package:wzam/ui/styles/app_colors.dart';
import 'package:wzam/ui/views/event_recurrence_dialog.dart';
import 'package:wzam/ui/pages/field_device_list.dart';
import 'package:wzam/ui/styles/screen_size.dart';
import 'package:wzam/ui/styles/spacing.dart';
import 'package:wzam/ui/styles/widgets/wzam_app_bar.dart';

class RecordingConfigurationPageController extends GetxController {
  TextEditingController recordingNameController = TextEditingController();
  TextEditingController recordingDescriptionController =
      TextEditingController();
  List workTypeNameList = [
    ["", false]
  ];
  Rx<DateTime> startDate = Rx<DateTime>(DateTime.now());
  TextEditingController startDateController = TextEditingController();
  Rx<DateTime?> endDate = Rx<DateTime?>(null);
  TextEditingController endDateController = TextEditingController();
  TextEditingController mobilitySpeedController = TextEditingController();
  Rx<RoadSegmentSurfaceType?> surfaceType =
      Rx<RoadSegmentSurfaceType?>(RoadSegmentSurfaceType.paved);
  Rx<VehicleImpact> vehicleImpact =
      Rx<VehicleImpact>(VehicleImpact.allLanesOpen);
  TextEditingController numberOfLanesController = TextEditingController();
  Rx<List<Pair<Rx<WorkTypeName?>, Rx<bool>>>> workTypeList =
      Rx<List<Pair<Rx<WorkTypeName?>, Rx<bool>>>>(
          [Pair(Rx<WorkTypeName?>(null), Rx<bool>(false))]);
  TextEditingController roadNameController = TextEditingController();
  Rx<RoadwayDirection?> roadDirection = Rx<RoadwayDirection?>(null);
  Rx<EventRecurrence?> recurrence = Rx<EventRecurrence?>(null);
  Rx<int?> roadEventId = Rx<int?>(null);
  Rx<int?> projectId = Rx<int?>(null);
  RxList<String> selectedFieldDeviceIds = <String>[].obs;

  RxBool isNew = false.obs;
  RxBool isInitialized = false.obs;
  DateTime? recordingStartTimestamp;

  Future<void> initialize({RoadEventWrapper? roadEventWrapper}) async {
    if (isInitialized.value) return; // Prevent re-initialization

    recordingStartTimestamp = DateTime.now();
    if (roadEventWrapper != null) {
      RoadEvent roadEvent = roadEventWrapper.roadEvent;
      roadEventId.value = roadEvent.id.toInt();
      recordingNameController.text = roadEvent.name;
      recordingDescriptionController.text = roadEvent.description;
      startDate.value = roadEvent.startDate.toDateTime();
      startDateController.text = roadEvent.startDate.toDateTime().toString();
      if (roadEvent.hasEndDate()) {
        endDate.value = roadEvent.endDate.toDateTime();
        endDateController.text = roadEvent.endDate.toDateTime().toString();
      }
      workTypeList.value = roadEvent.typesOfWork
          .map((workType) => Pair(
              Rx<WorkTypeName>(WorkTypeName.fromProto(workType.typeName)),
              Rx<bool>(workType.isArchitecturalChange)))
          .toList();
      numberOfLanesController.text = roadEventWrapper.numLanes != null ? roadEventWrapper.numLanes.toString() : "";
      projectId.value = roadEvent.projectId.toInt();
      selectedFieldDeviceIds.value =
          roadEventWrapper.roadEvent.linkedFieldDeviceIds;
      if (roadEvent.hasDefaultSchedule()) {
        recurrence.value = EventRecurrence.fromProto(roadEvent.defaultSchedule);
      }
    } else {
      isNew.value = true;
    }

    isInitialized.value = true; // Mark as initialized
  }
}

//This is the first page that the user is taken to when creating a recording. It allows the user to input the necessary information to start a recording.
class RecordingConfiguration extends StatelessWidget {
  final RecordingConfigurationPageController controller =
      Get.put(RecordingConfigurationPageController());
  final AuthService authService = Get.find<AuthService>();
  final RoadEventWrapper? existingRoadEvent;
  RecordingConfiguration({super.key, required this.existingRoadEvent});

  final FileStorageService fileStorageService = Get.find<FileStorageService>();
  //final TextEditingController recordingNameController = TextEditingController();
  //final TextEditingController recordingDescriptionController =
  //    TextEditingController();
  // final List workTypeNameList = [
  //   ["", false]
  // ];
  // final TextEditingController startDateController = TextEditingController();
  // final TextEditingController endDateController = TextEditingController();
  // final TextEditingController mobilitySpeedController = TextEditingController();
  // final Rx<RoadSegmentSurfaceType?> surfaceType =
  //     Rx<RoadSegmentSurfaceType?>(null);
  // final Rx<VehicleImpact> vehicleImpact =
  //     Rx<VehicleImpact>(VehicleImpact.VEHICLE_IMPACT_ALL_LANES_OPEN);
  // final TextEditingController numberOfLanesController = TextEditingController();
  // final Rx<List<Pair<Rx<WorkTypeName?>, Rx<bool>>>> workTypeList =
  //     Rx<List<Pair<Rx<WorkTypeName?>, Rx<bool>>>>(
  //         [Pair(Rx<WorkTypeName?>(null), Rx<bool>(false))]);
  // final TextEditingController roadNameController = TextEditingController();
  // final Rx<RoadwayDirection?> roadDirection = Rx<RoadwayDirection?>(null);
  // final Rx<EventRecurrence?> recurrence = Rx<EventRecurrence?>(null);
  // final Rx<int?> roadEventId = Rx<int?>(null);
  // final Rx<int?> projectId = Rx<int?>(null);
  // final RxList<String> selectedFieldDeviceIds = <String>[].obs;

  @override
  Widget build(BuildContext context) {
    controller.initialize(roadEventWrapper: existingRoadEvent);
    return Scaffold(
        appBar: WZAMAppBar(
          title: "Create Recording",
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Obx(() => ListView(children: [
                _sectionTitle(
                    controller.isNew.value ? "New Recording" : "Edit Recording",
                    paddingTop: 0,
                    helpText:
                        "Work zone recordings are used to quickly and accurately map out work zones along the roadway. "
                        "Recordings allow the user to drive through a work area and mark the start/end of the event, speed limits, "
                        "lane closures, and the presence of workers. "
                        "They keep the TMC operators and automated systems aware of work occurring on the ground, "
                        "so that they can provide accurate information to the traveling public."
                        "\nSubmitted recordings will be automatically processed and validated, and are always verified "
                        "by a TMC operator before warning messages are distributed to the traveling public. "),
                _inputField("Event Name", controller.recordingNameController,
                    isRequired: true),
                verticalSpaceMedium,
                _inputField(
                    "Description", controller.recordingDescriptionController),
                verticalSpaceMedium,
                _inputField("Start Date", controller.startDateController,
                    isDate: true, context: context, isRequired: true),
                verticalSpaceMedium,
                _inputField("End Date", controller.endDateController,
                    isDate: true, context: context),
                verticalSpaceMedium,
                ...controller.workTypeList.value.asMap().entries.expand(
                    (entry) => _workTypeSegment(
                        context,
                        WorkTypeNameExtensions.getPairs(),
                        entry.value.first,
                        entry.value.last,
                        entry.key)),
                verticalSpaceMedium,
                _inputField("Number of Lanes (per direction)",
                    controller.numberOfLanesController,
                    isDouble: true, isRequired: true),
                verticalSpaceMedium,
                _dropdownField<RoadSegmentSurfaceType?>(
                    "Surface Type *",
                    RoadSegmentSurfaceTypeExtensions.getPairs(),
                    controller.surfaceType,
                    context),
                verticalSpaceMedium,
                _dropdownField<VehicleImpact?>(
                    "Vehicle Impacts *",
                    VehicleImpactExtensions.getAllowedPairs(),
                    controller.vehicleImpact,
                    context),
                verticalSpaceMedium,
                Obx(() => InkWell(
                      onTap: () async {
                        controller.recurrence.value =
                            await Get.dialog<EventRecurrence>(
                                EventRecurrenceDialog(
                          eventStartDate: controller.startDate.value,
                          eventEndDate: controller.endDate.value,
                          initialSchedule: controller.recurrence.value,
                        ));
                      },
                      child: InputDecorator(
                        decoration: const InputDecoration(
                            labelText: "Activity Schedule"),
                        child: Text(getFormattedDateRange(
                            ProtobufUtils.getDateTimeRange(
                                controller.recurrence.value?.startDate,
                                controller.recurrence.value?.endDate),
                            defaultText: "Select Activity Schedule")),
                      ),
                    )),
                verticalSpaceSmall,
                _sectionTitle("External links",
                    helpText:
                        "Field devices may be selected and will be used to automatically update this recording as the devices are used."),
                ElevatedButton.icon(
                  onPressed: () async {
                    List<String>? selectedFieldDeviceIds =
                        await Get.to(() => FieldDeviceList(
                              selectedFieldDeviceIds:
                                  controller.selectedFieldDeviceIds,
                              selectedRoadEventId: controller.roadEventId.value,
                            ));

                    if (selectedFieldDeviceIds != null) {
                      controller.selectedFieldDeviceIds.value = selectedFieldDeviceIds;
                    }
                  },
                  icon: const Icon(Icons.map),
                  label: Obx(
                    () => Text(
                        "Select Field Devices (${controller.selectedFieldDeviceIds.length})"),
                  ),
                ),
                _sectionTitle("Additional Details",
                    helpText: "All fields are optional"
                        "\n- Speed Limit: The speed limit of the roadway before the work zone begins"
                        "\n- Number of Lanes: The number of lanes on the roadway, allows this # of lanes to be opened/closed while recording"
                        "\n- Road Name: The name of the roadway (e.x. I-80)"
                        "\n- Roadway Direction: The direction of the roadway (e.g northbound)"
                        "\n- License Plate: License plate of mobile vehicle, if applicable"),
                _inputField("Base Speed Limit (MPH, before event)",
                    controller.mobilitySpeedController,
                    isDouble: true),
                verticalSpaceMedium,
                _inputField(
                    "Road Name", controller.roadNameController), //optional
                verticalSpaceMedium,
                _dropdownField<RoadwayDirection?>(
                    "Roadway Direction",
                    RoadwayDirectionExtensions.getPairs(),
                    controller.roadDirection,
                    context), //optional
                verticalSpaceSmall,
                const Divider(thickness: 3),
                verticalSpaceMedium,
                _startRecordingButton(),
              ])),
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
      bool isDouble = false,
      bool isRequired = false,
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
                  initialTime: TimeOfDay.now(),
                );
                if (pickedTime != null) {
                  DateTime finalDateTime = DateTime(
                      pickedDate.year,
                      pickedDate.month,
                      pickedDate.day,
                      pickedTime.hour,
                      pickedTime.minute);
                  controller.text = finalDateTime.toString();
                }
              }
            }
          : null,
      onChanged: (value) async {
        // Handle changes if needed
      },
    );
  }

  Widget _dropdownField<T>(String labelText, List<Pair<T, String>> options,
      Rx<T> selectedValue, BuildContext context) {
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

  static Widget dropdownField<T>(
      String labelText,
      List<Pair<T, String>> options,
      Rx<T> selectedValue,
      BuildContext context, {bool lightTheme = false}) {
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
        dropdownColor: lightTheme ? lightBackgroundColor : Theme.of(context).dialogTheme.backgroundColor,
        items: options
            .map((p) => DropdownMenuItem(
                  value: p.first,
                  child: Text(p.last, style: lightTheme ? const TextStyle(color: Colors.black) : null),
                ))
            .toList(),
        onChanged: (value) async {
          selectedValue.value = value as T;
        });
  }

  ElevatedButton _startRecordingButton() {
    return ElevatedButton(
      onPressed: () async {
        if (!_fieldsValid()) {
          return;
        }
        Recording recording = Recording(
          projectId: controller.projectId.value,
          roadEventId: controller.roadEventId.value,
          name: controller.recordingNameController.text,
          description:
              controller.recordingDescriptionController.text, //optional
          typesOfWork: controller.workTypeList.value
              .where((v) => v.first.value != null)
              .map((v) {
            return TypeOfWork(
              typeName: v.first.value!,
              isArchitecturalChange:
                  v.last.value, // This should work if TypeOfWork expects a bool
            );
          }).toList(),
          roadName: controller.roadNameController.text != ""
              ? controller.roadNameController.text
              : null, //optional
          direction: controller.roadDirection.value, //optional
          startDate: _parseDate(controller.startDateController.text), //optional
          endDate: _parseDate(controller.endDateController.text), //optional
          timestamp: DateTime.now(),
          areaType: WorkZoneType.static,
          vehicleImpact: controller.vehicleImpact.value,
          surfaceType: controller.surfaceType.value!,
          points: [],
          userId: await authService.getUserId(),
          eventSchedule: controller.recurrence.value,
          recordingStartTimestamp: controller.recordingStartTimestamp,
          linkedFieldDeviceIds: controller.selectedFieldDeviceIds
        );
        int numLanes = int.parse(controller.numberOfLanesController.text);
        int speedLimit = controller.mobilitySpeedController.text != ""
            ? int.parse(controller.mobilitySpeedController.text)
            : 25;
        Get.to(() => WorkZoneRecordingTwo(recording, numLanes, speedLimit));
      },
      child: const Text("Start Recording"),
    );
  }

  bool _fieldsValid() {
    List<String> messages = [];
    if (controller.recordingNameController.text == "") {
      messages.add("- Name is required");
    }
    if (!controller.workTypeList.value
        .any((element) => element.first.value != null)) {
      messages.add('- You must select at least 1 type of work');
    }
    if (controller.surfaceType.value == null) {
      messages.add('- Surface type is required');
    }
    if (controller.numberOfLanesController.text == "") {
      messages.add('- One or more required fields are missing');
    }
    if (messages.isNotEmpty) {
      NotificationController()
          .queueNotification('Invalid Recording', messages.join("\n"));
      return false;
    } else {
      return true;
    }
  }

  DateTime? _parseDate(String? date) {
    if (date == "" || date == null) {
      return null;
    }
    DateTime dateTime = DateTime.parse(date);
    return dateTime;
  }
}
