import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:wzam/models/generated/google/protobuf/timestamp.pb.dart';
import 'package:wzam/ui/styles/screen_size.dart';
import 'package:wzam/ui/styles/spacing.dart';
import 'package:wzam/ui/styles/widgets/wzam_text.dart';
import 'package:wzam/ui/views/road_event_selection_dialog.dart';



class SelectCurrentOrNewEventDialog extends StatelessWidget {

  const SelectCurrentOrNewEventDialog({super.key});


  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                //mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  WZAMText.styleTwo('Create Report'),
                  verticalSpaceSmall,
                  SizedBox(
                    width: screenWidth(context) * 0.7,
                    child: ElevatedButton(
                          onPressed: () async {
                            //Get.back(); // Close the dialog
                            await Get.dialog(RoadEventListDialog());
                          },
                          child: const Text('Edit an existing work zone'),
                        ),
                  ),
                  verticalSpaceSmall,
                  WZAMText.styleFour('OR'),
                  verticalSpaceSmall,
                  SizedBox(
                    width: screenWidth(context) * 0.7,
                    child: ElevatedButton(
                          onPressed: () {
                            Get.back(); // Close the dialog
                            //Get.dialog(const StartLiveWorkerSessionDialog());
                          },
                          child: const Text('Create a new work zone'),
                        ),
                  ),
                ],
              ),
            ),
          ),
    );
  }

  String timestampToString(Timestamp timestamp) {
    int seconds = timestamp.seconds.toInt();
    return DateFormat.yMd().add_jm().format(DateTime.fromMillisecondsSinceEpoch(seconds * 1000));
  }
}

