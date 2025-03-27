import Flutter
import UIKit
import CleverTapSDK
import clevertap_plugin
import FirebaseCore

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    FirebaseApp.configure()
    CleverTap.autoIntegrate() // integrate CleverTap SDK using the autoIntegrate option
    CleverTapPlugin.sharedInstance()?.applicationDidLaunch(options: launchOptions)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
