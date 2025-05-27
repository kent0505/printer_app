// import Flutter
// import UIKit

// @main
// @objc class AppDelegate: FlutterAppDelegate {
//   override func application(
//     _ application: UIApplication,
//     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
//   ) -> Bool {
//     GeneratedPluginRegistrant.register(with: self)
//     return super.application(application, didFinishLaunchingWithOptions: launchOptions)
//   }
// }

import UIKit
import Flutter
import WebKit

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {

  var webView: WKWebView?

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    
    let controller = window?.rootViewController as! FlutterViewController
    let channel = FlutterMethodChannel(name: "com.example.webview/screenshot",
                                       binaryMessenger: controller.binaryMessenger)

    channel.setMethodCallHandler { [weak self] (call, result) in
      if call.method == "captureScreenshot" {
        self?.captureWebViewScreenshot(result: result)
      } else {
        result(FlutterMethodNotImplemented)
      }
    }

    // You can set up your own WKWebView here (as a test)
    self.webView = WKWebView(frame: UIScreen.main.bounds)
    if let url = URL(string: "https://flutter.dev") {
      let request = URLRequest(url: url)
      self.webView?.load(request)
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  private func captureWebViewScreenshot(result: @escaping FlutterResult) {
    guard let webView = self.webView else {
      result(FlutterError(code: "NO_WEBVIEW", message: "WebView is not initialized", details: nil))
      return
    }

    let config = WKSnapshotConfiguration()
    config.rect = webView.bounds

    webView.takeSnapshot(with: config) { image, error in
      guard let image = image else {
        result(FlutterError(code: "SNAPSHOT_ERROR", message: error?.localizedDescription, details: nil))
        return
      }

      if let pngData = image.pngData() {
        result(FlutterStandardTypedData(bytes: pngData))
      } else {
        result(FlutterError(code: "IMAGE_CONVERSION", message: "Failed to convert image to PNG", details: nil))
      }
    }
  }
}
