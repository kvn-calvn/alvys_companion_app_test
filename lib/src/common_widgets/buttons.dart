import 'package:alvys3/src/constants/color.dart';
import 'package:alvys3/src/constants/text_styles.dart';
import 'package:flutter/material.dart';

class ButtonStyle1 extends StatelessWidget {
  const ButtonStyle1(
      {Key? key,
      required this.onPressAction,
      required this.title,
      required this.isLoading,
      required this.isDisable})
      : super(key: key);

  final Function onPressAction;
  final bool isLoading;
  final bool isDisable;
  final String title;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : () => onPressAction(),
      /*onPressed: () {
                    Navigator.pushNamed(context, '/verifyphone');
                  },*/
      style: ElevatedButton.styleFrom(
        minimumSize: const Size.fromHeight(60),
        backgroundColor: ColorManager.primary(Theme.of(context).brightness),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      child: Text(
        isLoading ? "Loading.." : title,
        style: getRegularStyle(color: ColorManager.white),
      ),
    );
  }
}

class ButtonStyle2 extends StatelessWidget {
  const ButtonStyle2(
      {Key? key,
      required this.onPressAction,
      required this.title,
      required this.isLoading,
      required this.isDisable})
      : super(key: key);

  final Function onPressAction;
  final bool isLoading;
  final bool isDisable;
  final String title;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isDisable ? null : () => onPressAction(),
      style: ElevatedButton.styleFrom(
        backgroundColor: ColorManager.primary(Theme.of(context).brightness),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Text(
          title,
          style: getSemiBoldStyle(color: ColorManager.white, fontSize: 14),
        ),
      ),
    );
  }
}
