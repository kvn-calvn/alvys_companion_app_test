import 'package:flutter/material.dart';

class LargeNavButton extends StatelessWidget {
  const LargeNavButton({
    Key? key,
    required this.title,
    required this.onPressed,
    this.suffix,
    this.icon,
  }) : super(key: key);

  final String title;
  final Icon? icon;
  final Widget? suffix;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Material(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        elevation: 2,
        clipBehavior: Clip.antiAlias,
        child: Ink(
          child: InkWell(
            onTap: onPressed,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  if (icon != null) icon!,
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                    child: Text(
                      title,
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const Expanded(
                    child: Align(
                      alignment: AlignmentDirectional(0.9, 0),
                      child: Icon(
                        Icons.arrow_forward_ios,
                        color: Color(0xFF95A1AC),
                        size: 18,
                      ),
                    ),
                  ),
                  suffix ?? const SizedBox.shrink(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
