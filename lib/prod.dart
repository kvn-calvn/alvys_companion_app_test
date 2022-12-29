import 'package:alvys3/env/env.dart';

import 'flavor_config.dart';

void main() {
  FlavorConfig(
      flavor: Flavor.prod,
      env: Flavor.prod.toString().toUpperCase(),
      baseUrl: "https://api.alvys.com/api/mobilev2/",
      androidGeniusScanSDKKey: Env.androidGeniusScanSDKKey,
      iosGeniusScanSDKKey: Env.iOSGeniusScanSDKKey,
      azureTelemetryKey: Env.azureTelemetryKeyPROD,
      gMapsKey: Env.gMapsKey,
      hereMapsKey: Env.hereMapsKey);

  //mainCommon();
}
