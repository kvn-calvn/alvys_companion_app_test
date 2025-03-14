// import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/color.dart';
import 'shimmer_widget.dart';

class TripListShimmer extends StatelessWidget {
  const TripListShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return AlvysShimmer(repeatingChild: (index) => TripCardShimmer(), repeatAmount: 5);
  }
}

class TripCardShimmer extends ConsumerWidget {
  const TripCardShimmer({super.key, this.millisecondsDelay = 2000});

  final int millisecondsDelay;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Material(
        color: Theme.of(context).cardColor.withAlpha(100),
        borderRadius: BorderRadius.circular(12),
        clipBehavior: Clip.antiAlias,
        elevation: 4,
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(15, 5, 15, 5),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 8, 5, 8),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FadeShimmer(
                      millisecondsDelay: millisecondsDelay,
                      height: 16,
                      width: 100,
                      radius: 5,
                      highlightColor: ColorManager.shimmerCardHighlight,
                      baseColor: ColorManager.shimmerCardHighlight,
                    ),
                    FadeShimmer(
                      millisecondsDelay: millisecondsDelay,
                      height: 16,
                      width: 80,
                      radius: 5,
                      highlightColor: ColorManager.shimmerCardHighlight,
                      baseColor: ColorManager.shimmerCardHighlight,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 8, 0, 8),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.arrow_upward_outlined,
                      color: Color(0XFFF08080),
                      size: 24,
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FadeShimmer(
                            millisecondsDelay: millisecondsDelay,
                            height: 16,
                            width: 100,
                            radius: 5,
                            highlightColor: ColorManager.shimmerCardHighlight,
                            baseColor: ColorManager.shimmerCardHighlight,
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          FadeShimmer(
                            millisecondsDelay: millisecondsDelay,
                            height: 16,
                            width: 100,
                            radius: 5,
                            highlightColor: ColorManager.shimmerCardHighlight,
                            baseColor: ColorManager.shimmerCardHighlight,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 8, 0, 8),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.arrow_downward_outlined,
                      color: Color(0XFF2991C2),
                      size: 24,
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FadeShimmer(
                            millisecondsDelay: millisecondsDelay,
                            height: 16,
                            width: 100,
                            radius: 5,
                            highlightColor: ColorManager.shimmerCardHighlight,
                            baseColor: ColorManager.shimmerCardHighlight,
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          FadeShimmer(
                            millisecondsDelay: millisecondsDelay,
                            height: 16,
                            width: 100,
                            radius: 5,
                            highlightColor: ColorManager.shimmerCardHighlight,
                            baseColor: ColorManager.shimmerCardHighlight,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 8, 5, 8),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TripCardDetail(
                      millisecondsDelay: millisecondsDelay,
                    ),
                    TripCardDetail(
                      millisecondsDelay: millisecondsDelay,
                    ),
                    TripCardDetail(
                      millisecondsDelay: millisecondsDelay,
                    ),
                    TripCardDetail(
                      millisecondsDelay: millisecondsDelay,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TripCardDetail extends StatelessWidget {
  final int millisecondsDelay;
  const TripCardDetail({super.key, required this.millisecondsDelay});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        FadeShimmer(
          millisecondsDelay: millisecondsDelay,
          height: 16,
          width: 20,
          radius: 5,
          highlightColor: ColorManager.shimmerCardHighlight,
          baseColor: ColorManager.shimmerCardHighlight,
        ),
        const SizedBox(height: 5),
        FadeShimmer(
          millisecondsDelay: millisecondsDelay,
          height: 16,
          width: 60,
          radius: 5,
          highlightColor: ColorManager.shimmerCardHighlight,
          baseColor: ColorManager.shimmerCardHighlight,
        ),
      ],
    );
  }
}
