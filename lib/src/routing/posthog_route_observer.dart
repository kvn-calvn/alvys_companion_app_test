import 'package:flutter/material.dart';
import 'package:posthog_flutter/posthog_flutter.dart';

class PostHogRouteObserver extends NavigatorObserver {
  @override
  void didPop(Route route, Route? previousRoute) {
    _sendPageView(previousRoute?.settings.name);
    super.didPop(route, previousRoute);
  }

  @override
  void didPush(Route route, Route? previousRoute) {
    _sendPageView(route.settings.name);
    super.didPush(route, previousRoute);
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    _sendPageView(newRoute?.settings.name);
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
  }

  void _sendPageView(String? pageName) {
    // Capture the pageview event with the custom page name
    if (pageName != null) {
      Posthog().screen(screenName: pageName);
    }
  }
}
