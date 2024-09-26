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

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<String?> getAvailableUpiApps() {
    throw UnimplementedError('availableUpiApps() has not been implemented.');
  }

  Future<String?> openUpiIntent(String url) {
    throw UnimplementedError('openUpiIntent(url) has not been implemented.');
  }

  Future<String?> launchUpiIntent(String url, String package) {
    throw UnimplementedError('launchUpiIntent(url, package) has not been implemented.');
  }

  Stream<String> streamTimeFromNative() {
    throw UnimplementedError('timerFromNative() has not been implemented.');
  }

  Stream<String> streamLocationFromNative() {
    throw UnimplementedError('locationFromNative() has not been implemented.');
  }

  Stream<String> getNetworkFromNative() {
    throw UnimplementedError('networkFromNative() has not been implemented.');
  }

  Stream<String> getSmsFromNative() {
    throw UnimplementedError('smsFromNative() has not been implemented.');
  }
}
