import UIKit
import Flutter
import FirebaseCore
import WindowsAzureMessaging
import UserNotifications

import GoogleMaps


@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate,MSNotificationHubDelegate {
    
    private var notificationPresentationCompletionHandler: Any?
    private var notificationResponseCompletionHandler: Any?
    private var notificationCategory: String?
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
         
        let FVC: FlutterViewController = window?.rootViewController as! FlutterViewController
        let platformChannel = FlutterMethodChannel(name: "PLATFORM_CHANNEL", binaryMessenger: FVC as! FlutterBinaryMessenger)
        
        UNUserNotificationCenter.current().delegate = self;
        MSNotificationHub.setDelegate(self)
              
        platformChannel.setMethodCallHandler { (call, result) in
            let method = call.method
            guard let args = call.arguments as? NSDictionary else {return}
            
            switch method {
                
            case "registerForNotification":
                self.NHRegisterattion(driverPhone: args["driverPhone"] as? String, hubName: args["hubName"] as? String, connectionString: args["connectionString"] as? String)
            case "unregisterNotification":
                MSNotificationHub.clearTags()
                MSNotificationHub.setEnabled(false)
            case "startLocationTracking":
                print("\n\nSTART_TRACKING\n\n")
                
                guard let args = call.arguments as? Dictionary<String, Any> else {return}
               
                
                LocationManager.shared.setUpLocation()
                LocationManager.shared.driverId = (args["DriverId"] as? String)
                LocationManager.shared.loadNumber = (args["tripNumber"] as? String)
                LocationManager.shared.tripId = (args["tripId"] as? String)
                LocationManager.shared.driverName = (args["DriverName"] as? String)
                LocationManager.shared.url = (args["url"] as? String)
                LocationManager.shared.companyCode = (args["companyCode"] as? String)
                LocationManager.shared.token = (args["token"] as? String)
            case "stopLocationTracking":
                LocationManager.shared.stopLocation()
                
            case "isTablet":
                result(UIDevice.current.userInterfaceIdiom == .pad)
            default:
                result(FlutterMethodNotImplemented)
            }
        }
        
        GMSServices.provideAPIKey("AIzaSyDe8oPVBFDy1cfY0D8yHw9DCr7TLUdxVHs")
        FirebaseApp.configure()
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    func NHRegisterattion(driverPhone: String?, hubName: String?, connectionString: String?) {
        
        if (!(connectionString ?? "").isEmpty && !(hubName ?? "").isEmpty && !(driverPhone ?? "").isEmpty){
            
            let hubOptions = MSNotificationHubOptions(withOptions: [.alert, .badge, .sound])!
            
            MSNotificationHub.start(connectionString: connectionString!, hubName: hubName!,options: hubOptions)
            MSNotificationHub.addTags([driverPhone!])
            MSNotificationHub.setEnabled(true)
        }else {
            print("Values missing to register NH\n\n")
        }
    }
    override
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        // Pass the device token to MSNotificationHub
        MSNotificationHub.didRegisterForRemoteNotifications(withDeviceToken: deviceToken)
    }
    
    override
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        
        // Pass the error to MSNotificationHub
        MSNotificationHub.didFailToRegisterForRemoteNotificationsWithError(error)
    }
    
    @available(iOS 10.0, *)
    override
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        //Pass the notification payload to MSNotificationHub
        MSNotificationHub.didReceiveRemoteNotification(notification.request.content.userInfo)
        
        self.notificationPresentationCompletionHandler = completionHandler;
    }
    
    @available(iOS 10.0, *)
    override
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
                
        // Pass the notification payload to MSNotificationHub
        MSNotificationHub.didReceiveRemoteNotification(response.notification.request.content.userInfo)
        
        self.notificationResponseCompletionHandler = completionHandler;
    }
    
    override func applicationDidBecomeActive(_ application: UIApplication) {
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
    
    func notificationHub(_ notificationHub: MSNotificationHub!, didReceivePushNotification notification: MSNotificationHubMessage!) {
    
        //guard let aps = notification.userInfo["aps"] as? [String: Any] else { return }
        //guard let category = aps["category"] as? String else {return}
        
        //Do something when notification is tapped whether app is active or not
        if (notificationResponseCompletionHandler != nil) {
            guard let url = notification.userInfo["LINK"] as? String else {return}
            openDeepLinkURL(url: url)
        }
    
        // Call notification completion handlers.
        if (notificationResponseCompletionHandler != nil) {
            (notificationResponseCompletionHandler as! () -> Void)()
            notificationResponseCompletionHandler = nil
        }
        if (notificationPresentationCompletionHandler != nil) {
            (notificationPresentationCompletionHandler as! (UNNotificationPresentationOptions) -> Void)([.banner, .sound])
            notificationPresentationCompletionHandler = nil
        }
    }
    
    func openDeepLinkURL(url: String){
        let deepLinkUrl = URL(string: url)!
        if UIApplication.shared.canOpenURL(deepLinkUrl) {
            UIApplication.shared.open(deepLinkUrl, options: [:]) { success in
                print("Can open app store URL: \(url)")
            }
        }else {
            print("Cannot open URL: \(url)")
        }
    }
}



