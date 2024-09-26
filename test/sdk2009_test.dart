import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:sdk2009/plugin/sdk2009_platform_interface.dart';
import 'package:sdk2009/plugin/sdk2009_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:sdk2009/sdk2009.dart';

class MockSdk2009Platform
    with MockPlatformInterfaceMixin
    implements Sdk2009Platform {
  @override
  Future<String?> getPlatformVersion() => Future.value('42');

  @override
  Stream<String> streamTimeFromNative() =>
      Stream.periodic(const Duration(seconds: 1));

  @override
  Future<String?> getAvailableUpiApps() {
    // TODO: implement getAvailableUpiApps
    throw UnimplementedError();
  }

  @override
  Future<String?> openUpiIntent(String url) {
    // TODO: implement openUpiIntent
    throw UnimplementedError();
  }

  @override
  Future<String?> launchUpiIntent(String url, String package) {
    // TODO: implement launchUpiIntent
    throw UnimplementedError();
  }

  @override
  Stream<String> getNetworkFromNative() {
    // TODO: implement getNetworkFromNative
    throw UnimplementedError();
  }

  @override
  Stream<String> getSmsFromNative() {
    // TODO: implement getSmsFromNative
    throw UnimplementedError();
  }

  @override
  Stream<String> streamLocationFromNative() {
    // TODO: implement streamLocationFromNative
    throw UnimplementedError();
  }

}

void main() {
  final Sdk2009Platform initialPlatform = Sdk2009Platform.instance;

  test('$MethodChannelSdk2009 is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelSdk2009>());
  });

  test('getPlatformVersion', () async {
    Sdk2009 sdk2009Plugin = Sdk2009();
    MockSdk2009Platform fakePlatform = MockSdk2009Platform();
    Sdk2009Platform.instance = fakePlatform;

    expect(await sdk2009Plugin.getPlatformVersion(), '42');
  });
}
