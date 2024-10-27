import 'dart:async';

import 'package:events_emitter/events_emitter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sdk2009/event/callback_interface.dart';
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

  Stream<String> getStreamAnyEvent() {
    return Sdk2009Platform.instance.streamAnyFromNative();
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

// 1. Define a Stream in your plugin
// Remember to call dispose on eventController to avoid memory leaks when it’s no longer needed.
  StreamController<String> eventController =
      StreamController<String>.broadcast();

  Stream<String> get eventStream => eventController.stream;

  // Event names
  static const eventSuccess = 'response.success';
  static const eventError = 'response.error';

  // EventEmitter instance used for communication
  late EventEmitter _eventEmitter;

  /// Registers listeners for events
  void activate(String event, Function handler) {
    debugPrint('------result void activate ---->');
    cb(event) {
      debugPrint('------result void cb inside ---->');
      handler(event);
      // handler(event.eventData);
    }

    _eventEmitter.on(event, cb);
    // _eventEmitter.on(event, null, cb);
  }

  void on(
      {required CallbackFunction callbackFunction,
        required PluginCallback pluginCallback,
      required Function errorResponse,
      required Function successResponse}) {
    _eventEmitter = EventEmitter(); // eent emitter register here
    activate(eventSuccess, successResponse);
    activate(eventError, errorResponse);
    //====================stream controller event register===
    eventController.stream.listen((event) {
      // setState(() {
      String eventMessage = event; // Update UI based on event
      debugPrint('------result stream event ----> $eventMessage');
      // });
    });
    //==================== callback event register===
    setCallback(pluginCallback);

    setFunctionCallback(callbackFunction);
    //==================== End register===
  }

  void init({required BuildContext context, required String paymentUrl}) async {
    waitingForWebviewResponse(context, paymentUrl);
  }

  PluginCallback? _callback;
  CallbackFunction? _callbackFunction;

  // Set the callback
  void setCallback(PluginCallback callback) {
    _callback = callback;
  }

  void setFunctionCallback(CallbackFunction callbackFunction) {
    _callbackFunction = callbackFunction;
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

      //====================stream controller event result===
      debugPrint('------Emit Adding here stream event ---->');
      // Listen to the event stream from the plugin
      eventController.add('2. ----->Trigger an event in your plugin');

      //====================callback event result===
      // Simulate triggering an event
      // void triggerEvent() {
      String eventMessage = "Plugin event success triggered!";
      _callback?.onSuccess(eventMessage); // Call the callback
      String eventFailedMessage = "Plugin event failed triggered!";
      _callback?.onFailed(eventFailedMessage); // Call the callback
      //====================callback event result callback function ===
      _callbackFunction?.triggerEventFailed();
      _callbackFunction?.onSuccessCallback("Trigger--- success-- callback-- funcation----");
      // }
    }).catchError((onError) {});
  }

}
