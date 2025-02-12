import 'env/env.dart';
import 'flavor_config.dart';
import 'main_common.dart';
import 'src/utils/extensions.dart';

void main() {
  FlavorConfig(
    flavor: Flavor.qa,
    env: Flavor.qa.toUpperCase,
    rawApiBase: "alvysapi-qa.azurewebsites.net",
    baseUrl: "https://qaapi.alvys.net/api/",
    mobileBaseApi: 'https://qaapi.alvys.net/api/mobile/',
    storageUrl: "https://qafiles.alvys.net/",
    androidGeniusScanSDKKey: Env.androidGeniusScanSDKKeyQA,
    iosGeniusScanSDKKey: Env.iOSGeniusScanSDKKeyQA,
    azureTelemetryKey: Env.azureTelemetryConnectionStringQA,
    gMapsKey: Env.gMapsKey,
    hereMapsKey: Env.hereMapsKeyDEV,
    hubName: Env.hubNameQA,
    connectionString: Env.connectionStringQA,
    launchDarklySdkKey: Env.launchDarklySDKKeyQA,
  );

  mainCommon();
}
