import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PhoneNumberVerificationPage extends StatefulWidget {
  const PhoneNumberVerificationPage({Key? key}) : super(key: key);

  @override
  _PhoneNumberVerificationPageState createState() =>
      _PhoneNumberVerificationPageState();
}

class _PhoneNumberVerificationPageState
    extends State<PhoneNumberVerificationPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      //backgroundColor:
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(10, 0, 10, 0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 50,
                ),
                Text(
                  'Enter the verification code',
                  textAlign: TextAlign.start,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w800,
                    fontSize: 30,
                    textStyle: const TextStyle(color: Colors.black),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  'We sent you a SMS with a 6 digit code to verify your phone number.',
                  textAlign: TextAlign.start,
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  obscureText: false,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Color(0x00000000),
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: Color(0x00000000),
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    filled: true,
                    fillColor: const Color(0xFFCFD8DC),
                  ),
                  //style: FlutterFlowTheme.of(context).bodyText1,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/loadlist');
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: const Text(
                    'Next',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () {},
                    child: const Text(
                      'Resend Code',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
