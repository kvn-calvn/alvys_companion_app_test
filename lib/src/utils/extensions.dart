import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension ListExt<T, K> on Iterable<T>? {
  bool isInStatus(String test) {
    bool inStatus = false;
    if (this == null) return inStatus;

    if (T is String) {
      for (var element in this!) {
        if (element == test) {
          inStatus = true;
        }
      }
    }
    return inStatus;
  }

  List<T> toListNotNull() {
    if (this == null) {
      return [];
    }
    return this!.map((e) => e).toList();
  }

  bool get isNullOrEmpty {
    if (this == null) return true;
    return this!.isEmpty;
  }

  bool get isNotNullOrEmpty {
    if (this == null) return false;
    return this!.isNotEmpty;
  }

  bool containsElement(T? element) {
    if (this == null) return false;
    if (element == null) return false;
    for (T e in this!) {
      if (e == element) return true;
    }
    return false;
  }
}

extension StringExt on String? {
  bool isInStatus(Iterable<String> test) {
    bool inStatus = false;
    for (var element in test) {
      if (element == this) {
        inStatus = true;
      }
    }
    return inStatus;
  }

  bool get isNullOrEmpty {
    if (this == null) return true;
    return this!.isEmpty;
  }

  bool get isNotNullOrEmpty {
    if (this == null) return false;
    return this!.isNotEmpty;
  }

  String get sentenceCase {
    if (this == null) return "";
    return this!.isNotEmpty
        ? '${this![0].toUpperCase()}${this!.substring(1).toLowerCase()}'
        : '';
  }

  String get titleCase {
    if (this == null) return "";
    return this!
        .replaceAll(RegExp(' +'), ' ')
        .split(" ")
        .map((str) => str.sentenceCase)
        .join(" ");
  }

  String get numbersOnly {
    if (this == null) return '';
    return this!.replaceAll(RegExp(r'[^0-9]'), '');
  }

  String get currencyNumbersOnly {
    if (this == null) return '';
    return this!.replaceAll(RegExp(r'[^0-9 \.]'), '');
  }

  String get toPhoneNumberString {
    if (this == null) return '';
    String newNumber = numbersOnly;

    switch (newNumber.length) {
      case 7:
        return "${newNumber.substring(0, 3)}-${newNumber.substring(3, 7)}";
      case 10:
        return "(${newNumber.substring(0, 3)}) ${newNumber.substring(3, 6)}-${newNumber.substring(6, 10)}";
      case 11:
        return "${newNumber[0]} (${newNumber.substring(1, 4)}) ${newNumber.substring(4, 7)}-${newNumber.substring(7, 11)}";
      default:
        return '';
    }
  }
}

extension DoubleExt on double? {
  String get toCashFormat {
    if (this == null) return '-';
    return '\$${this!.toStringAsPrecision(2)}';
  }
}

extension BrightnessExtn on Brightness {
  bool get isLight => this == Brightness.light;
}

extension EnumExtn on Enum {
  String get toTitleCase => name.titleCase;
  String get toRoute => "/$name";
}

extension DateTimeExtn on DateTime? {
  bool get isNullOrAfterNow {
    if (this == null) return true;
    return DateTime.now().isAfter(this!);
  }
}

extension EnumListExt<T extends Enum> on Iterable<T> {
  T? byNameOrNull(String? name) {
    if (name == null) return null;
    for (var value in this) {
      if (value.name == name) return value;
    }
    return null;
  }
}

extension DateFormatEx on DateFormat {
  String formatNullDate(DateTime? date) {
    if (date == null) return '-';
    return format(date);
  }
}
