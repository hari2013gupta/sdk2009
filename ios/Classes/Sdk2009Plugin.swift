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
        guard let args = call.arguments as? [String: Any],
              let upiUrl = args["uri"] as? String else {
            result(FlutterError(code: "INVALID_ARGUMENT", message: "UPI URL is required", details: nil))
            return
        }

        let packageName = args["packageName"] as? String // Optional package name (app scheme)
        self.resultCallback = result

        if let packageName = packageName, !packageName.isEmpty {
            // Check if specific app (via URL scheme) is installed
            if !isSpecificUpiAppInstalled(scheme: packageName) {
                result(FlutterError(code: "APP_NOT_FOUND", message: "Specified UPI app (\(packageName)) is not installed", details: nil))
                return
            }
        }
        if let url = URL(string: upiUrl), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
            result("UPI Intent Triggered")
        } else {
            result(FlutterError(code: "INVALID_URL", message: "Unable to open UPI URL", details: nil))
        }
    case "download_file":
        val url = call.argument<String>("url")!!
        val fileName = call.argument<String>("fileName")!!

        val request = DownloadManager.Request(Uri.parse(url))
        request.setTitle(fileName)
        request.setDescription("Downloading...")
        request.setDestinationInExternalPublicDir(Environment.DIRECTORY_DOWNLOADS, fileName)

        val downloadManager = getSystemService(Context.DOWNLOAD_SERVICE) as DownloadManager
        val downloadId = downloadManager.enqueue(request)

        result.success(downloadId)

    default:
      result(FlutterMethodNotImplemented)
    }
  }

//  let uri = (call.arguments! as AnyObject)["uri"]! as? String
//  let uri = (arguments!["uri"] as? String)!
//  result(self.canLaunch(uri: uri))
//  self.launchUri(uri: uri, result: result)
//  self.launchUri(uri: uri, result: result)

  private func canLaunch(uri: String) -> Bool {
    let url = URL(string: uri)
    return UIApplication.shared.canOpenURL(url!)
  }
    private func isSpecificUpiAppInstalled(scheme: String) -> Bool {
        guard let urlScheme = URL(string: "\(scheme)://") else { return false }
        return UIApplication.shared.canOpenURL(urlScheme)
    }
    func isAppInstalled(urlScheme: String) -> Bool {
        if let url = URL(string: urlScheme), UIApplication.shared.canOpenURL(url) {
            return true
        } else {
            return false
        }
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