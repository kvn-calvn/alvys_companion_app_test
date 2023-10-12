import 'package:flutter/material.dart';

class LargeNavButton extends StatelessWidget {
  const LargeNavButton(
      {Key? key, required this.title, required this.onPressed, this.suffix, this.icon, this.padding = 16})
      : super(key: key);

  final String title;
  final Icon? icon;
  final double padding;
  final Widget? suffix;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Material(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
          elevation: 0,
          clipBehavior: Clip.antiAlias,
          child: Ink(
            child: InkWell(
              onTap: onPressed,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: padding, horizontal: 12),
                child: Row(
                  children: [
                    if (icon != null) icon!,
                    const SizedBox(
                      width: 5,
                    ),
                    ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: constraints.maxWidth * 0.8),
                        child: Text(title, style: Theme.of(context).textTheme.bodyLarge)),
                    const Spacer(),
                    const Icon(
                      Icons.arrow_forward_ios,
                      color: Color(0xFF95A1AC),
                      size: 18,
                    ),
                    suffix ?? const SizedBox.shrink(),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
