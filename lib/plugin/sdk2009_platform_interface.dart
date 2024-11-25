import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'sdk2009_method_channel.dart';

abstract class Sdk2009Platform extends PlatformInterface {
  /// Constructs a Sdk2009Platform.
  Sdk2009Platform() : super(token: _token);

  static final Object _token = Object();

  static Sdk2009Platform _instance = MethodChannelSdk2009();

  /// The default instance of [Sdk2009Platform] to use.
  ///
  /// Defaults to [MethodChannelSdk2009].
  static Sdk2009Platform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [Sdk2009Platform] when
  /// they register themselves.
  static set instance(Sdk2009Platform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  MethodChannel getMethodChannel() {
    throw UnimplementedError('methodChannel() has not been implemented.');
  }

  Future<String?> showNativeToast(String msg) {
    throw UnimplementedError('nativeToast() has not been implemented.');
  }

  Future<String?> showNativeAlert(String title, String text, String style) {
    throw UnimplementedError('nativeAlert() has not been implemented.');
  }

  Future<String?> showNativeCustomAlert(
      String title, String text, String style) {
    throw UnimplementedError('nativeCustomAlert() has not been implemented.');
  }

  Future<String?> playNativeSound() {
    throw UnimplementedError('nativeSound() has not been implemented.');
  }

  Future<String?> iConnect() {
    throw UnimplementedError('iConnect() has not been implemented.');
  }

  Future<String?> getPlatformInfo() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<void> nativeRegisterReceiver() {
  throw UnimplementedError('registerReceiver() has not been implemented.');
  }

  Future<void> nativeUnregisterReceiver() {
  throw UnimplementedError('unregisterReceiver() has not been implemented.');
  }

  Future<String?> getAvailableUpiApps() {
    throw UnimplementedError('availableUpiApps() has not been implemented.');
  }

  Future<String?> openUpiIntent(String url) {
    throw UnimplementedError('openUpiIntent(url) has not been implemented.');
  }

  Future<String?> launchUpiIntent(String url, String package) {
    throw UnimplementedError(
        'launchUpiIntent(url, package) has not been implemented.');
  }

  Stream<String> streamTimeFromNative() {
    throw UnimplementedError('timerFromNative() has not been implemented.');
  }

  Stream<String> streamAnyFromNative() {
    throw UnimplementedError('anyFromNative() has not been implemented.');
  }

  Stream<String> streamLocationFromNative() {
    throw UnimplementedError('locationFromNative() has not been implemented.');
  }

  Stream<String> getNetworkFromNative() {
    throw UnimplementedError('networkFromNative() has not been implemented.');
  }

  Future<String?> getBoomerang() {
    throw UnimplementedError('boomerang() has not been implemented.');
  }

  Widget getWebView() {
    throw UnimplementedError('webView() has not been implemented.');
  }
}
