import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'posthog_service.dart';

// Create a provider for the PostHogService
final postHogProvider = Provider<PostHogService>((ref) {
  return PostHogService();
});
