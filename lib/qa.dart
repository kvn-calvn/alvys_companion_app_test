import 'env/env.dart';
import 'main_common.dart';
import 'src/utils/extensions.dart';

import 'flavor_config.dart';

void main() {
  FlavorConfig(
    flavor: Flavor.qa,
    env: Flavor.qa.toUpperCase,
    rawApiBase: "alvysapi-qa.azurewebsites.net",
    baseUrl: "https://alvysapi-qa.azurewebsites.net/api/",
    mobileBaseApi: 'https://alvysapi-qa.azurewebsites.net/api/mobile/',
    storageUrl: "https://alvysqastorage.blob.core.windows.net/",
    androidGeniusScanSDKKey: Env.androidGeniusScanSDKKeyQA,
    iosGeniusScanSDKKey: Env.iOSGeniusScanSDKKeyQA,
    azureTelemetryKey: Env.azureTelemetryKeyQA,
    gMapsKey: Env.gMapsKey,
    hereMapsKey: Env.hereMapsKey,
    hubName: Env.hubNameQA,
    connectionString: Env.connectionStringQA,
  );

  mainCommon();
}
