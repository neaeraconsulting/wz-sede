import 'dart:async';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:wzam/services/push_notification_service.dart';

enum NotificationSeverity { success, error, info }

class NotificationController {
  DateTime? lastNotificationTime;
  QueuedNotification? queuedNotification;
  Timer? timer;

  NotificationController() {
    startNotifications();
  }

  void queueNotification(String title, String message,
      {NotificationSeverity severity = NotificationSeverity.error}) {
    queuedNotification = QueuedNotification(title, message, severity);
  }

  void sendNotification(QueuedNotification notification) {
    final _NotificationStyle style = _styleForSeverity(notification.severity);

    Get.snackbar(
      notification.title,
      notification.message,
      backgroundColor: style.bgColor,
      colorText: style.textColor,
      borderColor: style.borderColor,
      borderWidth: 2,
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.all(12),
      duration: style.duration,
    );
    lastNotificationTime = DateTime.now();
    queuedNotification = null;
  }

  Future<T> sendNotificationWithPromise<T>({
    required Future<T> Function() task,
    String loadingTitle = 'Working',
    String loadingMessage = 'Please wait...',
    String successTitle = 'Success',
    String successMessage = 'Completed successfully',
    String errorTitle = 'Error',
    bool onErrorSendPushNotification = true,
    int errorPushNotificationId = 901,
    String Function(Object error)? errorMessageBuilder,
    NotificationSeverity successSeverity = NotificationSeverity.success,
    NotificationSeverity errorSeverity = NotificationSeverity.error,
  }) async {
    // Ignore queued notifications for promise-driven UX.
    final _NotificationStyle loadingStyle =
        _styleForSeverity(NotificationSeverity.info);

    if (Get.isSnackbarOpen) {
      Get.closeCurrentSnackbar();
    }

    Get.snackbar(
      loadingTitle,
      loadingMessage,
      titleText: Text(
        loadingTitle,
        style: TextStyle(
          color: loadingStyle.textColor,
          fontWeight: FontWeight.w700,
        ),
      ),
      messageText: Row(
        children: [
          SizedBox(
            width: 14,
            height: 14,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor:
                  AlwaysStoppedAnimation<Color>(loadingStyle.borderColor),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              loadingMessage,
              style: TextStyle(color: loadingStyle.textColor),
            ),
          ),
        ],
      ),
      backgroundColor: loadingStyle.bgColor,
      colorText: loadingStyle.textColor,
      borderColor: loadingStyle.borderColor,
      borderWidth: 2,
      snackStyle: SnackStyle.FLOATING,
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.all(12),
      duration: const Duration(days: 1),
      isDismissible: false,
    );

    try {
      final T result = await task();

      if (Get.isSnackbarOpen) {
        Get.closeCurrentSnackbar();
      }

      sendNotification(
        QueuedNotification(successTitle, successMessage, successSeverity),
      );
      return result;
    } catch (error) {
      if (Get.isSnackbarOpen) {
        Get.closeCurrentSnackbar();
      }

      final String message =
          errorMessageBuilder?.call(error) ?? error.toString();

      sendNotification(
        QueuedNotification(errorTitle, message, errorSeverity),
      );
      if (onErrorSendPushNotification &&
          Get.isRegistered<PushNotificationService>()) {
        final PushNotificationService pushNotificationService =
            Get.find<PushNotificationService>();
        await pushNotificationService.showSimpleNotification(
          title: errorTitle,
          body: message,
          payload: errorTitle,
          id: errorPushNotificationId,
        );
      }
      rethrow;
    }
  }

  _NotificationStyle _styleForSeverity(NotificationSeverity severity) {
    switch (severity) {
      case NotificationSeverity.success:
        return _NotificationStyle(
          bgColor: Colors.green.shade50,
          borderColor: Colors.green,
          textColor: Colors.green.shade900,
          duration: const Duration(seconds: 3),
        );
      case NotificationSeverity.error:
        return _NotificationStyle(
          bgColor: Colors.red.shade50,
          borderColor: Colors.red,
          textColor: Colors.red.shade900,
          duration: const Duration(seconds: 5),
        );
      case NotificationSeverity.info:
        return _NotificationStyle(
          bgColor: Colors.blue.shade50,
          borderColor: Colors.blue,
          textColor: Colors.blue.shade900,
          duration: const Duration(seconds: 4),
        );
    }
  }

  void startNotifications() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (queuedNotification == null) return;
      final notification = queuedNotification!;

      if (lastNotificationTime == null) {
        sendNotification(notification);
      } else if (DateTime.now()
              .difference(lastNotificationTime!)
              .inSeconds
              .abs() >
          5) {
        sendNotification(notification);
      }
    });
  }
}

class QueuedNotification {
  final String title;
  final String message;
  final NotificationSeverity severity;

  QueuedNotification(this.title, this.message, this.severity);
}

class _NotificationStyle {
  final Color bgColor;
  final Color borderColor;
  final Color textColor;
  final Duration duration;

  const _NotificationStyle({
    required this.bgColor,
    required this.borderColor,
    required this.textColor,
    required this.duration,
  });
}
