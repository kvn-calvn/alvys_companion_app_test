import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:opentelemetry/api.dart';

class TelemetryHelper {
  static TelemetryConnectionData parseConnectionString(String connectionString) {
    String getRequiredEntry(Map<String, String> entries, String entryKey) {
      final maybeValue = entries[entryKey];

      if (maybeValue == null) {
        throw UnsupportedError(
            "Connection string does not contain required entry, '$entryKey': $connectionString");
      }

      return maybeValue;
    }

    if (connectionString.isEmpty) {
      throw UnsupportedError('Connection string cannot be an empty string');
    }

    final seenKeys = <String>{};

    final mapEntries =
        connectionString.split(';').where((s) => s.isNotEmpty).map((potentialKeyValuePair) {
      final keyValuePair = potentialKeyValuePair.split('=');

      if (keyValuePair.length != 2) {
        throw UnsupportedError(
            "Connection string contains portion '$potentialKeyValuePair', which cannot be parsed. Expected format is key=value");
      }

      final key = keyValuePair[0];

      if (seenKeys.contains(key)) {
        throw UnsupportedError('Connection string contains duplicate key, $key');
      }

      seenKeys.add(key);

      final value = keyValuePair[1];
      return MapEntry(key, value);
    });

    final map = Map.fromEntries(mapEntries);
    final instrumentationKey = getRequiredEntry(map, 'InstrumentationKey');

    return TelemetryConnectionData(
      instrumentationKey: instrumentationKey,
      ingestionEndpoint: map['IngestionEndpoint']!,
      endpointSuffix: map['EndpointSuffix'],
      location: map['Location'],
    );
  }
}

class TelemetryConnectionData {
  static String traceParentHeader = 'traceparent';
  final String instrumentationKey, ingestionEndpoint;
  final String? endpointSuffix, location;

  TelemetryConnectionData(
      {required this.instrumentationKey,
      required this.ingestionEndpoint,
      required this.endpointSuffix,
      required this.location});
}

class TelemetryTraceData {
  final String operationId, parentSpanId, traceFlags;

  TelemetryTraceData(this.operationId, this.parentSpanId, this.traceFlags);
  TelemetryTraceData.empty()
      : operationId = '',
        parentSpanId = '',
        traceFlags = '';
  factory TelemetryTraceData.fromTraceParent(String? traceParent) {
    var parts = traceParent?.split('-') ?? [];
    if (parts.length != 4) {
      return TelemetryTraceData.empty();
    }
    return TelemetryTraceData(parts[1], parts[2], parts[3]);
  }
  factory TelemetryTraceData.fromHeaders(Map<String, String> headers) {
    return TelemetryTraceData.fromTraceParent(headers[TelemetryConnectionData.traceParentHeader]);
  }
}

final telemetrySpanProvider = Provider<TelemetrySpanHelper>((ref) {
  return TelemetrySpanHelper();
});

class TelemetrySpanHelper {
  var setHeaders = <String, String>{};
  final tracer = globalTracerProvider.getTracer('http-tracer');
  Span? currentSpan;
  TelemetryTraceData get traceData => TelemetryTraceData.fromHeaders(setHeaders);
  void startSpan() {
    setHeaders = <String, String>{};
    currentSpan = tracer.startSpan('mobile-http');
    var propagator = W3CTraceContextPropagator();
    propagator.inject(
      contextWithSpanContext(Context.current, currentSpan!.spanContext),
      setHeaders,
      CustomTextMapSetter(),
    );
  }

  void endSpan() {
    currentSpan?.end();
    currentSpan = null;
    setHeaders = <String, String>{};
  }
}

class CustomTextMapSetter implements TextMapSetter<Map<String, String>> {
  @override
  void set(carrier, String key, String value) {
    carrier[key] = value;
  }
}
