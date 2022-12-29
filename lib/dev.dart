import 'package:alvys3/env/env.dart';

import 'flavor_config.dart';

void main() {
  FlavorConfig(
      flavor: Flavor.dev,
      env: "DEV",
      baseUrl: "https://devapi.alvys.com/api/mobilev2/",
      androidGeniusScanSDKKey: Env.androidGeniusScanSDKKey,
      iosGeniusScanSDKKey: Env.iOSGeniusScanSDKKey,
      azureTelemetryKey: Env.azureTelemetryKeyDEV,
      gMapsKey: Env.gMapsKey,
      hereMapsKey: Env.hereMapsKey);

  //mainCommon();
}
