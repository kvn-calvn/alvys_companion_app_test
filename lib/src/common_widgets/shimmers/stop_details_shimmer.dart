import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter/material.dart';

import '../../constants/color.dart';
import 'shimmer_widget.dart';

class StopDetailsShimmer extends StatelessWidget {
  const StopDetailsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return AlvysShimmer(
        repeatAmount: 1,
        repeatingChild: (index) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FadeShimmer(
              width: constraints.maxWidth * 0.2,
              height: 20,
              highlightColor: ColorManager.shimmerCardHighlight,
              baseColor: ColorManager.shimmerCardHighlight,
            ),
            const SizedBox(height: 6),
            FadeShimmer(
              width: constraints.maxWidth * 0.4,
              height: 12,
              highlightColor: ColorManager.shimmerCardHighlight,
              baseColor: ColorManager.shimmerCardHighlight,
            ),
            const SizedBox(height: 6),
            FadeShimmer(
              width: constraints.maxWidth * 0.4,
              height: 12,
              highlightColor: ColorManager.shimmerCardHighlight,
              baseColor: ColorManager.shimmerCardHighlight,
            ),
            const SizedBox(height: 6),
            FadeShimmer(
              width: constraints.maxWidth * 0.4,
              height: 12,
              highlightColor: ColorManager.shimmerCardHighlight,
              baseColor: ColorManager.shimmerCardHighlight,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FadeShimmer(
                      width: constraints.maxWidth * 0.2,
                      height: 20,
                      highlightColor: ColorManager.shimmerCardHighlight,
                      baseColor: ColorManager.shimmerCardHighlight,
                    ),
                    const SizedBox(height: 6),
                    FadeShimmer(
                      width: constraints.maxWidth * 0.3,
                      height: 12,
                      highlightColor: ColorManager.shimmerCardHighlight,
                      baseColor: ColorManager.shimmerCardHighlight,
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    FadeShimmer(
                      width: constraints.maxWidth * 0.12,
                      height: 20,
                      highlightColor: ColorManager.shimmerCardHighlight,
                      baseColor: ColorManager.shimmerCardHighlight,
                    ),
                    const SizedBox(height: 6),
                    FadeShimmer(
                      width: constraints.maxWidth * 0.3,
                      height: 12,
                      highlightColor: ColorManager.shimmerCardHighlight,
                      baseColor: ColorManager.shimmerCardHighlight,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FadeShimmer(
                      width: constraints.maxWidth * 0.2,
                      height: 20,
                      highlightColor: ColorManager.shimmerCardHighlight,
                      baseColor: ColorManager.shimmerCardHighlight,
                    ),
                    const SizedBox(height: 6),
                    FadeShimmer(
                      width: constraints.maxWidth * 0.3,
                      height: 12,
                      highlightColor: ColorManager.shimmerCardHighlight,
                      baseColor: ColorManager.shimmerCardHighlight,
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    FadeShimmer(
                      width: constraints.maxWidth * 0.2,
                      height: 20,
                      highlightColor: ColorManager.shimmerCardHighlight,
                      baseColor: ColorManager.shimmerCardHighlight,
                    ),
                    const SizedBox(height: 6),
                    FadeShimmer(
                      width: constraints.maxWidth * 0.3,
                      height: 12,
                      highlightColor: ColorManager.shimmerCardHighlight,
                      baseColor: ColorManager.shimmerCardHighlight,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            FadeShimmer(
              width: constraints.maxWidth * 0.3,
              height: 20,
              highlightColor: ColorManager.shimmerCardHighlight,
              baseColor: ColorManager.shimmerCardHighlight,
            ),
            const SizedBox(height: 6),
            ComodityShimmer(constraints: constraints),
            const SizedBox(height: 6),
            ComodityShimmer(constraints: constraints),
            const Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.more_horiz, size: 50)]),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FadeShimmer(
                  width: constraints.maxWidth * 0.3,
                  height: 20,
                  highlightColor: ColorManager.shimmerCardHighlight,
                  baseColor: ColorManager.shimmerCardHighlight,
                ),
                const SizedBox(height: 6),
                FadeShimmer(
                  width: constraints.maxWidth * 0.4,
                  height: 12,
                  highlightColor: ColorManager.shimmerCardHighlight,
                  baseColor: ColorManager.shimmerCardHighlight,
                ),
              ],
            ),
            const SizedBox(height: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FadeShimmer(
                  width: constraints.maxWidth * 0.3,
                  height: 20,
                  highlightColor: ColorManager.shimmerCardHighlight,
                  baseColor: ColorManager.shimmerCardHighlight,
                ),
                const SizedBox(height: 6),
                FadeShimmer(
                  width: constraints.maxWidth * 0.4,
                  height: 12,
                  highlightColor: ColorManager.shimmerCardHighlight,
                  baseColor: ColorManager.shimmerCardHighlight,
                ),
              ],
            ),
            const SizedBox(height: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FadeShimmer(
                  width: constraints.maxWidth * 0.3,
                  height: 20,
                  highlightColor: ColorManager.shimmerCardHighlight,
                  baseColor: ColorManager.shimmerCardHighlight,
                ),
                const SizedBox(height: 6),
                FadeShimmer(
                  width: constraints.maxWidth * 0.4,
                  height: 12,
                  highlightColor: ColorManager.shimmerCardHighlight,
                  baseColor: ColorManager.shimmerCardHighlight,
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}

class ComodityShimmer extends StatelessWidget {
  const ComodityShimmer({super.key, required this.constraints});
  final BoxConstraints constraints;
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).cardColor.withAlpha(100),
      clipBehavior: Clip.antiAlias,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FadeShimmer(
              width: constraints.maxWidth * 0.2,
              height: 18,
              highlightColor: ColorManager.shimmerCardHighlight,
              baseColor: ColorManager.shimmerCardHighlight,
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    FadeShimmer(
                      width: constraints.maxWidth * 0.2,
                      height: 18,
                      highlightColor: ColorManager.shimmerCardHighlight,
                      baseColor: ColorManager.shimmerCardHighlight,
                    ),
                    const SizedBox(height: 6),
                    FadeShimmer(
                      width: constraints.maxWidth * 0.2,
                      height: 12,
                      highlightColor: ColorManager.shimmerCardHighlight,
                      baseColor: ColorManager.shimmerCardHighlight,
                    ),
                  ],
                ),
                Column(
                  children: [
                    FadeShimmer(
                      width: constraints.maxWidth * 0.2,
                      height: 18,
                      highlightColor: ColorManager.shimmerCardHighlight,
                      baseColor: ColorManager.shimmerCardHighlight,
                    ),
                    const SizedBox(height: 6),
                    FadeShimmer(
                      width: constraints.maxWidth * 0.2,
                      height: 12,
                      highlightColor: ColorManager.shimmerCardHighlight,
                      baseColor: ColorManager.shimmerCardHighlight,
                    ),
                  ],
                ),
                Column(
                  children: [
                    FadeShimmer(
                      width: constraints.maxWidth * 0.2,
                      height: 18,
                      highlightColor: ColorManager.shimmerCardHighlight,
                      baseColor: ColorManager.shimmerCardHighlight,
                    ),
                    const SizedBox(height: 6),
                    FadeShimmer(
                      width: constraints.maxWidth * 0.2,
                      height: 12,
                      highlightColor: ColorManager.shimmerCardHighlight,
                      baseColor: ColorManager.shimmerCardHighlight,
                    ),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
