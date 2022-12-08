import 'package:alvys3/src/common_widgets/buttons.dart';
import 'package:alvys3/src/constants/color.dart';
import 'package:alvys3/src/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';

import '../auth_provider_controller.dart';

class PhoneNumberVerificationPage extends ConsumerStatefulWidget {
  const PhoneNumberVerificationPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PhoneNumberVerificationPageState();
}

class _PhoneNumberVerificationPageState
    extends ConsumerState<PhoneNumberVerificationPage> {
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
  PinTheme defaultPinTheme(BuildContext context) => PinTheme(
        width: 56,
        height: 60,
        textStyle: Theme.of(context).textTheme.titleLarge,
        decoration: BoxDecoration(
          color: Theme.of(context).inputDecorationTheme.fillColor,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: (Theme.of(context).brightness.isLight
                    ? Colors.black
                    : Colors.white)
                .withOpacity(0.5),
          ),
        ),
      );
  @override
  Widget build(BuildContext context) {
    const length = 5;

    return GestureDetector(
      onTap: () => (focusNode.unfocus()),
      child: Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.adaptive.arrow_back,
            ),
            onPressed: () {
              GoRouter.of(context).pop();
            },
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 25,
                  ),
                  Text('Verification',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineLarge),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    'Enter the code sent to the number.',
                    textAlign: TextAlign.center,
                  ),
                  Text(ref.watch(authProvider).value!.phone.toPhoneNumberString,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(
                    height: 40,
                  ),
                  Pinput(
                    length: length,
                    controller: pinController,
                    focusNode: focusNode,
                    onChanged:
                        ref.watch(authProvider.notifier).setVerificationCode,
                    defaultPinTheme: defaultPinTheme(context),
                    cursor: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Theme.of(context)
                                .textSelectionTheme
                                .cursorColor),
                        height: double.infinity,
                        width: 2,
                      ),
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                    ],
                    onCompleted: (pin) {
                      setState(() => showError = pin != '5555');
                    },
                    focusedPinTheme: defaultPinTheme(context).copyWith(
                      decoration: defaultPinTheme(context).decoration!.copyWith(
                            border: Border.all(
                              color: ColorManager.primary(
                                      Theme.of(context).brightness)
                                  .withOpacity(0.8),
                            ),
                          ),
                    ),
                    errorPinTheme: defaultPinTheme(context).copyWith(
                      decoration: BoxDecoration(
                        color: ColorManager.cancelColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  ButtonStyle1(
                      isDisable: ref
                              .watch(authProvider)
                              .value!
                              .verificationCode
                              .length !=
                          5,
                      onPressAction: () {
                        //context.goNamed('Trips');
                        context.goNamed('LocationPermission');
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
