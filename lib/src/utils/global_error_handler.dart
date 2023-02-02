import 'package:alvys3/src/common_widgets/app_dialog.dart';
import 'package:alvys3/src/common_widgets/snack_bar.dart';
import 'package:alvys3/src/routing/error_page.dart';
import 'package:alvys3/src/utils/exceptions.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class GlobalErrorHandler {
  static void handle(FlutterErrorDetails? details, bool flutterError,
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

  static void _handleError(Object error, Function handleDefault) {
    switch (error.runtimeType) {
      case AlvysClientException:
        var e = error as AlvysClientException;
        /*
        var context =
            ErrorFunctionHandler.instance.navKey.currentState!.context;
        AppDialog(
          title: e.message.title ?? "_",
          description: e.message.content ?? "-",
          action1Label: 'Ok',
          action1: () {
            GoRouter.of(context).pop();
          },
        );*/
        //ErrorFunctionHandler.instance.executeOnError();

        showDialog(
          useRootNavigator: true,
          context: ErrorFunctionHandler.instance.navKey.currentState!.context,
          builder: (context) => AppDialog(
            title: 'Error',
            description: '${e.message.content}',
            actions: [
              AppDialogAction(
                label: 'OK',
                action: () => Navigator.pop(context),
                primary: true,
              )
            ],
          ),
        ).then((value) => ErrorFunctionHandler.instance.executeOnError());

        break;
      default:
        handleDefault.call();
    }
  }
}
