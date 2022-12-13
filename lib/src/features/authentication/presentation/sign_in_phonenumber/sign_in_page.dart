import 'package:alvys3/src/features/authentication/presentation/auth_provider_controller.dart';
import 'package:alvys3/src/utils/extensions.dart';
import 'package:alvys3/src/utils/magic_strings.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import 'package:alvys3/src/constants/color.dart';
import 'package:alvys3/src/constants/text_styles.dart';
import 'package:flutter/material.dart';

class SignInPage extends ConsumerStatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignInPageState();
}

class _SignInPageState extends ConsumerState<SignInPage> {
  final TextEditingController phoneNumber = TextEditingController();

  var phoneNumberMaskFormatter = MaskTextInputFormatter(
      mask: '(###) ###-####',
      filter: {"#": RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
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
                  autocorrect: false,
                  keyboardType: TextInputType.number,
                  inputFormatters: [phoneNumberMaskFormatter],
                  onChanged: ref.read(authProvider.notifier).setPhone,
                  textAlign: TextAlign.center,
                  autofocus: true,
                  decoration: const InputDecoration(hintText: "(###) ###-####"),
                  buildCounter: (context,
                      {required currentLength, required isFocused, maxLength}) {
                    return Text(
                        '${ref.watch(authProvider).value!.phone.length}/10');
                  },
                ),
                const SizedBox(
                  height: 16,
                ),
                ButtonStyle1(
                    title: "Next",
                    isLoading: false,
                    isDisable:
                        ref.watch(authProvider).value!.phone.length != 10,
                    onPressAction: () {
                      context.pushNamed(RouteName.verify.name);
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
        textStyle: Theme.of(context).textTheme.titleLarge,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      child: Text(
        isLoading ? "Loading.." : title,
      ),
    );
  }
}
