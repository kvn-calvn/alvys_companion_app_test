import 'dart:ui';

import 'package:alvys3/src/common_widgets/buttons.dart';
import 'package:flutter/material.dart';

class AppDialog extends StatelessWidget {
  const AppDialog({
    Key? key,
    required this.title,
    required this.description,
    required this.action1Label,
    required this.action1,
    this.action2Label,
    this.action2,
  }) : super(key: key);

  final String title, description;
  final String action1Label;
  final String? action2Label;
  final Function() action1;
  final Function()? action2;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(100.0),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
        child: contentBox(context),
      ),
    );
  }

  contentBox(context) {
    return Stack(
      children: <Widget>[
        Container(
          constraints: const BoxConstraints(minWidth: 100, maxWidth: 350),
          padding: const EdgeInsets.all(25),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(Constants.padding),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                description,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 22,
              ),
              ButtonStyle1(onPressAction: action1, title: action1Label),
              if (action2 != null && action2Label != null) ...[
                TextButton(
                  onPressed: action2!,
                  child: Text(
                    action2Label!,
                    style: const TextStyle(fontSize: 12),
                  ),
                )
              ]
            ],
          ),
        ),
      ],
    );
  }
}

class Constants {
  Constants._();
  static const double padding = 10;
  static const double avatarRadius = 10;
}
