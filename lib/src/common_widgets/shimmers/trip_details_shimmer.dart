import '../../constants/color.dart';
import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter/material.dart';

import 'shimmer_widget.dart';

class TripDetailsShimmer extends StatelessWidget {
  const TripDetailsShimmer({super.key});
  int get delay => 2000;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: AlvysShimmer(
        repeatAmount: 1,
        repeatingChild: (index) => Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 200,
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                child: FadeShimmer(
                  millisecondsDelay: delay,
                  height: 200,
                  width: 1000,
                  radius: 5,
                  highlightColor: const Color(0xffF9F9FB),
                  baseColor: const Color(0xffE6E8EB),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                color: Theme.of(context).cardColor.withAlpha(100),
              ),
              padding: const EdgeInsetsDirectional.all(15),
              child: FadeShimmer(
                millisecondsDelay: delay,
                height: 20,
                width: double.infinity,
                radius: 6,
                highlightColor: const Color(0xffF9F9FB),
                baseColor: const Color(0xffE6E8EB),
              ),
            ),
            const SizedBox(height: 15),
            Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                color: Theme.of(context).cardColor.withAlpha(100),
              ),
              padding: const EdgeInsetsDirectional.all(15),
              child: Wrap(
                runSpacing: 14,
                children: [
                  DetailsShimmer(delay: delay),
                  DetailsShimmer(delay: delay),
                  DetailsShimmer(delay: delay),
                ],
              ),
            ),
            const SizedBox(height: 15),
            Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                color: Theme.of(context).cardColor.withAlpha(100),
              ),
              padding: const EdgeInsetsDirectional.all(15),
              child: Wrap(
                runSpacing: 14,
                children: [
                  DetailsShimmer(delay: delay),
                  DetailsShimmer(delay: delay),
                  DetailsShimmer(delay: delay),
                  DetailsShimmer(delay: delay),
                  DetailsShimmer(delay: delay),
                  DetailsShimmer(delay: delay),
                  DetailsShimmer(delay: delay),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ReferencesCardShimmer(delay: delay),
            const SizedBox(height: 20),
            StopCardShimmer(delay: delay),
            const SizedBox(height: 10),
            StopCardShimmer(delay: delay)
          ],
        ),
      ),
    );
  }
}

class DetailsShimmer extends StatelessWidget {
  const DetailsShimmer({
    super.key,
    required this.delay,
  });
  final int delay;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: FadeShimmer(
            millisecondsDelay: delay,
            height: 20,
            width: 70,
            radius: 6,
            highlightColor: const Color(0xffF9F9FB),
            baseColor: const Color(0xffE6E8EB),
          ),
        ),
        SizedBox(width: 80),
        Expanded(
          child: FadeShimmer(
            millisecondsDelay: delay,
            height: 20,
            width: 70,
            radius: 6,
            highlightColor: const Color(0xffF9F9FB),
            baseColor: const Color(0xffE6E8EB),
          ),
        ),
      ],
    );
  }
}

class ReferencesCardShimmer extends StatelessWidget {
  final int delay;
  const ReferencesCardShimmer({super.key, required this.delay});

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(10.0)),
        color: Theme.of(context).cardColor.withAlpha(100),
      ),
      padding: const EdgeInsetsDirectional.all(15),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FadeShimmer(
                millisecondsDelay: delay,
                width: 56,
                height: 22,
                radius: 5,
                highlightColor: ColorManager.shimmerCardHighlight,
                baseColor: ColorManager.shimmerCardHighlight,
              ),
              Icon(
                Icons.adaptive.arrow_forward,
                size: 20,
              )
            ],
          ),
          const SizedBox(height: 8),
          FadeShimmer(
            millisecondsDelay: delay,
            width: double.infinity,
            height: 18,
            radius: 5,
            highlightColor: ColorManager.shimmerCardHighlight,
            baseColor: ColorManager.shimmerCardHighlight,
          ),
        ],
      ),
    );
  }
}

class StopCardShimmer extends StatelessWidget {
  const StopCardShimmer({super.key, required this.delay});
  final int delay;
  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor.withAlpha(100),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsetsDirectional.fromSTEB(15, 5, 15, 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0, 8, 0, 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 6, 8, 0),
                  child: FadeShimmer(
                    millisecondsDelay: delay,
                    width: 8,
                    height: 77,
                    radius: 5,
                    highlightColor: const Color(0xffF9F9FB),
                    baseColor: const Color(0xffE6E8EB),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FadeShimmer(
                      millisecondsDelay: delay,
                      height: 30,
                      width: 250,
                      radius: 10,
                      highlightColor: const Color(0xffF9F9FB),
                      baseColor: const Color(0xffE6E8EB),
                    ),
                    const SizedBox(height: 5),
                    FadeShimmer(
                      millisecondsDelay: delay,
                      height: 20,
                      width: 50,
                      radius: 10,
                      highlightColor: const Color(0xffF9F9FB),
                      baseColor: const Color(0xffE6E8EB),
                    ),
                    const SizedBox(height: 5),
                    FadeShimmer(
                      millisecondsDelay: delay,
                      height: 20,
                      width: 100,
                      radius: 10,
                      highlightColor: const Color(0xffF9F9FB),
                      baseColor: const Color(0xffE6E8EB),
                    ),
                    const SizedBox(height: 5),
                    FadeShimmer(
                      millisecondsDelay: delay,
                      height: 20,
                      width: 50,
                      radius: 10,
                      highlightColor: const Color(0xffF9F9FB),
                      baseColor: const Color(0xffE6E8EB),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Row(
            children: [
              FadeShimmer(
                millisecondsDelay: delay,
                height: 36,
                width: 100,
                radius: 10,
                highlightColor: const Color(0xffF9F9FB),
                baseColor: const Color(0xffE6E8EB),
              ),
              const SizedBox(width: 5),
              FadeShimmer(
                millisecondsDelay: delay,
                height: 36,
                width: 100,
                radius: 10,
                highlightColor: const Color(0xffF9F9FB),
                baseColor: const Color(0xffE6E8EB),
              ),
              const SizedBox(width: 5),
              FadeShimmer(
                millisecondsDelay: delay,
                height: 36,
                width: 80,
                radius: 10,
                highlightColor: const Color(0xffF9F9FB),
                baseColor: const Color(0xffE6E8EB),
              ),
              const SizedBox(width: 5),
            ],
          ),
          const SizedBox(height: 4),
        ],
      ),
    );
  }
}
