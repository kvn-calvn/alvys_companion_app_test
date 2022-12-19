import 'package:alvys3/src/constants/color.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'extensions.dart';
import 'package:flutter/material.dart';

class AlvysTheme {
  static ThemeData mainTheme(Brightness brightness) {
    final textTheme = appTextTheme(
        MediaQueryData.fromWindow(WidgetsBinding.instance.window).size.width,
        brightness);
    return ThemeData(
      textTheme: textTheme,
      brightness: brightness,
      primaryColor: brightness.isLight ? Colors.white : Colors.black,
      scaffoldBackgroundColor: ColorManager.scaffoldColor(brightness),
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
        elevation: 0,
        titleTextStyle: appTextTheme(
                MediaQueryData.fromWindow(WidgetsBinding.instance.window)
                    .size
                    .width,
                brightness)
            .headlineLarge!
            .copyWith(
              fontWeight: FontWeight.bold,
              color: brightness.isLight ? Colors.black : Colors.white,
            ),
      ),
      buttonTheme: const ButtonThemeData(textTheme: ButtonTextTheme.primary),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorManager.primary(brightness),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          textStyle: appTextTheme(
                  MediaQueryData.fromWindow(WidgetsBinding.instance.window)
                      .size
                      .width,
                  brightness)
              .labelMedium!
              .copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
      ),
      cardColor: ColorManager.cardColor(brightness),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: ColorManager.cardColor(brightness),
        selectedItemColor: ColorManager.primary(brightness),
        unselectedItemColor: Colors.grey,
      ),
      inputDecorationTheme: InputDecorationTheme(
        isDense: true,
        fillColor: brightness.isLight ? Colors.white : ColorManager.lightgrey2,
        filled: true,
        border: AlvysOutlineBorder(brightness),
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: ColorManager.primary(brightness),
        selectionHandleColor: ColorManager.primary(brightness),
        selectionColor: ColorManager.primary(brightness).withOpacity(0.5),
      ),
      radioTheme: RadioThemeData(
        fillColor: AlvysMaterialStateColor(brightness),
      ),
      cardTheme: CardTheme(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: ColorManager.primary(brightness),
      ),
      indicatorColor: ColorManager.primary(brightness),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: ColorManager.primary(brightness),
        foregroundColor: Colors.white,
      ),
      iconTheme: IconThemeData(
        color: brightness.isLight ? Colors.black : Colors.white,
      ),
      colorScheme: ColorScheme(
        brightness: brightness,
        primary: ColorManager.primary(brightness),
        onPrimary: Colors.white,
        secondary: Colors.grey,
        onSecondary: brightness.isLight ? Colors.black : Colors.white,
        error: Colors.red,
        onError: Colors.white,
        background: brightness.isLight ? Colors.white : Colors.black,
        onBackground: brightness.isLight ? Colors.black : Colors.white,
        surface: brightness.isLight ? Colors.white : Colors.black,
        onSurface: brightness.isLight ? Colors.black : Colors.white,
      ),
      snackBarTheme: SnackBarThemeData(
          backgroundColor: ColorManager.cardColor(brightness),
          contentTextStyle: textTheme.bodyMedium),
    );
  }

  static TextStyle appbarTextStyle(BuildContext context, bool small) {
    return small
        ? Theme.of(context).textTheme.titleMedium!
        : Theme.of(context).textTheme.headlineLarge!;
  }

  static TextTheme defaultTextTheme(Brightness brightness) => TextTheme(
        displayLarge: const TextStyle(
          // height: 64,
          fontSize: 57,
          wordSpacing: 0,
          fontWeight: FontWeight.w400,
        ),
        displayMedium: const TextStyle(
          // height: 52,
          fontSize: 45,
          wordSpacing: 0,
          fontWeight: FontWeight.w400,
        ),
        displaySmall: const TextStyle(
          // height: 44,
          fontSize: 36,
          wordSpacing: 0,
          fontWeight: FontWeight.w400,
        ),
        headlineLarge: const TextStyle(
          // height: 40,
          fontSize: 30,
          wordSpacing: 0,
          fontWeight: FontWeight.w700,
        ),
        headlineMedium: const TextStyle(
          // height: 36,
          fontSize: 28,
          wordSpacing: 0,
          fontWeight: FontWeight.w400,
        ),
        headlineSmall: const TextStyle(
          // height: 32,
          fontSize: 24,
          wordSpacing: 0,
          fontWeight: FontWeight.w400,
        ),
        titleLarge: const TextStyle(
          // height: 28,
          fontSize: 22,
          wordSpacing: 0,
          fontWeight: FontWeight.w700,
        ),
        titleMedium: const TextStyle(
          // height: 24,
          fontSize: 18,
          wordSpacing: 0.15,
          fontWeight: FontWeight.w700,
        ),
        titleSmall: const TextStyle(
          // height: 20,
          fontSize: 14,
          wordSpacing: 0.1,
          fontWeight: FontWeight.w500,
        ),
        labelLarge: TextStyle(
            // height: 20,
            fontSize: 16,
            wordSpacing: 0.1,
            fontWeight: FontWeight.w700,
            color: ColorManager.lightTextColor(brightness)),
        labelMedium: const TextStyle(
          // height: 16,
          fontSize: 12,
          wordSpacing: 0.5,
          fontWeight: FontWeight.w500,
        ),
        labelSmall: const TextStyle(
          // height: 16,
          fontSize: 11,
          wordSpacing: 0.5,
          fontWeight: FontWeight.w500,
        ),
        bodyLarge: const TextStyle(
          // height: 24,
          fontSize: 16,
          wordSpacing: 0.15,
          fontWeight: FontWeight.w600,
        ),
        bodyMedium: const TextStyle(
          // height: 20,
          fontSize: 14,
          wordSpacing: 0.25,
          fontWeight: FontWeight.w400,
        ),
        bodySmall: const TextStyle(
          // height: 16,
          fontSize: 12,
          wordSpacing: 0.4,
          fontWeight: FontWeight.w400,
        ),
      );
  static TextTheme appTextTheme(double width, Brightness brightness) {
    return GoogleFonts.poppinsTextTheme(defaultTextTheme(brightness).apply(
      fontSizeFactor: (width / 1000) * 2.55,
    ));
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
      borderSide: BorderSide(color: color, width: 1),
      borderRadius: BorderRadius.circular(10),
    );
  }
}

class AlvysMaterialStateColor extends MaterialStateColor {
  final Brightness brightness;

  const AlvysMaterialStateColor(this.brightness) : super(0);
  @override
  Color resolve(Set<MaterialState> states) {
    Color color = Colors.grey;
    if (states.contains(MaterialState.error)) {
      color = ColorManager.cancelColor;
    }
    if (states.contains(MaterialState.disabled)) {
      color = Colors.grey.withOpacity(0.5);
    }
    if (states.contains(MaterialState.focused) ||
        states.contains(MaterialState.selected)) {
      color = ColorManager.primary(brightness).withOpacity(0.8);
    }
    return color;
  }
}

class AlvysButtonMaterialStateColor extends MaterialStateColor {
  final Brightness brightness;

  const AlvysButtonMaterialStateColor(this.brightness) : super(0);
  @override
  Color resolve(Set<MaterialState> states) {
    Color color = ColorManager.primary(brightness);
    if (states.contains(MaterialState.disabled)) {
      color = Colors.grey.withOpacity(0.5);
    }
    return color;
  }
}
