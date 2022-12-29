import 'package:alvys3/env/env.dart';

import 'flavor_config.dart';

void main() {
  FlavorConfig(
      flavor: Flavor.qa,
      env: Flavor.qa.toString().toUpperCase(),
      baseUrl: "https://alvysapi-qa.azurewebsites.net/api/mobilev2/",
      androidGeniusScanSDKKey: Env.androidGeniusScanSDKKey,
      iosGeniusScanSDKKey: Env.iOSGeniusScanSDKKey,
      azureTelemetryKey: Env.azureTelemetryKeyQA,
      gMapsKey: Env.gMapsKey,
      hereMapsKey: Env.hereMapsKey);

  //mainCommon();
}
