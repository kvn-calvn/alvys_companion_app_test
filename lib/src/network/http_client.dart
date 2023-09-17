import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:azure_application_insights/azure_application_insights.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:uuid/uuid.dart';
import 'package:uuid/uuid_util.dart';

import '../../flavor_config.dart';
import '../features/authentication/domain/models/driver_user/driver_user.dart';
import '../utils/exceptions.dart';
import '../utils/magic_strings.dart';
import 'custom_multipart_request.dart';

final httpClientProvider = Provider<AlvysHttpClient>((ref) => AlvysHttpClient());

class AlvysHttpClient {
  late TelemetryClient telemetryClient;
  late TelemetryHttpClient telemetryHttpClient;
  FlutterSecureStorage storage = const FlutterSecureStorage();
  AlvysHttpClient() {
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

  Future<Map<String, String>> get getBaseHeaders async {
    var token = await storage.read(key: StorageKey.driverToken.name);
    var companyCode = await storage.read(key: StorageKey.companyCode.name);
    return token == null
        ? {HttpHeaders.contentTypeHeader: ContentType.json.value}
        : {
            HttpHeaders.contentTypeHeader: ContentType.json.value,
            HttpHeaders.authorizationHeader: 'Basic $token',
            if (companyCode != null) 'CompanyCode': companyCode
          };
  }

  Future<Map<String, String>> getHeaders(Map<String, String>? headers) async {
    var newHeaders = await getBaseHeaders;
    if (headers != null) {
      newHeaders.addAll(headers);
    }
    return newHeaders;
  }

  Future<StreamedResponse> sendData<T>(BaseRequest request) async {
    try {
      var streamedRes = await telemetryHttpClient.send(request);
      _handleResponse(await Response.fromStream(streamedRes));
      return streamedRes;
    } on SocketException {
      return Future.error(AlvysSocketException(T));
    } on TimeoutException {
      return Future.error(AlvysTimeoutException(T));
    }
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
    request.headers.addAll(await getBaseHeaders);
    await sendData<T>(request);
  }

  Future<void> download<T>(
    Uri url, {
    required Function(int current, int total) onProgress,
    Map<String, String>? headers,
  }) async {
    var request = CustomMultipartRequest("GET", url, onProgress: onProgress);
    if (headers != null) request.headers.addAll(headers);
    request.headers.addAll(await getBaseHeaders);
    await sendData<T>(request);
  }

  Future<Response> getData<T>(Uri uri, {Map<String, String>? headers}) {
    return _executeRequest<T>(() async => telemetryHttpClient.get(uri, headers: await getHeaders(headers)));
  }

  Future<Response> postData<T>(Uri uri, {Map<String, String>? headers, Object? body, Encoding? encoding}) {
    return _executeRequest<T>(
        () async => telemetryHttpClient.post(uri, headers: await getHeaders(headers), body: body, encoding: encoding));
  }

  Future<Response> putData<T>(Uri uri, {Map<String, String>? headers, Object? body, Encoding? encoding}) {
    return _executeRequest<T>(
        () async => telemetryHttpClient.put(uri, headers: await getHeaders(headers), body: body, encoding: encoding));
  }

  Future<Response> deleteData<T>(Uri uri, {Map<String, String>? headers, Object? body, Encoding? encoding}) {
    return _executeRequest<T>(() async =>
        telemetryHttpClient.delete(uri, headers: await getHeaders(headers), body: body, encoding: encoding));
  }

  Future<Response> patchData<T>(Uri uri, {Map<String, String>? headers, Object? body, Encoding? encoding}) {
    return _executeRequest<T>(
        () async => telemetryHttpClient.patch(uri, headers: await getHeaders(headers), body: body, encoding: encoding));
  }

  Future<Response> _executeRequest<T>(Future<Response> Function() op) async {
    try {
      var companyCode = await storage.read(key: StorageKey.companyCode.name);
      if (companyCode != null) telemetryClient.context.properties['tenantId'] = companyCode;
      telemetryClient.context.operation.id = const Uuid().v4(options: {'rng': UuidUtil.cryptoRNG});
      var res = await op();
      return _handleResponse<T>(res);
    } on SocketException {
      return Future.error(AlvysSocketException(T));
    } on TimeoutException {
      return Future.error(AlvysTimeoutException(T));
    }
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

  Future<void> setTelemetryContext({DriverUser? user, String? companyCode, Map<String, dynamic>? extraData}) async {
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
  }
}
