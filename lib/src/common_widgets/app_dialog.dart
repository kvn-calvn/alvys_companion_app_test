import 'dart:ui';

import 'package:alvys3/src/common_widgets/buttons.dart';
import 'package:flutter/material.dart';

class AppDialogAction {
  final String label;
  final bool primary;
  final void Function() action;

  AppDialogAction(
      {required this.label, required this.action, this.primary = false});
}

class AppDialog extends StatelessWidget {
  const AppDialog(
      {Key? key,
      required this.title,
      required this.description,
      required this.actions})
      : super(key: key);

  final String title, description;
  final List<AppDialogAction> actions;

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
              for (var action in actions)
                action.primary
                    ? ButtonStyle1(
                        onPressAction: action.action, title: action.label)
                    : TextButton(
                        onPressed: action.action,
                        child: Text(
                          action.label,
                          style: const TextStyle(fontSize: 12),
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
