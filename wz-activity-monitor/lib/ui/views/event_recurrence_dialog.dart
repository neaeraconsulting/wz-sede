import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:wzam/models/report.dart';
import 'package:wzam/ui/styles/screen_size.dart';
import 'package:wzam/ui/styles/spacing.dart';

String getFormattedDateRange(DateTimeRange? range, {String defaultText = '-'}) {
  if (range == null) return defaultText;
  final dateFormat = DateFormat('yyyy-MM-dd'); // Define the date format
  return '${dateFormat.format(range.start)} - ${dateFormat.format(range.end)}';
}

class EventRecurrenceDialogController extends GetxController {
  final EventRecurrence? initialSchedule;
  final DateTime? initialStartDate;
  final DateTime? initialEndDate;
  EventRecurrenceDialogController(
      {this.initialSchedule, this.initialStartDate, this.initialEndDate}) {
    if (initialSchedule != null) {
      activeDateRange.value = DateTimeRange(
        start: initialSchedule!.startDate,
        end: initialSchedule!.endDate,
      );
      startTime.value = initialSchedule!.startTime;
      endTime.value = initialSchedule!.endTime;
      selectedDays.value = initialSchedule!.daysOfWeek.toSet();
    } else if (initialStartDate != null && initialEndDate != null) {
      activeDateRange.value = DateTimeRange(
        start: initialStartDate!,
        end: initialEndDate!,
      );
    }
  }

  Rx<DateTimeRange?> activeDateRange = Rx<DateTimeRange?>(null);
  Rx<TimeOfDay?> startTime = Rx<TimeOfDay?>(null);
  Rx<TimeOfDay?> endTime = Rx<TimeOfDay?>(null);
  Rx<Set<int>> selectedDays = Rx<Set<int>>({1, 2, 3, 4, 5});
  RxString errorMessage = "".obs;

  EventRecurrence? getSchedule({updateErrorMessage = true}) {
    DateTimeRange? dtr = activeDateRange.value;
    TimeOfDay? startT = startTime.value;
    TimeOfDay? endT = endTime.value;

    if (updateErrorMessage) {
      List<String> errorMessages = [];
      if (dtr == null) errorMessages.add("Missing date range");
      if (startT == null) errorMessages.add("Missing start time");
      if (endT == null) errorMessages.add("Missing end time");
      if (errorMessages.isNotEmpty) {
        errorMessage.value = "Errors: \n  - ${errorMessages.join('\n  - ')}";
      }
    }

    if (dtr == null || startT == null || endT == null) {
      return null;
    }
    EventRecurrence schedule = EventRecurrence(
      startDate: dtr.start,
      endDate: dtr.end,
      startTime: startT,
      endTime: endT,
      daysOfWeek: selectedDays.value.toList(),
      exclusion: false,
    );

    return schedule;
  }
}

class EventRecurrenceDialog extends StatelessWidget {
  final DateTime? eventStartDate;
  final DateTime? eventEndDate;
  final EventRecurrence? initialSchedule;
  const EventRecurrenceDialog(
      {super.key,
      this.eventStartDate,
      this.eventEndDate,
      this.initialSchedule});

  @override
  Widget build(BuildContext context) {
    EventRecurrenceDialogController controller = Get.put(
        EventRecurrenceDialogController(initialSchedule: initialSchedule));
    return Dialog(
      child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Work Zone Activity Schedule",
                    style: Theme.of(context).textTheme.titleLarge),
                verticalSpaceMedium,
                const Text("Activity Date Range"),
                verticalSpaceSmall,
                Obx(
                  () => Row(
                    children: [
                      Expanded(
                          child: _DateRangePicker(
                              label: "Start Time",
                              value: controller.activeDateRange.value,
                              firstDate: eventStartDate,
                              lastDate: eventEndDate,
                              onChanged: (DateTimeRange dtRange) {
                                controller.activeDateRange.value = dtRange;
                              })),
                    ],
                  ),
                ),

                verticalSpaceMedium,

                // 2. Daily Time Range
                const Text("Daily Active Times"),
                verticalSpaceSmall,
                Obx(
                  () => Row(
                    children: [
                      Expanded(
                          child: _TimePicker(
                              label: "Start Time",
                              value: controller.startTime.value,
                              onChanged: (TimeOfDay time) {
                                controller.startTime.value = time;
                              })),
                      verticalSpaceSmall,
                      Expanded(
                          child: _TimePicker(
                              label: "End Time",
                              value: controller.endTime.value,
                              onChanged: (TimeOfDay time) {
                                controller.endTime.value = time;
                              })),
                    ],
                  ),
                ),

                verticalSpaceMedium,

                // 3. Days of the Week
                const Text("Days of the Week"),
                verticalSpaceSmall,
                Wrap(
                  spacing: 8,
                  children: List.generate(
                    7,
                    (i) => Obx(
                      () => _DayCircleToggle(
                        day: i,
                        selectedDays: controller.selectedDays.value,
                        onChanged: (int day) {
                          Set<int> days = Set.of(controller.selectedDays.value);
                          if (days.contains(day)) {
                            days.remove(day);
                          } else {
                            days.add(day);
                          }
                          controller.selectedDays.value = days;
                        },
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Error Message
                Obx(() {
                  if (controller.errorMessage.value.isNotEmpty) {
                    return Text(
                      controller.errorMessage.value,
                      style: const TextStyle(color: Colors.red),
                    );
                  }
                  return const SizedBox.shrink();
                }),

                // Save / Cancel Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment
                      .spaceBetween, // Align buttons to opposite ends
                  children: [
                    TextButton(
                      onPressed: () => Get.back(),
                      child: const Text("Cancel"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        EventRecurrence? schedule = controller.getSchedule();
                        if (schedule == null) {
                          return;
                        } else {
                          Get.back(result: schedule);
                        }
                      },
                      child: const Text("Save"),
                    ),
                  ],
                )
              ],
            ),
          )),
    );
  }
}

class _DateRangePicker extends StatelessWidget {
  final String label;
  final DateTimeRange? value;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final ValueChanged<DateTimeRange> onChanged;

  const _DateRangePicker(
      {required this.label,
      required this.value,
      this.firstDate,
      this.lastDate,
      required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        DateTimeRange? picked = await showCustomDateRangeDialog(
          context,
          firstDate ?? DateTime.now(),
          lastDate ?? DateTime.now().add(const Duration(days: 365)),
        );
        if (picked != null) onChanged(picked);
      },
      child: InputDecorator(
        decoration: InputDecoration(labelText: label),
        child: Text(getFormattedDateRange(value)),
      ),
    );
  }

  Future<DateTimeRange?> showCustomDateRangeDialog(BuildContext context, DateTime firstDate, DateTime lastDate) {
    return showDialog<DateTimeRange>(
      context: context,
      builder: (context) => Dialog(
        child: SizedBox(  
          height: screenHeight(context) * 0.6, // Adjust as needed
          width: screenWidth(context), // Adjust as needed
          child: DateRangePickerDialog(
              firstDate: firstDate,
              lastDate: lastDate,
              initialDateRange: null,
          ),
        )
      ),
    );
  }
}

class _TimePicker extends StatelessWidget {
  final String label;
  final TimeOfDay? value;
  final ValueChanged<TimeOfDay> onChanged;

  const _TimePicker(
      {required this.label, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        TimeOfDay? picked = await showTimePicker(
          context: context,
          initialTime: value ?? const TimeOfDay(hour: 8, minute: 0),
        );
        if (picked != null) onChanged(picked);
      },
      child: InputDecorator(
        decoration: InputDecoration(labelText: label),
        child: Text(value != null ? value!.format(context) : '-'),
      ),
    );
  }
}

class _DayCircleToggle extends StatelessWidget {
  final int day; // 0 = Sunday, 6 = Saturday
  final Set<int> selectedDays;
  final ValueChanged<int> onChanged;

  const _DayCircleToggle({
    required this.day,
    required this.selectedDays,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final labels = ['S', 'M', 'T', 'W', 'T', 'F', 'S']; // Short labels for days
    final isSelected = selectedDays.contains(day);

    return GestureDetector(
      onTap: () => onChanged(day),
      child: Container(
        width: screenWidth(Get.context!) * (1/12), 
        height: screenWidth(Get.context!) * (1/12),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected ? Theme.of(context).primaryColor : Colors.grey[300],
        ),
        alignment: Alignment.center,
        child: Text(
          labels[day],
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
