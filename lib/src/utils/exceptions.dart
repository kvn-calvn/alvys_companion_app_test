import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../network/client_error/client_error.dart';

class AlvysClientException implements ControllerException {
  late ClientError error;
  late Type controllerType;
  AlvysClientException(dynamic msg, this.controllerType) {
    error = ClientError.fromJson(msg);
  }

  @override
  // TODO: implement message
  String get message => error.title ?? error.details ?? error.errors.entries.firstOrNull?.value[0]?.first ?? "";

  @override
  // TODO: implement source
  Type get source => controllerType;

  @override
  // TODO: implement title
  String get title => "Client Error";
}

class PermissionException implements Exception {
  final String message;
  final Function onError;
  PermissionException(this.message, this.onError);
}

class AlvysDioError extends DioException {
  AlvysDioError({required RequestOptions requestOptions}) : super(requestOptions: requestOptions);
}

class AlvysTimeoutException extends ControllerException {
  final Type s;
  AlvysTimeoutException(this.s)
      : super('Request Timeout', 'The request for this resource has timed out. Try again later', s);
}

class AlvysSocketException extends ControllerException {
  final Type s;
  AlvysSocketException(this.s)
      : super('Connection Error', 'There was an error with connecting to the server. Try again later', s);
}

class AlvysEntityNotFoundException extends ControllerException {
  final Type s;
  AlvysEntityNotFoundException(this.s) : super('Not Found', 'The requested item was not found.', s);
}

class AlvysUnauthorizedException extends ControllerException {
  final Type s;
  AlvysUnauthorizedException(this.s) : super('Unauthorized', 'You are not authorized to access this item', s);
}

class ApiServerException extends ControllerException {
  final Type s;
  ApiServerException(this.s) : super('Server Error', 'A server error has occured. Try again later', s);
}

class ControllerException implements Exception {
  final String message, title;
  final Type source;

  ControllerException(this.title, this.message, this.source);
}

abstract class IAppErrorHandler {
  FutureOr<void> onError();
}
