import 'provider_args_saver.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'magic_strings.dart';

class ThemeHandlerNotifier extends Notifier<ThemeMode> {
  late ThemeMode currentThemeMode;
  late SharedPreferences pref;
  ThemeHandlerNotifier([ThemeMode? currentThemeMode]) {
    this.currentThemeMode = currentThemeMode ?? ThemeMode.system;
  }
  @override
  build() {
    pref = ref.read(sharedPreferencesProvider)!;
    state = currentThemeMode;
    return state;
  }

  void setThemeMode(ThemeMode themeMode) {
    state = themeMode;
    saveToStorage();
  }

  Future<void> saveToStorage() async {
    await pref.setString(SharedPreferencesKey.themeMode.name, state.name);
  }
}

final themeHandlerProvider = NotifierProvider<ThemeHandlerNotifier, ThemeMode>(ThemeHandlerNotifier.new);
