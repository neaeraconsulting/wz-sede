class NotificationModel {
  final String title;
  final String body;
  final String payload;

  NotificationModel(this.title, this.body, this.payload);
  NotificationModel.simple(String title, String body)
      : this(title, body, title);

  copyWith({
    String? title,
    String? body,
    String? payload,
  }) {
    return NotificationModel(
      title ?? this.title,
      body ?? this.body,
      payload ?? this.payload,
    );
  }
}
