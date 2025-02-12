import '../../common_widgets/app_dialog.dart';

import '../../utils/global_error_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:upgrader/upgrader.dart';

final updaterProvider = FutureProvider<UpdaterController>((ref) async {
  await Upgrader.sharedInstance.initialize();
  var errorHandler = ref.read(globalErrorHandlerProvider);
  return UpdaterController(
    errorHandler: errorHandler,
  );
});

class UpdaterController {
  bool showing = false;
  final GlobalErrorHandler errorHandler;
  void showUpdateDialog() {
    if (errorHandler.navKey.currentContext == null) return;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (Upgrader.sharedInstance.shouldDisplayUpgrade() && !showing) {
        showing = true;

        showDialog(
            context: errorHandler.navKey.currentContext!,
            barrierDismissible: false,
            builder: (context) => PopScope(
                  canPop: true,
                  onPopInvokedWithResult: (didPop, result) => (didPop) => Future.value(false),
                  child: AppDialog(
                    title: 'Update Available',
                    description:
                        'Version ${Upgrader.sharedInstance.currentAppStoreVersion} of the app is available.',
                    actions: [
                      AppDialogAction(
                        action: () {
                          Navigator.of(context, rootNavigator: true).pop();
                          Upgrader.sharedInstance.sendUserToAppStore();
                        },
                        label: 'Update',
                        primary: true,
                      ),
                      if (!Upgrader.sharedInstance.blocked())
                        AppDialogAction(
                            action: () {
                              Navigator.of(context, rootNavigator: true).pop();
                            },
                            label: 'Later')
                    ],
                  ),
                )).then((value) => showing = false);
      }

      //  showDialog(context: errorHandler.navKey.currentState!.context, builder: (context) => UpgradeAlert());
    });
  }

  UpdaterController({required this.errorHandler});
}
