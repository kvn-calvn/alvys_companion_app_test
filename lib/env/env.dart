// ignore_for_file: non_constant_identifier_names

import 'dart:io';

import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env')
abstract class Env {
  @EnviedField(varName: 'GMAPSKEY', obfuscate: true)
  static final String gMapsKey = _Env.gMapsKey;

  @EnviedField(varName: 'HEREMAPSKEY', obfuscate: true)
  static final String hereMapsKey = _Env.hereMapsKey;

  @EnviedField(varName: 'IOS_GENIUSSCANSDKKEY', obfuscate: true)
  static final String iOSGeniusScanSDKKey = _Env.iOSGeniusScanSDKKey;

  @EnviedField(varName: 'IOS_GENIUSSCANSDKKEY_QA', obfuscate: true)
  static final String iOSGeniusScanSDKKey_QA = _Env.iOSGeniusScanSDKKey_QA;

  @EnviedField(varName: 'IOS_GENIUSSCANSDKKEY_DEV', obfuscate: true)
  static final String iOSGeniusScanSDKKey_DEV = _Env.iOSGeniusScanSDKKey_DEV;

  @EnviedField(varName: 'ANDROID_GENIUSSCANSDKKEY', obfuscate: true)
  static final String androidGeniusScanSDKKey = _Env.androidGeniusScanSDKKey;

  @EnviedField(varName: 'ANDROID_GENIUSSCANSDKKEY_DEV', obfuscate: true)
  static final String androidGeniusScanSDKKey_DEV = _Env.androidGeniusScanSDKKey_DEV;

  @EnviedField(varName: 'ANDROID_GENIUSSCANSDKKEY_QA', obfuscate: true)
  static final String androidGeniusScanSDKKey_QA = _Env.androidGeniusScanSDKKey_QA;

  @EnviedField(varName: 'AZURETELEMETRYKEY_DEV', obfuscate: true)
  static final String azureTelemetryKeyDEV = _Env.azureTelemetryKeyDEV;

  @EnviedField(varName: 'AZURETELEMETRYKEY_PROD', obfuscate: true)
  static final String azureTelemetryKeyPROD = _Env.azureTelemetryKeyPROD;

  @EnviedField(varName: 'AZURETELEMETRYKEY_QA', obfuscate: true)
  static final String azureTelemetryKeyQA = _Env.azureTelemetryKeyQA;

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
