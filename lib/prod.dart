import 'env/env.dart';
import 'flavor_config.dart';
import 'main_common.dart';
import 'src/utils/extensions.dart';

void main() {
  FlavorConfig(
      flavor: Flavor.prod,
      env: Flavor.prod.toUpperCase,
      rawApiBase: "api.alvys.com",
      baseUrl: "https://api.alvys.com/api/",
      mobileBaseApi: 'https://api.alvys.com/api/mobile/',
      storageUrl: "https://files.alvys.com/",
      androidGeniusScanSDKKey: Env.androidGeniusScanSDKKey,
      iosGeniusScanSDKKey: Env.iOSGeniusScanSDKKey,
      azureTelemetryKey: Env.azureTelemetryKeyPROD,
      gMapsKey: Env.gMapsKey,
      hereMapsKey: Env.hereMapsKeyPROD,
      hubName: Env.hubNameProd,
      connectionString: Env.connectionStringProd);

  mainCommon();
}
