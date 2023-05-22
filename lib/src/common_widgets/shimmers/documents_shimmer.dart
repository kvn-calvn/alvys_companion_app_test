import 'package:alvys3/src/common_widgets/shimmers/shimmer_widget.dart';
import 'package:fade_shimmer/fade_shimmer.dart';
import 'package:flutter/material.dart';

class DocumentsShimmer extends StatelessWidget {
  const DocumentsShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlvysShimmer(
      repeatAmount: 30,
      repeatingChild: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.065,
          width: double.infinity,
          clipBehavior: Clip.antiAlias,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor.withAlpha(100),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Row(
            children: [
              CircleAvatar(),
              SizedBox(
                width: 10,
              ),
              FadeShimmer(
                millisecondsDelay: 2000,
                height: 16,
                width: 75,
                radius: 5,
                highlightColor: Color(0xffF9F9FB),
                baseColor: Color(0xffE6E8EB),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
