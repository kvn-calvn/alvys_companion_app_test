import 'package:alvys3/src/constants/color.dart';
import 'package:flutter/material.dart';

class SnackBarWrapper {
  static void snackBar(
      {required String msg,
      required BuildContext context,
      final Function()? action,
      String? actionLabel,
      required bool isSuccess}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        action: SnackBarAction(
          label: actionLabel ?? "",
          textColor: ColorManager.white,
          onPressed: action ?? () {},
        ),
        content: Text(
          msg,
          style: TextStyle(color: ColorManager.white),
        ),
        duration: const Duration(milliseconds: 2000),
        //width: 280.0, // Width of the SnackBar.
        padding: const EdgeInsets.symmetric(
          horizontal: 10.0, // Inner padding for SnackBar content.
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor:
            isSuccess ? ColorManager.success : ColorManager.failure,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    );
  }
}
