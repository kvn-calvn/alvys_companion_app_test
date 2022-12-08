import 'dart:io';
import 'package:alvys3/custom_icons/alvys3_icons.dart';
import 'package:alvys3/src/common_widgets/buttons.dart';
import 'package:alvys3/src/constants/color.dart';
import 'package:alvys3/src/constants/text_styles.dart';
import 'package:alvys3/src/utils/magic_strings.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RequestNotification extends StatelessWidget {
  const RequestNotification({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text(
            'Notification Permission',
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
                  'Get notified when you are assigned a load and other critical updates.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                const SizedBox(
                  height: 30,
                ),
                ButtonStyle1(
                  title: "Continue",
                  isLoading: false,
                  isDisable: false,
                  onPressAction: () {
                    context.goNamed(RouteName.trips.name);
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Not now',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
