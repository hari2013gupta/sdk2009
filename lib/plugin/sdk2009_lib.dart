import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sdk2009/sdk2009.dart';
import 'package:sdk2009/src/sdk_view.dart';
import 'package:sdk2009/src/singleton/generic_event_bus.dart';
import 'package:sdk2009/src/singleton/global_event_bus.dart';
import 'package:sdk2009/src/singleton/multi_event_bus.dart';

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

  // Event names
  static const eventSuccess = 'response.success';
  static const eventError = 'response.error';

  /// Registers listeners for events
  void activate({
    required PluginCallback pluginCallback,
    required CallbackFunction callbackFunction,
  }) {
    // Register listeners using the typedef
    // GlobalEventBus<ResponseSuccessResponse>().registerListener((event) {
    //   debugPrint('-----GlobalEventBus---received-----2');
    //   debugPrint('event received :: ${event.paymentId}');
    //   // _callback?.onSuccess(event);
    //   // _callbackFunction?.onSuccessCallback(event);
    // });

    // GenericEventBus().registerListener<ResponseSuccessResponse>((event) {
    //   debugPrint('-----GenericEventBus---received-----2');
    //   debugPrint('event received :: ${event.paymentId}');
    //   // _callback?.onSuccess(event);
    //   // _callbackFunction?.onSuccessCallback(event);
    // });
    // GlobalEventBus<ResponseFailureResponse>().registerListener((event) {
    //   debugPrint('-----GlobalEventBus---received-----1');
    //   debugPrint('event received :: ${event.message}');
    //   // _callback?.onFailed(event); // Fire the callback
    // });

    // Register a single listener for multiple types
    MultiEventBus()
        .registerMultiTypeListener([ResponseSuccessResponse, ResponseFailureResponse], (event) {
      if (event is ResponseSuccessResponse) {
        log('-----MultiEventBus----event received :: ${event.paymentId}');
        _callback?.onSuccess(event);
        _callbackFunction?.onSuccessCallback(event);
      } else if (event is ResponseFailureResponse) {
        log('------MultiEventBus-----event received :: ${event.message}');
        _callback?.onFailed(event);
        _callbackFunction?.onFailedCallback(event);
      } else {
        log('event received :: Unknown event: $event');
      }
    });

    _callback = pluginCallback;

    _callbackFunction = callbackFunction;
  }

  void init({
    required BuildContext context,
    required String paymentUrl,
    required PluginCallback pluginCallback,
    required CallbackFunction callbackFunction,
  }) async {
    activate(
        pluginCallback: pluginCallback, callbackFunction: callbackFunction);
    waitingForWebviewResponse(context, paymentUrl);
  }

  PluginCallback? _callback;
  CallbackFunction? _callbackFunction;

  Future<void> waitingForWebviewResponse(context, paymentUrl) async {
    await Navigator.of(context)
        .push(MaterialPageRoute(
      builder: (context) => SdkView(url: paymentUrl),
    ))
        .then((s) {
      // bus.emit('streamController');

      // Simulate triggering an event
      // String eventMessage = "paymentId";
      // ResponseSuccessResponse eventSuccessMessage =
      //     ResponseSuccessResponse(eventMessage, 'orderId', 'signature');
      // _callback?.onSuccess(eventSuccessMessage);

      // String eventFailedMessage = "Plugin event failed triggered!";
      // Map<String, dynamic> data = {'err': 'hello error'};
      // dynamic payload = ResponseFailureResponse(
      //     code: 11, message: eventFailedMessage, error: data);
      // _callback?.onSuccess(eventSuccessMessage);
      // _callback?.onFailed(payload); // Fire the callback
      // dynamic p2 = ResponseSuccessResponse(
      //     'paymentId11111', 'orderId3333', 'signature2222');
      //
      // bus.emit(p2);
      // }

      dynamic successEvent = ResponseSuccessResponse(
          'paymentIdu111', 'orderId3333', 'signature2222');

      MultiEventBus().emit<ResponseSuccessResponse>(successEvent);

      // GlobalEventBus<ResponseSuccessResponse>().emit(p2);
      // GenericEventBus().emit<ResponseSuccessResponse>(successEvent);
    }).catchError((onError) {});
  }
}
