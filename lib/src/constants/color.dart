import 'package:alvys3/src/utils/extensions.dart';
import 'package:flutter/material.dart';

class ColorManager {
  static Color primary(Brightness brightness) =>
      brightness.isLight ? const Color(0XFF233E90) : const Color(0XFF265CFF);
  static Color darkgrey = const Color(0XFF1F1F1F);
  static Color lightTextColor(Brightness brightness) =>
      brightness.isLight ? const Color(0XFF1F1F1F) : const Color(0XFFEDEEF1);
  static Color lightgrey = const Color(0XFF777777);
  static Color lightgrey2 = const Color(0XFF232323);
  static Color lightBackground = const Color(0XFFF1F4F8);
  static Color pickupColor = const Color(0XFF2991C2);
  static Color deliveryColor = const Color(0XFFF08080);
  static Color cancelColor = const Color(0XFFFF0000);
  static Color white = Colors.white;
  static Color cardColor(Brightness brightness) =>
      brightness.isLight ? Colors.white : const Color(0XFF232323);
  static Color scaffoldColor(Brightness brightness) =>
      brightness.isLight ? const Color(0xFFF1F4F8) : const Color(0XFF141414);
}
