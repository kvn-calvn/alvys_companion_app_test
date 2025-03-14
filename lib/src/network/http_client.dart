import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:alvys3/src/utils/telemetry.dart';
import 'package:azure_application_insights/azure_application_insights.dart';
import 'package:coder_matthews_extensions/coder_matthews_extensions.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../flavor_config.dart';
import '../features/authentication/domain/models/driver_user/driver_user.dart';
import '../utils/exceptions.dart';
import '../utils/magic_strings.dart';
import '../utils/permission_helper.dart';
import '../utils/provider_args_saver.dart';
import 'custom_multipart_request.dart';
import 'network_info.dart';

final httpClientProvider = Provider<AlvysHttpClient>((ref) {
  return AlvysHttpClient(ref.read(telemetryClientProvider), ref.read(sharedPreferencesProvider)!,
      ref.watch(internetConnectionCheckerProvider.notifier), ref);
});

final telemetryClientProvider = Provider<TelemetryClient>((ref) {
  final client = Client();
  final processor = TransmissionProcessor(
    connectionString: FlavorConfig.instance!.azureConnectionString,
    httpClient: client,
    timeout: const Duration(seconds: 100),
  );

  var telemetryClient = TelemetryClient(
    processor: processor,
  );
  return telemetryClient;
});

class AlvysHttpClient {
  TelemetryClient telemetryClient;
  late InnerAlvysHttpClient telemetryHttpClient;
  final SharedPreferences pref;
  final NetworkNotifier networkInfo;
  AlvysHttpClient(this.telemetryClient, this.pref, this.networkInfo, Ref ref) {
    debugPrint("TELEMETRY CONNECTION STRING: ${FlavorConfig.instance!.azureConnectionString}");
    telemetryHttpClient = InnerAlvysHttpClient(
        telemetryClient: telemetryClient,
        inner: (telemetryClient.processor as TransmissionProcessor).httpClient,
        ref: ref);
  }
  Future<void> trackEvent(
      {required String name,
      Map<String, Object> additionalProperties = const <String, Object>{},
      DateTime? timestamp}) async {
    await addPermissionDetails();
    telemetryClient.trackEvent(
        name: name, additionalProperties: additionalProperties, timestamp: timestamp);
  }

  Map<String, String> getBaseHeaders(String? companyCode) {
    var token = pref.getString(SharedPreferencesKey.driverToken.name);
    var userAgent = pref.getString(SharedPreferencesKey.userAgent.name);
    return {
      HttpHeaders.contentTypeHeader: ContentType.json.value,
      if (userAgent.isNotNullOrEmpty) HttpHeaders.userAgentHeader: userAgent!,
      if (token != null) HttpHeaders.authorizationHeader: 'Basic $token',
      if (companyCode != null) AlvysHttpHeaders.companyCode: companyCode
    };
  }

  Map<String, String> getHeaders(String? companyCode, Map<String, String>? headers) {
    var newHeaders = getBaseHeaders(companyCode);
    if (headers != null) {
      newHeaders.addAll(headers);
    }
    return newHeaders;
  }

  Future<StreamedResponse> sendData<T>(BaseRequest request) async {
    var streamedRes = await _tryRequest<T, StreamedResponse>((client) => client.send(request));
    _handleResponse(await Response.fromStream(streamedRes));
    return streamedRes;
  }

  Future<void> upload<T>(
    Uri url,
    String? companyCode, {
    required List<MultipartFile> files,
    required Function(int current, int total) onProgress,
    Map<String, String>? headers,
  }) async {
    var request = CustomMultipartRequest("POST", url, onProgress: onProgress);
    request.files.addAll(files);
    if (headers != null) request.headers.addAll(headers);
    request.headers.addAll(getBaseHeaders(companyCode));
    await sendData<T>(request);
  }

  Future<void> download<T>(
    Uri url, {
    required Function(int current, int total) onProgress,
    Map<String, String>? headers,
  }) async {
    var request = CustomMultipartRequest("GET", url, onProgress: onProgress);
    if (headers != null) request.headers.addAll(headers);
    request.headers.addAll(getBaseHeaders(null));
    await sendData<T>(request);
  }

  Future<Response> getData<T>(Uri uri, String? companyCode, {Map<String, String>? headers}) {
    return _executeRequest<T>(
        companyCode, (client) => client.get(uri, headers: getHeaders(companyCode, headers)));
  }

  Future<Response> postData<T>(Uri uri, String? companyCode,
      {Map<String, String>? headers, Object? body, Encoding? encoding}) {
    return _executeRequest<T>(
        companyCode,
        (client) => client.post(uri,
            headers: getHeaders(companyCode, headers), body: body, encoding: encoding));
  }

  Future<Response> putData<T>(Uri uri, String? companyCode,
      {Map<String, String>? headers, Object? body, Encoding? encoding}) {
    return _executeRequest<T>(
        companyCode,
        (client) => client.put(uri,
            headers: getHeaders(companyCode, headers), body: body, encoding: encoding));
  }

  Future<Response> deleteData<T>(Uri uri, String? companyCode,
      {Map<String, String>? headers, Object? body, Encoding? encoding}) {
    return _executeRequest<T>(
        companyCode,
        (client) => client.delete(uri,
            headers: getHeaders(companyCode, headers), body: body, encoding: encoding));
  }

  Future<Response> patchData<T>(Uri uri, String? companyCode,
      {Map<String, String>? headers, Object? body, Encoding? encoding}) {
    return _executeRequest<T>(
        companyCode,
        (client) => client.patch(uri,
            headers: getHeaders(companyCode, headers), body: body, encoding: encoding));
  }

  Future<Response> _executeRequest<T>(
      String? companyCode, Future<Response> Function(InnerAlvysHttpClient client) op) async {
    if (companyCode != null) {
      telemetryClient.context.properties['tenantId'] = companyCode;
    }
    await addPermissionDetails();
    var res = await _tryRequest<T, Response>(op);
    return _handleResponse<T>(res);
  }

  Future<Response> _handleResponse<T>(Response response) {
    networkInfo.setInternetState(true);
    switch (response.statusCode) {
      case (400):
        throw AlvysClientException(jsonDecode(response.body), T);
      case (404):
        throw AlvysEntityNotFoundException(jsonDecode(response.body), T);
      case (401):
        throw AlvysUnauthorizedException(T);
      case (504):
        try {
          var data = jsonDecode(response.body);
          throw AlvysDependencyException(data, T);
        } on FormatException {
          throw AlvysServiceUnavailableException(T);
        }
      case 500:
        throw ApiServerException(T);
      case 503:
        throw AlvysServiceUnavailableException(T);
      default:
        return Future.value(response);
    }
  }

  Future<TResponse> _tryRequest<TSource, TResponse>(
      Future<TResponse> Function(InnerAlvysHttpClient client) op) async {
    try {
      return await op(telemetryHttpClient).timeout(
        const Duration(minutes: 2),
        onTimeout: () {
          throw AlvysTimeoutException(TSource);
        },
      );
    } on SocketException {
      throw AlvysSocketException(TSource);
    } on TimeoutException {
      throw AlvysTimeoutException(TSource);
    }
  }

  Future<void> addPermissionDetails() async {
    var permissions = [
      Permission.location,
      Permission.locationAlways,
      Permission.locationWhenInUse,
      Permission.notification,
      Platform.isAndroid ? await PermissionHelper.androidGalleryPermission() : Permission.photos,
      Permission.camera
    ];
    telemetryClient.context.properties['permissionStatus'] =
        (await PermissionHelper.getAllUserPermissions(permissions)).toJsonEncodedString;
  }

  Future<void> setTelemetryContext({DriverUser? user, Map<String, dynamic>? extraData}) async {
    assert((user == null && extraData != null) || (user != null && extraData == null));
    Map<String, dynamic> driver = user == null
        ? extraData!
        : {
            "email": user.email,
            "phone": user.phone,
            "tenantId": user.companyCodes,
            "name": user.name,
          };
    late IosDeviceInfo iosInfo;
    late AndroidDeviceInfo androidInfo;
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      iosInfo = await deviceInfo.iosInfo;
    } else if (Platform.isAndroid) {
      androidInfo = await deviceInfo.androidInfo;
    }
    telemetryClient.context
      ..device.model = Platform.isAndroid
          ? "${androidInfo.manufacturer} ${androidInfo.model}"
          : Platform.isIOS
              ? iosInfo.utsname.machine
              : ""
      ..device.osVersion = Platform.isAndroid
          ? "Android ${androidInfo.version.release} SDK(${androidInfo.version.sdkInt})"
          : Platform.isIOS
              ? "${iosInfo.systemName} ${iosInfo.systemVersion}"
              : ""
      ..device.type = "mobile"
      ..applicationVersion = packageInfo.version
      ..user.accountId = user?.id
      ..properties['user'] = jsonEncode(driver)
      ..device.id = Platform.isAndroid ? androidInfo.id : iosInfo.identifierForVendor;
    await addPermissionDetails();
    if (user != null) {
      telemetryClient.context.properties['tenantPermissions'] =
          Map.fromEntries(user.userTenants.map((e) => MapEntry(e.companyCode, e.permissions)))
              .toJsonEncodedString;
      telemetryClient.context.properties['driverTypes'] =
          Map.fromEntries(user.userTenants.map((e) => MapEntry(e.companyCode, e.contractorType)))
              .toJsonEncodedString;
    }
  }
}

class AlvysHttpHeaders {
  static String companyCode = 'CompanyCode';
}

class InnerAlvysHttpClient extends BaseClient {
  InnerAlvysHttpClient({
    required this.inner,
    required this.telemetryClient,
    required this.ref,
    this.appendHeader,
  });
  final Client inner;
  final TelemetryClient telemetryClient;
  final bool Function(String header)? appendHeader;
  final Ref ref;

  @override
  Future<StreamedResponse> send(BaseRequest request) async {
    var spanHelper = ref.read(telemetrySpanProvider);
    request.headers.addAll(spanHelper.setHeaders);
    final response = await inner.send(request);
    //  removed since backend logs requests already
    // telemetryClient.trackRequest(
    //     responseCode: response.statusCode.toString(),
    //     name: "${request.method} ${(request.url.path.isEmpty ? '/' : request.url.path)}",
    //     id: spanHelper.traceData.parentSpanId,
    //     success: response.statusCode >= 200 && response.statusCode < 300,
    //     duration: stopwatch.elapsed,
    //     additionalProperties: <String, Object>{
    //       'method': request.method,
    //       if (headers.isNotEmpty) 'headers': headers,
    //       if (contentLength != null) 'contentLength': contentLength,
    //     },
    //     timestamp: timestamp,
    //     url: request.url.toString());
    spanHelper.endSpan();
    return response;
  }
}
