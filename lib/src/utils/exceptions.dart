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
  String get message => error.errors.entries.firstOrNull?.value.firstOrNull ?? error.detail ?? '';

  @override
  Type get source => controllerType;

  @override
  String get title => error.title ?? error.errors.entries.firstOrNull?.key ?? "Client Error";
}

class AlvysDependencyException implements ControllerException {
  late DependencyError error;
  late Type controllerType;
  AlvysDependencyException(dynamic msg, this.controllerType) {
    error = DependencyError.fromJson(msg);
  }

  @override
  String get message => '''${error.title}
  ${error.detail ?? ''}''';

  @override
  Type get source => controllerType;

  @override
  String get title => "Dependency Failure Error";
}

class AlvysEntityNotFoundException implements ControllerException {
  late NotFoundError error;
  late Type controllerType;
  AlvysEntityNotFoundException(dynamic msg, this.controllerType) {
    error = NotFoundError.fromJson(msg);
  }

  @override
  String get message => error.title;

  @override
  Type get source => controllerType;

  @override
  String get title => "Not Found";
}

class PermissionException implements Exception {
  final String message;
  final Function onError;
  final List<ExceptionAction> optionalActions;
  PermissionException(this.message, this.onError, [this.optionalActions = const []]);
}

class ExceptionAction {
  final String title;
  final void Function() action;

  ExceptionAction({required this.title, required this.action});
}

class AlvysException implements Exception {
  final String message, title;
  final Function onError;
  AlvysException(this.message, this.title, this.onError);
}

class AlvysDioError extends DioException {
  AlvysDioError({required super.requestOptions});
}

class AlvysTimeoutException extends ControllerException {
  final Type s;
  AlvysTimeoutException(this.s)
      : super('Request Timeout', 'The request for this resource has timed out. Try again later', s);
}

class AlvysSocketException extends ControllerException {
  final Type s;
  AlvysSocketException(this.s)
      : super('Connection Error',
            'There was an error with connecting to the server. Check your internet connection and try again later', s);
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
  FutureOr<void> onError(Exception ex);
  FutureOr<void> refreshPage(String page);
}
