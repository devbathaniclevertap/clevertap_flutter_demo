import UIKit
import Flutter
import CleverTapSDK
import UserNotifications

@main
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)
        
        // Initialize CleverTap
        CleverTap.autoIntegrate()
        CleverTap.setDebugLevel(3)
        // CleverTap.sharedInstance()?.setUrlDelegate(self)

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
    
    // MARK: - CleverTapURLDelegate
    // func shouldHandleCleverTap(_ url: URL?, for channel: CleverTapChannel) -> Bool {
    //     if let url = url {
    //         print("Handling URL: \(url) for channel: \(channel)")
    //         // Add your deep link handling logic here
    //         return true
    //     }
    //     return false
    // }
}
