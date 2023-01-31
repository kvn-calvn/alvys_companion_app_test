import 'dart:ui';

import 'package:alvys3/src/common_widgets/button_style1.dart';
import 'package:flutter/material.dart';

class PermissionDialog extends StatefulWidget {
  const PermissionDialog(
      {Key? key, required this.title, required this.description})
      : super(key: key);

  final String title, description;

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
          constraints: const BoxConstraints(minWidth: 100, maxWidth: 300),
          padding: const EdgeInsets.all(30),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Colors.white,
            borderRadius: BorderRadius.circular(Constants.padding),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                widget.title,
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                widget.description,
                style: const TextStyle(fontSize: 14),
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
