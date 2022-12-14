import 'package:alvys3/src/constants/color.dart';
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
      onPressed: isDisable ? null : () => onPressAction(),
      /*onPressed: () {
                    Navigator.pushNamed(context, '/verifyphone');
                  },*/
      style: ElevatedButton.styleFrom(
        textStyle: Theme.of(context).textTheme.titleLarge,
        minimumSize: const Size.fromHeight(60),
        backgroundColor: ColorManager.primary(Theme.of(context).brightness),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      child: Text(
        isLoading ? "Loading.." : title,
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
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Text(
          title,
        ),
      ),
    );
  }
}
