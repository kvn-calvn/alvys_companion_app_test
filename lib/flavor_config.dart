enum Flavor { dev, prod, qa }

class FlavorConfig {
  final Flavor flavor;
  final String env;
  final String rawApiBase;
  final String baseUrl;
  final String mobileBaseApi;

  final String gMapsKey;
  final String hereMapsKey;
  final String iosGeniusScanSDKKey;
  final String androidGeniusScanSDKKey;
  final String azureConnectionString;
  final String hubName;
  final String connectionString;

  final String launchDarklySdkKey;

  static FlavorConfig? _instance;

  factory FlavorConfig({
    required Flavor flavor,
    required String env,
    required String rawApiBase,
    required String baseUrl,
    required String mobileBaseApi,
    required String gMapsKey,
    required String hereMapsKey,
    required String iosGeniusScanSDKKey,
    required String androidGeniusScanSDKKey,
    required String azureTelemetryKey,
    required String hubName,
    required String connectionString,
    required String launchDarklySdkKey,
  }) {
    _instance ??= FlavorConfig._internal(
      flavor,
      env,
      rawApiBase,
      baseUrl,
      mobileBaseApi,
      gMapsKey,
      hereMapsKey,
      iosGeniusScanSDKKey,
      androidGeniusScanSDKKey,
      azureTelemetryKey,
      hubName,
      connectionString,
      launchDarklySdkKey,
    );
    return _instance!;
  }

  FlavorConfig._internal(
    this.flavor,
    this.env,
    this.rawApiBase,
    this.baseUrl,
    this.mobileBaseApi,
    this.gMapsKey,
    this.hereMapsKey,
    this.iosGeniusScanSDKKey,
    this.androidGeniusScanSDKKey,
    this.azureConnectionString,
    this.hubName,
    this.connectionString,
    this.launchDarklySdkKey,
  );

  static FlavorConfig? get instance => _instance;

  static bool get isDevelopment => _instance!.flavor == Flavor.dev;
  static bool get isProduction => _instance!.flavor == Flavor.prod;
  static bool get isQa => _instance!.flavor == Flavor.qa;
}
