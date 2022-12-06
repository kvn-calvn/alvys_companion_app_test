import 'package:alvys3/src/constants/color.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'extensions.dart';
import 'package:flutter/material.dart';

class AlvysTheme {
  static ThemeData mainTheme(Brightness brightness) {
    return ThemeData(
      textTheme: appTextTheme(
          MediaQueryData.fromWindow(WidgetsBinding.instance.window).size.width,
          brightness),
      brightness: brightness,
      primaryColor: brightness.isLight ? Colors.white : Colors.black,
      scaffoldBackgroundColor: brightness.isLight
          ? const Color(0xFFF1F4F8)
          : const Color(0XFF141414),
      appBarTheme: AppBarTheme(
          centerTitle: true,
          iconTheme: IconThemeData(
            color: brightness.isLight
                ? Colors.black
                : Colors.white, //change your color here
          ),
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarBrightness: brightness,
          ),
          backgroundColor: Colors.transparent,
          titleTextStyle: appTextTheme(
                  MediaQueryData.fromWindow(WidgetsBinding.instance.window)
                      .size
                      .width,
                  brightness)
              .headlineSmall!
              .copyWith(fontWeight: FontWeight.bold)
          // titleTextStyle: TextStyle(
          //   fontSize: 20,
          //   fontWeight: FontWeight.bold,
          //   color: brightness.isLight ? Colors.black : Colors.white,
          // ),
          ),
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
        backgroundColor: ColorManager.primary(brightness),
        foregroundColor: Colors.white,
      )),
      cardColor: brightness.isLight ? Colors.white : const Color(0XFF232323),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: brightness.isLight
            ? Colors.white
            : const Color.fromARGB(255, 0, 0, 0),
        selectedItemColor: ColorManager.primary(brightness),
        unselectedItemColor: Colors.grey,
      ),
      inputDecorationTheme: InputDecorationTheme(
        isDense: true,
        fillColor: brightness.isLight ? Colors.white : Colors.black,
        filled: true,
        border: AlvysOutlineBorder(brightness),
      ),
      textSelectionTheme: TextSelectionThemeData(
          cursorColor: ColorManager.primary(brightness),
          selectionHandleColor: ColorManager.primary(brightness),
          selectionColor: ColorManager.primary(brightness).withOpacity(0.5)),
    );
  }

  // static TextTheme defaultTextTheme = TextTheme(
  //   headline1: const TextStyle(
  //       fontSize: 96, fontWeight: FontWeight.w300, wordSpacing: -1.5),
  //   headline2: const TextStyle(
  //       fontSize: 60, fontWeight: FontWeight.w300, wordSpacing: -0.5),
  //   headline3: const TextStyle(
  //       fontSize: 48, fontWeight: FontWeight.w400, wordSpacing: 0.0),
  //   headline4: const TextStyle(
  //       fontSize: 34.0, fontWeight: FontWeight.w400, wordSpacing: 0.25),
  //   headline5: const TextStyle(
  //       fontSize: 24.0, fontWeight: FontWeight.w400, wordSpacing: 0.0),
  //   headline6: const TextStyle(
  //       fontSize: 20, fontWeight: FontWeight.w500, wordSpacing: 0.15),
  //   subtitle1: const TextStyle(
  //       fontSize: 18, fontWeight: FontWeight.w400, wordSpacing: 0.15),
  //   subtitle2: const TextStyle(
  //       fontSize: 14, fontWeight: FontWeight.w500, wordSpacing: 0.1),
  //   bodyText1: const TextStyle(
  //       fontSize: 16, fontWeight: FontWeight.w400, wordSpacing: 0.5),
  //   bodyText2: const TextStyle(
  //       fontSize: 14, fontWeight: FontWeight.w400, wordSpacing: 0.25),
  //   button: const TextStyle(
  //       fontSize: 14, fontWeight: FontWeight.w500, wordSpacing: 1.125),
  //   caption: const TextStyle(
  //       fontSize: 12, fontWeight: FontWeight.w400, wordSpacing: 0.4),
  //   overline: const TextStyle(
  //       fontSize: 11, fontWeight: FontWeight.w400, wordSpacing: 1.5),
  //   displayLarge: const TextStyle(
  //       fontSize: 11, fontWeight: FontWeight.w400, wordSpacing: 1.5),
  // );
  static TextTheme defaultTextTheme =
      GoogleFonts.poppinsTextTheme(const TextTheme(
    displayLarge: TextStyle(
      // height: 64,
      fontSize: 57,
      wordSpacing: 0,
      fontWeight: FontWeight.w400,
    ),
    displayMedium: TextStyle(
      // height: 52,
      fontSize: 45,
      wordSpacing: 0,
      fontWeight: FontWeight.w400,
    ),
    displaySmall: TextStyle(
      // height: 44,
      fontSize: 36,
      wordSpacing: 0,
      fontWeight: FontWeight.w400,
    ),
    headlineLarge: TextStyle(
      // height: 40,
      fontSize: 30,
      wordSpacing: 0,
      fontWeight: FontWeight.w700,
    ),
    headlineMedium: TextStyle(
      // height: 36,
      fontSize: 28,
      wordSpacing: 0,
      fontWeight: FontWeight.w400,
    ),
    headlineSmall: TextStyle(
      // height: 32,
      fontSize: 24,
      wordSpacing: 0,
      fontWeight: FontWeight.w400,
    ),
    titleLarge: TextStyle(
      // height: 28,
      fontSize: 22,
      wordSpacing: 0,
      fontWeight: FontWeight.w700,
    ),
    titleMedium: TextStyle(
      // height: 24,
      fontSize: 18,
      wordSpacing: 0.15,
      fontWeight: FontWeight.w500,
    ),
    titleSmall: TextStyle(
      // height: 20,
      fontSize: 14,
      wordSpacing: 0.1,
      fontWeight: FontWeight.w500,
    ),
    labelLarge: TextStyle(
        // height: 20,
        fontSize: 16,
        wordSpacing: 0.1,
        fontWeight: FontWeight.w800,
        color: Colors.grey),
    labelMedium: TextStyle(
      // height: 16,
      fontSize: 12,
      wordSpacing: 0.5,
      fontWeight: FontWeight.w500,
    ),
    labelSmall: TextStyle(
      // height: 16,
      fontSize: 11,
      wordSpacing: 0.5,
      fontWeight: FontWeight.w500,
    ),
    bodyLarge: TextStyle(
      // height: 24,
      fontSize: 16,
      wordSpacing: 0.15,
      fontWeight: FontWeight.w400,
    ),
    bodyMedium: TextStyle(
      // height: 20,
      fontSize: 14,
      wordSpacing: 0.25,
      fontWeight: FontWeight.w400,
    ),
    bodySmall: TextStyle(
      // height: 16,
      fontSize: 12,
      wordSpacing: 0.4,
      fontWeight: FontWeight.w400,
    ),
  ));
  static TextTheme appTextTheme(double width, Brightness brightness) {
    return defaultTextTheme.apply(
      fontSizeFactor: (width / 1000) * 2.3,
    );
  }
}

class AlvysOutlineBorder extends MaterialStateUnderlineInputBorder {
  final Brightness brightness;

  const AlvysOutlineBorder(this.brightness);
  @override
  InputBorder resolve(Set<MaterialState> states) {
    Color color = Colors.grey.withOpacity(0.6);
    if (states.contains(MaterialState.focused)) {
      color = ColorManager.primary(brightness).withOpacity(0.8);
    }
    if (states.contains(MaterialState.error)) {
      color = ColorManager.cancelColor;
    }
    if (states.contains(MaterialState.disabled)) {
      color = Colors.transparent;
    }
    return OutlineInputBorder(
      borderSide: BorderSide(color: color, width: 0.5),
      borderRadius: BorderRadius.circular(10),
    );
  }
}

class AlvysMaterialStateColor extends MaterialStateColor {
  final Brightness brightness;

  const AlvysMaterialStateColor(this.brightness) : super(0);
  @override
  Color resolve(Set<MaterialState> states) {
    Color color = ColorManager.primary(brightness).withOpacity(0.8);
    if (states.contains(MaterialState.error)) {
      color = ColorManager.cancelColor;
    }
    // if (states.contains(MaterialState.disabled)) {
    //   color = Colors.transparent;
    // }
    return color;
  }
}
