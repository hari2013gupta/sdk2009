import 'package:flutter/material.dart';
import 'package:sdk2009/src/sdk_loader.dart';

import 'sdk2009_platform_interface.dart';

class Sdk2009 {
  Future<String?> showNativeToast() {
    return Sdk2009Platform.instance.showNativeToast();
  }

  Future<String?> getPlatformVersion() {
    return Sdk2009Platform.instance.getPlatformVersion();
  }

  Future<String?> getAvailableUpiApps() {
    return Sdk2009Platform.instance.getAvailableUpiApps();
  }

  Future<String?> openUpiIntent({required String url}) {
    return Sdk2009Platform.instance.openUpiIntent(url);
  }

  Future<String?> launchUpiIntent(
      {required String url, required String package}) {
    return Sdk2009Platform.instance.launchUpiIntent(url, package);
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

  void init({required BuildContext context, required String paymentUrl}) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => SdkLoader(url: paymentUrl),
    ));
  }
}
