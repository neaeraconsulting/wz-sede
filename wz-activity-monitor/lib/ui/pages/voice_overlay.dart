import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:confetti/confetti.dart';
import 'package:wzam/models/stt_commands.dart';
import 'package:wzam/models/voice_command_status.dart';
import 'package:wzam/services/voice_commands/speech_service.dart';
import 'package:wzam/services/voice_commands/voice_command_service.dart';

class VoiceOverlay extends StatefulWidget {
  const VoiceOverlay({super.key});

  @override
  VoiceOverlayState createState() => VoiceOverlayState();
}

class VoiceOverlayState extends State<VoiceOverlay> {
  final SpeechService speechService = Get.find<SpeechService>();
  final VoiceCommandService voiceCommandService =
      Get.find<VoiceCommandService>();
  final RxSet<SttCommand> _recognizedCommands = <SttCommand>{}.obs;
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 10));
    speechService.updateAllowedCommands(SttCommand.values);
    voiceCommandService.initialize();
  }

  @override
  void dispose() async {
    _confettiController.dispose();
    voiceCommandService.deinit();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: voiceCommandService
                    .settingsController.voiceCommandState.value
                ? [
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Obx(() => IconButton(
                                onPressed: () {
                                  voiceCommandService.startVoiceCommand();
                                },
                                iconSize: 80,
                                icon: voiceCommandService.status.value.icon,
                              )),

                          const SizedBox(height: 16),

                          // Display recognized text
                          Obx(() => Text(
                                voiceCommandService.status.value ==
                                        VoiceCommandStatus.listeningForCommand
                                    ? "Listening..."
                                    : "Say \"Hey Work Zone\" or Tap the microphone to start listening",
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              )),

                          const SizedBox(height: 16),

                          // Display error messages or results
                          StreamBuilder<SttCommand>(
                            stream: voiceCommandService.commandStream,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                final recognizedCommand = snapshot.data!;
                                WidgetsBinding.instance
                                    .addPostFrameCallback((_) {
                                  _recognizedCommands.add(
                                      recognizedCommand); // Update reactively after the frame

                                  // Trigger confetti if all commands are recognized
                                  if (_recognizedCommands.length ==
                                      SttCommand.values.length) {
                                    _confettiController.play();
                                  }
                                });
                                return Text(
                                  recognizedCommand.confirmationString,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                );
                              } else {
                                return const Text(
                                  "No command detected.",
                                  style: TextStyle(fontSize: 16),
                                  textAlign: TextAlign.center,
                                );
                              }
                            },
                          ),

                          const SizedBox(height: 16),

                          // Display recognized text
                          Obx(() => Text(
                                "Recognized Speech: ${speechService.textReceived.value}",
                                style: const TextStyle(
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.center,
                              )),

                          const SizedBox(height: 16),

                          // Spacer to push the voiceCommandList to the bottom
                          const Divider(thickness: 1),
                          const Text("Commands for Recording Mode",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                          SizedBox(
                            height: 150,
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: voiceCommandList(),
                          ),
                          const Divider(thickness: 1),
                        ],
                      ),
                    ),
                  ]
                : [
                    description(),
                  ],
          ),
        ),

        // Confetti widget
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.9,
          height: MediaQuery.of(context).size.height * 0.9,
          child: Center(
            child: ConfettiWidget(
              confettiController: _confettiController,

              blastDirectionality:
                  BlastDirectionality.explosive, // Explodes in all directions
              shouldLoop: false, // Only play once
              colors: const [
                Colors.red,
                Colors.blue,
                Colors.green,
                Colors.orange
              ], // Confetti colors
            ),
          ),
        ),
      ],
    );
  }

  Widget description() {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: Text(
        "Voice commands allow hands-free operation of the recording mode. Use control recordings without touching the screen. To enable them, ensure the \"Voice Commands Enabled\" slider is set to true in the settings menu.",
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: Colors.black87,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget voiceCommandList() {
    // Example grouped commands
    final Map<String, List<SttCommand>> groupedCommands = {
      "Start/Stop": [
        SttCommand.startWorkZone,
        SttCommand.endWorkZone,
      ],
      "Worker Presence": [
        SttCommand.workersPresent,
        SttCommand.workersNotPresent,
      ],
      "Close Lanes": [
        SttCommand.laneClosed1,
        SttCommand.laneClosed2,
        SttCommand.laneClosed3,
        SttCommand.laneClosed4,
        SttCommand.laneClosed5,
        SttCommand.laneClosed6,
      ],
      "Open Lanes": [
        SttCommand.laneOpened1,
        SttCommand.laneOpened2,
        SttCommand.laneOpened3,
        SttCommand.laneOpened4,
        SttCommand.laneOpened5,
        SttCommand.laneOpened6,
      ],
      "Speed Limits": [
        SttCommand.speedLimit5,
        SttCommand.speedLimit10,
        SttCommand.speedLimit15,
        SttCommand.speedLimit20,
        SttCommand.speedLimit25,
        SttCommand.speedLimit30,
        SttCommand.speedLimit35,
        SttCommand.speedLimit40,
        SttCommand.speedLimit45,
        SttCommand.speedLimit50,
        SttCommand.speedLimit55,
        SttCommand.speedLimit60,
        SttCommand.speedLimit65,
        SttCommand.speedLimit70,
        SttCommand.speedLimit75,
        SttCommand.speedLimit80,
        SttCommand.speedLimit85,
        SttCommand.speedLimit90,
        SttCommand.speedLimit95,
        SttCommand.speedLimit100,
      ],
    };

    return ListView(
      shrinkWrap: true, // Allow the ListView to shrink to fit its content
      physics:
          const AlwaysScrollableScrollPhysics(), // Ensure scrolling is always enabled
      children: groupedCommands.entries.map((entry) {
        final sectionName = entry.key;
        final commands = entry.value;

        return ExpansionTile(
          title: Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    sectionName,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                    overflow:
                        TextOverflow.fade, // Clip the text with an ellipsis
                    softWrap: false, // Prevent wrapping to the next line
                  ),
                ),
                if (commands.every((command) => _recognizedCommands.contains(
                    command))) // Add a checkmark if all commands are recognized
                  const Icon(Icons.check, color: Colors.green, size: 24),
              ],
            ),
          ),
          children: commands.map((command) {
            return Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
              child: Obx(
                () => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Command text
                    Expanded(
                      child: Text(
                        command.examplePhrases.join(", "),
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                    // Checkmark if the command is recognized
                    if (_recognizedCommands.contains(command))
                      const Icon(Icons.check, color: Colors.green, size: 16),
                  ],
                ),
              ),
            );
          }).toList(),
        );
      }).toList(),
    );
  }
}
