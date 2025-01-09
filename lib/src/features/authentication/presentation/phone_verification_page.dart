import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:pinput/pinput.dart';

import '../../../common_widgets/buttons.dart';
import '../../../common_widgets/unfocus_widget.dart';
import '../../../constants/color.dart';
import '../../../utils/extensions.dart';
import '../../../utils/tablet_utils.dart';
import 'auth_provider_controller.dart';

class PhoneNumberVerificationPage extends ConsumerStatefulWidget {
  const PhoneNumberVerificationPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PhoneNumberVerificationPageState();
}

class _PhoneNumberVerificationPageState
    extends ConsumerState<PhoneNumberVerificationPage> {
  final pinController = TextEditingController();
  final focusNode = FocusNode();
  bool canResend = false;
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
            color: (Theme.of(context).brightness.isLight
                    ? Colors.black
                    : Colors.white)
                .withValues(alpha: 0.5),
          ),
        ),
      );
  static int length = 6;
  @override
  Widget build(BuildContext context) {
    return UnfocusWidget(
      child: Scaffold(
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
        body: Container(
          alignment: Alignment.topCenter,
          child: SafeArea(
            child: Container(
              constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.longestSide *
                      (TabletUtils.instance.isTablet ? 0.5 : 1)),
              padding: const EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
              child: Form(
                key: formKey,
                child: SingleChildScrollView(
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
                        'Enter the code sent to the number',
                        textAlign: TextAlign.center,
                      ),
                      Text(
                          ref
                              .watch(authProvider)
                              .value!
                              .phone
                              .toPhoneNumberString,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(
                        height: 40,
                      ),
                      Pinput(
                        key: const Key('verificationCodeTF'),
                        length: length,
                        controller: pinController,
                        focusNode: focusNode,
                        onChanged: ref
                            .watch(authProvider.notifier)
                            .setVerificationCode,
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
                        onCompleted: (pin) async {
                          await ref
                              .read(authProvider.notifier)
                              .verifyDriver(context);
                        },
                        focusedPinTheme: defaultPinTheme(context).copyWith(
                          decoration:
                              defaultPinTheme(context).decoration!.copyWith(
                                    border: Border.all(
                                      color: ColorManager.primary(
                                              Theme.of(context).brightness)
                                          .withValues(alpha: 0.8),
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
                            key: const Key('verifyBtn'),
                            isDisable: ref
                                    .watch(authProvider)
                                    .value!
                                    .verificationCode
                                    .length !=
                                6,
                            onPressAction: () async {
                              await ref
                                  .read(authProvider.notifier)
                                  .verifyDriver(context);
                            },
                            title: "Verify",
                            isLoading: false),
                        SizedBox(
                          width: double.infinity,
                          child: TextButton(
                            key: const Key('resendCodeBtn'),
                            onPressed: canResend
                                ? () {
                                    setState(() => canResend = false);
                                    ref
                                        .read(authProvider.notifier)
                                        .resendCode();
                                  }
                                : null,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'Resend Code',
                                ),
                                ResendTimer(
                                    canResend: canResend,
                                    resendCodeUpdater: (b) {
                                      setState(() => canResend = true);
                                    })
                              ],
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
      ),
    );
  }
}

class ResendTimer extends StatefulWidget {
  final bool canResend;
  final void Function(bool canResendCode) resendCodeUpdater;
  const ResendTimer(
      {super.key, required this.resendCodeUpdater, required this.canResend});

  @override
  State<ResendTimer> createState() => _ResendTimerState();
}

class _ResendTimerState extends State<ResendTimer> {
  Duration timerDuration = const Duration(seconds: 30);
  late Timer resendTimer;

  @override
  void initState() {
    super.initState();
    resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (widget.canResend) return;
      if (timerDuration.inSeconds <= 1) {
        timerDuration = const Duration(seconds: 30);
        widget.resendCodeUpdater(true);
        return;
      }
      setState(
          () => timerDuration = Duration(seconds: timerDuration.inSeconds - 1));
    });
  }

  @override
  void dispose() {
    resendTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return !widget.canResend
        ? Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
                '${timerDuration.inMinutes.remainder(60)}:${(NumberFormat('00').format(timerDuration.inSeconds.remainder(60)))}'),
          )
        : const SizedBox.shrink();
  }
}
