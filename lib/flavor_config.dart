// ignore_for_file: constant_identifier_names
import 'env/env.dart';

enum Flavor { dev, prod, qa }

class FlavorConfig {
  final Flavor flavor;
  final String env;
  final String baseUrl;
  final String gMapsKey;
  final String hereMapsKey;
  final String iosGeniusScanSDKKey;
  final String androidGeniusScanSDKKey;
  final String azureTelemetryKey;

  static FlavorConfig? _instance;

  factory FlavorConfig(
      {required Flavor flavor,
      required String baseUrl,
      required String env,
      required String gMapsKey,
      required String hereMapsKey,
      required String iosGeniusScanSDKKey,
      required String androidGeniusScanSDKKey,
      required String azureTelemetryKey}) {
    _instance ??= FlavorConfig._internal(
        flavor,
        baseUrl,
        env,
        gMapsKey,
        hereMapsKey,
        iosGeniusScanSDKKey,
        androidGeniusScanSDKKey,
        azureTelemetryKey);
    return _instance!;
  }

  FlavorConfig._internal(
    this.flavor,
    this.baseUrl,
    this.env,
    this.gMapsKey,
    this.hereMapsKey,
    this.iosGeniusScanSDKKey,
    this.androidGeniusScanSDKKey,
    this.azureTelemetryKey,
  );

  static FlavorConfig? get instance => _instance;

  static bool isDevelopment() => _instance!.flavor == Flavor.dev;
  static bool isProduction() => _instance!.flavor == Flavor.prod;
  static bool isQa() => _instance!.flavor == Flavor.qa;
}
