import 'package:alvys3/src/constants/color.dart';
import 'package:flutter/material.dart';

class TextfieldInput extends StatelessWidget {
  const TextfieldInput(
      {Key? key,
      required this.hint,
      required this.textfieldController,
      this.isDisabled = false,
      this.isFocus = false,
      required this.keyboardType})
      : super(key: key);

  final TextEditingController textfieldController;
  final String hint;
  final TextInputType keyboardType;
  final bool isDisabled;
  final bool isFocus;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: textfieldController,
      keyboardType: keyboardType,
      autofocus: isFocus,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        filled: true,
        focusColor: ColorManager.primary,
        enabledBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(
            Radius.circular(10.0),
          ),
          borderSide: BorderSide(
            color: ColorManager.lightgrey,
            width: .5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(
            Radius.circular(10.0),
          ),
          borderSide: BorderSide(
            color: ColorManager.primary,
          ),
        ),
        hintText: hint,
        fillColor: ColorManager.white,
      ),
      onChanged: (str) {
        // To Do
      },
      onSubmitted: (str) {
        // To Do
      },
    );
  }
}
