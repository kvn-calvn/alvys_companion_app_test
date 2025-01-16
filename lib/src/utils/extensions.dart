import 'dart:io';

import 'package:coder_matthews_extensions/coder_matthews_extensions.dart';
import 'package:flutter/material.dart';

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

  bool containsElement(T? element) {
    if (this == null) return false;
    if (element == null) return false;
    for (T e in this!) {
      if (e == element) return true;
    }
    return false;
  }

  List<J> mapList<J>(J Function(T e, int index, bool isLast) toElement) {
    List<J> items = [];
    if (isNullOrEmpty) return items;
    for (var i = 0; i < this!.length; i++) {
      items.add(toElement(this!.elementAt(i), i, i == this!.length - 1));
    }
    return items;
  }

  Future<Iterable<J>> asyncMap<J>(Future<J> Function(T e) op) {
    if (this == null) return Future.value([]);
    var res = this!.map((e) async => await op(e));
    return Future.wait(res);
  }
}

extension StringExt on String? {
  bool isInStatus(Iterable<String> test) {
    bool inStatus = false;
    for (var element in test) {
      if (element.toLowerCase() == this?.toLowerCase()) return true;
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

  bool get isNullOrAfterNowOnlyDate {
    if (this == null) return true;
    return (this!.isUtc ? DateTime.now().onlyUtcDate : DateTime.now().onlyDate)!.isAfter(this!);
  }

  bool get paystubDateShouldShow {
    if (this == null) return true;
    return DateTime.now().onlyDate!.add(Duration(seconds: 1)).isAfter(this!);
  }

  bool isAfterNull(DateTime? other) {
    if (other == null) return true;
    if (this == null) return false;
    return this!.isAfter(other);
  }

  DateTime? get onlyDate {
    if (this == null) return null;
    return DateTime(this!.year, this!.month, this!.day);
  }

  DateTime? get onlyUtcDate {
    if (this == null) return null;
    return DateTime.utc(this!.year, this!.month, this!.day);
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

extension FileExn on File {
  Future<double> get sizeInMb => length().then((value) => value / (1024 * 1024));
}
