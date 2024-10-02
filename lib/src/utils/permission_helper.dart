import 'dart:io';

import 'package:coder_matthews_extensions/coder_matthews_extensions.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionHelper {
  static Future<bool> getCameraPermission() async {
    var status = await Permission.camera.status;
    if (status == PermissionStatus.granted) return true;
    if (status == PermissionStatus.permanentlyDenied) return false;
    var newStatus = await Permission.camera.request();
    switch (newStatus) {
      case PermissionStatus.permanentlyDenied:
      case PermissionStatus.denied:
      case PermissionStatus.restricted:
        return false;
      case PermissionStatus.granted:
      case PermissionStatus.limited:
      case PermissionStatus.provisional:
        return true;
    }
  }

  static Future<bool> getPermission(Permission permission) async {
    var status = await permission.status;
    if (status == PermissionStatus.granted) return true;
    if (status == PermissionStatus.permanentlyDenied) return false;

    var newStatus = await permission.request();
    switch (newStatus) {
      case PermissionStatus.permanentlyDenied:
      case PermissionStatus.denied:
      case PermissionStatus.restricted:
        return false;
      case PermissionStatus.granted:
      case PermissionStatus.limited:
      case PermissionStatus.provisional:
        return true;
    }
  }

  static Future<List<Permission>> get appUserPermissions async => [
        Permission.location,
        Permission.locationAlways,
        Permission.locationWhenInUse,
        Permission.notification,
        Platform.isAndroid ? await PermissionHelper.androidGalleryPermission() : Permission.photos,
        Permission.camera
      ];
  static Future<Map<String, dynamic>> getAllUserPermissions(List<Permission> permissions) async =>
      Map.fromEntries(await permissions.mapAsync(
          (element) async => MapEntry(element.toString().replaceAll('Permission.', ''), (await element.status).name)));
  static Future<void> requestPermissionAndThrow(Permission permission, [String action = 'proceed']) async {
    ValidationContract.requires(await getPermission(permission), "Permission required.",
        "The ${permission.toString().replaceAll('Permission.', '').splitCamelCaseWord().sentenceCase} permission is reuired to $action.");
  }

  static Future<Permission> androidGalleryPermission() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    var androidInfo = await deviceInfo.androidInfo;
    return androidInfo.version.sdkInt >= 33 ? Permission.photos : Permission.storage;
  }
}
