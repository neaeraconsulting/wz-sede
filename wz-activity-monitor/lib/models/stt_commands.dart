// Speech to text commands
enum SttCommand {
  // Speed limit commands
  speedLimit5,
  speedLimit10,
  speedLimit15,
  speedLimit20,
  speedLimit25,
  speedLimit30,
  speedLimit35,
  speedLimit40,
  speedLimit45,
  speedLimit50,
  speedLimit55,
  speedLimit60,
  speedLimit65,
  speedLimit70,
  speedLimit75,
  speedLimit80,
  speedLimit85,
  speedLimit90,
  speedLimit95,
  speedLimit100,
  
  // Lane control commands
  laneClosed1,
  laneClosed2,
  laneClosed3,
  laneClosed4,
  laneClosed5,
  laneClosed6,
  laneOpened1,
  laneOpened2,
  laneOpened3,
  laneOpened4,
  laneOpened5,
  laneOpened6,
  
  // Worker presence commands
  workersPresent,
  workersNotPresent,
  
  // Work zone commands
  startWorkZone,
  endWorkZone,
  noCommandRecognized;
}

enum SttCommandCategory {
  speedLimit,
  laneOpen,
  laneClosed,
  workerPresence,
  workZone,
  other,
}

List<String> generateSpeedLimitComparisonStrings(String speedLimit) => [
      'speed limit 2 $speedLimit',
      'speed limit to $speedLimit',
      'speed limit too $speedLimit',
      'speed limit $speedLimit',
      'speed limit is $speedLimit',
    ];

List<String> generateLaneClosureComparisonStrings(String laneNumber) => [
      'lane $laneNumber close',
      'lane number $laneNumber close',
      'lane $laneNumber closed',
      'lane number $laneNumber closed',
      'close lane $laneNumber',
      'clothes lane $laneNumber',
      'closed lane $laneNumber',
      'line $laneNumber close',
      'line number $laneNumber close',
      'line $laneNumber closed',
      'line number $laneNumber closed',
      'close line $laneNumber',
      'clothes line $laneNumber',
      'closed line $laneNumber',
      'close lane number $laneNumber',
      'clothes lane number $laneNumber',
      'closed lane number $laneNumber',
      'close line number $laneNumber',
      'clothes line number $laneNumber',
      'closed line number $laneNumber',
    ];

List<String> generateLaneOpenedComparisonStrings(String laneNumber) => [
      'lane $laneNumber open',
      'lane number $laneNumber open',
      'lane $laneNumber opened',
      'lane number $laneNumber opened',
      'line $laneNumber open',
      'line number $laneNumber open',
      'line $laneNumber opened',
      'line number $laneNumber opened',
      'open lane $laneNumber',
      'opened lane $laneNumber',
      'open lane number $laneNumber',
      'opened lane number $laneNumber',
      'open line $laneNumber',
      'opened line $laneNumber',
      'open line number $laneNumber',
      'opened line number $laneNumber',
    ];

/// Extension to add a method that returns the associated text for each enum value.
extension SttCommandExtension on SttCommand {
  String get confirmationString {
    switch (this) {
      case SttCommand.speedLimit5:
        return 'Speed limit set to 5 mph';
      case SttCommand.speedLimit10:
        return 'Speed limit set to 10 mph';
      case SttCommand.speedLimit15:
        return 'Speed limit set to 15 mph';
      case SttCommand.speedLimit20:
        return 'Speed limit set to 20 mph';
      case SttCommand.speedLimit25:
        return 'Speed limit set to 25 mph';
      case SttCommand.speedLimit30:
        return 'Speed limit set to 30 mph';
      case SttCommand.speedLimit35:
        return 'Speed limit set to 35 mph';
      case SttCommand.speedLimit40:
        return 'Speed limit set to 40 mph';
      case SttCommand.speedLimit45:
        return 'Speed limit set to 45 mph';
      case SttCommand.speedLimit50:
        return 'Speed limit set to 50 mph';
      case SttCommand.speedLimit55:
        return 'Speed limit set to 55 mph';
      case SttCommand.speedLimit60:
        return 'Speed limit set to 60 mph';
      case SttCommand.speedLimit65:
        return 'Speed limit set to 65 mph';
      case SttCommand.speedLimit70:
        return 'Speed limit set to 70 mph';
      case SttCommand.speedLimit75:
        return 'Speed limit set to 75 mph';
      case SttCommand.speedLimit80:
        return 'Speed limit set to 80 mph';
      case SttCommand.speedLimit85:
        return 'Speed limit set to 85 mph';
      case SttCommand.speedLimit90:
        return 'Speed limit set to 90 mph';
      case SttCommand.speedLimit95:
        return 'Speed limit set to 95 mph';
      case SttCommand.speedLimit100:
        return 'Speed limit set to 100 mph';

      case SttCommand.laneClosed1:
        return 'Lane 1 closed';
      case SttCommand.laneClosed2:
        return 'Lane 2 closed';
      case SttCommand.laneClosed3:
        return 'Lane 3 closed';
      case SttCommand.laneClosed4:
        return 'Lane 4 closed';
      case SttCommand.laneClosed5:
        return 'Lane 5 closed';
      case SttCommand.laneClosed6:
        return 'Lane 6 closed';

      case SttCommand.laneOpened1:
        return 'Lane 1 opened';
      case SttCommand.laneOpened2:
        return 'Lane 2 opened';
      case SttCommand.laneOpened3:
        return 'Lane 3 opened';
      case SttCommand.laneOpened4:
        return 'Lane 4 opened';
      case SttCommand.laneOpened5:
        return 'Lane 5 opened';
      case SttCommand.laneOpened6:
        return 'Lane 6 opened';

      case SttCommand.workersPresent:
        return 'Workers are present';
      case SttCommand.workersNotPresent:
        return 'No workers are present';

      case SttCommand.startWorkZone:
        return 'Work zone starting point marked';
      case SttCommand.endWorkZone:
        return 'Work zone ending point marked';

      case SttCommand.noCommandRecognized:
        return 'No command recognized';
    }
  }

  List<String> get comparisonStrings {
    switch (this) {
      case SttCommand.speedLimit5:
        return [
          ...generateSpeedLimitComparisonStrings("5"),
          ...generateSpeedLimitComparisonStrings("five")
        ];
      case SttCommand.speedLimit10:
        return [
          ...generateSpeedLimitComparisonStrings("10"),
          ...generateSpeedLimitComparisonStrings("ten")
        ];
      case SttCommand.speedLimit15:
        return [
          ...generateSpeedLimitComparisonStrings("15"),
          ...generateSpeedLimitComparisonStrings("fifteen")
        ];
      case SttCommand.speedLimit20:
        return [
          ...generateSpeedLimitComparisonStrings("20"),
          ...generateSpeedLimitComparisonStrings("twenty")
        ];
      case SttCommand.speedLimit25:
        return [
          ...generateSpeedLimitComparisonStrings("25"),
          ...generateSpeedLimitComparisonStrings("twenty five")
        ];
      case SttCommand.speedLimit30:
        return [
          ...generateSpeedLimitComparisonStrings("30"),
          ...generateSpeedLimitComparisonStrings("thirty")
        ];
      case SttCommand.speedLimit35:
        return [
          ...generateSpeedLimitComparisonStrings("35"),
          ...generateSpeedLimitComparisonStrings("thirty five")
        ];
      case SttCommand.speedLimit40:
        return [
          ...generateSpeedLimitComparisonStrings("40"),
          ...generateSpeedLimitComparisonStrings("forty")
        ];
      case SttCommand.speedLimit45:
        return [
          ...generateSpeedLimitComparisonStrings("45"),
          ...generateSpeedLimitComparisonStrings("forty five")
        ];
      case SttCommand.speedLimit50:
        return [
          ...generateSpeedLimitComparisonStrings("50"),
          ...generateSpeedLimitComparisonStrings("fifty")
        ];
      case SttCommand.speedLimit55:
        return [
          ...generateSpeedLimitComparisonStrings("55"),
          ...generateSpeedLimitComparisonStrings("fifty five")
        ];
      case SttCommand.speedLimit60:
        return [
          ...generateSpeedLimitComparisonStrings("60"),
          ...generateSpeedLimitComparisonStrings("sixty")
        ];
      case SttCommand.speedLimit65:
        return [
          ...generateSpeedLimitComparisonStrings("65"),
          ...generateSpeedLimitComparisonStrings("sixty five")
        ];
      case SttCommand.speedLimit70:
        return [
          ...generateSpeedLimitComparisonStrings("70"),
          ...generateSpeedLimitComparisonStrings("seventy")
        ];
      case SttCommand.speedLimit75:
        return [
          ...generateSpeedLimitComparisonStrings("75"),
          ...generateSpeedLimitComparisonStrings("seventy five")
        ];
      case SttCommand.speedLimit80:
        return [
          ...generateSpeedLimitComparisonStrings("80"),
          ...generateSpeedLimitComparisonStrings("eighty")
        ];
      case SttCommand.speedLimit85:
        return [
          ...generateSpeedLimitComparisonStrings("85"),
          ...generateSpeedLimitComparisonStrings("eighty five")
        ];
      case SttCommand.speedLimit90:
        return [
          ...generateSpeedLimitComparisonStrings("90"),
          ...generateSpeedLimitComparisonStrings("ninety")
        ];
      case SttCommand.speedLimit95:
        return [
          ...generateSpeedLimitComparisonStrings("95"),
          ...generateSpeedLimitComparisonStrings("ninety five")
        ];
      case SttCommand.speedLimit100:
        return [
          ...generateSpeedLimitComparisonStrings("100"),
          ...generateSpeedLimitComparisonStrings("one hundred")
        ];

      case SttCommand.laneClosed1:
        return [
          ...generateLaneClosureComparisonStrings("1"),
          ...generateLaneClosureComparisonStrings("one")
        ];
      case SttCommand.laneClosed2:
        return [
          ...generateLaneClosureComparisonStrings("2"),
          ...generateLaneClosureComparisonStrings("to"),
          ...generateLaneClosureComparisonStrings("too"),
          ...generateLaneClosureComparisonStrings("two")
        ];
      case SttCommand.laneClosed3:
        return [
          ...generateLaneClosureComparisonStrings("3"),
          ...generateLaneClosureComparisonStrings("three"),
          ...generateLaneClosureComparisonStrings("tree")
        ];
      case SttCommand.laneClosed4:
        return [
          ...generateLaneClosureComparisonStrings("4"),
          ...generateLaneClosureComparisonStrings("for")
        ];
      case SttCommand.laneClosed5:
        return [
          ...generateLaneClosureComparisonStrings("5"),
          ...generateLaneClosureComparisonStrings("five")
        ];
      case SttCommand.laneClosed6:
        return [
          ...generateLaneClosureComparisonStrings("6"),
          ...generateLaneClosureComparisonStrings("six")
        ];

      case SttCommand.laneOpened1:
        return [
          ...generateLaneOpenedComparisonStrings("1"),
          ...generateLaneOpenedComparisonStrings("one")
        ];
      case SttCommand.laneOpened2:
        return [
          ...generateLaneOpenedComparisonStrings("2"),
          ...generateLaneOpenedComparisonStrings("to"),
          ...generateLaneOpenedComparisonStrings("too")
        ];
      case SttCommand.laneOpened3:
        return [
          ...generateLaneOpenedComparisonStrings("3"),
          ...generateLaneOpenedComparisonStrings("three"),
          ...generateLaneOpenedComparisonStrings("tree")
        ];
      case SttCommand.laneOpened4:
        return [
          ...generateLaneOpenedComparisonStrings("4"),
          ...generateLaneOpenedComparisonStrings("for")
        ];
      case SttCommand.laneOpened5:
        return [
          ...generateLaneOpenedComparisonStrings("5"),
          ...generateLaneOpenedComparisonStrings("five")
        ];
      case SttCommand.laneOpened6:
        return [
          ...generateLaneOpenedComparisonStrings("6"),
          ...generateLaneOpenedComparisonStrings("six")
        ];

      case SttCommand.workersPresent:
        return [
          'workers present',
          'worker\'s present',
          'workers are present',
          'worker\'s are present',
          'start workers',
        ];
      case SttCommand.workersNotPresent:
        return [
          'workers not present',
          'worker\'s not present',
          'workers no longer present',
          'worker\'s no longer present',
          'end workers',
          'and workers',
        ];

      case SttCommand.startWorkZone:
        return [
          'start work zone',
          'begin work zone',
          'work zone starts here',
          'start recording',
          'begin recording'
        ];
      case SttCommand.endWorkZone:
        return [
          'end work zone',
          'and work zone',
          'finish work zone',
          'stop work zone',
          'end recording',
          'and recording',
          'finish recording',
          'stop recording'
        ];

      case SttCommand.noCommandRecognized:
        return [];
    }
  }

  List<String> get examplePhrases {
    switch (this) {
      case SttCommand.speedLimit5:
        return ["Speed Limit 5"];
      case SttCommand.speedLimit10:
        return ["Speed Limit 10"];
      case SttCommand.speedLimit15:
        return ["Speed Limit 15"];
      case SttCommand.speedLimit20:
        return ["Speed Limit 20"];
      case SttCommand.speedLimit25:
        return ["Speed Limit 25"];
      case SttCommand.speedLimit30:
        return ["Speed Limit 30"];
      case SttCommand.speedLimit35:
        return ["Speed Limit 35"];
      case SttCommand.speedLimit40:
        return ["Speed Limit 40"];
      case SttCommand.speedLimit45:
        return ["Speed Limit 45"];
      case SttCommand.speedLimit50:
        return ["Speed Limit 50"];
      case SttCommand.speedLimit55:
        return ["Speed Limit 55"];
      case SttCommand.speedLimit60:
        return ["Speed Limit 60"];
      case SttCommand.speedLimit65:
        return ["Speed Limit 65"];
      case SttCommand.speedLimit70:
        return ["Speed Limit 70"];
      case SttCommand.speedLimit75:
        return ["Speed Limit 75"];
      case SttCommand.speedLimit80:
        return ["Speed Limit 80"];
      case SttCommand.speedLimit85:
        return ["Speed Limit 85"];
      case SttCommand.speedLimit90:
        return ["Speed Limit 90"];
      case SttCommand.speedLimit95:
        return ["Speed Limit 95"];
      case SttCommand.speedLimit100:
        return ["Speed Limit 100"];

      case SttCommand.laneClosed1:
        return ["Lane 1 closed", "Close lane 1"];
      case SttCommand.laneClosed2:
        return ["Lane 2 closed", "Close lane 2"];
      case SttCommand.laneClosed3:
        return ["Lane 3 closed", "Close lane 3"];
      case SttCommand.laneClosed4:
        return ["Lane 4 closed", "Close lane 4"];
      case SttCommand.laneClosed5:
        return ["Lane 5 closed", "Close lane 5"];
      case SttCommand.laneClosed6:
        return ["Lane 6 closed", "Close lane 6"];

      case SttCommand.laneOpened1:
        return ["Lane 1 open", "Open lane 1"];
      case SttCommand.laneOpened2:
        return ["Lane 2 open", "Open lane 2"];
      case SttCommand.laneOpened3:
        return ["Lane 3 open", "Open lane 3"];
      case SttCommand.laneOpened4:
        return ["Lane 4 open", "Open lane 4"];
      case SttCommand.laneOpened5:
        return ["Lane 5 open", "Open lane 5"];
      case SttCommand.laneOpened6:
        return ["Lane 6 open", "Open lane 6"];

      case SttCommand.workersPresent:
        return ['Workers present', 'Start workers'];
      case SttCommand.workersNotPresent:
        return ['Workers not present', 'End workers'];

      case SttCommand.startWorkZone:
        return ['Start work zone', 'Start recording', 'Begin recording'];
      case SttCommand.endWorkZone:
        return ['End work zone', 'Stop recording', 'End recording'];

      case SttCommand.noCommandRecognized:
        return [];
    }
  }

  int? get getValue {
    switch (this) {
      case SttCommand.speedLimit5:
        return 5;
      case SttCommand.speedLimit10:
        return 10;
      case SttCommand.speedLimit15:
        return 15;
      case SttCommand.speedLimit20:
        return 20;
      case SttCommand.speedLimit25:
        return 25;
      case SttCommand.speedLimit30:
        return 30;
      case SttCommand.speedLimit35:
        return 35;
      case SttCommand.speedLimit40:
        return 40;
      case SttCommand.speedLimit45:
        return 45;
      case SttCommand.speedLimit50:
        return 50;
      case SttCommand.speedLimit55:
        return 55;
      case SttCommand.speedLimit60:
        return 60;
      case SttCommand.speedLimit65:
        return 65;
      case SttCommand.speedLimit70:
        return 70;
      case SttCommand.speedLimit75:
        return 75;
      case SttCommand.speedLimit80:
        return 80;
      case SttCommand.speedLimit85:
        return 85;
      case SttCommand.speedLimit90:
        return 90;
      case SttCommand.speedLimit95:
        return 95;
      case SttCommand.speedLimit100:
        return 100;
      case SttCommand.laneClosed1:
        return 1;
      case SttCommand.laneClosed2:
        return 2;
      case SttCommand.laneClosed3:
        return 3;
      case SttCommand.laneClosed4:
        return 4;
      case SttCommand.laneClosed5:
        return 5;
      case SttCommand.laneClosed6:
        return 6;
      case SttCommand.laneOpened1:
        return 1;
      case SttCommand.laneOpened2:
        return 2;
      case SttCommand.laneOpened3:
        return 3;
      case SttCommand.laneOpened4:
        return 4;
      case SttCommand.laneOpened5:
        return 5;
      case SttCommand.laneOpened6:
        return 6;
      default:
        return null;
    }
  }

  static SttCommand? parseCommand(String text) {
    String normalizedText = text.toLowerCase().trim();

    SttCommand? matchedCommand;
    int matchLength = 0;
    for (final command in SttCommand.values) {
      for (final comparisonString in command.comparisonStrings) {
        String normalizedPattern = comparisonString.toLowerCase();

        // substring matching - text must contain the full pattern
        if (normalizedText.contains(normalizedPattern)) {
          // Prioritize longer matches
          if (normalizedPattern.length > matchLength) {
            matchedCommand = command;
            matchLength = normalizedPattern.length;
          }
        }
      }
    }
    return matchedCommand; // Return the first matching command
  }

  SttCommandCategory get category {
    switch (this) {
      case SttCommand.speedLimit5:
      case SttCommand.speedLimit10:
      case SttCommand.speedLimit15:
      case SttCommand.speedLimit20:
      case SttCommand.speedLimit25:
      case SttCommand.speedLimit30:
      case SttCommand.speedLimit35:
      case SttCommand.speedLimit40:
      case SttCommand.speedLimit45:
      case SttCommand.speedLimit50:
      case SttCommand.speedLimit55:
      case SttCommand.speedLimit60:
      case SttCommand.speedLimit65:
      case SttCommand.speedLimit70:
      case SttCommand.speedLimit75:
      case SttCommand.speedLimit80:
      case SttCommand.speedLimit85:
      case SttCommand.speedLimit90:
      case SttCommand.speedLimit95:
      case SttCommand.speedLimit100:
        return SttCommandCategory.speedLimit;
      case SttCommand.laneClosed1:
      case SttCommand.laneClosed2:
      case SttCommand.laneClosed3:
      case SttCommand.laneClosed4:
      case SttCommand.laneClosed5:
      case SttCommand.laneClosed6:
        return SttCommandCategory.laneClosed;
      case SttCommand.laneOpened1:
      case SttCommand.laneOpened2:
      case SttCommand.laneOpened3:
      case SttCommand.laneOpened4:
      case SttCommand.laneOpened5:
      case SttCommand.laneOpened6:
        return SttCommandCategory.laneOpen;
      case SttCommand.workersPresent:
      case SttCommand.workersNotPresent:
        return SttCommandCategory.workerPresence;
      case SttCommand.startWorkZone:
      case SttCommand.endWorkZone:
        return SttCommandCategory.workZone;
      default:
        return SttCommandCategory.other;
    }
  }

  static List<SttCommand> getCommandsByCategory(SttCommandCategory category) {
    return SttCommand.values
        .where((command) => command.category == category)
        .toList();
  }
}
