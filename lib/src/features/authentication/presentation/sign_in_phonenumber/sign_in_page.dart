import 'package:alvys3/src/common_widgets/unfocus_widget.dart';
import 'package:alvys3/src/features/authentication/presentation/auth_provider_controller.dart';
import 'package:alvys3/src/network/client_error/client_error.dart';
import 'package:alvys3/src/utils/exceptions.dart';
import 'package:alvys3/src/utils/magic_strings.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import 'package:alvys3/src/constants/color.dart';
import 'package:flutter/material.dart';

class SignInPage extends ConsumerStatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

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
        appBar: AppBar(),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
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
                  readOnly: ref.watch(authProvider).isLoading,
                  keyboardType: TextInputType.number,
                  inputFormatters: [phoneNumberMaskFormatter],
                  onChanged: (value) {
                    ref.read(authProvider.notifier).setPhone(value);
                  },
                  textAlign: TextAlign.center,
                  autofocus: true,
                  decoration: const InputDecoration(hintText: "(###) ###-####"),
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
    );
  }
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
