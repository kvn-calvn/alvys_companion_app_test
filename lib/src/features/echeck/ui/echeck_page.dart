import 'package:alvys3/src/common_widgets/echeck_card.dart';
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
        backgroundColor: Colors.transparent,
        title: Text(
          'EChecks',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 28,
            textStyle: const TextStyle(color: Colors.black),
          ),
        ),
        actions: [
          IconButton(
            /* borderColor: Colors.transparent,
            borderRadius: 30,
            borderWidth: 1,
            buttonSize: 60,*/
            icon: const Icon(
              Icons.map_rounded,
              color: Colors.black,
              size: 30,
            ),
            onPressed: () {
              debugPrint('IconButton pressed ...');
            },
          ),
        ],
        centerTitle: false,
        elevation: 0,
      ),
      backgroundColor: const Color(0xFFF1F4F8),
      body: ListView(
        children: const [EcheckCard()],
      ),
    );
  }
}
