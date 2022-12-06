import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ThemeHandlerNotifier extends Notifier<ThemeMode> {
  @override
  build() {
    return ThemeMode.system;
  }

  void setThemeMode(ThemeMode themeMode) {
    state = themeMode;
  }
}

final themeHandlerProvider =
    NotifierProvider<ThemeHandlerNotifier, ThemeMode>(ThemeHandlerNotifier.new);
