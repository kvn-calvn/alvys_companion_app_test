import 'package:alvys3/env/env.dart';
import 'package:alvys3/main_common.dart';

import 'flavor_config.dart';

void main() {
  FlavorConfig(
      flavor: Flavor.prod,
      env: Flavor.prod.toString().toUpperCase(),
      rawApiBase: "api.alvys.com",
      baseUrl: "https://api.alvys.com/api/",
      mobileBaseApi: 'https://api.alvys.com/api/mobilev2/',
      storageUrl: "https://alvyssandboxstorage.blob.core.windows.net/",
      androidGeniusScanSDKKey: Env.androidGeniusScanSDKKey,
      iosGeniusScanSDKKey: Env.iOSGeniusScanSDKKey,
      azureTelemetryKey: Env.azureTelemetryKeyPROD,
      gMapsKey: Env.gMapsKey,
      hereMapsKey: Env.hereMapsKey);

  mainCommon();
}
