import 'package:alvys3/env/env.dart';
import 'package:alvys3/main_common.dart';
import 'package:alvys3/src/utils/extensions.dart';

import 'flavor_config.dart';

void main() {
  FlavorConfig(
    flavor: Flavor.prod,
    env: Flavor.prod.toUpperCase,
    rawApiBase: "api.alvys.com",
    baseUrl: "https://api.alvys.com/api/",
    mobileBaseApi: 'https://api.alvys.com/api/mobile/',
    storageUrl: "https://alvyssandboxstorage.blob.core.windows.net/",
    androidGeniusScanSDKKey: Env.androidGeniusScanSDKKey,
    iosGeniusScanSDKKey: Env.iOSGeniusScanSDKKey,
    azureTelemetryKey: Env.azureTelemetryKeyPROD,
    gMapsKey: Env.gMapsKey,
    hereMapsKey: Env.hereMapsKey,
    hubName: Env.hubNameProd,
    connectionString: Env.connectionStringProd,
  );

  mainCommon();
}
