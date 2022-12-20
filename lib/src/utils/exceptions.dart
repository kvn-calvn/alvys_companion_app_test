import 'package:dio/dio.dart';

import '../network/client_error/client_error.dart';

class AlvysClientException implements Exception {
  late ClientError message;
  AlvysClientException(dynamic message) {
    this.message =
        (message is ClientError) ? message : ClientError.fromJson(message);
  }
}

class AlvysDioError extends DioError {
  AlvysDioError({required RequestOptions requestOptions})
      : super(requestOptions: requestOptions);
}
