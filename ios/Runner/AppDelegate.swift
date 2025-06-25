import UIKit
import Flutter
import CleverTapSDK
import UserNotifications

@main
@objc class AppDelegate: FlutterAppDelegate, CleverTapURLDelegate {

    // 🔧 Declare the variables here
    var flutterChannel: FlutterMethodChannel?
    var pendingCleverTapUrl: String?

    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)
        let controller = window?.rootViewController as! FlutterViewController
        flutterChannel = FlutterMethodChannel(name: "clevertap_deeplink_channel", binaryMessenger: controller.binaryMessenger)

        // If a deep link was received before the channel was ready
        if let url = pendingCleverTapUrl {
            flutterChannel?.invokeMethod("clevertapDeeplink", arguments: url)
            pendingCleverTapUrl = nil
        }

        // Initialize CleverTap
        CleverTap.autoIntegrate()
        CleverTap.setDebugLevel(3)
        CleverTap.sharedInstance()?.setUrlDelegate(self)

        // Request notification permission
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(
            options: [.alert, .badge, .sound],
            completionHandler: { (granted, error) in
                if granted {
                    DispatchQueue.main.async {
                        UIApplication.shared.registerForRemoteNotifications()
                    }
                }
            }
        )
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    func shouldHandleCleverTap(_ url: URL?, for channel: CleverTapChannel) -> Bool {
        if let url = url {
            print("CleverTap Deeplink Received: \(url.absoluteString)")
            
            if flutterChannel != nil {
                flutterChannel?.invokeMethod("clevertapDeeplink", arguments: url.absoluteString)
            } else {
                // Store until Flutter channel is ready
                pendingCleverTapUrl = url.absoluteString
            }
            return false
        }
        return false
    }
}
