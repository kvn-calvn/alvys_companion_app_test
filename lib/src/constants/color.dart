import 'package:alvys3/src/utils/extensions.dart';
import 'package:flutter/material.dart';

class ColorManager {
  static Color primary(Brightness brightness) =>
      brightness.isLight ? const Color(0XFF233E90) : const Color(0XFF265CFF);
  static Color darkgrey = const Color(0XFF1F1F1F);
  static Color lightTextColor(Brightness brightness) =>
      brightness.isLight ? const Color(0XFF7C7C7C) : const Color(0XFF7C7C7C);

  static Color lightgrey = const Color(0XFF7C7C7C);
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
  static Color shimmerHighlight(Brightness brightness) => brightness.isLight
      ? const Color.fromARGB(255, 233, 235, 238)
      : const Color(0xFF4C4C4C);
  static Color shimmerBaseColor(Brightness brightness) => brightness.isLight
      ? const Color.fromARGB(255, 214, 217, 221)
      : const Color(0xFF2A2A2A);
  static List<Color> shimmerColors(Brightness brightness) => [
        shimmerBaseColor(brightness),
        shimmerBaseColor(brightness),
        shimmerHighlight(brightness),
        shimmerBaseColor(brightness),
        shimmerBaseColor(brightness),
        shimmerHighlight(brightness),
        shimmerBaseColor(brightness)
      ];
}
