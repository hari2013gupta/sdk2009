import 'package:events_emitter/events_emitter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sdk2009/sdk2009.dart';
import 'package:sdk2009/src/sdk_view.dart';

import 'sdk2009_platform_interface.dart';

class Sdk2009 {
  MethodChannel getMethodChannel() {
    return Sdk2009Platform.instance.getMethodChannel();
  }

  Future<String?> showNativeToast(String msg) {
    return Sdk2009Platform.instance.showNativeToast(msg);
  }

  Future<String?> showNativeAlert(String title, String text, String style) {
    return Sdk2009Platform.instance.showNativeAlert(title, text, style);
  }

  Future<String?> showNativeCustomAlert(
      String title, String text, String style) {
    return Sdk2009Platform.instance.showNativeCustomAlert(title, text, style);
  }

  Future<String?> playNativeSound() {
    return Sdk2009Platform.instance.playNativeSound();
  }

  Future<String?> getPlatformInfo() {
    return Sdk2009Platform.instance.getPlatformInfo();
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

  Future<String?> getBoomerang() {
    return Sdk2009Platform.instance.getBoomerang();
  }

  // Event names
  static const eventSuccess = 'response.success';
  static const eventError = 'response.error';

  // EventEmitter instance used for communication
  late EventEmitter _eventEmitter;

  /// Registers event listeners for events
  void activate(String event, Function handler) {
    cb(event) {
      handler(event);
      // handler(event.eventData);
    }

    _eventEmitter.on(event, cb);
    // _eventEmitter.on(event, null, cb);
  }

  void on(
      {required BuildContext context,
      required Function errorResponse,
      required Function successResponse}) {
    _eventEmitter = EventEmitter();
    activate(eventSuccess, successResponse);
    activate(eventError, errorResponse);
  }

  void init({required BuildContext context, required String paymentUrl}) async {
    waitingForWebviewResponse(context, paymentUrl);
  }

  Future<void> waitingForWebviewResponse(context, paymentUrl) async {
    await Navigator.of(context)
        .push(MaterialPageRoute(
      builder: (context) => SdkView(url: paymentUrl),
    ))
        .then((s) {
      Map<String, dynamic> data = {'err': 'hellow error'};
      dynamic payload =
          ResponseFailureResponse(code: 11, message: s, error: data);

      _eventEmitter.emit(eventError, payload);
      // _eventEmitter.emit(eventError, null, payload);
    }).catchError((onError) {});
  }
}
