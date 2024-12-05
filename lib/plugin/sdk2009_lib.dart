import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sdk2009/sdk2009.dart';
import 'package:sdk2009/src/ui/native_webview.dart';
import 'package:sdk2009/src/ui/sdk_view.dart';
import 'package:sdk2009/src/singleton/generic_event_bus.dart';
import 'package:sdk2009/src/singleton/multi_event_bus.dart';

import 'sdk2009_platform_interface.dart';

class Sdk2009 {
  static final Sdk2009 _instance = Sdk2009._internal();

  // Private constructor
  Sdk2009._internal();

  // Factory to expose a single instance
  factory Sdk2009() => _instance;

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

  Future<String?> iConnect() {
    return Sdk2009Platform.instance.iConnect();
  }

  Future<String?> getPlatformInfo() {
    return Sdk2009Platform.instance.getPlatformInfo();
  }

  Future<void> nativeRegisterReceiver() {
    return Sdk2009Platform.instance.nativeRegisterReceiver();
  }

  Future<void> nativeUnregisterReceiver() {
    return Sdk2009Platform.instance.nativeUnregisterReceiver();
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

  Widget getWebView(String url) {
    return SdkView(url: url);
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
    GenericEventBus().registerListener<ResponseSuccessResponse>((event) {
      debugPrint('event received success :: ${event.paymentId}');
      _callback?.onSuccess(event);
      _callbackFunction?.onSuccessCallback(event);
    });

    GenericEventBus().registerListener<ResponseFailureResponse>((event) {
      debugPrint('event received failed :: ${event.message}');
      _callback?.onFailed(event); // Fire the callback
      _callbackFunction?.onFailedCallback(event);
    });

    _callback = pluginCallback;

    _callbackFunction = callbackFunction;
  }

  static bool _isInitialized = false;

  void init({
    required BuildContext context,
    required String paymentUrl,
    required PluginCallback pluginCallback,
    required CallbackFunction callbackFunction,
    required bool hasPlatformWebView,
  }) async {
    initializeDotenv();

    activate(
        pluginCallback: pluginCallback, callbackFunction: callbackFunction);
    if (hasPlatformWebView) {
      openNativePlatformWebView(context, paymentUrl);
    } else {
      waitingForWebviewResponse(context, paymentUrl);
    }
  }

  static Future<void> initializeDotenv() async {
    if (!_isInitialized) {
      await dotenv.load(fileName: ".env");
      _isInitialized = true;
    }
  }

  PluginCallback? _callback;
  CallbackFunction? _callbackFunction;

  void openNativePlatformWebView(context, paymentUrl) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => NativeWebView(url: paymentUrl),
    ));
  }

  Future<void> waitingForWebviewResponse(context, paymentUrl) async {
    await Navigator.of(context)
        .push(MaterialPageRoute(
      builder: (context) => SdkView(url: paymentUrl),
    ))
        .then((s) {
      String eventFailedMessage = "Plugin event failed triggered!";
      Map<String, dynamic> data = {'err': 'hello error'};
      dynamic payloadFailed = ResponseFailureResponse(
          code: 11, message: eventFailedMessage, error: data);

      dynamic payloadSuccess = ResponseSuccessResponse(
          'paymentIdu111', 'orderId3333', 'signature2222');

      MultiEventBus().emit<ResponseSuccessResponse>(payloadSuccess);
      GenericEventBus().emit<ResponseFailureResponse>(payloadFailed);
      // GlobalEventBus<ResponseFailureResponse>().emit(payloadFailed);
    }).catchError((onError) {});
  }
}
