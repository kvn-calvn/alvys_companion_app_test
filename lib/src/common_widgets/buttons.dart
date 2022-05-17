import 'package:alvys3/src/constants/color.dart';
import 'package:alvys3/src/constants/text_styles.dart';
import 'package:flutter/material.dart';

class ButtonStyle1 extends StatelessWidget {
  const ButtonStyle1(
      {Key? key,
      required this.onPressAction,
      required this.title,
      required this.isLoading})
      : super(key: key);

  final Function onPressAction;
  final bool isLoading;
  final bool isDisable = false;
  final String title;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: Text(
        isLoading ? "Loading.." : title,
        style: getRegularStyle(color: ColorManager.white),
      ),
      onPressed: isLoading ? null : () => onPressAction(),
      /*onPressed: () {
                    Navigator.pushNamed(context, '/verifyphone');
                  },*/
      style: ElevatedButton.styleFrom(
        minimumSize: const Size.fromHeight(60),
        primary: ColorManager.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }
}