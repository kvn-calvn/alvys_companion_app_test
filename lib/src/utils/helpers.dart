import 'package:app_settings/app_settings.dart';
import 'package:geolocator/geolocator.dart';

import 'exceptions.dart';

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
            'Location services have been denied, open location settings to allow "Alvys" access to your location.',
            onError, [
          ExceptionAction(
              title: 'Open Settings', action: () => AppSettings.openAppSettings(type: AppSettingsType.settings))
        ]));
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(PermissionException(
          'Location services have been disabled, open location settings to allow "Alvys" access to your location.',
          onError, [
        ExceptionAction(
            title: 'Open Settings', action: () => AppSettings.openAppSettings(type: AppSettingsType.settings))
      ]));
    }
    return await Geolocator.getCurrentPosition();
  }

  // static Future<void> setCompanyCode(String companyCode) async {
  //   var pref = await SharedPreferences.getInstance();
  //   await pref.setString(SharedPreferencesKey.companyCode.name, companyCode);
  // }
}
