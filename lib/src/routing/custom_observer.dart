import 'package:alvys3/src/network/http_client.dart';
import 'package:alvys3/src/utils/telemetry.dart';
import 'package:azure_application_insights/azure_application_insights.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final customObserverProvider = Provider<CustomObserver>((ref) {
  return CustomObserver(ref.read(telemetryClientProvider), ref.read(telemetrySpanProvider));
});

class CustomObserver extends RouteObserver<ModalRoute<dynamic>> {
  final TelemetryClient telemetryClient;
  final TelemetrySpanHelper telemetrySpanHelper;
  CustomObserver(this.telemetryClient, this.telemetrySpanHelper);
  String? currentRoute;
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    currentRoute = route.settings.name;
    telemetrySpanHelper.startSpan();
    if (currentRoute != null) {
      telemetryClient.context.operation.id = telemetrySpanHelper.traceData.operationId;
      telemetryClient.trackPageView(name: currentRoute!);
    }
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    currentRoute = newRoute?.settings.name;
    telemetrySpanHelper.startSpan();
    if (currentRoute != null) {
      telemetryClient.context.operation.id = telemetrySpanHelper.traceData.operationId;
      telemetryClient.trackPageView(name: currentRoute!);
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    currentRoute = previousRoute?.settings.name;
  }

  @override
  NavigatorState? get navigator => null;
}
