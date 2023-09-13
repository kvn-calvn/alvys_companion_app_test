import 'shimmer_widget.dart';
import '../../constants/color.dart';
import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter/material.dart';

class EditProfileShimmer extends StatelessWidget {
  const EditProfileShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Stack(
        children: [
          AlvysSingleChildShimmer(
            child: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  EditProfileShimmerItem(constraints: constraints),
                  EditProfileShimmerItem(constraints: constraints),
                  EditProfileShimmerItem(constraints: constraints),
                  EditProfileShimmerItemLarge(constraints: constraints),
                  EditProfileShimmerItemLarge(constraints: constraints),
                  EditProfileShimmerItemLarge(constraints: constraints),
                  Row(
                    children: [
                      Flexible(
                        child: EditProfileShimmerItemLarge(constraints: constraints),
                      ),
                      const SizedBox(width: 12),
                      Flexible(
                        child: EditProfileShimmerItemLarge(constraints: constraints),
                      )
                    ],
                  ),
                  const SizedBox(height: 6),
                  FadeShimmer(
                    width: constraints.maxWidth * 0.45,
                    height: 25,
                    millisecondsDelay: 2000,
                    highlightColor: ColorManager.shimmerCardHighlight,
                    baseColor: ColorManager.shimmerCardHighlight,
                  ),
                  const SizedBox(height: 6),
                  EditProfileShimmerItemLarge(constraints: constraints),
                  EditProfileShimmerItemLarge(constraints: constraints),
                  EditProfileShimmerItemLarge(constraints: constraints),
                ],
              ),
            ),
          ),
          AlvysSingleChildShimmer(
            child: Center(
              child: Text(
                'Updating Profile...',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w900),
              ),
            ),
          )
        ],
      );
    });
  }
}

class EditProfileShimmerItem extends StatelessWidget {
  const EditProfileShimmerItem({super.key, required this.constraints});
  final BoxConstraints constraints;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FadeShimmer(
          width: constraints.maxWidth * 0.2,
          height: 16,
          highlightColor: ColorManager.shimmerCardHighlight,
          baseColor: ColorManager.shimmerCardHighlight,
        ),
        const SizedBox(height: 6),
        FadeShimmer(
          width: constraints.maxWidth * 0.5,
          height: 16,
          highlightColor: ColorManager.shimmerCardHighlight,
          baseColor: ColorManager.shimmerCardHighlight,
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

class EditProfileShimmerItemLarge extends StatelessWidget {
  const EditProfileShimmerItemLarge({super.key, required this.constraints});
  final BoxConstraints constraints;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FadeShimmer(
          width: constraints.maxWidth * 0.2,
          height: 16,
          highlightColor: ColorManager.shimmerCardHighlight,
          baseColor: ColorManager.shimmerCardHighlight,
        ),
        const SizedBox(height: 6),
        FadeShimmer(
          width: constraints.maxWidth,
          height: 40,
          highlightColor: ColorManager.shimmerCardHighlight,
          baseColor: ColorManager.shimmerCardHighlight,
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
