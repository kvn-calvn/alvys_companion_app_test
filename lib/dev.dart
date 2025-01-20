import 'env/env.dart';
import 'flavor_config.dart';
import 'main_common.dart';
import 'src/utils/extensions.dart';

void main() {
  FlavorConfig(
    flavor: Flavor.dev,
    env: Flavor.dev.toUpperCase,
    rawApiBase: "devapi.alvys.net",
    baseUrl: "https://devapi.alvys.net/api/",
    mobileBaseApi: 'https://devapi.alvys.net/api/mobile/',
    storageUrl: "https://devfiles.alvys.net/",
    androidGeniusScanSDKKey: Env.androidGeniusScanSDKKeyDEV,
    iosGeniusScanSDKKey: Env.iOSGeniusScanSDKKeyDEV,
    azureTelemetryKey: Env.azureTelemetryConnectionStringDEV,
    gMapsKey: Env.gMapsKey,
    hereMapsKey: Env.hereMapsKeyDEV,
    hubName: Env.hubNameDEV,
    connectionString: Env.connectionStringDev,
    launchDarklySdkKey: Env.launchDarklySDKKeyDev,
  );

  mainCommon();
}
