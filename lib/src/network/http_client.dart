import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:azure_application_insights/azure_application_insights.dart';
import 'package:coder_matthews_extensions/coder_matthews_extensions.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:uuid/uuid_util.dart';

import '../../flavor_config.dart';
import '../features/authentication/domain/models/driver_user/driver_user.dart';
import '../utils/exceptions.dart';
import '../utils/magic_strings.dart';
import '../utils/provider_args_saver.dart';
import 'custom_multipart_request.dart';
import 'network_info.dart';

final httpClientProvider = Provider<AlvysHttpClient>((ref) {
  return AlvysHttpClient(ref.read(sharedPreferencesProvider)!, ref.watch(internetConnectionCheckerProvider.notifier));
});

class AlvysHttpClient {
  late TelemetryClient telemetryClient;
  late TelemetryHttpClient telemetryHttpClient;
  final SharedPreferences pref;
  final NetworkNotifier networkInfo;
  AlvysHttpClient(this.pref, this.networkInfo) {
    final client = Client();
    final processor = TransmissionProcessor(
      instrumentationKey: FlavorConfig.instance!.azureTelemetryKey,
      httpClient: client,
      timeout: const Duration(seconds: 10),
    );

    telemetryClient = TelemetryClient(
      processor: processor,
    );

    telemetryHttpClient = TelemetryHttpClient(
      telemetryClient: telemetryClient,
      inner: client,
    );
  }

  Future<void> trackEvent(
      {required String name,
      Map<String, Object> additionalProperties = const <String, Object>{},
      DateTime? timestamp}) async {
    await addPermissionDetails();
    return telemetryClient.trackEvent(name: name, additionalProperties: additionalProperties, timestamp: timestamp);
  }

  Map<String, String> get getBaseHeaders {
    var token = pref.getString(SharedPreferencesKey.driverToken.name);
    var companyCode = pref.getString(SharedPreferencesKey.companyCode.name);
    return token == null
        ? {HttpHeaders.contentTypeHeader: ContentType.json.value}
        : {
            HttpHeaders.contentTypeHeader: ContentType.json.value,
            HttpHeaders.authorizationHeader: 'Basic $token',
            if (companyCode != null) 'CompanyCode': companyCode
          };
  }

  Map<String, String> getHeaders(Map<String, String>? headers) {
    var newHeaders = getBaseHeaders;
    if (headers != null) {
      newHeaders.addAll(headers);
    }
    return newHeaders;
  }

  Future<StreamedResponse> sendData<T>(BaseRequest request) async {
    var streamedRes = await _tryRequest<T, StreamedResponse>(() => telemetryHttpClient.send(request));
    _handleResponse(await Response.fromStream(streamedRes));
    return streamedRes;
  }

  Future<void> upload<T>(
    Uri url, {
    required List<MultipartFile> files,
    required Function(int current, int total) onProgress,
    Map<String, String>? headers,
  }) async {
    var request = CustomMultipartRequest("POST", url, onProgress: onProgress);
    request.files.addAll(files);
    if (headers != null) request.headers.addAll(headers);
    request.headers.addAll(getBaseHeaders);
    await sendData<T>(request);
  }

  Future<void> download<T>(
    Uri url, {
    required Function(int current, int total) onProgress,
    Map<String, String>? headers,
  }) async {
    var request = CustomMultipartRequest("GET", url, onProgress: onProgress);
    if (headers != null) request.headers.addAll(headers);
    request.headers.addAll(getBaseHeaders);
    await sendData<T>(request);
  }

  Future<Response> getData<T>(Uri uri, {Map<String, String>? headers}) {
    return _executeRequest<T>(() async => telemetryHttpClient.get(uri, headers: getHeaders(headers)));
  }

  Future<Response> postData<T>(Uri uri, {Map<String, String>? headers, Object? body, Encoding? encoding}) {
    return _executeRequest<T>(
        () async => telemetryHttpClient.post(uri, headers: getHeaders(headers), body: body, encoding: encoding));
  }

  Future<Response> putData<T>(Uri uri, {Map<String, String>? headers, Object? body, Encoding? encoding}) {
    return _executeRequest<T>(
        () async => telemetryHttpClient.put(uri, headers: getHeaders(headers), body: body, encoding: encoding));
  }

  Future<Response> deleteData<T>(Uri uri, {Map<String, String>? headers, Object? body, Encoding? encoding}) {
    return _executeRequest<T>(
        () async => telemetryHttpClient.delete(uri, headers: getHeaders(headers), body: body, encoding: encoding));
  }

  Future<Response> patchData<T>(Uri uri, {Map<String, String>? headers, Object? body, Encoding? encoding}) {
    return _executeRequest<T>(
        () async => telemetryHttpClient.patch(uri, headers: getHeaders(headers), body: body, encoding: encoding));
  }

  Future<Response> _executeRequest<T>(Future<Response> Function() op) async {
    var companyCode = pref.getString(SharedPreferencesKey.companyCode.name);
    if (companyCode != null) {
      telemetryClient.context.properties['tenantId'] = companyCode;
    }
    await addPermissionDetails();
    telemetryClient.context.operation.id = const Uuid().v4(options: {'rng': UuidUtil.cryptoRNG});
    var res = await _tryRequest<T, Response>(op);
    return _handleResponse<T>(res);
  }

  Future<Response> _handleResponse<T>(Response response) {
    switch (response.statusCode) {
      case (400):
        return Future.error(AlvysClientException(jsonDecode(response.body), T));
      case (404):
        return Future.error(AlvysEntityNotFoundException(jsonDecode(response.body), T));
      case (401):
        return Future.error(AlvysUnauthorizedException(T));
      case (504):
        return Future.error(AlvysDependencyException(jsonDecode(response.body), T));
      case 500:
        return Future.error(ApiServerException(T));
      default:
        return Future.value(response);
    }
  }

  Future<TResponse> _tryRequest<TSource, TResponse>(Future<TResponse> Function() op) async {
    if (!networkInfo.hasInternet) {
      networkInfo.setInternetState(false);
      return Future.error(AlvysSocketException(TSource));
    }
    try {
      return await op();
    } on SocketException {
      return Future.error(AlvysSocketException(TSource));
    } on TimeoutException {
      return Future.error(AlvysTimeoutException(TSource));
    }
  }

  Future<void> addPermissionDetails() async {
    var permissions = [
      Permission.location,
      Permission.locationAlways,
      Permission.locationWhenInUse,
      Permission.notification,
      Platform.isAndroid ? Permission.mediaLibrary : Permission.photos,
      Permission.camera
    ];
    telemetryClient.context.properties['permissionStatus'] = Map.fromEntries(await permissions.mapAsync(
            (element) async => MapEntry(element.toString().replaceAll('Permission.', ''), (await element.status).name)))
        .toJsonEncodedString;
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
          Map.fromEntries(user.userTenants.map((e) => MapEntry(e.companyCode!, e.permissions))).toJsonEncodedString;
    }
  }
}
