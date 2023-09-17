import 'package:flutter/material.dart';

class TabletUtils {
  late bool isTablet;
  //late bool firstInstall;
  late TabController detailsController;
  TabletUtils._privateConstructor();

  static final TabletUtils _instance = TabletUtils._privateConstructor();

  static TabletUtils get instance => _instance;
}
