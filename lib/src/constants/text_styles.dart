import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

AlertStyle getLightErrorAlertStyle() {
  return AlertStyle(
      animationType: AnimationType.fromTop,
      isCloseButton: false,
      isOverlayTapDismiss: false,
      descStyle: const TextStyle(fontWeight: FontWeight.bold),
      animationDuration: const Duration(milliseconds: 400),
      alertBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
        side: const BorderSide(
          color: Colors.grey,
        ),
      ),
      titleStyle: const TextStyle(
        color: Colors.red,
      ),
      constraints: const BoxConstraints.expand(width: 300),
      //First to chars "55" represents transparency of color
      //     overlayColor: const Color(0x77000000),
      alertElevation: 0,
      alertAlignment: Alignment.center);
}
