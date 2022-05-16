import 'package:alvys3/src/routing/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Landing extends StatefulWidget {
  const Landing({Key? key}) : super(key: key);

  @override
  _LandingState createState() => _LandingState();
}

class _LandingState extends State<Landing> {
  @override
  void initState() {
    _getLoginData();
    super.initState();
  }

  Future<void> _getLoginData() async {
    const storage = FlutterSecureStorage();

    var token = await storage.read(key: 'appToken');
    if (token != null) {
      Navigator.pushNamedAndRemoveUntil(context, Routes.tripPageRoute,
          ModalRoute.withName(Routes.tripPageRoute));
      //debugPrint("Home");
    } else {
      Navigator.pushNamedAndRemoveUntil(
          context, Routes.signInRoute, ModalRoute.withName(Routes.signInRoute));
      //debugPrint("SignIn");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
