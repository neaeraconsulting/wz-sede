import 'package:get/get.dart';
import 'package:wzam/models/recording.dart';
import 'package:wzam/services/file_storage.dart';

class ViewRecordingsController extends GetxController {
  RxList<Recording> unUploadedRecordings = <Recording>[].obs;
  RxBool areThereLocalRecordings = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadInRecordings();
  }

  Future<void> loadInRecordings() async {
    FileStorageService fileService = Get.find<FileStorageService>();
    await fileService.refreshLocalUploadState();
    unUploadedRecordings.value = fileService.localRecordings.toList();
    areThereLocalRecordings.value = unUploadedRecordings.isNotEmpty;
    if (areThereLocalRecordings.value) {
      areThereLocalRecordings.value = true;
    }
  }
}
