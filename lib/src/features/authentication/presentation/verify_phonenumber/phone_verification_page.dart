import 'package:alvys3/src/common_widgets/buttons.dart';
import 'package:alvys3/src/constants/color.dart';
import 'package:alvys3/src/constants/text_styles.dart';
import 'package:alvys3/src/features/authentication/domain/models/verified/verified.dart';
import 'package:alvys3/src/routing/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import 'phone_verification_controller.dart';

class PhoneNumberVerificationPage extends StatefulWidget {
  const PhoneNumberVerificationPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
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

  final form = FormGroup({
    'verify': FormControl(validators: [
      Validators.required,
      Validators.number,
      Validators.minLength(6)
    ])
  });

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
                Text('Enter the verification code',
                    textAlign: TextAlign.start,
                    style: getExtraBoldStyle(
                        color: ColorManager.darkgrey, fontSize: 30)),
                const SizedBox(
                  height: 19,
                ),
                Text(
                    'We sent you a SMS with a 6 digit code to verify your phone number.',
                    textAlign: TextAlign.start,
                    style: getRegularStyle(color: ColorManager.lightgrey)),
                const SizedBox(
                  height: 16,
                ),
                Consumer(
                  builder: ((context, ref, _) {
                    final state = ref.watch(verificationPageController);
                    final isloading = state is AsyncLoading;

                    state.whenData((Verified? value) {
                      if (value!.errorCode == 0) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          Navigator.pushNamed(context, Routes.tripPageRoute);
                        });
                      }
                    });

                    ref.listen<AsyncValue<void>>(
                      verificationPageController,
                      (_, state) => state.whenOrNull(
                        error: (error, stackTrace) {
                          Alert(
                              context: context,
                              type: AlertType.error,
                              desc: error.toString(),
                              style: getLightErrorAlertStyle(),
                              buttons: [
                                DialogButton(
                                  onPressed: () => Navigator.pop(context),
                                  color: ColorManager.primary,
                                  child: const Text(
                                    "Ok",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ),
                                )
                              ]).show();
                        },
                      ),
                    );
                    return ReactiveForm(
                      formGroup: form,
                      child: Column(
                        children: [
                          ReactiveTextField(
                            formControlName: 'verify',
                            keyboardType: TextInputType.number,
                            maxLength: 6,
                            autofocus: true,
                            validationMessages: (control) => {'required': ''},
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
                          ReactiveFormConsumer(
                              builder: ((context, formGroup, child) {
                            return ButtonStyle1(
                                isDisable: !form.valid,
                                onPressAction: () {
                                  Navigator.pushNamed(
                                      context, Routes.tripPageRoute);
                                  // ignore: unused_local_variable
                                  var code = formGroup.control('verify').value;
/*
                                  formGroup.valid
                                      ? ref
                                          .read(verificationPageController
                                              .notifier)
                                          .verifyPhoneNumber('', code)
                                      : null;*/
                                },
                                title: "Continue",
                                isLoading: isloading);
                          }))
                        ],
                      ),
                    );
                  }),
                ),
                const SizedBox(
                  height: 10,
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
