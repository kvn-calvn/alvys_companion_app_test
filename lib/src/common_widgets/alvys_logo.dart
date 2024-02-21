import '../../custom_icons/alvys3_icons.dart';
import '../constants/color.dart';
import 'package:flutter/material.dart';

class AlvysLogo extends StatelessWidget {
  final bool showSubtext;
  final double scaleFactor;
  const AlvysLogo.raw({super.key, this.scaleFactor = 1}) : showSubtext = false;
  const AlvysLogo.subText({super.key, this.scaleFactor = 1}) : showSubtext = true;

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: scaleFactor,
      child: Column(
        children: [
          Image.asset(
            'assets/images/logo_white_text.png',
            height: 70,
            color: ColorManager.primary(Theme.of(context).brightness),
          ),
          showSubtext
              ? Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Alvys3Icons.deliveryTruck),
                      const SizedBox(width: 10),
                      Text(
                        'Driver Companion',
                        style: Theme.of(context).textTheme.bodySmall,
                      )
                    ],
                  ),
                )
              : const SizedBox.shrink()
        ],
      ),
    );
  }
}
