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
        hintText: hint,
        filled: true,
        fillColor: ColorManager.darkgrey,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(width: .5, color: ColorManager.lightgrey),
          borderRadius: BorderRadius.circular(15),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
              width: 1, color: ColorManager.primary(Brightness.dark)),
          borderRadius: BorderRadius.circular(10),
        ),
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
