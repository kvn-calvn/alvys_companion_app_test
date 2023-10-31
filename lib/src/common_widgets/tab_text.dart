import 'package:flutter/material.dart';

import '../utils/tablet_utils.dart';

class TabText extends StatelessWidget {
  final String data;
  const TabText(this.data, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      data,
      textScaleFactor: TabletUtils.instance.isTablet ? 1.25 : 0.9,
      softWrap: false,
      overflow: TextOverflow.fade,
    );
  }
}
