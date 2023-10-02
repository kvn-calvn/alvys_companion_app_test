import 'package:flutter/material.dart';

import 'shimmer_widget.dart';

class GenerateEcheckShimmer extends StatelessWidget {
  const GenerateEcheckShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return const AlvysSingleChildShimmer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Material(
            child: SizedBox(
              height: 50,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Material(
            child: SizedBox(
              height: 50,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Material(
            child: SizedBox(
              height: 70,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Material(
            child: SizedBox(
              height: 50,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Material(
            child: SizedBox(
              height: 50,
            ),
          ),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
