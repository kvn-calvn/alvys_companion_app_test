import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PlatformChannel {
  static const platform = MethodChannel('PLATFORM_CHANNEL');

  static void getNotification(
      String driverPhone, String hubName, String connectionString) async {
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
      String companyCode) async {
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
      await platform.invokeMethod("stopLocationTracking");
    } on PlatformException catch (e) {
      debugPrint(
        "Invoke stopLocationTracking unsuccessful: \n $e",
      );
    }
  }
}
