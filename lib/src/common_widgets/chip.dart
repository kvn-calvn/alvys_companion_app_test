import 'package:flutter/material.dart';

import '../constants/color.dart';

class ChipCard extends StatelessWidget {
  const ChipCard({
    super.key,
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: ColorManager.chipColor(Theme.of(context).brightness),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(80),
        //set border radius more than 50% of height and width to make circle
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Text(
          text,
          style: Theme.of(context).textTheme.labelLarge!,
        ),
      ),
    );
  }
}
