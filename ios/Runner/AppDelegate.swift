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
      let platformChannel = FlutterMethodChannel(name: "PLATFORM_CHANNEL", binaryMessenger: FVC as! FlutterBinaryMessenger)

      
      platformChannel.setMethodCallHandler { (call, result) in
         let method = call.method
         guard let args = call.arguments as? NSDictionary else {return}
         
         switch method {
             
         case "registerForNotification":
             self.NHRegisterattion(driverID: args["driverId"] as? String, hubName: args["hubName"] as? String, connectionString: args["connectionString"] as? String)
         case "unregisterNotification":
             MSNotificationHub.clearTags()
             MSNotificationHub.setEnabled(false)
         case "startLocationTracking":
             print("\n\nSTART_TRACKING\n\n")
              
              guard let args = call.arguments as? Dictionary<String, Any> else {return}
              print("TRACKING_ARGS: ")
              print(args)
              
              LocationManager.shared.setUpLocation()
              LocationManager.shared.driverId = (args["DriverId"] as? String)
              LocationManager.shared.loadNumber = (args["tripNumber"] as? String)
              LocationManager.shared.tripId = (args["tripId"] as? String)
              LocationManager.shared.driverName = (args["DriverName"] as? String)
              LocationManager.shared.url = (args["url"] as? String)
              LocationManager.shared.companyCode = (args["companyCode"] as? String)
              LocationManager.shared.token = (args["token"] as? String)
         default:
             result(FlutterMethodNotImplemented)
         }
     }
      
    GeneratedPluginRegistrant.register(with: self)
    FirebaseApp.configure()
      
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
    func NHRegisterattion(driverID: String?, hubName: String?, connectionString: String?) {
        
        if (!(connectionString ?? "").isEmpty && !(hubName ?? "").isEmpty && !(driverID ?? "").isEmpty){
            let hubOptions = MSNotificationHubOptions(withOptions: [.alert, .badge, .sound])!

            MSNotificationHub.start(connectionString: connectionString!, hubName: hubName!,options: hubOptions)
            MSNotificationHub.addTags([driverID!])
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



