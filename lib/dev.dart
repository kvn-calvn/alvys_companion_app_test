import 'package:alvys3/env/env.dart';
import 'package:alvys3/main_common.dart';

import 'flavor_config.dart';

void main() {
  FlavorConfig(
    flavor: Flavor.dev,
    env: Flavor.dev.toString().toUpperCase(),
    rawApiBase: "devapi.alvys.com",
    baseUrl: "https://devapi.alvys.com/api/",
    mobileBaseApi: 'https://devapi.alvys.com/api/mobilev2/',
    storageUrl: "https://alvysstorage.blob.core.windows.net/",
    androidGeniusScanSDKKey: Env.androidGeniusScanSDKKey,
    iosGeniusScanSDKKey: Env.iOSGeniusScanSDKKey,
    azureTelemetryKey: Env.azureTelemetryKeyDEV,
    gMapsKey: Env.gMapsKey,
    hereMapsKey: Env.hereMapsKey,
  );

  mainCommon();
}
