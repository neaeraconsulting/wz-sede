import 'dart:typed_data';

class BrowserSelectedFile {
  final String name;
  final Uint8List bytes;

  const BrowserSelectedFile({
    required this.name,
    required this.bytes,
  });
}

Future<BrowserSelectedFile?> pickFileFromSystem({
  List<String> acceptedExtensions = const [],
}) async {
  return null;
}
