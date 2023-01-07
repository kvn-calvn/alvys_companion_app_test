import 'dart:io';
import 'package:alvys3/custom_icons/alvys3_icons.dart';
import 'package:alvys3/src/common_widgets/buttons.dart';
import 'package:alvys3/src/constants/color.dart';
import 'package:alvys3/src/utils/magic_strings.dart';
import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';

class RequestLocation extends StatelessWidget {
  const RequestLocation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, [bool mounted = true]) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            'Location Permission',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          centerTitle: true,
          elevation: 0,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
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
                    var requestLocationResult =
                        await Permission.location.request();
                    await Permission.locationAlways.request();

                    var notificationPermStatus =
                        await Permission.notification.status;

                    if (requestLocationResult.isPermanentlyDenied) {
                      debugPrint('Location request was denied');
                      //AppSettings.openLocationSettings();
                    }

                    debugPrint("Notification status: $notificationPermStatus");

                    if (notificationPermStatus.isDenied) {
                      if (!mounted) return;
                      context.goNamed(RouteName.notificationPermission.name);
                    } else {
                      if (!mounted) return;
                      context.goNamed(RouteName.trips.name);
                    }
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                TextButton(
                  onPressed: () async {
                    var notificationPermStatus =
                        await Permission.notification.status;
                    if (notificationPermStatus.isGranted ||
                        notificationPermStatus.isDenied) {
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
        ));
  }
}
