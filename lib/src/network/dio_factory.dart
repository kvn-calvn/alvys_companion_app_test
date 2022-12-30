// ignore_for_file: constant_identifier_names, no_leading_underscores_for_local_identifiers

//import 'package:alvys3/src/constants/api_routes.dart';
import 'package:alvys3/src/network/user_token_handler.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

const String APPLICATION_JSON = "application/json";
const String CONTENT_TYPE = "content-type";
const String ACCEPT = "accept";
const String AUTHORIZATION = "authorization";
const String DEFAULT_LANGUAGE = "language";

class DioFactory {
  final UserTokenHandle _userTokenHandle;
  DioFactory(this._userTokenHandle);

  Future<Dio> getDio() async {
    Dio dio = Dio();
    int _timeOut = 60 * 1000; // 1 min

    Map<String, String> headers = {
      CONTENT_TYPE: APPLICATION_JSON,
      ACCEPT: APPLICATION_JSON,
      AUTHORIZATION: await _userTokenHandle.getLoginData(),
      DEFAULT_LANGUAGE: "en" // todo get lang from app prefs
    };

    dio.options = BaseOptions(
        //baseUrl: ApiRoutes.baseUrl,
        connectTimeout: _timeOut,
        receiveTimeout: _timeOut,
        headers: headers);

    if (kReleaseMode) {
      //print("Release mode no logs.");
    } else {
      dio.interceptors.add(PrettyDioLogger(
          requestHeader: true, requestBody: true, responseHeader: true));
    }

    return dio;
  }
}
