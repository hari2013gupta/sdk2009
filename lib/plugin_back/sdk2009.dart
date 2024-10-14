
import 'sdk2009_platform_interface.dart';

class Sdk2009 {
  Future<String?> getPlatformVersion() {
    return Sdk2009Platform.instance.getPlatformVersion();
  }
}
