import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AppVersionService extends GetxService {
  String? _cachedSemver;

  Future<AppVersionService> init() async {
    await _loadVersion();
    return this;
  }

  Future<String> getSemver() async {
    if (_cachedSemver == null || _cachedSemver!.isEmpty) {
      await _loadVersion();
    }
    return _cachedSemver ?? '0.0.0';
  }

  String? get cachedSemver => _cachedSemver;

  Future<void> _loadVersion() async {
    final info = await PackageInfo.fromPlatform();
    _cachedSemver = info.version.trim();
  }
}
