import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'custom_multipart_request.dart';
import '../utils/exceptions.dart';
import '../utils/magic_strings.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';

final httpClientProvider = Provider<AlvysHttpClient>((ref) => AlvysHttpClient());

class AlvysHttpClient extends BaseClient {
  Future<Map<String, String>> get getBaseHeaders async {
    var storage = const FlutterSecureStorage();
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

  @override
  Future<StreamedResponse> send(BaseRequest request) async {
    return request.send();
  }

  Future<StreamedResponse> sendData<T>(BaseRequest request) async {
    try {
      var streamedRes = await request.send();
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
    return _executeRequest<T>(() async => this.get(uri, headers: await getHeaders(headers)));
  }

  Future<Response> postData<T>(Uri uri, {Map<String, String>? headers, Object? body, Encoding? encoding}) {
    return _executeRequest<T>(
        () async => this.post(uri, headers: await getHeaders(headers), body: body, encoding: encoding));
  }

  Future<Response> putData<T>(Uri uri, {Map<String, String>? headers, Object? body, Encoding? encoding}) {
    return _executeRequest<T>(
        () async => this.put(uri, headers: await getHeaders(headers), body: body, encoding: encoding));
  }

  Future<Response> deleteData<T>(Uri uri, {Map<String, String>? headers, Object? body, Encoding? encoding}) {
    return _executeRequest<T>(
        () async => this.delete(uri, headers: await getHeaders(headers), body: body, encoding: encoding));
  }

  Future<Response> patchData<T>(Uri uri, {Map<String, String>? headers, Object? body, Encoding? encoding}) {
    return _executeRequest<T>(
        () async => this.patch(uri, headers: await getHeaders(headers), body: body, encoding: encoding));
  }

  Future<Response> _executeRequest<T>(Future<Response> Function() op) async {
    try {
      var res = await op();
      return _handleResponse(res);
    } on SocketException {
      return Future.error(AlvysSocketException(T));
    } on TimeoutException {
      return Future.error(AlvysTimeoutException(T));
    }
  }

  Future<Response> _handleResponse<T>(Response response) {
    var body = response.statusCode != 200 ? jsonDecode(response.body) : {};
    switch (response.statusCode) {
      case (400):
        return Future.error(AlvysClientException(body, T));
      case (404):
        return Future.error(AlvysEntityNotFoundException(body, T));
      case (401):
        return Future.error(AlvysUnauthorizedException(T));
      case (504):
        return Future.error(AlvysDependencyException(body, T));
      case 500:
        return Future.error(ApiServerException(T));
      default:
        return Future.value(response);
    }
  }
}
