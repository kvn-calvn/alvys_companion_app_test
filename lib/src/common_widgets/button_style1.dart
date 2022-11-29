import 'package:alvys3/src/constants/color.dart';
import 'package:alvys3/src/constants/text_styles.dart';
import 'package:flutter/material.dart';

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
        minimumSize: const Size.fromHeight(60),
        backgroundColor: ColorManager.primary,
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
