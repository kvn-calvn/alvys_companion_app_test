import '../features/authentication/presentation/edit_profile_controller.dart';
import '../features/echeck/presentation/controller/echeck_page_controller.dart';
import '../features/trips/presentation/controller/trip_page_controller.dart';
import 'provider_args_saver.dart';

import '../network/http_client.dart';
import 'package:azure_application_insights/azure_application_insights.dart';

import '../common_widgets/app_dialog.dart';
import 'exceptions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/authentication/presentation/auth_provider_controller.dart';
import '../features/documents/presentation/upload_documents_controller.dart';

final globalErrorHandlerProvider = Provider<GlobalErrorHandler>((ref) {
  return GlobalErrorHandler(
      providers: () => {
            AuthProviderNotifier: () => ref.read(authProvider.notifier),
            UploadDocumentsController: () =>
                ref.read(uploadDocumentsController.call(ProviderArgsSaver.instance.uploadArgs!).notifier),
            EditProfileNotifier: () => ref.read(editProfileProvider.notifier),
            TripController: () => ref.read(tripControllerProvider.notifier),
            EcheckPageController: () =>
                ref.read(echeckPageControllerProvider.call(ProviderArgsSaver.instance.echeckArgs).notifier)
          },
      telemetry: ref.read(httpClientProvider));
});

class GlobalErrorHandler {
  final AlvysHttpClient telemetry;
  LabeledGlobalKey<NavigatorState> navKey = LabeledGlobalKey<NavigatorState>("MainNavKey");
  Map<Type, IAppErrorHandler Function()> Function() providers;
  GlobalErrorHandler({required this.providers, required this.telemetry});
  void handle(FlutterErrorDetails? details, bool flutterError, [Object? error, StackTrace? trace]) {
    _handleError(
      flutterError ? details!.exception : error!,
      () {
        if (flutterError) {
          telemetry.telemetryClient
              .trackTrace(severity: Severity.error, message: 'mobile_app_client_error', additionalProperties: {
            "Error": details!.exception.toString(),
            "StackTrace": details.stack.toString(),
            "ErrorType": "Flutter error",
          });
          FlutterError.presentError(details);
        } else {
          telemetry.telemetryClient
              .trackTrace(severity: Severity.error, message: 'mobile_app_client_error', additionalProperties: {
            "Error": error.toString(),
            "StackTrace": trace.toString(),
            "ErrorType": "Regular",
          });
          debugPrint("$error");
          debugPrintStack(stackTrace: trace);
        }
      },
    );
  }

  void _handleError(Object error, Function handleDefault) {
    Function? onError;
    List<ExceptionAction> optionalOptions = [];
    String message = '';
    String title = '';
    bool hasError = true;
    switch (error.runtimeType) {
      case AlvysClientException:
      case AlvysEntityNotFoundException:
      case AlvysSocketException:
      case AlvysTimeoutException:
      case AlvysUnauthorizedException:
      case ApiServerException:
      case AlvysDependencyException:
      case ControllerException:
        var e = error as ControllerException;
        onError = () => executeOnError(e.source);
        message = e.message;
        title = e.title;
        break;
      case PermissionException:
        var e = error as PermissionException;
        message = e.message;
        title = 'Permission Error';
        onError = e.onError;
        optionalOptions = e.optionalActions;
        break;
      case AlvysException:
        var e = error as AlvysException;
        message = e.message;
        title = e.title;
        onError = e.onError;
        break;
      default:
        hasError = false;
        handleDefault();
    }
    if (hasError) {
      showErrorDialog(
        context: navKey.currentState!.context,
        afterError: () => onError?.call(),
        optionalActions: optionalOptions,
        message: message,
        title: title,
      );
    }
  }

  void executeOnError(Type t) {
    var providerData = providers();
    if (providerData.containsKey(t)) {
      providerData[t]!().onError();
    }
    // switch (t) {
    //   case AuthProviderNotifier:
    //     ref.read(authProvider.notifier).onError();
    //     break;
    //   case UploadDocumentsController:
    //     ref.read(uploadDocumentsController.call(ProviderArgsSaver.instance.uploadArgs!).notifier).onError();
    //     break;
    //   case EditProfileNotifier:
    //     ref.read(editProfileProvider.notifier).onError();
    //   case TripController:
    //     ref.read(tripControllerProvider.notifier).onError();
    //   case EcheckPageController:
    //     ref.read(echeckPageControllerProvider.call(ProviderArgsSaver.instance.echeckArgs).notifier).onError();
    // }
  }

  void showErrorDialog(
          {required BuildContext context,
          required void Function() afterError,
          required List<ExceptionAction> optionalActions,
          required String message,
          required String title}) =>
      showDialog(
        context: context,
        useRootNavigator: true,
        builder: (context) => AppDialog(
          title: title,
          description: message,
          actions: [
            AppDialogAction(
              label: 'OK',
              action: () => Navigator.pop(context),
              primary: true,
            ),
            ...optionalActions.map((e) => AppDialogAction(label: e.title, action: e.action, primary: true))
          ],
        ),
      ).then((value) => afterError());
}
