import 'package:alvys3/src/common_widgets/echeck_card.dart';
import 'package:alvys3/src/constants/color.dart';
import 'package:alvys3/src/constants/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EcheckPage extends StatefulWidget {
  const EcheckPage({Key? key}) : super(key: key);

  @override
  _EcheckPageState createState() => _EcheckPageState();
}

class _EcheckPageState extends State<EcheckPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black, //change your color here
        ),
        backgroundColor: Colors.transparent,
        title: Text(
          'EChecks',
          textAlign: TextAlign.start,
          style: getBoldStyle(color: ColorManager.darkgrey, fontSize: 20),
        ),
        actions: const [],
        centerTitle: true,
        elevation: 0,
      ),
      backgroundColor: const Color(0xFFF1F4F8),
      body: ListView(
        children: const [EcheckCard()],
      ),
    );
  }
}
