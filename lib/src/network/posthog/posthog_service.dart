import 'package:posthog_flutter/posthog_flutter.dart';

class PostHogService {
  Future<void> postHogTrackEvent(
      String event, Map<String, Object>? properties) async {
    await Posthog().capture(
      eventName: event,
      properties: properties,
    );
  }

  Future<void> reset() async {
    await Posthog().reset();
  }

  Future<void> postHogIdentify(
      String userId,
      Map<String, Object> userProperties,
      Map<String, Object>? userPropertiesSetOnce) async {
    await Posthog().identify(
        userId: userId,
        userProperties: userProperties,
        userPropertiesSetOnce: userPropertiesSetOnce);
  }

  Future<void> postHogScreen(
    String screenName,
    Map<String, Object>? properties,
  ) async {
    await Posthog().screen(screenName: screenName, properties: properties);
  }
}
