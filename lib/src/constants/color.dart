class Color {
  static Color primary = HexColor.fromHex("#003494");
  static Color darkgrey = HexColor.fromHex("#1F1F1F");
  static Color lightgrey = HexColor.fromHex("#777777");
  static Color lightBackground = HexColor.fromHex("#F1F4F8");
  static Color pickupColor = HexColor.fromHex("#2991C2");
  static Color deliveryColor = HexColor.fromHex("#F08080");
  static Color cancelColor = HexColor.fromHex("#FF0000");

  Color(int parse);
}

extension HexColor on Color {
  static Color fromHex(String hexColorString) {
    hexColorString = hexColorString.replaceAll("#", '');
    if (hexColorString.length == 6) {
      hexColorString = "FF" + hexColorString;
    }

    return Color(int.parse(hexColorString, radix: 16));
  }
}
