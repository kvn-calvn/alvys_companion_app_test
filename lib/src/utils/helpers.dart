import 'package:app_settings/app_settings.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geolocator/geolocator.dart';

import 'exceptions.dart';
import 'magic_strings.dart';

class Helpers {
  static Future<Position> getUserPosition(void Function() onError) async {
    var serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error(PermissionException(
          "Location permissions are disabled. Go to settings and enable location services", onError, [
        ExceptionAction(
            title: 'Open Settings', action: () => AppSettings.openAppSettings(type: AppSettingsType.settings))
      ]));
    }
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error(PermissionException(
            "Location permissions are denied. Go to settings and enable location services", onError, [
          ExceptionAction(
              title: 'Open Settings', action: () => AppSettings.openAppSettings(type: AppSettingsType.settings))
        ]));
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(PermissionException(
          'Location permissions are permanently denied, we cannot request permissions.', onError, [
        ExceptionAction(
            title: 'Open Settings', action: () => AppSettings.openAppSettings(type: AppSettingsType.settings))
      ]));
    }
    return await Geolocator.getCurrentPosition();
  }

  static Future<void> setCompanyCode(String companyCode) async {
    var storage = const FlutterSecureStorage();
    await storage.write(key: StorageKey.companyCode.name, value: companyCode);
  }
}
