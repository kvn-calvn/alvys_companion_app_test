import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import 'exceptions.dart';

class Helpers {
  static Future<Position> getUserPosition(void Function() onError) async {
    var serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error(PermissionException(
          "Location permissions are disabled. Go to settings and enable location services",
          onError, [
        ExceptionAction(
            title: 'Open Settings',
            action: () =>
                AppSettings.openAppSettings(type: AppSettingsType.settings))
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
              title: 'Open Settings',
              action: () =>
                  AppSettings.openAppSettings(type: AppSettingsType.settings))
        ]));
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(PermissionException(
          'Location services have been disabled, open location settings to allow "Alvys" access to your location.',
          onError, [
        ExceptionAction(
            title: 'Open Settings',
            action: () =>
                AppSettings.openAppSettings(type: AppSettingsType.settings))
      ]));
    }
    return await Geolocator.getCurrentPosition();
  }

  String toSnakeCase(String input) {
    // Insert underscores before uppercase letters, then convert to lowercase
    var output = input
        // Insert underscores before uppercase letters (but not at the start)
        .replaceAllMapped(
            RegExp(r'(?<!^)([A-Z])'), (match) => '_${match.group(0)}')
        // Replace spaces or multiple spaces with underscores
        .replaceAll(RegExp(r'\s+'), '_')
        // Convert the entire string to lowercase
        .toLowerCase();

    debugPrint("TEST_: $output");
    return output;
  }
  // static Future<void> setCompanyCode(String companyCode) async {
  //   var pref = await SharedPreferences.getInstance();
  //   await pref.setString(SharedPreferencesKey.companyCode.name, companyCode);
  // }
}
