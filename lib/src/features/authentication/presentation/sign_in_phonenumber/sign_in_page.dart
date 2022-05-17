import 'package:alvys3/src/common_widgets/alert_dialog.dart';
import 'package:alvys3/src/constants/color.dart';
import 'package:alvys3/src/constants/text_styles.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'sign_in_page_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignInPage extends StatelessWidget {
  SignInPage({Key? key}) : super(key: key);
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: ColorManager.lightBackground,
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
                Text('Enter your 10 digit phone number',
                    textAlign: TextAlign.start,
                    style: getExtraBoldStyle(
                        color: ColorManager.darkgrey, fontSize: 30)),
                const SizedBox(
                  height: 19,
                ),
                Text(
                    'A text message with a verification code will be sent to the number.',
                    textAlign: TextAlign.start,
                    style: getRegularStyle(color: ColorManager.lightgrey)),
                const SizedBox(
                  height: 16,
                ),
                Consumer(builder: ((context, ref, _) {
                  final state = ref.watch(signInPageControllerProvider);
                  final isloading = state is AsyncLoading;

                  TextEditingController phoneNumberController =
                      TextEditingController();

                  ref.listen<AsyncValue<void>>(
                    signInPageControllerProvider,
                    (_, state) => state.whenOrNull(
                      error: (error, stackTrace) {
                        Alert(
                            context: context,
                            type: AlertType.error,
                            desc: error.toString(),
                            style: getLightErrorAlertStyle(),
                            buttons: [
                              DialogButton(
                                child: const Text(
                                  "Ok",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                                onPressed: () => Navigator.pop(context),
                                color: ColorManager.primary,
                              )
                            ]).show();
                      },
                    ),
                  );
                  return Column(
                    children: [
                      TextField(
                        keyboardType: TextInputType.number,
                        controller: phoneNumberController,
                        autofocus: true,
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Color(0xffE5E5E5), width: 2.0),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Color(0xffE5E5E5), width: 2.0),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      ButtonStyle1(
                          title: "Next",
                          isLoading: isloading,
                          onPressAction: () {
                            ref
                                .read(signInPageControllerProvider.notifier)
                                .loginWithPhoneNumber(
                                    phoneNumberController.text);
                          }),
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

class ButtonStyle1 extends StatelessWidget {
  const ButtonStyle1(
      {Key? key,
      required this.onPressAction,
      required this.title,
      required this.isLoading})
      : super(key: key);

  final Function onPressAction;
  final bool isLoading;
  final bool isDisable = false;
  final String title;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: Text(
        isLoading ? "Loading.." : title,
        style: getRegularStyle(color: ColorManager.white),
      ),
      onPressed: isLoading ? null : () => onPressAction(),
      /*onPressed: () {
                    Navigator.pushNamed(context, '/verifyphone');
                  },*/
      style: ElevatedButton.styleFrom(
        minimumSize: const Size.fromHeight(60),
        primary: ColorManager.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }
}
