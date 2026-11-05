import 'dart:async';
import 'dart:html' as html;
import 'dart:typed_data';

import 'web_file_picker_stub.dart';

Future<BrowserSelectedFile?> pickFileFromSystem({
  List<String> acceptedExtensions = const [],
}) async {
  final input = html.FileUploadInputElement();
  input.multiple = false;

  if (acceptedExtensions.isNotEmpty) {
    input.accept = acceptedExtensions
        .map((extension) => extension.startsWith('.') ? extension : '.$extension')
        .join(',');
  }

  input.click();
  await input.onChange.first;

  final selectedFile = input.files?.isNotEmpty == true ? input.files!.first : null;
  if (selectedFile == null) {
    return null;
  }

  final reader = html.FileReader();
  final completer = Completer<BrowserSelectedFile?>();

  reader.onLoad.listen((_) {
    final result = reader.result;
    if (result is ByteBuffer) {
      completer.complete(
        BrowserSelectedFile(
          name: selectedFile.name,
          bytes: Uint8List.view(result),
        ),
      );
      return;
    }

    if (result is Uint8List) {
      completer.complete(
        BrowserSelectedFile(
          name: selectedFile.name,
          bytes: result,
        ),
      );
      return;
    }

    completer.complete(null);
  });

  reader.onError.listen((_) {
    completer.complete(null);
  });

  reader.readAsArrayBuffer(selectedFile);
  return completer.future;
}
