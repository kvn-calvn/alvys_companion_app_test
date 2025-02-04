import 'dart:io';

import 'package:alvys3/src/utils/telemetry.dart';
import 'package:azure_application_insights/azure_application_insights.dart';
import 'package:coder_matthews_extensions/coder_matthews_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../common_widgets/app_dialog.dart';
import '../features/authentication/presentation/auth_provider_controller.dart';
import '../features/authentication/presentation/edit_profile_controller.dart';
import '../features/documents/presentation/docs_controller.dart';
import '../features/documents/presentation/upload_documents_controller.dart';
import '../features/echeck/presentation/controller/echeck_page_controller.dart';
import '../features/trailers/presentation/controller/search_trailer_controller.dart';
import '../features/trips/presentation/controller/trip_page_controller.dart';
import '../network/http_client.dart';
import '../routing/custom_observer.dart';
import 'exceptions.dart';
import 'provider_args_saver.dart';

final globalErrorHandlerProvider = Provider<GlobalErrorHandler>((ref) {
  return GlobalErrorHandler(
      auth: () => ref.read(authProvider.notifier),
      providers: () => {
            AuthProviderNotifier: () => ref.read(authProvider.notifier),
            UploadDocumentsController: () => ref.read(
                uploadDocumentsController.call(ProviderArgsSaver.instance.uploadArgs!).notifier),
            DocumentsNotifier: () =>
                ref.read(documentsProvider.call(ProviderArgsSaver.instance.documentArgs!).notifier),
            EditProfileNotifier: () => ref.read(editProfileProvider.notifier),
            TripController: () => ref.read(tripControllerProvider.notifier),
            EcheckPageController: () => ref.read(
                echeckPageControllerProvider.call(ProviderArgsSaver.instance.echeckArgs).notifier),
            SearchTrailerController: () => ref.read(searchTrailerControllerProvider
                .call(ProviderArgsSaver.instance.assignTrailerDto!)
                .notifier)
          },
      telemetry: ref.read(telemetryClientProvider),
      customObserver: ref.read(customObserverProvider),
      telemetrySpanHelper: ref.read(telemetrySpanProvider));
});

class GlobalErrorHandler {
  final TelemetryClient telemetry;
  final TelemetrySpanHelper telemetrySpanHelper;
  final CustomObserver customObserver;
  LabeledGlobalKey<NavigatorState> navKey = LabeledGlobalKey<NavigatorState>("MainNavKey");
  Map<Type, IErrorHandler Function()> Function() providers;
  AuthProviderNotifier Function() auth;
  GlobalErrorHandler(
      {required this.providers,
      required this.telemetrySpanHelper,
      required this.telemetry,
      required this.auth,
      required this.customObserver});
  void handle(FlutterErrorDetails? details, bool flutterError, [Object? error, StackTrace? trace]) {
    _handleError(
      flutterError ? details!.exception : error!,
      () {
        if (flutterError) {
          if (details!.exception is! SocketException) {
            telemetry.trackError(
                severity: Severity.error,
                error: details.exception,
                additionalProperties: {
                  "Error": details.exception.toString(),
                  "StackTrace": details.stack.toString(),
                  "ErrorType": "Flutter error",
                  "Page": '${customObserver.currentRoute}',
                });
          }
          FlutterError.presentError(details);
        } else {
          if (error is! SocketException) {
            telemetry.trackError(severity: Severity.error, error: error!, additionalProperties: {
              "Error": error.toString(),
              "StackTrace": trace.toString(),
              "ErrorType": "Regular",
              "Page": '${customObserver.currentRoute}',
            });
          }
          debugPrint("$error");
          debugPrintStack(stackTrace: trace);
        }
        telemetrySpanHelper.endSpan();
      },
    );
  }

  void _handleError(Object error, Function handleDefault) {
    void Function()? onError;
    List<ExceptionAction> optionalOptions = [];
    String message = '';
    String title = '';
    String? dismissButtonText;
    bool hasError = true;
    switch (error.runtimeType) {
      case const (AlvysClientException):
      case const (AlvysEntityNotFoundException):
      case const (AlvysSocketException):
      case const (AlvysTimeoutException):
      case const (ApiServerException):
      case const (AlvysDependencyException):
      case const (AlvysServiceUnavailableException):
      case const (AppControllerException):
        var e = error as AppControllerException;
        onError = () => executeOnError(e.source, e);
        message = e.message;
        title = e.title;

        dismissButtonText = "Ok";
        break;
      case const (AlvysUnauthorizedException):
        var e = error as AlvysUnauthorizedException;
        onError = () {
          executeOnError(e.source, e);
          auth().signOut(navKey.currentContext!);
        };
        message = e.message;
        title = e.title;

        dismissButtonText = "Ok";
        break;
      case const (PermissionException):
        var e = error as PermissionException;
        message = e.message;
        title = 'Permission Error';
        onError = e.onError;
        optionalOptions = e.optionalActions;
        dismissButtonText = "Not now";
        break;
      case const (AlvysException):
        var e = error as AlvysException;
        message = e.message;
        title = e.title;
        onError = e.onError;
        break;
      case const (AppException):
        var e = error as AppException;
        message = e.message;
        title = e.title;
        onError = e.actions.firstOrNull?.op;
        break;
      default:
        hasError = false;
        handleDefault();
    }
    if (hasError) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        showErrorDialog(
            context: navKey.currentState!.context,
            afterError: () => onError?.call(),
            optionalActions: optionalOptions,
            message: message,
            title: title,
            dismissButtonText: dismissButtonText);
      });
    }
  }

  void executeOnError(Type t, Exception ex) {
    var providerData = providers();
    if (providerData.containsKey(t)) {
      providerData[t]!().onError(ex);
    }
  }

  void showErrorDialog(
          {required BuildContext context,
          required void Function() afterError,
          required List<ExceptionAction> optionalActions,
          required String message,
          String? dismissButtonText,
          required String title}) =>
      showDialog(
        context: context,
        useRootNavigator: true,
        builder: (context) => AppDialog(
          title: title,
          description: message,
          actions: [
            ...optionalActions.map(
              (e) => AppDialogAction(label: e.title, action: e.action, primary: true),
            ),
            AppDialogAction(
              label: dismissButtonText ?? 'Ok',
              action: () => Navigator.pop(context),
              primary: optionalActions.isEmpty,
            ),
          ],
        ),
      ).then((value) => afterError());
}
