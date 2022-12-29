// ignore_for_file: constant_identifier_names
import 'env/env.dart';

enum Flavor { dev, prod, qa }

class FlavorConfig {
  final Flavor flavor;
  final String env;
  final String baseUrl;

  static FlavorConfig? _instance;

  factory FlavorConfig({
    required Flavor flavor,
    required String baseUrl,
    required String env,
  }) {
    _instance ??= FlavorConfig._internal(flavor, baseUrl, env);
    return _instance!;
  }

  FlavorConfig._internal(
    this.flavor,
    this.baseUrl,
    this.env,
  );

  static FlavorConfig? get instance => _instance;

  static bool isDevelopment() => _instance!.flavor == Flavor.dev;

  static bool isProduction() => _instance!.flavor == Flavor.prod;
}
