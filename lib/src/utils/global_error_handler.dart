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
    print(error.runtimeType);
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
          context: navKey.currentState!.context,
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
        ).then((value) => executeOnError(e.controllerType));

        break;
      default:
        handleDefault.call();
    }
  }

  void executeOnError(Type t) {
    switch (t) {
      case AuthProviderNotifier:
        ref.read(authProvider.notifier).onError();
    }
  }
}
