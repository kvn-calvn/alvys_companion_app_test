import 'package:flutter/material.dart';

class CustomObserver extends RouteObserver<ModalRoute<dynamic>> {
  CustomObserver._init();
  static final CustomObserver _instance = CustomObserver._init();
  static CustomObserver get instance => _instance;
  String? currentRoute;
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    currentRoute = route.settings.toString();
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    currentRoute = newRoute?.settings.toString();
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    currentRoute = previousRoute?.settings.toString();
  }

  @override
  NavigatorState? get navigator => null;
}
