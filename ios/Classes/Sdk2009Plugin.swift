import Flutter
import UIKit

public class Sdk2009Plugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "sdk2009", binaryMessenger: registrar.messenger())
    let instance = Sdk2009Plugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getPlatformVersion":
      result("iOS " + UIDevice.current.systemVersion)
    case "get_available_upi":
      result("iOS " + UIDevice.current.systemVersion)
    case "native_intent":
      result("iOS " + UIDevice.current.systemVersion)
    case "launch_upi_app":
      result("iOS " + UIDevice.current.systemVersion)
    default:
      result(FlutterMethodNotImplemented)
    }
  }
}