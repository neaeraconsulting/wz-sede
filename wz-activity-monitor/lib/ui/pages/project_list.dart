import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wzam/models/generated/google/protobuf/timestamp.pb.dart';
import 'package:wzam/models/wrappers/project_wrapper.dart';
import 'package:wzam/services/cache_service.dart';
import 'package:wzam/services/protobuf_utils.dart';

class ProjectList extends StatelessWidget {
  final CacheService cacheService = Get.find<CacheService>();
  ProjectList({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ProjectWrapper>>(
      future: cacheService.updateProjects().then((v) => v.values.toList()),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          final projects = snapshot.data!;
          return Scaffold(
            appBar: AppBar(
              title: const Text('Select a Project'),
            ),
            body: ListView.builder(
              itemCount: projects.length,
              itemBuilder: (context, index) {
                final project = projects[index];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: ListTile(
                    title: Text(project.project.name,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(
                      '${project.project.description}\nStart: ${formatDateTime(project.project.startDate)}\nEnd: ${formatDateTime(project.project.endDate)}',
                      style: const TextStyle(fontSize: 12),
                    ),
                    isThreeLine: true,
                    onTap: () {
                      Get.back(result: project); // Return the selected project
                    },
                  ),
                );
              },
            ),
          );
        }
      },
    );
  }

  String formatDateTime(Timestamp timestamp) {
    DateTime dateTime = ProtobufUtils.fromTimestamp(timestamp);
    return '${dateTime.year}-${dateTime.month}-${dateTime.day} ${dateTime.hour}:${dateTime.minute}';
  }
}
