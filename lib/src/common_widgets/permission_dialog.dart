import 'dart:ui';

import 'package:alvys3/src/common_widgets/buttons.dart';
import 'package:flutter/material.dart';

class PermissionDialog extends StatefulWidget {
  const PermissionDialog(
      {Key? key,
      required this.title,
      required this.description,
      required this.allowAction,
      required this.notNowAction})
      : super(key: key);

  final String title, description;
  final Function allowAction;
  final Function notNowAction;

  @override
  State<PermissionDialog> createState() => _PermissionDialogState();
}

class _PermissionDialogState extends State<PermissionDialog> {
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
                widget.title,
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                widget.description,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 22,
              ),
              ButtonStyle1(onPressAction: () {}, title: "Allow"),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  "Don't Allow",
                  style: TextStyle(fontSize: 12),
                ),
              )
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
