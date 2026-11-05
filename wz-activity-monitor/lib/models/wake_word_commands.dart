// Speech to text commands
enum WakeWordCommand {
  // Speed limit commands
  heyWorkZone,
}

/// Extension to add a method that returns the associated text for each enum value.
extension WakeWordCommandExtension on WakeWordCommand {
  String get text {
    switch (this) {
      case WakeWordCommand.heyWorkZone:
        return 'Hey Work Zone';
    }
  }
}
