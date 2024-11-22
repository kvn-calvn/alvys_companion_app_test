import 'package:flutter/material.dart';

import '../utils/tablet_utils.dart';

Future<T?> showCustomBottomSheet<T>(BuildContext context, Widget child,
        {bool constrain = true, bool isScrollControlled = true}) =>
    showModalBottomSheet<T>(
      useRootNavigator: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      context: context,
      useSafeArea: true,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      isScrollControlled: true,
      constraints:
          BoxConstraints(maxHeight: double.infinity, maxWidth: TabletUtils.instance.isTablet ? 600 : double.infinity),
      builder: (context) => CustomBottomSheet(
        constrain: constrain,
        child: child,
      ),
    );

class CustomBottomSheet extends StatefulWidget {
  final Widget child;
  final bool constrain;

  const CustomBottomSheet({super.key, required this.child, required this.constrain});

  @override
  State<CustomBottomSheet> createState() => _CustomBottomSheetState();
}

class _CustomBottomSheetState extends State<CustomBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Container(
        constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * (widget.constrain ? 0.5 : 1)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 6,
                width: 40,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              Flexible(
                child: widget.child,
              )
            ],
          ),
        ),
      );
    });
  }
}
