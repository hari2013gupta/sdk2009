import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'sdk2009_platform_interface.dart';

/// An implementation of [Sdk2009Platform] that uses method channels.
class MethodChannelSdk2009 extends Sdk2009Platform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('sdk2009');

  final timeEventChannel = const EventChannel(
      'timeHandlerEvent'); // timeHandlerEvent event name . it should be same on android , IOS and Flutter

  final locationEventChannel = const EventChannel('locationHandlerEvent');

  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('get_platform_version');
    return version;
  }

  @override
  Future<String?> getAvailableUpiApps() async {
    final result = await methodChannel.invokeMethod<String>('get_available_upi');
    return result;
  }

  @override
  Future<String?> openUpiIntent(String url) async {
    final result = await methodChannel.invokeMethod<String>('native_intent');
    return result;
  }

  @override
  Stream<String> streamTimeFromNative() {
    return timeEventChannel
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
