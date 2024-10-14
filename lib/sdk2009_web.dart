// In order to *not* need this ignore, consider extracting the "web" version
// of your plugin as a separate package, instead of inlining it in the same
// package as the core of your plugin.
// ignore: avoid_web_libraries_in_flutter

import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:web/web.dart' as web;

import 'plugin/sdk2009_platform_interface.dart';

/// A web implementation of the Sdk2009Platform of the Sdk2009 plugin.
class Sdk2009Web extends Sdk2009Platform {
  /// Constructs a Sdk2009Web
  Sdk2009Web();

  static void registerWith(Registrar registrar) {
    Sdk2009Platform.instance = Sdk2009Web();
  }

  /// Returns a [String] containing the version of the platform.
  @override
  Future<String?> getPlatformInfo() async {
    final version = web.window.navigator.userAgent;
    return version;
  }
}
