import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';

import '../../../common_widgets/buttons.dart';
import '../../../common_widgets/unfocus_widget.dart';
import '../../../constants/color.dart';
import '../../../utils/extensions.dart';
import '../../../utils/tablet_utils.dart';
import 'auth_provider_controller.dart';

class PhoneNumberVerificationPage extends ConsumerStatefulWidget {
  const PhoneNumberVerificationPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  ConsumerState<ConsumerStatefulWidget> createState() => _PhoneNumberVerificationPageState();
}

class _PhoneNumberVerificationPageState extends ConsumerState<PhoneNumberVerificationPage> {
  final pinController = TextEditingController();
  final focusNode = FocusNode();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

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
            color: (Theme.of(context).brightness.isLight ? Colors.black : Colors.white).withOpacity(0.5),
          ),
        ),
      );
  static int length = 6;
  @override
  Widget build(BuildContext context) {
    return UnfocusWidget(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          backgroundColor: Colors.transparent,
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
          child: Center(
            child: Container(
              constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.longestSide * (TabletUtils.instance.isTablet ? 0.5 : 1)),
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
                    Text('Verification', textAlign: TextAlign.center, style: Theme.of(context).textTheme.headlineLarge),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text(
                      'Enter the code sent to the number.',
                      textAlign: TextAlign.center,
                    ),
                    Text(ref.watch(authProvider).value!.phone.toPhoneNumberString,
                        textAlign: TextAlign.center, style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(
                      height: 40,
                    ),
                    Pinput(
                      length: length,
                      controller: pinController,
                      focusNode: focusNode,
                      onChanged: ref.watch(authProvider.notifier).setVerificationCode,
                      defaultPinTheme: defaultPinTheme(context),
                      cursor: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        child: Container(
                          decoration: BoxDecoration(color: Theme.of(context).textSelectionTheme.cursorColor),
                          height: double.infinity,
                          width: 2,
                        ),
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                      ],
                      onCompleted: (pin) async {
                        await ref.read(authProvider.notifier).verifyDriver(context, mounted);
                      },
                      focusedPinTheme: defaultPinTheme(context).copyWith(
                        decoration: defaultPinTheme(context).decoration!.copyWith(
                              border: Border.all(
                                color: ColorManager.primary(Theme.of(context).brightness).withOpacity(0.8),
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
                    if (ref.watch(authProvider).isLoading)
                      SpinKitFoldingCube(
                        size: 30,
                        color: Theme.of(context).colorScheme.primary,
                      )
                    else ...[
                      ButtonStyle1(
                          isDisable: ref.watch(authProvider).value!.verificationCode.length != 6,
                          onPressAction: () async {
                            await ref.read(authProvider.notifier).verifyDriver(context, mounted);
                          },
                          title: "Verify",
                          isLoading: false),
                      SizedBox(
                        width: double.infinity,
                        child: TextButton(
                          onPressed: ref.read(authProvider.notifier).resendCode,
                          child: const Text(
                            'Resend Code',
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                      ),
                    ]
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
