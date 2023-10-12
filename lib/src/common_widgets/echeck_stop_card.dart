import 'package:coder_matthews_extensions/coder_matthews_extensions.dart';
import 'package:flutter/material.dart';

import '../constants/color.dart';
import '../features/trips/domain/app_trip/stop.dart';

class ECheckStopCard extends StatefulWidget {
  const ECheckStopCard({
    Key? key,
    required this.onTap,
    this.currentStopId,
    required this.selectedColor,
    this.selected = false,
    required this.stop,
  }) : super(key: key);

  final String? currentStopId;

  final Color selectedColor;
  final Stop stop;
  final void Function(String stop) onTap;
  final bool selected;

  @override
  State<ECheckStopCard> createState() => _ECheckStopCardState();
}

class _ECheckStopCardState extends State<ECheckStopCard> with TickerProviderStateMixin {
  Color selectedColor(BuildContext context) {
    return isSelected ? ColorManager.primary(Theme.of(context).brightness) : Theme.of(context).cardColor;
  }

  bool get isSelected {
    if (widget.currentStopId.isNullOrEmpty) return false;
    return widget.currentStopId == widget.stop.stopId;
  }

  late AnimationController animationController;
  late Animation<Color?> colorAnimation;
  @override
  void initState() {
    super.initState();
    animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 350));
    colorAnimation =
        ColorTween(begin: widget.selectedColor.withAlpha(0), end: widget.selectedColor).animate(animationController);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return AnimatedBuilder(
          animation: colorAnimation,
          builder: (context, child) {
            isSelected ? animationController.forward() : animationController.reverse();
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Material(
                elevation: isSelected ? 1 : 0,
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(10),
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: () {
                    widget.onTap(widget.stop.stopId!);
                  },
                  child: Ink(
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: colorAnimation.value!, width: 2.3)),
                      child: Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(10, 8, 0, 8),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 8, 0),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: widget.stop.stopType == 'Pickup'
                                        ? ColorManager.pickupColor
                                        : ColorManager.deliveryColor,
                                    borderRadius: BorderRadius.circular(10)),
                                width: 8,
                                height: 35,
                              ),
                            ),
                            ConstrainedBox(
                              constraints: BoxConstraints(maxWidth: constraints.maxWidth * 0.8),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.stop.companyName!,
                                    style: Theme.of(context).textTheme.bodyLarge,
                                  ),
                                  Text(
                                      "${widget.stop.address?.city ?? ''}, ${widget.stop.address?.state ?? ''} ${widget.stop.address?.zip ?? ''}",
                                      style: Theme.of(context).textTheme.bodyMedium),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          });
    });
  }
}
