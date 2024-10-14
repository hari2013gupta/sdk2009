// import 'package:flutter/services.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:sdk2009/sdk2009_method_channel.dart';
//
// void main() {
//   TestWidgetsFlutterBinding.ensureInitialized();
//
//   MethodChannelSdk2009 platform = MethodChannelSdk2009();
//   const MethodChannel channel = MethodChannel('sdk2009');
//
//   setUp(() {
//     TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
//       channel,
//       (MethodCall methodCall) async {
//         return '42';
//       },
//     );
//   });
//
//   tearDown(() {
//     TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, null);
//   });
//
//   test('getPlatformVersion', () async {
//     expect(await platform.getPlatformVersion(), '42');
//   });
// }
