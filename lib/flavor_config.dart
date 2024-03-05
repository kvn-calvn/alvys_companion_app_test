enum Flavor { dev, prod, qa }

class FlavorConfig {
  final Flavor flavor;
  final String env;
  final String rawApiBase;
  final String baseUrl;
  final String storageUrl;
  final String mobileBaseApi;

  final String gMapsKey;
  final String hereMapsKey;
  final String iosGeniusScanSDKKey;
  final String androidGeniusScanSDKKey;
  final String azureTelemetryKey;
  final String hubName;
  final String connectionString;
  final String appcenterIOS;
  final String appcenterAndroid;

  static FlavorConfig? _instance;

  factory FlavorConfig({
    required Flavor flavor,
    required String env,
    required String rawApiBase,
    required String baseUrl,
    required String storageUrl,
    required String mobileBaseApi,
    required String gMapsKey,
    required String hereMapsKey,
    required String iosGeniusScanSDKKey,
    required String androidGeniusScanSDKKey,
    required String azureTelemetryKey,
    required String hubName,
    required String connectionString,
    required String appcenterIOS,
    required String appcenterAndroid,
  }) {
    _instance ??= FlavorConfig._internal(
        flavor,
        env,
        rawApiBase,
        baseUrl,
        storageUrl,
        mobileBaseApi,
        gMapsKey,
        hereMapsKey,
        iosGeniusScanSDKKey,
        androidGeniusScanSDKKey,
        azureTelemetryKey,
        hubName,
        connectionString,
        appcenterIOS,
        appcenterAndroid);
    return _instance!;
  }

  FlavorConfig._internal(
    this.flavor,
    this.env,
    this.rawApiBase,
    this.baseUrl,
    this.storageUrl,
    this.mobileBaseApi,
    this.gMapsKey,
    this.hereMapsKey,
    this.iosGeniusScanSDKKey,
    this.androidGeniusScanSDKKey,
    this.azureTelemetryKey,
    this.hubName,
    this.connectionString,
    this.appcenterIOS,
    this.appcenterAndroid,
  );

  static FlavorConfig? get instance => _instance;

  static bool get isDevelopment => _instance!.flavor == Flavor.dev;
  static bool get isProduction => _instance!.flavor == Flavor.prod;
  static bool get isQa => _instance!.flavor == Flavor.qa;
}
