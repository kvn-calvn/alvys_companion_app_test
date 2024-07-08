import 'env/env.dart';
import 'flavor_config.dart';
import 'main_common.dart';
import 'src/utils/extensions.dart';

void main() {
  FlavorConfig(
      flavor: Flavor.dev,
      env: Flavor.dev.toUpperCase,
      rawApiBase: "devapi.alvys.com",
      baseUrl: "https://devapi.alvys.com/api/",
      mobileBaseApi: 'https://devapi.alvys.com/api/mobile/',
      storageUrl: "https://alvysstorage.blob.core.windows.net/",
      androidGeniusScanSDKKey: Env.androidGeniusScanSDKKeyDEV,
      iosGeniusScanSDKKey: Env.iOSGeniusScanSDKKeyDEV,
      azureTelemetryKey: Env.azureTelemetryKeyDEV,
      gMapsKey: Env.gMapsKey,
      hereMapsKey: Env.hereMapsKeyDEV,
      hubName: Env.hubNameDEV,
      connectionString: Env.connectionStringDev);

  mainCommon();
}
