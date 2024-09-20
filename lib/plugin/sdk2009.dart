import 'package:flutter/material.dart';
import 'package:sdk2009/src/sdk_loader.dart';

import 'sdk2009_platform_interface.dart';

class Sdk2009 {
  Future<String?> getPlatformVersion() {
    return Sdk2009Platform.instance.getPlatformVersion();
  }

  Stream<String> getStreamTimerEvent() {
    return Sdk2009Platform.instance.streamTimeFromNative();
  }

  void init(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const SdkLoader(),
    ));
  }
}
