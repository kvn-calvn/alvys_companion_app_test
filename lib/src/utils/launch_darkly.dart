import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:launchdarkly_flutter_client_sdk/launchdarkly_flutter_client_sdk.dart';

class LaunchDarklyClient {
  late LDClient client;
  bool _initialized = false;

  LaunchDarklyClient._privateConstructor();

  static final LaunchDarklyClient _instance =
      LaunchDarklyClient._privateConstructor();

  static LaunchDarklyClient get instance => _instance;

  Future<void> init(String mobileKey) async {
    if (_initialized) return;

    final config = LDConfig(
      mobileKey,
      AutoEnvAttributes.enabled,
    );

    final contextBuilder = LDContextBuilder();
    final context = contextBuilder.build();

    client = LDClient(config, context);
    await client.start();
    _initialized = true;
  }
}

final launchDarklyClientProvider = Provider<LaunchDarklyClient>((ref) {
  return LaunchDarklyClient.instance;
});
