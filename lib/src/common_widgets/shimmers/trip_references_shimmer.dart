import 'shimmer_widget.dart';
import '../../constants/color.dart';
import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter/material.dart';

class TripReferencesShimer extends StatelessWidget {
  const TripReferencesShimer({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return AlvysShimmer(
        repeatAmount: 35,
        repeatingChild: (index) => Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FadeShimmer(
                width: constraints.maxWidth * 0.2,
                height: 24,
                highlightColor: ColorManager.shimmerCardHighlight,
                baseColor: ColorManager.shimmerCardHighlight,
              ),
              FadeShimmer(
                width: constraints.maxWidth * 0.65,
                height: index % 3 == 2 ? 56 : 24,
                highlightColor: ColorManager.shimmerCardHighlight,
                baseColor: ColorManager.shimmerCardHighlight,
              ),
            ],
          ),
        ),
      );
    });
  }
}
