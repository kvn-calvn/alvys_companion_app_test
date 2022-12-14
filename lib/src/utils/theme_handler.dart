import 'package:alvys3/src/utils/magic_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ThemeHandlerNotifier extends Notifier<ThemeMode> {
  late ThemeMode currentThemeMode;

  ThemeHandlerNotifier([ThemeMode? currentThemeMode]) {
    this.currentThemeMode = currentThemeMode ?? ThemeMode.system;
  }
  @override
  build() {
    state = currentThemeMode;
    return state;
  }

  void setThemeMode(ThemeMode themeMode) {
    state = themeMode;
    saveToStorage();
  }

  Future<void> saveToStorage() async {
    var storage = const FlutterSecureStorage();
    storage.write(key: StorageKey.themeMode.name, value: state.name);
  }
}

final themeHandlerProvider =
    NotifierProvider<ThemeHandlerNotifier, ThemeMode>(ThemeHandlerNotifier.new);
