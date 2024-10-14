import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'sdk2009_platform_interface.dart';

/// An implementation of [Sdk2009Platform] that uses method channels.
class MethodChannelSdk2009 extends Sdk2009Platform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('sdk2009');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
