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

//  let uri = (arguments!["uri"] as? String)!
//  result(self.canLaunch(uri: uri))
//  self.launchUri(uri: uri, result: result)
//  self.launchUri(uri: uri, result: result)

  private func canLaunch(uri: String) -> Bool {
    let url = URL(string: uri)
    return UIApplication.shared.canOpenURL(url!)
  }

  private func launchUri(uri: String, result: @escaping FlutterResult) -> Bool {
    if(canLaunch(uri: uri)) {
      let url = URL(string: uri)
      if #available(iOS 10, *) {
        UIApplication.shared.open(url!, completionHandler: { (ret) in
            result(ret)
        })
      } else {
        result(UIApplication.shared.openURL(url!))
      }
    }
    return false
  }
}