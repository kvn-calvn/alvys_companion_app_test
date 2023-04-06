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
        return true;
    }
  }
}
