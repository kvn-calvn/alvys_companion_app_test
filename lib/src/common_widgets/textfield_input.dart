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
