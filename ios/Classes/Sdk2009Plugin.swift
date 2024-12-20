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
    case "native_download":
        let urlString = call.arguments as! String
        let url = URL(string: urlString)!
        let task = URLSession.shared.downloadTask(with: url) { localURL, response, error in
            if let error = error {
                result(FlutterError(code: "DOWNLOAD_FAILED", message: error.localizedDescription, details: nil))
            } else if let localURL = localURL {
                result(localURL.path)
            } else {
                result(FlutterError(code: "UNKNOWN_ERROR", message: "Download failed", details: nil))
            }
        }
        task.resume()
    case "native_pdf_viewer":

            guard let arguments = call.arguments as? [String: Any],
                  let urlString = arguments["url"] as? String,
                  let fileName = arguments["fileName"] as? String else {
                result(FlutterError(code: "INVALID_ARGUMENTS", message: "Invalid arguments passed", details: nil))
                return
            }

            downloadAndViewPdf(from: urlString, fileName: fileName, result: result)

    default:
      result(FlutterMethodNotImplemented)
    }
  }

    private func downloadAndViewPdf(from urlString: String, fileName: String, result: @escaping FlutterResult) {
        guard let url = URL(string: urlString) else {
            result(FlutterError(code: "INVALID_URL", message: "The provided URL is invalid", details: nil))
            return
        }

//        let fileManager = FileManager.default
//        let tempDir = fileManager.temporaryDirectory
//        let filePath = tempDir.appendingPathComponent(fileName)

        // Save to the app's "Documents/Downloads" folder
        let fileManager = FileManager.default
        let documentsDir = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let downloadsDir = documentsDir.appendingPathComponent("Downloads", isDirectory: true)

        // Ensure the Downloads directory exists
        if !fileManager.fileExists(atPath: downloadsDir.path) {
            do {
                try fileManager.createDirectory(at: downloadsDir, withIntermediateDirectories: true, attributes: nil)
            } catch {
                result(FlutterError(code: "DIRECTORY_CREATION_ERROR", message: "Failed to create Downloads directory: \(error.localizedDescription)", details: nil))
                return
            }
        }
        let filePath = downloadsDir.appendingPathComponent(fileName)

        DispatchQueue.global(qos: .background).async {
            do {
                let pdfData = try Data(contentsOf: url)
                try pdfData.write(to: filePath)

                DispatchQueue.main.async {
                    self.openPdf(at: filePath, result: result)
                }
            } catch {
                DispatchQueue.main.async {
                    result(FlutterError(code: "DOWNLOAD_ERROR", message: "Failed to download PDF: \(error.localizedDescription)", details: nil))
                }
            }
        }
    }

    private func openPdf(at filePath: URL, result: @escaping FlutterResult) {
        let documentInteractionController = UIDocumentInteractionController(url: filePath)
        documentInteractionController.delegate = self

        if let rootViewController = UIApplication.shared.keyWindow?.rootViewController {
            if documentInteractionController.presentPreview(animated: true) {
                result("PDF opened successfully")
            } else {
                result(FlutterError(code: "VIEW_ERROR", message: "Unable to open PDF viewer", details: nil))
            }
        } else {
            result(FlutterError(code: "NO_CONTEXT", message: "No root view controller found", details: nil))
        }
    }
}

extension SwiftPdfDownloaderViewerPlugin: UIDocumentInteractionControllerDelegate {
    public func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return UIApplication.shared.keyWindow!.rootViewController!
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