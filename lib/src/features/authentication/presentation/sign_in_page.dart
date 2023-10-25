import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../../../common_widgets/buttons.dart';
import '../../../common_widgets/unfocus_widget.dart';
import '../../../utils/tablet_utils.dart';
import 'auth_provider_controller.dart';

class SignInPage extends ConsumerStatefulWidget {
  const SignInPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignInPageState();
}

class _SignInPageState extends ConsumerState<SignInPage> {
  final phoneNumberMaskFormatter = MaskTextInputFormatter(
    mask: '(###) ###-####',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.eager,
  );
  TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return UnfocusWidget(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: SafeArea(
          child: Center(
            child: Container(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
              constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.longestSide *
                      (TabletUtils.instance.isTablet ? 0.5 : 1)),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 25,
                  ),
                  Text('Enter your 10 digit phone number',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineLarge),
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
                    readOnly: ref.watch(authProvider).isLoading,
                    keyboardType: TextInputType.number,
                    inputFormatters: [phoneNumberMaskFormatter],
                    onChanged: (value) {
                      ref.read(authProvider.notifier).setPhone(value);
                    },
                    textAlign: TextAlign.center,
                    autofocus: true,
                    decoration:
                        const InputDecoration(hintText: "(###) ###-####"),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  ref.watch(authProvider).isLoading
                      ? SpinKitFoldingCube(
                          size: 30,
                          color: Theme.of(context).colorScheme.primary,
                        )
                      : ButtonStyle1(
                          title: "Next",
                          isLoading: false,
                          isDisable:
                              ref.watch(authProvider).value!.phone.length < 10,
                          onPressAction: () async {
                            await ref
                                .read(authProvider.notifier)
                                .signInDriver(context, mounted);
                          }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
