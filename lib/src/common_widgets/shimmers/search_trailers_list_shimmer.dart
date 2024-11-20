import '../../../custom_icons/alvys_mobile_icons.dart';
import '../../constants/color.dart';
import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter/material.dart';
import 'shimmer_widget.dart';

class SearchTrailersListShimmer extends StatelessWidget {
  const SearchTrailersListShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return AlvysShimmer(
      repeatAmount: 20,
      repeatingChild: (index) => Padding(
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Row(
          children: [
            Icon(AlvysMobileIcons.trailer),
            SizedBox(width: 20),
            FadeShimmer(
              width: 70,
              height: 20,
              radius: 3,
              highlightColor: ColorManager.shimmerCardHighlight,
              baseColor: ColorManager.shimmerCardHighlight,
            )
          ],
        ),
      ),
    );
  }
}
