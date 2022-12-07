import 'package:flutter/material.dart';

Future<T?> showCustomBottomSheet<T>(BuildContext context, Widget child) =>
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) => CustomBottomSheet(child: child));

class CustomBottomSheet extends StatefulWidget {
  final Widget child;
  const CustomBottomSheet({Key? key, required this.child}) : super(key: key);

  @override
  State<CustomBottomSheet> createState() => _CustomBottomSheetState();
}

class _CustomBottomSheetState extends State<CustomBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Container(
        constraints: BoxConstraints(maxHeight: constraints.maxHeight * 0.5),
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 8,
                width: 40,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              Flexible(
                  child: SingleChildScrollView(
                child: widget.child,
              ))
            ],
          ),
        ),
      );
    });
  }
}
