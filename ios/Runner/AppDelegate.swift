import UIKit
import Flutter
import FirebaseCore
import WindowsAzureMessaging


@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate,MSNotificationHubDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      
      MSNotificationHub.setDelegate(self)

      
      let FVC: FlutterViewController = window?.rootViewController as! FlutterViewController
      let platformChannel = FlutterMethodChannel(name: "PlatformChannel", binaryMessenger: FVC as! FlutterBinaryMessenger)

      
      platformChannel.setMethodCallHandler { (call, result) in
         let method = call.method
         guard let args = call.arguments as? NSDictionary else {return}
         
         switch method {
             
         case "registerForNotification":
             self.NHRegisterattion(driverID: args["driverId"] as? String)
         case "unregisterNotification":
             MSNotificationHub.clearTags()
             MSNotificationHub.setEnabled(false)
         default:
             result(FlutterMethodNotImplemented)
         }
     }
      
    GeneratedPluginRegistrant.register(with: self)
    FirebaseApp.configure()
      
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
    func NHRegisterattion(driverID: String?) {
    
        guard let driverId = driverID  else {return}
        
        if let path = Bundle.main.path(forResource: "NHSettings", ofType: "plist") {
            if let configValues = NSDictionary(contentsOfFile: path) {
               
               var connectionString: String?
               var hubName: String?
                
                connectionString = configValues["CONNECTION_STRING"] as? String
                hubName = configValues["HUB_NAME"] as? String
          
                if (!(connectionString ?? "").isEmpty && !(hubName ?? "").isEmpty && !(driverID ?? "").isEmpty){
                    let hubOptions = MSNotificationHubOptions(withOptions: [.alert, .badge, .sound])!

                    MSNotificationHub.start(connectionString: connectionString!, hubName: hubName!,options: hubOptions)
                    MSNotificationHub.addTags([driverID!])
                    MSNotificationHub.setEnabled(true)
                }else {
                    print("Values missing to register NH\n\n")
                }
            }
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
     
        // Pass the notification payload to MSNotificationHub
        MSNotificationHub.didReceiveRemoteNotification(notification.request.content.userInfo)

        // Complete handling the notification
        completionHandler([])
    }
    
    
    @available(iOS 10.0, *)
    override
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {

        // Pass the notification payload to MSNotificationHub
        MSNotificationHub.didReceiveRemoteNotification(response.notification.request.content.userInfo)

        // Complete handling the notification
        completionHandler()
    }
    
    func notificationHub(_ notificationHub: MSNotificationHub!, didReceivePushNotification notification: MSNotificationHubMessage!) {

        let title = notification.title ?? ""
        let body = notification.body ?? ""

        if (UIApplication.shared.applicationState == .background) {
            NSLog("Notification received in background: title:\"\(title)\" body:\"\(body)\"")
        } else {
            NSLog("Notification received in foreground: title:\"\(title)\" body:\"\(body)\"")
        }
    }
    
}



