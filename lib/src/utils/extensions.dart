import 'package:flutter/material.dart';

extension ListExt<T> on Iterable<T>? {
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
}
