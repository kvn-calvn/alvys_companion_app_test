import 'dart:io';

import 'package:alvys3/src/features/authentication/presentation/auth_extension.dart';
import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../custom_icons/alvys3_icons.dart';
import '../../../../flavor_config.dart';
import '../../../common_widgets/app_dialog.dart';
import '../../../common_widgets/buttons.dart';
import '../../../constants/color.dart';
import '../../../utils/magic_strings.dart';
import '../../../utils/platform_channel.dart';
import '../../../utils/tablet_utils.dart';
import '../../authentication/presentation/auth_provider_controller.dart';

class RequestNotification extends ConsumerWidget {
  const RequestNotification({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref, [bool mounted = true]) {
    var userState = ref.watch(authProvider);
    final userValue = userState.authValue;

    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            'Notification Permission',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
            child: Container(
              constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.longestSide *
                      (TabletUtils.instance.isTablet ? 0.5 : 1)),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Alvys3Icons.notificationIcon,
                      size: MediaQuery.of(context).size.height * 0.125,
                      color: ColorManager.primary(Theme.of(context).brightness),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Text(
                      'Get notified when you are assigned a trip and other critical updates.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    ButtonStyle1(
                      key: const Key("notificationPermContinueBtn"),
                      title: "Continue",
                      isLoading: false,
                      isDisable: false,
                      onPressAction: () async {
                        var requestNotificationResult = await Permission.notification.request();

                        if (requestNotificationResult.isPermanentlyDenied) {
                          if (context.mounted) {
                            await showDialog(
                              context: context,
                              builder: (context) {
                                return AppDialog(
                                  title: "Allow Alvys Notifications",
                                  description:
                                      "Alvys notification permission is permanently denied. Open notification settings to change it.",
                                  actions: [
                                    AppDialogAction(
                                        label: 'Allow',
                                        action: () {
                                          AppSettings.openAppSettings(
                                                  type: AppSettingsType.notification)
                                              .then((value) => {
                                                    if (context.mounted) GoRouter.of(context).pop(),
                                                  });
                                        },
                                        primary: true),
                                    AppDialogAction(
                                        label: 'Not Now',
                                        action: () {
                                          context.goNamed(RouteName.trips.name);
                                        })
                                  ],
                                );
                              },
                            );
                            // await showDialog(
                            //     context: context,
                            //     builder: (context) {
                            //       return AlertDialog(
                            //         content: const Text(
                            //             'You have this app\'s notification permession to permanently denied. Open notification settings to change it.'),
                            //         actions: [
                            //           TextButton(
                            //               onPressed: () {
                            //                 Navigator.of(context, rootNavigator: true).pop();
                            //               },
                            //               child: const Text('Open Settings'))
                            //         ],
                            //       );
                            //     });
                          }

                          // AppSettings.openAppSettings(
                          //     type: AppSettingsType.notification);
                        }

                        if (requestNotificationResult.isGranted) {
                          if (!context.mounted) return;

                          debugPrint("PHONE_NUMBER: ${userValue.driver!.phone!}");

                          PlatformChannel.getNotification(
                              userValue.driver!.phone!,
                              FlavorConfig.instance!.hubName,
                              FlavorConfig.instance!.connectionString);

                          context.goNamed(RouteName.trips.name);
                        }
                      },
                    ),
                    if (Platform.isAndroid) ...[
                      const SizedBox(
                        height: 10,
                      ),
                      TextButton(
                        key: const Key("notificationPermNotNowBtn"),
                        onPressed: () {
                          if (!mounted) return;
                          context.goNamed(RouteName.trips.name);
                        },
                        child: const Text(
                          'Not now',
                        ),
                      ),
                    ]
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
