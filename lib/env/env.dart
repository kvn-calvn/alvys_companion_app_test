import 'dart:io';

import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env')
abstract class Env {
  @EnviedField(varName: 'GMAPSKEY', obfuscate: true)
  static final String gMapsKey = _Env.gMapsKey;

  @EnviedField(varName: 'HEREMAPSKEYDEV', obfuscate: true)
  static final String hereMapsKeyDEV = _Env.hereMapsKeyDEV;

  @EnviedField(varName: 'HEREMAPSKEYPROD', obfuscate: true)
  static final String hereMapsKeyPROD = _Env.hereMapsKeyPROD;

  @EnviedField(varName: 'IOS_GENIUSSCANSDKKEY', obfuscate: true)
  static final String iOSGeniusScanSDKKey = _Env.iOSGeniusScanSDKKey;

  @EnviedField(varName: 'IOS_GENIUSSCANSDKKEY_QA', obfuscate: true)
  static final String iOSGeniusScanSDKKeyQA = _Env.iOSGeniusScanSDKKeyQA;

  @EnviedField(varName: 'IOS_GENIUSSCANSDKKEY_DEV', obfuscate: true)
  static final String iOSGeniusScanSDKKeyDEV = _Env.iOSGeniusScanSDKKeyDEV;

  @EnviedField(varName: 'ANDROID_GENIUSSCANSDKKEY', obfuscate: true)
  static final String androidGeniusScanSDKKey = _Env.androidGeniusScanSDKKey;

  @EnviedField(varName: 'ANDROID_GENIUSSCANSDKKEY_DEV', obfuscate: true)
  static final String androidGeniusScanSDKKeyDEV = _Env.androidGeniusScanSDKKeyDEV;

  @EnviedField(varName: 'ANDROID_GENIUSSCANSDKKEY_QA', obfuscate: true)
  static final String androidGeniusScanSDKKeyQA = _Env.androidGeniusScanSDKKeyQA;

  @EnviedField(varName: 'AZURETELEMETRY_CONNECTION_STRING_DEV', obfuscate: true)
  static final String azureTelemetryConnectionStringDEV = _Env.azureTelemetryConnectionStringDEV;

  @EnviedField(varName: 'AZURETELEMETRY_CONNECTION_STRING_PROD', obfuscate: true)
  static final String azureTelemetryConnectionStringPROD = _Env.azureTelemetryConnectionStringPROD;

  @EnviedField(varName: 'AZURETELEMETRY_CONNECTION_STRING_QA', obfuscate: true)
  static final String azureTelemetryConnectionStringQA = _Env.azureTelemetryConnectionStringQA;

  @EnviedField(varName: 'HUB_NAME_QA', obfuscate: false)
  static const String hubNameQA = _Env.hubNameQA;

  @EnviedField(varName: 'HUB_NAME_PROD', obfuscate: false)
  static const String hubNameProd = _Env.hubNameProd;

  @EnviedField(varName: 'HUB_NAME_DEV', obfuscate: false)
  static const String hubNameDEV = _Env.hubNameDEV;

  @EnviedField(varName: 'CONNECTION_STRING_PROD', obfuscate: true)
  static final String connectionStringProd = _Env.connectionStringProd;

  @EnviedField(varName: 'CONNECTION_STRING_QA', obfuscate: true)
  static final String connectionStringQA = _Env.connectionStringQA;

  @EnviedField(varName: 'CONNECTION_STRING_DEV', obfuscate: true)
  static final String connectionStringDev = _Env.connectionStringDev;

  static String get geniusScanKey => Platform.isAndroid ? androidGeniusScanSDKKey : iOSGeniusScanSDKKey;
}
