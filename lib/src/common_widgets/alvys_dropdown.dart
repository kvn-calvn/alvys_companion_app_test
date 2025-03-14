import 'package:flutter/material.dart';

import '../utils/extensions.dart';

const Duration duration = Duration(milliseconds: 128);

class AlvysDropdown<T> extends StatefulWidget {
  final List<T> items;
  final T? initialItem;
  final String Function(T item) dropDownTitle;
  final void Function(T item) onItemTap;
  final bool coverDisplayText;
  final BorderSide? border;
  final Color? backgroundColor;
  final double radius, elevation;
  final TextStyle? textStyle;
  final bool includeTrailing;
  const AlvysDropdown(
      {super.key,
      required this.items,
      required this.dropDownTitle,
      required this.onItemTap,
      this.coverDisplayText = false,
      this.radius = 0,
      this.border,
      this.backgroundColor,
      this.includeTrailing = true,
      this.initialItem,
      this.elevation = 3,
      this.textStyle});

  @override
  State<AlvysDropdown<T>> createState() => _AlvysDropdownState<T>();
}

class _AlvysDropdownState<T> extends State<AlvysDropdown<T>> {
  late T currentItem;
  GlobalKey actionKey = LabeledGlobalKey('alvysdropdown');
  bool isOpen = false;
  late int currentlySelected;
  @override
  void initState() {
    super.initState();
    currentItem = widget.initialItem ?? widget.items.first;
    currentlySelected = widget.items.indexOf(currentItem);
  }

  List<Widget> get getItems => widget.items.mapList<Widget>((e, index, last) => DecoratedBox(
        decoration: BoxDecoration(
            color: index == currentlySelected
                ? Theme.of(context).colorScheme.primary.withAlpha((255.0 * 0.2).round())
                : (widget.backgroundColor ?? Theme.of(context).cardColor),
            border: Border(
                bottom:
                    last ? BorderSide.none : BorderSide(color: Theme.of(context).dividerColor))),
        child: ListTile(
          title: Text(widget.dropDownTitle(e), style: widget.textStyle),
          dense: true,
          onTap: () {
            setState(() {
              currentItem = e;
              currentlySelected = widget.items.indexOf(e);
            });
            widget.onItemTap(e);

            Navigator.pop(context);
          },
        ),
      ));

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: widget.elevation,
      key: actionKey,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(widget.radius),
          side: widget.border ?? BorderSide.none),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () async {
          setState(() {
            isOpen = true;
          });
          var data = actionKey.getKeyPosition(context);
          await Navigator.push(
              context, _AlvysDropdownRoute(getItems, data, widget.coverDisplayText, widget.radius));
          setState(() {
            isOpen = false;
          });
        },
        child: ListTile(
          title: Text(widget.dropDownTitle(currentItem), style: widget.textStyle),
          dense: true,
          tileColor: widget.backgroundColor,
          trailing: widget.includeTrailing
              ? AnimatedRotation(
                  duration: duration,
                  turns: isOpen ? 0.5 : 0,
                  child: const Icon(Icons.arrow_drop_down),
                )
              : null,
        ),
      ),
    );
  }
}

class _AlvysDropdownRoute extends PopupRoute {
  final List<Widget> items;
  final KeyData data;
  final bool coverDisplayText;
  final double radius;
  _AlvysDropdownRoute(this.items, this.data, this.coverDisplayText, this.radius);

  @override
  Color? get barrierColor => null;

  @override
  bool get barrierDismissible => true;

  @override
  String? get barrierLabel => '${super.debugLabel}_AlvysDropdownRoute';

  @override
  Widget buildPage(
      BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
    return DropDownContainer(
      items: items,
      animation: animation,
      position: data.rect,
      size: data.size,
      coverDisplayText: coverDisplayText,
      radius: radius,
    );
  }

  @override
  Duration get transitionDuration => duration;
}

class DropDownContainer extends StatelessWidget {
  final Animation animation;
  final List<Widget> items;
  final RelativeRect position;
  final Size size;
  final bool coverDisplayText;
  final double radius;
  const DropDownContainer(
      {super.key,
      required this.items,
      required this.animation,
      required this.position,
      required this.size,
      required this.coverDisplayText,
      required this.radius});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Stack(
        children: [
          Positioned(
            top: position.top <= position.bottom
                ? position.top + (coverDisplayText ? 0 : size.height + 3)
                : null,
            left: position.left,
            right: position.right,
            bottom: position.bottom < position.top
                ? position.bottom + (coverDisplayText ? 0 : size.height + 5)
                : null,
            child: AnimatedBuilder(
                animation: animation,
                builder: (context, widget) {
                  return Material(
                    borderRadius: BorderRadius.circular(radius),
                    clipBehavior: Clip.antiAlias,
                    elevation: 3,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(radius),
                      child: Align(
                        heightFactor: animation.value,
                        child: Container(
                          constraints: BoxConstraints(maxHeight: constraints.maxHeight * 0.3),
                          child: SingleChildScrollView(
                            child: Column(
                              children: items,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
          ),
        ],
      );
    });
  }
}
