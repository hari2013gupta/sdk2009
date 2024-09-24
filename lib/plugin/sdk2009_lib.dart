import 'package:flutter/material.dart';
import 'package:sdk2009/src/sdk_loader.dart';

import 'sdk2009_platform_interface.dart';

class Sdk2009 {
  Future<String?> getPlatformVersion() {
    return Sdk2009Platform.instance.getPlatformVersion();
  }

  Future<String?> getAvailableUpiApps() {
    return Sdk2009Platform.instance.getAvailableUpiApps();
  }

  Future<String?> openUpiIntent(String url) {
    return Sdk2009Platform.instance.openUpiIntent(url);
  }

  Stream<String> getStreamTimerEvent() {
    return Sdk2009Platform.instance.streamTimeFromNative();
  }

  Stream<String> streamLocationEvent() {
    return Sdk2009Platform.instance.streamLocationFromNative();
  }

  Stream<String> getNetworkFromNative() {
    return Sdk2009Platform.instance.getNetworkFromNative();
  }

  Stream<String> getSmsFromNative() {
    return Sdk2009Platform.instance.getSmsFromNative();
  }

  void init(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const SdkLoader(),
    ));
  }
}
