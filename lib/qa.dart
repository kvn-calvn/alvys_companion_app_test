import 'package:alvys3/env/env.dart';
import 'package:alvys3/main_common.dart';

import 'flavor_config.dart';

void main() {
  FlavorConfig(
    flavor: Flavor.qa,
    env: Flavor.qa.toString().toUpperCase(),
    rawApiBase: "alvysapi-qa.azurewebsites.net",
    baseUrl: "https://alvysapi-qa.azurewebsites.net/api/",
    mobileBaseApi: 'https://alvysapi-qa.azurewebsites.net/api/mobilev2/',
    storageUrl: "https://alvysqastorage.blob.core.windows.net/",
    androidGeniusScanSDKKey: Env.androidGeniusScanSDKKey,
    iosGeniusScanSDKKey: Env.iOSGeniusScanSDKKey,
    azureTelemetryKey: Env.azureTelemetryKeyQA,
    gMapsKey: Env.gMapsKey,
    hereMapsKey: Env.hereMapsKey,
  );

  mainCommon();
}
