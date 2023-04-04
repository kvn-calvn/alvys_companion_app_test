import 'dart:io';

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

  @EnviedField(varName: 'HUB_NAME_QA', obfuscate: false)
  static const hubNameQA = _Env.hubNameQA;

  @EnviedField(varName: 'HUB_NAME_PROD', obfuscate: false)
  static const hubNameProd = _Env.hubNameProd;

  @EnviedField(varName: 'HUB_NAME_DEV', obfuscate: false)
  static const hubNameDEV = _Env.hubNameDEV;

  @EnviedField(varName: 'CONNECTION_STRING_PROD', obfuscate: true)
  static final connectionStringProd = _Env.connectionStringProd;

  @EnviedField(varName: 'CONNECTION_STRING_QA', obfuscate: true)
  static final connectionStringQA = _Env.connectionStringQA;

  @EnviedField(varName: 'CONNECTION_STRING_DEV', obfuscate: true)
  static final connectionStringDev = _Env.connectionStringDev;

  static String get geniusScanKey =>
      Platform.isAndroid ? androidGeniusScanSDKKey : iOSGeniusScanSDKKey;
}
