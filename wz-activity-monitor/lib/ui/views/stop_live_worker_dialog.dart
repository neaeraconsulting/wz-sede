import 'package:flutter/material.dart';
import 'package:get/get.dart';

AlertDialog stopLiveWorker() {
    return AlertDialog(
      title: const Text("Stop Active Worker Session"),
      content: const Text("Are you sure you want to stop the active worker session?"),
      actions: [
        TextButton(
          onPressed: () => Get.back(result: false),
          child: const Text("Cancel"),
        ),
        TextButton(
          onPressed: () => Get.back(result: true),
          child: const Text("Stop"),
        ),
      ],
    );
  }