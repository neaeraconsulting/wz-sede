import 'package:wzam/services/web_file_picker_stub.dart';

import 'web_file_picker_stub.dart'
    if (dart.library.html) 'web_file_picker_web.dart' as web_picker;

export 'web_file_picker_stub.dart';

Future<BrowserSelectedFile?> pickFileFromSystem({
  List<String> acceptedExtensions = const ['kml'],
}) {
  return web_picker.pickFileFromSystem(
    acceptedExtensions: acceptedExtensions,
  );
}
