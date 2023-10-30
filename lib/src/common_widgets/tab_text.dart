import 'package:flutter/material.dart';

class TabText extends StatelessWidget {
  final String data;
  const TabText(this.data, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      textScaleFactor: 0.9,
      softWrap: false,
      overflow: TextOverflow.fade,
    );
  }
}
