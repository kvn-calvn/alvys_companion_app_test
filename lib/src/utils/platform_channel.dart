//import 'package:alvys3/flavor_config.dart';
import 'package:coder_matthews_extensions/coder_matthews_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

import 'dummy_data.dart';

class PlatformChannel {
  static const platform = MethodChannel('PLATFORM_CHANNEL');
  static void getNotification(String driverPhone, String hubName, String connectionString) async {
    try {
      await platform.invokeMethod('registerForNotification', <String, String>{
        'driverPhone': driverPhone,
        'hubName': hubName,
        'connectionString': connectionString
      });
    } on PlatformException catch (e) {
      debugPrint(
        "Invoke registerForNotification unsuccessful $e",
      );
    }
  }

  static void startLocationTracking(
    String driverName,
    String driverID,
    String tripNumber,
    String tripId,
    String token,
    String url,
    String companyCode,
  ) async {
    debugPrint("START_LOCATION_TRACKING_MC_CALLED");
    if (companyCode.equalsIgnoreCase(testTrip.companyCode ?? "")) return;
    await platform.invokeMethod('startLocationTracking', <String, dynamic>{
      'DriverName': driverName,
      'DriverId': driverID,
      'tripNumber': tripNumber,
      'tripId': tripId,
      'companyCode': companyCode,
      'token': token,
      'url': url
    });
  }

  static void stopLocationTracking() async {
    try {
      debugPrint("STOP_LOCATION_TRACKING_MC_CALLED");

      platform.invokeMethod("stopLocationTracking", <String, dynamic>{});
    } on PlatformException catch (e) {
      debugPrint(
        "Invoke stopLocationTracking unsuccessful: \n $e",
      );
    }
  }

  static Future<bool> isTablet() async {
    try {
      return await platform.invokeMethod("isTablet", <String, dynamic>{});
    } on PlatformException catch (e) {
      debugPrint(
        "Determining if device is a tablet was unsuccessful: \n $e",
      );
      return false;
    }
  }

  // static Future<void> passApiKeys() async {
  //   try {
  //     platform.invokeMethod("nativeApiKeys", <String, String>{
  //       'appcenterKey': Platform.isIOS ? FlavorConfig.instance!.appcenterIOS : FlavorConfig.instance!.appcenterAndroid
  //     });
  //   } on Exception catch (e) {
  //     debugPrint(
  //       "Sending api keys unsuccessful: \n $e",
  //     );
  //   }
  // }

  static void unregisterNotification() async {
    try {
      platform.invokeMethod("unregisterNotification", <String, String>{});
    } on Exception catch (e) {
      debugPrint(
        "unregister notification unsuccessful: \n $e",
      );
    }
  }

  static Future<PermissionStatus> requestAndroidLocationPermissions() async {
    try {
      bool res = await platform.invokeMethod("requestLocationPermissions", <String, String>{});
      return res ? PermissionStatus.granted : PermissionStatus.permanentlyDenied;
    } on Exception {
      return PermissionStatus.permanentlyDenied;
    }
  }
}
