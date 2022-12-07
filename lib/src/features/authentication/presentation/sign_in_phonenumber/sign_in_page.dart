// ignore_for_file: unnecessary_string_escapes
import 'package:alvys3/src/common_widgets/textfield_input.dart';
import 'package:alvys3/src/features/authentication/domain/models/phonenumber/phonenumber.dart';
import 'package:alvys3/src/routing/routes.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:reactive_forms/reactive_forms.dart';

import 'package:alvys3/src/constants/color.dart';
import 'package:alvys3/src/constants/text_styles.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'sign_in_page_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> with InputValidationMixin {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController phoneNumber = TextEditingController();

  final formGlobalKey = GlobalKey<FormState>();

  var phoneNumberMaskFormatter = MaskTextInputFormatter(
      mask: '(###) ###-####',
      filter: {"#": RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy);

  final form = FormGroup({
    'phone': FormControl(validators: [
      Validators.required,
      Validators.number,
      Validators.minLength(10)
    ])
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 25,
                ),
                Text(
                  'Enter your 10 digit phone number',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'A text message with a verification code will be sent to the number.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 16,
                ),
                TextField(
                  keyboardType: TextInputType.number,
                  inputFormatters: [phoneNumberMaskFormatter],
                  // maxLength: 10,
                  autofocus: true,
                  decoration: const InputDecoration(hintText: "(###) ###-####"),
                ),
                // TextfieldInput(
                //     hint: "Phone",
                //     textfieldController: phoneNumber,
                //     isFocus: true,
                //     keyboardType: TextInputType.number),
                const SizedBox(
                  height: 16,
                ),
                ButtonStyle1(
                    title: "Next",
                    isLoading: false,
                    isDisable: false,
                    onPressAction: () {
                      context.pushNamed(
                        'Verify',
                      );
                    }),
                /*Consumer(
                  builder: ((context, ref, _) {
                    final state = ref.watch(signInPageControllerProvider);
                    final isloading = state is AsyncLoading;

                    state.whenData((Phonenumber? value) {
                      if (value!.errorCode == 0) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          Navigator.pushNamed(context, Routes.verifyRoute,
                              arguments: {'phone': '9094623310'});
                        });
                      }
                    });

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
                                  onPressed: () => Navigator.pop(context),
                                  color: ColorManager.primary(
                                      Theme.of(context).brightness),
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
                              formControlName: 'phone',
                              keyboardType: TextInputType.number,
                              maxLength: 10,
                              autofocus: true,
                              validationMessages: (control) => {'required': ''},
                            ),
                            ReactiveFormConsumer(
                                builder: ((context, formGroup, child) {
                              return ButtonStyle1(
                                  title: "Next",
                                  isLoading: false,
                                  isDisable: false,
                                  onPressAction: () {
                                    context.pushNamed(
                                      'Verify',
                                    );
                                  });
                            }))
                          ],
                        ));
                  }),
                ),
              */
              ],
            ),
          ),
        ),
      ),
    );
  }
/*
  Form SignInForm(bool _btnEnabled, TextEditingController phoneNumberController,
      bool isloading, WidgetRef ref) {
    return Form(
      key: formGlobalKey,
      onChanged: () =>
          setState(() => _btnEnabled = formGlobalKey.currentState!.validate()),
      child: Column(
        children: [
          TextFormField(
            keyboardType: TextInputType.number,
            controller: phoneNumberController,
            maxLength: 10,
            validator: (phoneNumber) {
              if (isPhoneNumberValid(phoneNumber!)) {
                _btnEnabled = true;
              } else {
                _btnEnabled = false;
              }
              return null;
            },
            autofocus: true,
            decoration: InputDecoration(
              fillColor: Colors.white,
              filled: true,
              enabledBorder: OutlineInputBorder(
                borderSide:
                    const BorderSide(color: Color(0xffE5E5E5), width: 2.0),
                borderRadius: BorderRadius.circular(10),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide:
                    const BorderSide(color: Color(0xffE5E5E5), width: 2.0),
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
              isDisable: _btnEnabled,
              onPressAction: () {
                if (formGlobalKey.currentState!.validate()) {
                  formGlobalKey.currentState!.save();
                  // use the email provided here
                  ref
                      .read(signInPageControllerProvider.notifier)
                      .loginWithPhoneNumber(phoneNumberController.text);
                }
              }),
        ],
      ),
    );
  }*/
}

class ButtonStyle1 extends StatelessWidget {
  const ButtonStyle1(
      {Key? key,
      required this.onPressAction,
      required this.title,
      this.isLoading = false,
      this.isDisable = false})
      : super(key: key);

  final Function onPressAction;
  final bool isLoading;
  final bool isDisable;
  final String title;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading || isDisable ? null : () => onPressAction(),
      /*onPressed: () {
                    Navigator.pushNamed(context, '/verifyphone');
                  },*/
      style: ElevatedButton.styleFrom(
        minimumSize: const Size.fromHeight(60),
        backgroundColor: ColorManager.primary(Theme.of(context).brightness),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      child: Text(
        isLoading ? "Loading.." : title,
        style: getRegularStyle(color: ColorManager.white),
      ),
    );
  }
}

mixin InputValidationMixin {
  bool isPhoneNumberValid(String phoneNumber) => phoneNumber.length == 10;
/*
  bool isEmailValid(String email) {
    Pattern pattern = r '^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex =  RegExp(pattern);
    return regex.hasMatch(email);
  }*/
}
