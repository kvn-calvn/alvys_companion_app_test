import 'dart:io';

import 'package:alvys3/src/features/authentication/presentation/auth_provider_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../../custom_icons/alvys3_icons.dart';
import '../../../../../flavor_config.dart';
import '../../../../common_widgets/buttons.dart';
import '../../../../constants/color.dart';
import '../../../../utils/magic_strings.dart';
import '../../../../utils/platform_channel.dart';
import '../../../../utils/tablet_utils.dart';

class RequestLocation extends ConsumerStatefulWidget {
  const RequestLocation({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RequestLocationState();
}

class _RequestLocationState extends ConsumerState<RequestLocation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            'Location Permission',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
            child: Container(
              constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.longestSide * (TabletUtils.instance.isTablet ? 0.5 : 1)),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Alvys3Icons.trackIcon,
                      size: MediaQuery.of(context).size.height * 0.15,
                      color: ColorManager.primary(Theme.of(context).brightness),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Text(
                      Platform.isAndroid
                          ? 'Alvys driver companion collects your location data to enable real time driver location tracking even when the app is closed or not in use.'
                          : 'Alvys uses your location data to track the movement of loads you have been assigned.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    ButtonStyle1(
                      title: "Continue",
                      isLoading: false,
                      isDisable: false,
                      onPressAction: () async {
                        var requestLocationResult = await Permission.location.request();
                        await Permission.locationAlways.request();

                        var notificationPermStatus = await Permission.notification.status;

                        if (requestLocationResult.isPermanentlyDenied) {
                          //debugPrint('Location request was denied');
                          //AppSettings.openLocationSettings();
                        }

                        //debugPrint("Notification status: $notificationPermStatus");

                        if (notificationPermStatus.isDenied) {
                          if (!mounted) return;
                          context.goNamed(RouteName.notificationPermission.name);
                        }

                        if (notificationPermStatus.isGranted) {
                          if (!mounted) return;
                          PlatformChannel.getNotification(ref.read(authProvider).value!.driver!.phone!,
                              FlavorConfig.instance!.hubName, FlavorConfig.instance!.connectionString);
                          context.goNamed(RouteName.trips.name);
                        }

                        /*
                        if (requestLocationResult.isGranted) {
                          if (notificationPermStatus.isDenied ||
                              notificationPermStatus.isPermanentlyDenied) {
                            if (!mounted) return;
                            context.goNamed(RouteName.notificationPermission.name);
                          }
                        }*/

                        //context.goNamed(RouteName.notificationPermission.name);
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextButton(
                      onPressed: () async {
                        var notificationPermStatus = await Permission.notification.status;
                        if (notificationPermStatus.isGranted || notificationPermStatus.isDenied) {
                          if (!mounted) return;
                          context.goNamed(RouteName.trips.name);
                        } else {
                          if (!mounted) return;
                          context.goNamed(RouteName.notificationPermission.name);
                        }
                      },
                      child: const Text(
                        'Not now',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
