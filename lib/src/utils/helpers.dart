import 'package:alvys3/src/utils/exceptions.dart';
import 'package:geolocator/geolocator.dart';

class Helpers {
  static Future<Position> getUserPosition(void Function() onError) async {
    var serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error(
          AlvysException("Go to settings and enable location services", 'Location services are disabled.', onError));
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error(PermissionException(
            "Location permissions are denied. Go to settings and enable location services", onError));
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          PermissionException('Location permissions are permanently denied, we cannot request permissions.', onError));
    }
    return await Geolocator.getCurrentPosition(forceAndroidLocationManager: true);
  }
}
