import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'sdk2009_platform_interface.dart';

/// An implementation of [Sdk2009Platform] that uses method channels.
class MethodChannelSdk2009 extends Sdk2009Platform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('sdk2009');

  // timeHandlerEvent event name. it should be same on Android, IOS and Flutter
  final timeEventChannel = const EventChannel('time_handler_event');

  // timeHandlerEvent event name. it should be same on Android, IOS and Flutter
  final anyEventChannel = const EventChannel('any_handler_event');

  // locationHandlerEvent event name. it should be same on Android, IOS and Flutter
  final locationEventChannel = const EventChannel('location_handler_event');

  @override
  MethodChannel getMethodChannel() {
    return methodChannel;
  }

  @override
  Future<String?> showNativeToast(String msg) async {
    return await methodChannel
        .invokeMethod<String>('native_toast', {'msg': msg});
  }

  @override
  Future<String?> showNativeAlert(
      String title, String text, String style) async {
    return await methodChannel.invokeMethod<String>('native_alert',
        {'window_title': title, 'alert_text': text, 'alert_style': style});
  }

  @override
  Future<String?> showNativeCustomAlert(
      String title, String text, String style) async {
    return await methodChannel.invokeMethod<String>('native_custom_alert',
        {'window_title': title, 'alert_text': text, 'alert_style': style});
  }

  @override
  Future<String?> playNativeSound() async {
    return await methodChannel.invokeMethod<String>('native_sound');
  }

  @override
  Future<String?> getPlatformInfo() async {
    final info = await methodChannel.invokeMethod<String>('get_platform_info');
    return info;
  }

  @override
  Future<void> nativeRegisterReceiver() async {
    return await methodChannel.invokeMethod<void>('native_receiver_register');
  }

  @override
  Future<void> nativeUnregisterReceiver() async {
    return await methodChannel.invokeMethod<void>('native_receiver_unregister');
  }

  @override
  Future<String?> getAvailableUpiApps() async {
    return await methodChannel.invokeMethod<String>('get_available_upi');
  }

  @override
  Future<String?> openUpiIntent(String url) async {
    final result = await methodChannel.invokeMethod<String>(
      'native_intent',
      {'url': url},
    );
    return result;
  }

  @override
  Future<String?> launchUpiIntent(String url, String package) async {
    final result = await methodChannel.invokeMethod<String>(
      'launch_upi_app',
      {'url': url, 'package': package},
    );
    return result;
  }

  @override
  Future<String?> getBoomerang() async {
    return await methodChannel
        .invokeMethod<String>('android_sms_consent', {'code': 'Boomerang'});
  }

  @override
  Stream<String> streamTimeFromNative() {
    return timeEventChannel
        .receiveBroadcastStream()
        .map((event) => event.toString());
  }

  @override
  Stream<String> streamAnyFromNative() {
    return anyEventChannel
        .receiveBroadcastStream()
        .map((event) => event.toString());
  }

  @override
  Stream<String> streamLocationFromNative() {
    return locationEventChannel
        .receiveBroadcastStream()
        .map((event) => event.toString());
  }
}
