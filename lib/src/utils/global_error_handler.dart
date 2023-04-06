import 'package:alvys3/src/common_widgets/app_dialog.dart';
import 'package:alvys3/src/features/authentication/presentation/auth_provider_controller.dart';
import 'package:alvys3/src/utils/exceptions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final globalErrorHandlerProvider = Provider<GlobalErrorHandler>((ref) {
  return GlobalErrorHandler(ref: ref);
});

class GlobalErrorHandler {
  final ProviderRef<GlobalErrorHandler> ref;
  GlobalKey<NavigatorState> navKey =
      GlobalKey<NavigatorState>(debugLabel: "MainNavKey");
  GlobalErrorHandler({required this.ref});
  void handle(FlutterErrorDetails? details, bool flutterError,
      [Object? error, StackTrace? trace]) {
    _handleError(
      flutterError ? details!.exception : error!,
      () {
        if (flutterError) {
          FlutterError.presentError(details!);
        } else {
          debugPrint("$error");
          debugPrintStack(stackTrace: trace);
        }
      },
    );
  }

  void _handleError(Object error, Function handleDefault) {
    Function? onError;
    String message = '';
    bool hasError = true;
    switch (error.runtimeType) {
      case AlvysClientException:
        var e = error as AlvysClientException;
        onError = () => executeOnError(e.controllerType);
        message = '${e.message.content}';

        break;
      case PermissionException:
        var e = error as PermissionException;
        message = e.message;
        onError = e.onError;
        break;
      default:
        hasError = false;
        handleDefault.call();
    }
    if (hasError) {
      showErrorDialog(
        context: navKey.currentState!.context,
        afterError: () => onError?.call(),
        message: message,
      );
    }
  }

  void executeOnError(Type t) {
    switch (t) {
      case AuthProviderNotifier:
        ref.read(authProvider.notifier).onError();
        break;
    }
  }

  void showErrorDialog(
          {required BuildContext context,
          required void Function() afterError,
          required String message}) =>
      showDialog(
        context: context,
        useRootNavigator: true,
        builder: (context) => AppDialog(
          title: 'Error',
          description: message,
          actions: [
            AppDialogAction(
              label: 'OK',
              action: () => Navigator.pop(context),
              primary: true,
            )
          ],
        ),
      ).then((value) => afterError());
}
