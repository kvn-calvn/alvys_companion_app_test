import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

TextStyle getRegularStyle({required Color color, double fontSize = 16}) {
  return GoogleFonts.getFont('Poppins',
      color: color, fontSize: fontSize, fontWeight: FontWeight.normal);
}

TextStyle getBoldStyle({required Color color, double fontSize = 16}) {
  return GoogleFonts.getFont('Poppins',
      color: color, fontSize: fontSize, fontWeight: FontWeight.bold);
}

TextStyle getMediumStyle({required Color color, double fontSize = 16}) {
  return GoogleFonts.getFont('Poppins',
      color: color, fontSize: fontSize, fontWeight: FontWeight.w500);
}

TextStyle getSemiBoldStyle({required Color color, double fontSize = 16}) {
  return GoogleFonts.getFont('Poppins',
      color: color, fontSize: fontSize, fontWeight: FontWeight.w600);
}

TextStyle getExtraBoldStyle({required Color color, double fontSize = 16}) {
  return GoogleFonts.getFont('Poppins',
      color: color, fontSize: fontSize, fontWeight: FontWeight.w800);
}

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
