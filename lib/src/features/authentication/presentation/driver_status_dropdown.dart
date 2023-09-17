import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';

import '../../../utils/magic_strings.dart';
import '../../trips/presentation/controller/trip_page_controller.dart';
import '../../tutorial/tutorial_controller.dart';
import 'auth_provider_controller.dart';

class DriverStatusDropdown extends ConsumerWidget {
  const DriverStatusDropdown({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var authState = ref.watch(authProvider);
    var status = authState.value!.driverStatus;
    var tripController = ref.read(tripControllerProvider.notifier);
    return DropdownButtonHideUnderline(
      key: ref.read(tutorialProvider).sleepDropdown,
      child: DropdownButton(
        value: status ?? DriverStatus.online,
        isDense: true,
        elevation: 1,
        iconSize: 0.0,
        borderRadius: BorderRadius.circular(10),
        items: DriverStatus.driverStatuses
            .map((e) => DropdownMenuItem(
                  value: e,
                  child: Row(
                    children: [
                      e == DriverStatus.online
                          ? Lottie.asset('assets/lottie/green_pulse.json', width: 30, height: 30)
                          : const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.brightness_1,
                                color: Colors.grey,
                                size: 16,
                              ),
                            ),
                      const SizedBox(
                        width: 0,
                      ),
                      Text(
                        e,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                ))
            .toList(),
        //   [
        //   DropdownMenuItem(
        //     value: "Online",
        //     onTap: () {},
        //     child: Row(
        //       children: [
        //         Lottie.asset('assets/lottie/green_pulse.json', width: 30, height: 30),
        //         /*Icon(
        //                     Icons.brightness_1,
        //                     color: Colors.green.shade600,
        //                   ),*/
        //         const SizedBox(
        //           width: 0,
        //         ),
        //         Text(
        //           "Online",
        //           style: Theme.of(context).textTheme.titleMedium,
        //         ),
        //       ],
        //     ),
        //   ),
        //   DropdownMenuItem(
        //     value: "Offline",
        //     onTap: () {
        //       //Stop location tracking when offline.
        //       PlatformChannel.stopLocationTracking();
        //     },
        //     child: Row(
        //       children: [
        //         const SizedBox(
        //           width: 8,
        //         ),
        //         Icon(
        //           Icons.brightness_1,
        //           size: 14,
        //           color: Colors.grey.shade600,
        //         ),
        //         const SizedBox(
        //           width: 8,
        //         ),
        //         Text(
        //           "Offline",
        //           style: Theme.of(context).textTheme.titleMedium,
        //         ),
        //       ],
        //     ),
        //   )
        // ],
        onChanged: (String? value) => tripController.updateDriverStatus(value),
      ),
    );
  }
}
