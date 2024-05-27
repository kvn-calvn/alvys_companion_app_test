import 'dart:io';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../common_widgets/alvys_logo.dart';
import '../../../common_widgets/buttons.dart';
import '../../../common_widgets/popup_dropdown.dart';
import '../../../common_widgets/unfocus_widget.dart';
import '../../../constants/color.dart';
import '../../../network/firebase_remote_config_service.dart';
import '../../../network/http_client.dart';
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
    var authState = ref.watch(authProvider);

    var loginTitle =
        ref.watch(firebaseRemoteConfigServiceProvider).loginTitle();
    var loginMessage =
        ref.watch(firebaseRemoteConfigServiceProvider).loginMessage();
    var salesUrl = ref.watch(firebaseRemoteConfigServiceProvider).salesUrl();
    var copySupportEmail =
        ref.watch(firebaseRemoteConfigServiceProvider).copySupportEmail();
    var loginErrorMessage =
        ref.watch(firebaseRemoteConfigServiceProvider).loginErrorMessage();
    var supportUrl =
        ref.watch(firebaseRemoteConfigServiceProvider).supportUrl();

    return UnfocusWidget(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: Center(
          child: SafeArea(
            child: Container(
              alignment: Alignment.topCenter,
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
              constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.longestSide *
                      (TabletUtils.instance.isTablet ? 0.5 : 1)),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const AlvysLogo.subText(),
                    const SizedBox(
                      height: 25,
                    ),
                    Text(
                        authState.value!.hasLoginError
                            ? "Phone number not registered."
                            : loginTitle,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineLarge),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      authState.value!.hasLoginError
                          ? loginErrorMessage
                          : loginMessage,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    TextField(
                      key: const Key("signInPhoneNumber"),
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
                      height: 12,
                    ),
                    ref.watch(authProvider).isLoading
                        ? SpinKitFoldingCube(
                            key: const Key('signInSpinner'),
                            size: 30,
                            color: Theme.of(context).colorScheme.primary,
                          )
                        : Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ButtonStyle1(
                                  key: const Key("signInNextBtn"),
                                  title: "Next",
                                  isLoading: false,
                                  isDisable: ref
                                          .watch(authProvider)
                                          .value!
                                          .phone
                                          .length <
                                      10,
                                  onPressAction: () async {
                                    await ref
                                        .read(authProvider.notifier)
                                        .signInDriver(context);
                                  }),
                              const SizedBox(height: 70),
                              Wrap(children: <Widget>[
                                if (Platform.isAndroid) ...[
                                  RedirectCard(
                                    title: 'Not an Alvys customer?',
                                    buttonTitle: 'Contact sales',
                                    url: salesUrl,
                                    copyText: salesUrl,
                                  )
                                ],
                                RedirectCard(
                                  title: 'Need customer support?',
                                  buttonTitle: 'Contact support',
                                  url: supportUrl,
                                  copyText: copySupportEmail,
                                )
                              ]
                                  // .addBetween(const SizedBox(
                                  //   height: 40,
                                  //   child: VerticalDivider(
                                  //     width: 16,
                                  //     thickness: 1,
                                  //   ),
                                  // ))
                                  // .toList(),
                                  )
                            ],
                          ),
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

class RedirectCard extends StatefulWidget {
  final String title, buttonTitle, url, copyText;
  const RedirectCard(
      {super.key,
      required this.title,
      required this.buttonTitle,
      required this.url,
      required this.copyText});

  @override
  State<RedirectCard> createState() => _RedirectCardState();
}

class _RedirectCardState extends State<RedirectCard> {
  var currentKey = GlobalKey();

  String get getRawUrl => Uri.parse(widget.url).fragment;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer(builder: (context, ref, child) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(widget.title,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith()),
              InkWell(
                  key: currentKey,
                  onTap: () async {
      
                    launchUrlString(widget.url);
                  },
                  onLongPress: () {
                    showCustomPopup(
                      context: context,
                      onSelected: (value) {
                        Clipboard.setData(ClipboardData(text: widget.copyText));
                        ref
                            .read(httpClientProvider)
                            .telemetryClient
                            .trackEvent(name: "${widget.copyText}_copied");
                      },
                      items: (context) => [
                        const AlvysPopupItem(value: "", child: Text('Copy'))
                      ],
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      widget.buttonTitle,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: ColorManager.primary(
                              Theme.of(context).brightness)),
                    ),
                  ))
            ],
          );
        }));
  }
}
