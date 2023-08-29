import 'package:coder_matthews_extensions/coder_matthews_extensions.dart';
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

  T? firstOrNull(bool Function(T e) test) {
    if (this == null) return null;
    try {
      return this!.firstWhere(test);
    } on StateError catch (_) {
      return null;
    }
  }

  List<J> mapList<J>(J Function(T e, int index, bool isLast) toElement) {
    List<J> items = [];
    if (isNullOrEmpty) return items;
    for (var i = 0; i < this!.length; i++) {
      items.add(toElement(this!.elementAt(i), i, i == this!.length - 1));
    }
    return items;
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
  String get toUpperCase => name.toUpperCase();
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

extension MapExtn<T> on Map<T, dynamic> {
  Map<T, dynamic> get removeNulls {
    Map<T, dynamic> returnMap = {};
    forEach((key, value) {
      if (value != null) returnMap[key] = value;
    });
    return returnMap;
  }
}

extension KeyExtensions on GlobalKey {
  KeyData getKeyPosition(BuildContext context) {
    final RenderBox button = currentContext!.findRenderObject() as RenderBox;
    final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
    return KeyData(
        RelativeRect.fromRect(
          Rect.fromPoints(
            button.localToGlobal(button.size.topLeft(Offset.zero), ancestor: overlay),
            button.localToGlobal(button.size.bottomRight(Offset.zero), ancestor: overlay),
          ),
          Offset.zero & overlay.size,
        ),
        button.size);
  }
}

class KeyData {
  final RelativeRect rect;
  final Size size;

  KeyData(this.rect, this.size);
}
