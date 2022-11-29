// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'dart:convert';

class Utils {
  static String base64String(String _str) => base64.encode(utf8.encode(_str));
}
