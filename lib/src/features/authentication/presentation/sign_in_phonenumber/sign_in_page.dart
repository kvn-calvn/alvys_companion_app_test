import 'sign_in_page_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class SignInPage extends StatelessWidget {
  SignInPage({Key? key}) : super(key: key);
  final scaffoldKey = GlobalKey<ScaffoldState>();

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
                  height: 95,
                ),
                Text(
                  'Enter your 10 digit phone number',
                  textAlign: TextAlign.start,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w800,
                    fontSize: 30,
                    textStyle: const TextStyle(color: Colors.black),
                  ),
                ),
                const SizedBox(
                  height: 19,
                ),
                const Text(
                  'A text message with a verification code will be sent to the number.',
                  textAlign: TextAlign.start,
                ),
                const SizedBox(
                  height: 16,
                ),
                Consumer(builder: ((context, ref, _) {
                  //final state = ref.watch(signInPageControllerProvider);
                  //print(state);
                  return Column(
                    children: [
                      TextFormField(
                        obscureText: false,
                        autofocus: true,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 20.0, horizontal: 10.0),
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
                        child: const Text(
                          'Next',
                          style: TextStyle(fontSize: 16),
                        ),
                        onPressed: () => ref
                            .read(signInPageControllerProvider.notifier)
                            .loginWithPhoneNumber('9094623320'),
                        /*onPressed: () {
                    Navigator.pushNamed(context, '/verifyphone');
                  },*/
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                    ],
                  );
                })),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
