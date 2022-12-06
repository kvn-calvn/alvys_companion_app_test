import 'package:alvys3/src/common_widgets/buttons.dart';
import 'package:alvys3/src/constants/color.dart';
import 'package:alvys3/src/constants/text_styles.dart';
import 'package:alvys3/src/features/authentication/domain/models/verified/verified.dart';
import 'package:alvys3/src/routing/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';
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

  final pinController = TextEditingController();
  final focusNode = FocusNode();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    focusNode.requestFocus();
    super.initState();
  }

  @override
  void dispose() {
    pinController.dispose();
    focusNode.dispose();
    super.dispose();
  }

/*
  final form = FormGroup({
    'verify': FormControl(validators: [
      Validators.required,
      Validators.number,
      Validators.minLength(6)
    ])
  });*/

  bool showError = false;

  @override
  Widget build(BuildContext context) {
    const length = 5;
    const borderColor = Color.fromRGBO(114, 178, 238, 1);
    const errorColor = Color.fromRGBO(255, 234, 238, 1);
    const fillColor = Color.fromARGB(203, 235, 245, 255);
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 60,
      textStyle: getMediumStyle(
          color: ColorManager.primary(Theme.of(context).brightness),
          fontSize: 22),
      decoration: BoxDecoration(
        color: fillColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.transparent),
      ),
    );

    return GestureDetector(
      onTap: () => (focusNode.unfocus()),
      child: Scaffold(
        key: scaffoldKey,
        //backgroundColor:
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(10, 0, 10, 0),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 95,
                  ),
                  Text('Verification',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineLarge),
                  const SizedBox(
                    height: 19,
                  ),
                  Text(
                    'Enter the code sent to the number.',
                    textAlign: TextAlign.center,
                  ),
                  Text('+909 462 3310',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(
                    height: 16,
                  ),
                  Pinput(
                    length: length,
                    controller: pinController,
                    focusNode: focusNode,
                    defaultPinTheme: defaultPinTheme,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                    ],
                    onCompleted: (pin) {
                      setState(() => showError = pin != '5555');
                    },
                    focusedPinTheme: defaultPinTheme.copyWith(
                      decoration: defaultPinTheme.decoration!.copyWith(
                        border: Border.all(color: borderColor),
                      ),
                    ),
                    errorPinTheme: defaultPinTheme.copyWith(
                      decoration: BoxDecoration(
                        color: errorColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ButtonStyle1(
                      isDisable: false,
                      onPressAction: () {
                        context.goNamed('Trips');
                      },
                      title: "Verify",
                      isLoading: false),
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

                  /*Consumer(
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
                */
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
