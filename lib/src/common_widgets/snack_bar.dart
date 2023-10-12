import 'package:flutter/material.dart';

import '../constants/color.dart';

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
        backgroundColor: isSuccess ? ColorManager.success : ColorManager.failure,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    );
  }

  static SnackBar getSnackBar(String message) => SnackBar(
        padding: const EdgeInsets.only(top: 10),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12),
              child: Text(message),
            ),
            const SizedBox(
              height: 10,
            ),
            const Divider(
              height: 0,
              thickness: 1.5,
            )
          ],
        ),
        duration: const Duration(milliseconds: 2000),
      );
}
