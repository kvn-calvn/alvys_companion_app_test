import 'package:alvys3/src/features/authentication/presentation/auth_provider_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'posthog_service.dart';

// Create a provider for the PostHogService
final postHogProvider = Provider<PostHogService>((ref) {
  var driver = ref.read(authProvider).value?.driver;
  return PostHogService(driver);
});
