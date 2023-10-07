import 'package:alvys3/src/utils/global_error_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:upgrader/upgrader.dart';

final updaterProvider = FutureProvider<UpdaterController>((ref) async {
  await Upgrader.sharedInstance.initialize();
  var errorHandler = ref.read(globalErrorHandlerProvider);
  return UpdaterController(
    errorHandler: errorHandler,
  );
});

class UpdaterController {
  final GlobalErrorHandler errorHandler;
  UpdaterController({required this.errorHandler}) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (Upgrader.sharedInstance.shouldDisplayUpgrade()) {
        showDialog(
            context: errorHandler.navKey.currentContext!,
            barrierDismissible: false,
            builder: (context) => WillPopScope(
                  onWillPop: () => Future.value(false),
                  child: AlertDialog.adaptive(
                    title: const Text('New App Version'),
                    content:
                        Text('Version ${Upgrader.sharedInstance.currentAppStoreVersion()} of the app is available.'),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Upgrader.sharedInstance.onUserUpdated(context, true);
                          },
                          child: const Text('Update App'))
                    ],
                  ),
                ));
      }

      //  showDialog(context: errorHandler.navKey.currentState!.context, builder: (context) => UpgradeAlert());
    });
  }
}
