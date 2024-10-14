import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sdk2009/plugin/sdk2009_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelSdk2009 platform = MethodChannelSdk2009();
  const MethodChannel channel = MethodChannel('sdk2009');
  // const EventChannel eventChannel = EventChannel('timeHandlerEvent'); // tobe test event channel

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        final info = {'battery_level': 101, 'platform_android': '42'};
        return info;
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('get_platform_info', () async {
    final info = {'battery_level': 101, 'platform_android': '42'};
    expect(await platform.getPlatformInfo(), info);
  });
}
