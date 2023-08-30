import 'package:flutter/material.dart';

class DialogPage<T> extends Page<T> {
  final Widget child;

  const DialogPage(this.child);

  @override
  Route<T> createRoute(BuildContext context) => DialogRoute<T>(
        context: context,
        settings: this,
        builder: (context) => AlertDialog(
          content: child,
        ),
      );
}
