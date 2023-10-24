import 'package:flutter/material.dart';

import '../constants/color.dart';

class ButtonStyle1 extends StatelessWidget {
  const ButtonStyle1(
      {Key? key,
      required this.onPressAction,
      required this.title,
      this.isLoading = false,
      this.isDisable = false})
      : super(key: key);

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
        minimumSize: const Size.fromHeight(60),
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
      {Key? key,
      required this.onPressAction,
      required this.title,
      required this.isLoading})
      : super(key: key);

  final Function()? onPressAction;
  final bool isLoading;
  final String title;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressAction,
      style: ButtonStyle(
          elevation: MaterialStateProperty.all(0),
          backgroundColor: onPressAction == null
              ? MaterialStateProperty.all<Color>(
                  ColorManager.secondaryButtonDisabled(
                      Theme.of(context).brightness),
                )
              : MaterialStateProperty.all<Color>(
                  ColorManager.secondaryButton(Theme.of(context).brightness),
                )),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Text(
          title,
        ),
      ),
    );
  }
}
