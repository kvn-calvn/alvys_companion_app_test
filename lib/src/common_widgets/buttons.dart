import 'package:flutter/material.dart';

import '../constants/color.dart';

class ButtonStyle1 extends StatelessWidget {
  const ButtonStyle1(
      {super.key,
      required this.onPressAction,
      required this.title,
      this.isLoading = false,
      this.isDisable = false});

  final Function onPressAction;
  final bool isLoading;
  final bool isDisable;
  final String title;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading || isDisable ? null : () => onPressAction(),
      style: ElevatedButton.styleFrom(
        elevation: 0,
        minimumSize: const Size.fromHeight(54),
        //fixedSize: const Size.fromHeight(80),
        backgroundColor: ColorManager.primary(Theme.of(context).brightness),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      child: Text(
        isLoading ? "Loading.." : title,
        style: Theme.of(context)
            .textTheme
            .labelLarge!
            .copyWith(color: Colors.white),
      ),
    );
  }
}

class ButtonStyle2 extends StatelessWidget {
  const ButtonStyle2(
      {super.key,
      required this.onPressAction,
      required this.title,
      required this.isLoading});

  final Function()? onPressAction;
  final bool isLoading;
  final String title;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressAction,
      style: ButtonStyle(
        elevation: WidgetStateProperty.all(0),
        backgroundColor: onPressAction == null
            ? WidgetStateProperty.all<Color>(
                ColorManager.secondaryButtonDisabled(
                    Theme.of(context).brightness),
              )
            : WidgetStateProperty.all<Color>(
                ColorManager.secondaryButton(Theme.of(context).brightness),
              ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Text(
          title,
          style: TextStyle(
              color: onPressAction == null
                  ? ColorManager.greyColorScheme2
                  : ColorManager.white),
        ),
      ),
    );
  }
}
