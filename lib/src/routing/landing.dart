import 'package:flutter/material.dart';

class Landing extends StatefulWidget {
  const Landing({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _LandingState createState() => _LandingState();
}

class _LandingState extends State<Landing> {
  @override
  void initState() {
    //  _getLoginData();
    super.initState();
  }

  // Future<void> _getLoginData() async {
  //   const storage = FlutterSecureStorage();

  //   var token = await storage.read(key: 'appToken');
  //   if (token == null) {
  //     if (!mounted) return;
  //     context.goNamed(RouteName.signIn.name);
  //   } else {
  //     if (!mounted) return;
  //     context.goNamed(RouteName.trips.name);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.blue,
      ),
    );
  }
}
