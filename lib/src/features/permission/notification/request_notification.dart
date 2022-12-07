import 'dart:io';
import 'package:alvys3/custom_icons/alvys3_icons.dart';
import 'package:alvys3/src/common_widgets/buttons.dart';
import 'package:alvys3/src/constants/color.dart';
import 'package:alvys3/src/constants/text_styles.dart';
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
                const Icon(Alvys3Icons.notificationIcon, size: 90),
                const SizedBox(
                  height: 30,
                ),
                Text(
                  'Get notified when you are assigned a load and other critical updates.',
                  textAlign: TextAlign.center,
                  style:
                      getMediumStyle(color: ColorManager.white, fontSize: 16),
                ),
                const SizedBox(
                  height: 30,
                ),
                ButtonStyle1(
                  title: "Continue",
                  isLoading: false,
                  isDisable: false,
                  onPressAction: () {
                    context.goNamed(
                      'Trips',
                    );
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
