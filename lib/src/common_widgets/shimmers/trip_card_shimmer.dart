import 'package:alvys3/src/constants/color.dart';
import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TripCardShimmer extends ConsumerWidget {
  const TripCardShimmer({Key? key, this.millisecondsDelay = 0})
      : super(key: key);

  final int millisecondsDelay;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Material(
        color: Theme.of(context).cardColor,
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
                      radius: 7,
                      highlightColor: Color(0xffF9F9FB),
                      baseColor: Color(0xffE6E8EB),
                    ),
                    FadeShimmer(
                      millisecondsDelay: millisecondsDelay,
                      height: 16,
                      width: 80,
                      radius: 7,
                      highlightColor: Color(0xffF9F9FB),
                      baseColor: Color(0xffE6E8EB),
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
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.7,
                            child: FadeShimmer(
                              millisecondsDelay: millisecondsDelay,
                              height: 16,
                              width: 100,
                              radius: 7,
                              highlightColor: Color(0xffF9F9FB),
                              baseColor: Color(0xffE6E8EB),
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          FadeShimmer(
                            millisecondsDelay: millisecondsDelay,
                            height: 16,
                            width: 100,
                            radius: 7,
                            highlightColor: Color(0xffF9F9FB),
                            baseColor: Color(0xffE6E8EB),
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
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.7,
                            child: FadeShimmer(
                              millisecondsDelay: millisecondsDelay,
                              height: 16,
                              width: 100,
                              radius: 7,
                              highlightColor: Color(0xffF9F9FB),
                              baseColor: Color(0xffE6E8EB),
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          FadeShimmer(
                            millisecondsDelay: millisecondsDelay,
                            height: 16,
                            width: 100,
                            radius: 7,
                            highlightColor: Color(0xffF9F9FB),
                            baseColor: Color(0xffE6E8EB),
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
                      title: 'dh',
                      details: '0.00 mi',
                    ),
                    TripCardDetail(
                      millisecondsDelay: millisecondsDelay,
                      title: 'trip',
                      details: 'Trip number',
                    ),
                    TripCardDetail(
                      millisecondsDelay: millisecondsDelay,
                      title: 'stops',
                      details: 'StopCount',
                    ),
                    TripCardDetail(
                      millisecondsDelay: millisecondsDelay,
                      title: 'weight',
                      details: 'Weightlbs',
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
  final String details, title;
  final int millisecondsDelay;
  const TripCardDetail(
      {Key? key,
      required this.title,
      required this.details,
      required this.millisecondsDelay})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title.toUpperCase(),
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: ColorManager.lightTextColor(Theme.of(context).brightness),
              fontWeight: FontWeight.bold),
        ),
        FadeShimmer(
          millisecondsDelay: millisecondsDelay,
          height: 16,
          width: 60,
          radius: 7,
          highlightColor: Color(0xffF9F9FB),
          baseColor: Color(0xffE6E8EB),
        ),
      ],
    );
  }
}
