import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../network/client_error/client_error.dart';

class AlvysClientException implements Exception {
  late ClientError message;
  Type controllerType;
  AlvysClientException(dynamic message, this.controllerType) {
    this.message =
        (message is ClientError) ? message : ClientError.fromJson(message);
  }
}

class AlvysDioError extends DioError {
  AlvysDioError({required RequestOptions requestOptions})
      : super(requestOptions: requestOptions);
}

abstract class IAppErrorHandler {
  FutureOr<void> onError();
}
