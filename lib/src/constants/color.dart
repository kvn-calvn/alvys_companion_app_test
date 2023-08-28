import 'package:alvys3/src/utils/extensions.dart';
import 'package:flutter/material.dart';

class ColorManager {
  static Color primary(Brightness brightness) =>
      brightness.isLight ? const Color(0XFF233E90) : const Color(0XFF265CFF);
  static Color greyColorScheme1(Brightness brightness) =>
      brightness.isLight ? const Color(0XFF1F1F1F) : const Color(0XFFEDEEF1);
  static Color greyColorScheme2 = const Color(0XFF7C7C7C);

  static Color lightgrey2 = const Color(0XFF232323);
  static Color success = const Color(0XFF00AF54);
  static Color failure = const Color(0XFFE03616);
  static Color lightBackground = const Color(0XFFF1F4F8);
  static Color pickupColor = const Color(0XFF2991C2);
  static Color deliveryColor = const Color(0XFFF08080);
  static Color cancelColor = const Color(0XFFE03616);
  static Color white = Colors.white;

  static Color cardColor(Brightness brightness) =>
      brightness.isLight ? const Color(0XFFF1F1F1) : const Color(0XFF303030);

  static Color pickupStopCardBg(Brightness brightness) =>
      brightness.isLight ? const Color(0XFFFCE6E6) : const Color(0XFFB05858);
  static Color deliveryStopCardBg(Brightness brightness) =>
      brightness.isLight ? const Color(0XFFD4E9F3) : const Color(0XFF2279A3);
  static Color secondaryButton(Brightness brightness) =>
      brightness.isLight ? const Color(0XFF233E90) : const Color(0XFF265CFF);
  static Color secondaryButtonDisabled(Brightness brightness) =>
      brightness.isLight ? const Color(0XFFBEBEBE) : const Color(0XFF585858);
  static Color scaffoldColor(Brightness brightness) =>
      brightness.isLight ? const Color(0xFFFFFFFF) : const Color(0XFF141414);
  static Color chipColor(Brightness brightness) =>
      brightness.isLight ? const Color(0XFFEBF2FF) : const Color(0XFF233E90);
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
