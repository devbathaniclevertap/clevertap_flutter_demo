import Flutter
import UIKit
import CleverTapSDK
import clevertap_plugin
import FirebaseCore
import UserNotifications

@main
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)
        
        // Configure CleverTap
        CleverTap.autoIntegrate()
        CleverTapPlugin.sharedInstance()?.applicationDidLaunch(options: launchOptions)
        
        // Initialize Rich Push Notifications
        let notificationCategories = Set([
            UNNotificationCategory(
                identifier: "ct_rich_push",
                actions: [],
                intentIdentifiers: [],
                options: .customDismissAction
            )
        ])
        
        UNUserNotificationCenter.current().setNotificationCategories(notificationCategories)
        registerForPush()
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    func registerForPush() {
        // Register for Push notifications
        UNUserNotificationCenter.current().delegate = self
        
        // Request permissions with options
        let options: UNAuthorizationOptions = [.alert, .sound, .badge, .carPlay]
        UNUserNotificationCenter.current().requestAuthorization(
            options: options,
            completionHandler: { (granted, error) in
                if granted {
                    DispatchQueue.main.async {
                        UIApplication.shared.registerForRemoteNotifications()
                        
                        // Record event when permission is granted
                        CleverTap.sharedInstance()?.recordEvent("NotificationPermissionGranted")
                    }
                } else {
                    if let error = error {
                        print("Failed to request authorization: \(error.localizedDescription)")
                    }
                }
            }
        )
    }
    
}
