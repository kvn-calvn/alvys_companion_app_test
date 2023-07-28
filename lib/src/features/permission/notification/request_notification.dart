import 'package:alvys3/custom_icons/alvys3_icons.dart';
import 'package:alvys3/flavor_config.dart';
import 'package:alvys3/src/common_widgets/buttons.dart';
import 'package:alvys3/src/constants/color.dart';
import 'package:alvys3/src/utils/magic_strings.dart';
import 'package:alvys3/src/utils/platform_channel.dart';
import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:alvys3/src/features/authentication/presentation/auth_provider_controller.dart';

class RequestNotification extends ConsumerWidget {
  const RequestNotification({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref, [bool mounted = true]) {
    var userState = ref.watch(authProvider);

    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            'Notification Permission',
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
                  title: "Continue",
                  isLoading: false,
                  isDisable: false,
                  onPressAction: () async {
                    var requestNotificationResult = await Permission.notification.request();

                    if (requestNotificationResult.isPermanentlyDenied) {
                      if (mounted) {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                content: const Text(
                                    'You have this app\'s location permession to permanently denied. Open location settings to change it.'),
                                actions: [TextButton(onPressed: () {}, child: const Text(''))],
                              );
                            });
                      }
                      AppSettings.openAppSettings(type: AppSettingsType.notification);
                    }

                    if (requestNotificationResult.isGranted) {
                      if (!mounted) return;

                      debugPrint("PHONE_NUMBER: ${userState.value!.driver!.phone!}");

                      PlatformChannel.getNotification(userState.value!.driver!.phone!, FlavorConfig.instance!.hubName,
                          FlavorConfig.instance!.connectionString);

                      context.goNamed(RouteName.trips.name);
                    }
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                TextButton(
                  onPressed: () {
                    if (!mounted) return;
                    context.goNamed(RouteName.trips.name);
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
