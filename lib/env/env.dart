import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env')
abstract class Env {
  @EnviedField(varName: 'GMAPSKEY', obfuscate: true)
  static final gMapsKey = _Env.gMapsKey;
  @EnviedField(varName: 'HEREMAPSKEY', obfuscate: true)
  static final hereMapsKey = _Env.hereMapsKey;
  @EnviedField(varName: 'IOS_GENIUSSCANSDKKEY', obfuscate: true)
  static final iOSGeniusScanSDKKey = _Env.iOSGeniusScanSDKKey;
  @EnviedField(varName: 'ANDROID_GENIUSSCANSDKKEY', obfuscate: true)
  static final androidGeniusScanSDKKey = _Env.androidGeniusScanSDKKey;
  @EnviedField(varName: 'AZURETELEMETRYKEY_DEV', obfuscate: true)
  static final azureTelemetryKeyDEV = _Env.azureTelemetryKeyDEV;
  @EnviedField(varName: 'AZURETELEMETRYKEY_PROD', obfuscate: true)
  static final azureTelemetryKeyPROD = _Env.azureTelemetryKeyPROD;
  @EnviedField(varName: 'AZURETELEMETRYKEY_QA', obfuscate: true)
  static final azureTelemetryKeyQA = _Env.azureTelemetryKeyQA;

  static String get geniusScanKey =>
      Platform.isAndroid ? androidGeniusScanSDKKey : iOSGeniusScanSDKKey;
}
