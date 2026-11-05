import 'package:flutter/material.dart';
import 'package:get/get.dart';

AlertDialog stopMobileVehicle() {
    return AlertDialog(
      title: const Text("Stop Mobile Vehicle Session"),
      content: const Text("Are you sure you want to stop the mobile vehicle session?"),
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