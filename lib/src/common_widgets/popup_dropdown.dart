import 'package:flutter/material.dart';

showCustomPopup<T>(
    {required BuildContext context,
    required Function(T) onSelected,
    required List<AlvysPopupItem<T>> Function(BuildContext context) items,
    bool useRootNavigator = true}) async {
  final RenderBox button = context.findRenderObject() as RenderBox;
  final RenderBox overlay =
      Overlay.of(context)!.context.findRenderObject() as RenderBox;
  var position = RelativeRect.fromRect(
    Rect.fromPoints(
      button.localToGlobal(const Offset(0, 0), ancestor: overlay),
      button.localToGlobal(button.size.bottomRight(Offset.zero),
          ancestor: overlay),
    ),
    Offset.zero & overlay.size,
  );
  var newPos = position.shift(Offset(
      0, button.size.height * (position.top <= position.bottom ? 0.5 : -0.5)));
  T? res = await Navigator.of(context, rootNavigator: useRootNavigator)
      .push<T?>(_AlvysPopupRoute<T>(items(context), newPos, position));
  if (res != null) {
    onSelected(res);
  }
}

class AlvysPopupItem<T> extends StatelessWidget {
  final T value;
  final Widget child;
  const AlvysPopupItem({Key? key, required this.value, required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: () {
          Navigator.of(context).pop(value);
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: child,
        ),
      ),
    );
  }
}

// class AlvysPopup extends StatefulWidget {
//   const AlvysPopup({Key? key}) : super(key: key);

//   @override
//   State<AlvysPopup> createState() => _AlvysPopupState();
// }

// class _AlvysPopupState extends State<AlvysPopup> {
//   @override
//   Widget build(BuildContext context) {
//     return Container();
//   }
// }

class _AlvysPopupRoute<T> extends PopupRoute<T> {
  final List<AlvysPopupItem<T>> children;
  final RelativeRect newPos;
  final RelativeRect position;
  _AlvysPopupRoute(this.children, this.newPos, this.position);
  @override
  Color? get barrierColor => Colors.transparent;

  @override
  bool get barrierDismissible => true;

  @override
  String? get barrierLabel => "Alvys_Popup_Route";

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      removeBottom: true,
      removeLeft: true,
      removeRight: true,
      child: Stack(
        children: [
          Positioned(
            top: position.top <= position.bottom ? newPos.top : null,
            right: MediaQuery.of(context).size.width * 0.05,
            bottom: position.bottom < position.top ? newPos.bottom : null,
            child: AnimatedBuilder(
                animation: animation,
                builder: (context, child) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Align(
                      alignment: Alignment.topCenter,
                      heightFactor: animation.value,
                      child: Material(
                        elevation: 2,
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 100),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: children,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
          )
        ],
      ),
    );
  }

  @override
  Duration get transitionDuration => const Duration(milliseconds: 150);
}
