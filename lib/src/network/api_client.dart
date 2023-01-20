// ignore_for_file: constant_identifier_names

//import 'package:alvys3/src/constants/api_routes.dart';
import 'package:alvys3/src/utils/exceptions.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
//import 'package:alvys3/flavor_config.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../utils/magic_strings.dart';

const String APPLICATION_JSON = "application/json";
const String CONTENT_TYPE = "content-type";
const String ACCEPT = "accept";
const String AUTHORIZATION = "authorization";
const String DEFAULT_LANGUAGE = "language";

class ApiClient {
  Dio get dio => createDio();

  ApiClient._internal();

  static final singleton = ApiClient._internal();

  factory ApiClient() => singleton;

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
        receiveTimeout: 15000, // 15 seconds
        connectTimeout: 15000,
        sendTimeout: 15000,
        headers: headers));

    dio.interceptors.clear();
    dio.interceptors.addAll({
      DioApiInterCeptor(),
      /*  PrettyDioLogger(
          requestHeader: false, requestBody: false, responseHeader: false)*/
    });
    return dio;
  }
}

class DioApiInterCeptor extends Interceptor {
  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    var storage = const FlutterSecureStorage();
    String? driverToken = await storage.read(key: StorageKey.driverToken.name);
    if (driverToken != null) {
      options.headers.addAll({"Authorization": "Basic $driverToken"});
    }
    super.onRequest(options, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    if (err.response!.statusCode == 500) {
      super.onError(err, handler);
    } else {
      handler.resolve(err.response!);
    }

    // super.onError(err, handler);
    //  throw ClientException('');
    //debugPrint(err.response?.statusCode.toString());
    // if (err.response!.statusCode! == 400) {
    //   throw ClientException('message');
    // }
    // try {
    //   handler.next(err);
    // } catch (e) {
    //   throw ClientException('message');
    // }

    // //debugPrint(err.response?.statusCode.toString());

    // super.onError(err, handler);
  }

  // dynamic requestInterceptor(RequestOptions options) async {
  //   if (options.headers.containsKey("requiresToken")) {
  //     //remove the auxiliary header
  //     options.headers.remove("requiresToken");

  //     var token = await _userTokenHandle.getLoginData();

  //     options.headers.addAll({"Authorization": "Basic $token"});

  //     return options;
  //   }
  // }
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

final fileUploadProvider = NotifierProvider<FileUploadProgressNotifier, double>(
    FileUploadProgressNotifier.new);
