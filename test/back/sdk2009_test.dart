// import 'package:flutter_test/flutter_test.dart';
// import 'package:sdk2009/sdk2009.dart';
// import 'package:sdk2009/sdk2009_platform_interface.dart';
// import 'package:sdk2009/sdk2009_method_channel.dart';
// import 'package:plugin_platform_interface/plugin_platform_interface.dart';
//
// class MockSdk2009Platform
//     with MockPlatformInterfaceMixin
//     implements Sdk2009Platform {
//
//   @override
//   Future<String?> getPlatformVersion() => Future.value('42');
// }
//
// void main() {
//   final Sdk2009Platform initialPlatform = Sdk2009Platform.instance;
//
//   test('$MethodChannelSdk2009 is the default instance', () {
//     expect(initialPlatform, isInstanceOf<MethodChannelSdk2009>());
//   });
//
//   test('getPlatformVersion', () async {
//     Sdk2009 sdk2009Plugin = Sdk2009();
//     MockSdk2009Platform fakePlatform = MockSdk2009Platform();
//     Sdk2009Platform.instance = fakePlatform;
//
//     expect(await sdk2009Plugin.getPlatformVersion(), '42');
//   });
// }
