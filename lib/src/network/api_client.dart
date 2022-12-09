// ignore_for_file: constant_identifier_names

import 'package:alvys3/src/constants/api_routes.dart';
import 'package:alvys3/src/network/dio_factory.dart';
import 'package:alvys3/src/network/user_token_handler.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

const String APPLICATION_JSON = "application/json";
const String CONTENT_TYPE = "content-type";
const String ACCEPT = "accept";
const String AUTHORIZATION = "authorization";
const String DEFAULT_LANGUAGE = "language";

class ApiClient {
  final dio = createDio();

  ApiClient._internal();

  static final _singleton = ApiClient._internal();

  factory ApiClient() => _singleton;

  static Dio createDio() {
    Map<String, String> headers = {
      CONTENT_TYPE: APPLICATION_JSON,
      ACCEPT: APPLICATION_JSON,
      AUTHORIZATION:
          'Basic Y1JleVdBeTUyZ2c6YlVkbkxURmxNMkU0WW1RMExURTJOMlF0TkRrNE9TMWhPVGczTFRKa1pqSTVZV00yTWpWbE1DMDFTR1pK',
      //AUTHORIZATION: 'Basic c1UxN1pnRVEyUWc6UWxSaUxUbGxZVFV4TTJabUxXUTRNRFl0TkdZNVlTMWlNVGt3TFRFeU1EWmlZemM0T1dFNE1DMHlOSFZv',
      DEFAULT_LANGUAGE: "en" // todo get lang from app prefs
    };

    var dio = Dio(BaseOptions(
        baseUrl: ApiRoutes.baseUrl,
        receiveTimeout: 15000, // 15 seconds
        connectTimeout: 15000,
        sendTimeout: 15000,
        headers: headers));
    if (kReleaseMode) {
      //print("Release mode no logs.");
    } else {
      dio.interceptors.addAll({
        DioApiInterCeptor(),
        /*PrettyDioLogger(
            requestHeader: false, requestBody: false, responseHeader: false)*/
      });
    }
    return dio;
  }
}

class DioApiInterCeptor extends Interceptor {
  late final UserTokenHandle _userTokenHandle;

  //DioApiInterCeptor(Dio dio);

  dynamic requestInterceptor(RequestOptions options) async {
    if (options.headers.containsKey("requiresToken")) {
      //remove the auxiliary header
      options.headers.remove("requiresToken");

      var token = await _userTokenHandle.getLoginData();

      options.headers.addAll({"Authorization": "Basic $token"});

      return options;
    }
  }
}
