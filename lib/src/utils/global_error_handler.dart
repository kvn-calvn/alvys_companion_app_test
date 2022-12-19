import 'package:alvys3/src/routing/error_page.dart';
import 'package:alvys3/src/utils/exceptions.dart';
import 'package:flutter/material.dart';

class GlobalErrorHandler {
  static void handle(
      GlobalKey<NavigatorState> navKey, Object error, StackTrace? stackTrace) {
    switch (error.runtimeType) {
      case ClientException:
        var e = error as ClientException;
        showDialog(
                context: navKey.currentState!.context,
                builder: (context) => AlertDialog(
                      title: Text(e.message.title!),
                      content: Text(e.message.content!),
                    ))
            .then((value) => ErrorFunctionHandler.instance.executeOnError());
        break;
      default:
        throw error;
    }
  }
}
