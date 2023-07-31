// ignore_for_file: constant_identifier_names

//import 'package:alvys3/src/constants/api_routes.dart';
//import 'package:alvys3/src/utils/exceptions.dart';
//import 'package:alvys3/src/utils/exceptions.dart';
import 'dart:async';

import 'package:alvys3/src/network/network_info.dart';
import 'package:alvys3/src/utils/exceptions.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
//import 'package:alvys3/flavor_config.dart';
//import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../utils/magic_strings.dart';

const String APPLICATION_JSON = "application/json";
const String CONTENT_TYPE = "content-type";
const String ACCEPT = "accept";
const String AUTHORIZATION = "authorization";
const String DEFAULT_LANGUAGE = "language";

final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(ref.read(internetConnectionCheckerProvider));
});

class ApiClient {
  late Dio _dio;
  final InternetConnectionChecker connectionChecker;
  ApiClient(this.connectionChecker) {
    _dio = createDio();
  }

  Dio createDio() {
    Map<String, String> headers = {
      CONTENT_TYPE: APPLICATION_JSON,
      ACCEPT: APPLICATION_JSON,
      // AUTHORIZATION:
      //     'Basic Y1JleVdBeTUyZ2c6YlVkbkxURmxNMkU0WW1RMExURTJOMlF0TkRrNE9TMWhPVGczTFRKa1pqSTVZV00yTWpWbE1DMDFTR1pK',
      //AUTHORIZATION: 'Basic c1UxN1pnRVEyUWc6UWxSaUxUbGxZVFV4TTJabUxXUTRNRFl0TkdZNVlTMWlNVGt3TFRFeU1EWmlZemM0T1dFNE1DMHlOSFZv',
      DEFAULT_LANGUAGE: "en" // todo get lang from app prefs
    };

    var dio = Dio(BaseOptions(
        //baseUrl: FlavorConfig.instance!.baseUrl,
        receiveTimeout: const Duration(seconds: 15),
        connectTimeout: const Duration(seconds: 15),
        sendTimeout: const Duration(seconds: 15),
        headers: headers));

    dio.interceptors.clear();
    dio.interceptors.addAll({
      DioApiInterCeptor(),
      /*  PrettyDioLogger(
          requestHeader: false, requestBody: false, responseHeader: false)*/
    });
    return dio;
  }

  Future<Response> getData<C>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) {
    return _executeRequest<C>(() => _dio.get(
          path,
          data: data,
          queryParameters: queryParameters,
          options: options,
          cancelToken: cancelToken,
          onReceiveProgress: onReceiveProgress,
        ));
  }

  Future<Response> postData<C>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
    ProgressCallback? onSendProgress,
  }) {
    return _executeRequest<C>(() => _dio.post(
          path,
          data: data,
          queryParameters: queryParameters,
          options: options,
          cancelToken: cancelToken,
          onReceiveProgress: onReceiveProgress,
          onSendProgress: onSendProgress,
        ));
  }

  Future<Response> putData<C>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
    ProgressCallback? onSendProgress,
  }) {
    return _executeRequest<C>(() => _dio.put(
          path,
          data: data,
          queryParameters: queryParameters,
          options: options,
          cancelToken: cancelToken,
          onReceiveProgress: onReceiveProgress,
          onSendProgress: onSendProgress,
        ));
  }

  Future<Response> patchData<C>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
    ProgressCallback? onSendProgress,
  }) {
    return _executeRequest<C>(() => _dio.patch(
          path,
          data: data,
          queryParameters: queryParameters,
          options: options,
          cancelToken: cancelToken,
          onReceiveProgress: onReceiveProgress,
          onSendProgress: onSendProgress,
        ));
  }

  Future<Response> deleteData<C>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) {
    return _executeRequest<C>(() => _dio.delete(
          path,
          data: data,
          queryParameters: queryParameters,
          options: options,
          cancelToken: cancelToken,
        ));
  }

  Future<Response> _executeRequest<C>(Future<Response> Function() req) async {
    if (!(await connectionChecker.hasConnection)) throw Future.error(AlvysSocketException(C));
    try {
      return await req();
    } on DioException catch (ex) {
      switch (ex.type) {
        case DioExceptionType.sendTimeout:
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.receiveTimeout:
          return Future.error(AlvysTimeoutException(C));
        case DioExceptionType.badResponse:
          switch (ex.response?.statusCode) {
            case (400):
              return Future.error(AlvysClientException(ex.response!.data, C));
            case (417):
              return Future.error(ControllerException("Error", ex.response!.data['ErrorMessage'], C));
            case (404):
              return Future.error(AlvysEntityNotFoundException(C));
            case (401):
              return Future.error(AlvysUnauthorizedException(C));
            default:
              return Future.error(ApiServerException(C));
          }
        case DioExceptionType.cancel:
        case DioExceptionType.badCertificate:
          return Future.error(ApiServerException(C));
        case DioExceptionType.connectionError:
        case DioExceptionType.unknown:
          return Future.error(AlvysSocketException(C));
      }
    }
  }
}

class DioApiInterCeptor extends Interceptor {
  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    var storage = const FlutterSecureStorage();
    String? driverToken = await storage.read(key: StorageKey.driverToken.name);
    if (driverToken != null) {
      options.headers.addAll({"Authorization": "Basic $driverToken"});
    }
    super.onRequest(options, handler);
  }
}

class FileUploadProgressNotifier extends Notifier<double> {
  @override
  double build() {
    return 0;
  }

  void updateProgress(num total, num current) {
    state = current / total;
  }
}

final fileUploadProvider = NotifierProvider<FileUploadProgressNotifier, double>(FileUploadProgressNotifier.new);
