import 'package:flutter/material.dart';
import 'package:posthog_flutter/posthog_flutter.dart';

import '../utils/helpers.dart';

class PostHogRouteObserver extends NavigatorObserver {
  @override
  void didPop(Route route, Route? previousRoute) {
    _sendPageView(previousRoute);
    super.didPop(route, previousRoute);
  }

  @override
  void didPush(Route route, Route? previousRoute) {
    _sendPageView(route);
    super.didPush(route, previousRoute);
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    _sendPageView(newRoute);
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
  }

  void _sendPageView(Route? route) {
    if (route?.settings.name != null) {
      // Extract additional properties from route's settings
      final extraData = route?.settings.arguments as Map<String, Object>?;

      Posthog().screen(
          screenName:
              Helpers().toSnakeCase(route!.settings.name!.trim()).toLowerCase(),
          properties: extraData);
      debugPrint('Screen: ${route.settings.name!}, Extra Data: $extraData');
    }
  }
}
