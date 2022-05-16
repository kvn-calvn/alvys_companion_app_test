import 'package:alvys3/src/constants/api_routes.dart';
import 'package:alvys3/src/network/user_token_handler.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class ApiClient {
  final dio = createDio();
  final tokenDio = Dio(BaseOptions(baseUrl: ApiRoutes.baseUrl));

  ApiClient._internal();

  static final _singleton = ApiClient._internal();

  factory ApiClient() => _singleton;

  static Dio createDio() {
    var dio = Dio(BaseOptions(
      baseUrl: ApiRoutes.baseUrl,
      receiveTimeout: 15000, // 15 seconds
      connectTimeout: 15000,
      sendTimeout: 15000,
    ));
    if (kReleaseMode) {
      //print("Release mode no logs.");
    } else {
      dio.interceptors.addAll({
        DioApiInterCeptor(),
        PrettyDioLogger(
            requestHeader: true, requestBody: true, responseHeader: true)
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

final apiClient = Provider((ref) => ApiClient());
