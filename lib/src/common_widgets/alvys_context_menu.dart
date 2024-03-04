import 'package:flutter/material.dart';

class AlvysContextMenuItem<T> extends PopupMenuEntry<T> {
  final T? value;
  final void Function() onTap;
  final Widget child;
  const AlvysContextMenuItem({this.value, required this.onTap, required this.child, super.key});

  @override
  State<AlvysContextMenuItem> createState() => _AlvysContextMenuItemState();

  @override
  double get height => 20;

  @override
  bool represents(T? value) => value == this.value;
}

class _AlvysContextMenuItemState<T> extends State<AlvysContextMenuItem<T>> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        widget.onTap();
        Navigator.pop<T>(context, widget.value);
      },
      child: widget.child,
    );
  }
}
