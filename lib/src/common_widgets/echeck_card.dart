import '../features/tutorial/tutorial_controller.dart';
import '../utils/dummy_data.dart';

import '../features/authentication/presentation/auth_provider_controller.dart';

import '../features/echeck/presentation/controller/echeck_page_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'popup_dropdown.dart';
import '../features/trips/domain/app_trip/echeck.dart';
import '../utils/magic_strings.dart';
import 'package:coder_matthews_extensions/coder_matthews_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class EcheckCard extends ConsumerWidget {
  final ECheck eCheck;
  final String tripId, companyCode;
  final int index;
  final void Function(String echeckNumber) cancelECheck;
  const EcheckCard(
      {required this.companyCode,
      required this.index,
      Key? key,
      required this.eCheck,
      required this.cancelECheck,
      required this.tripId})
      : super(key: key);

  void showEcheckMenu(BuildContext context, bool canCancelEcheck, String? checkNumber, ECheck check) {
    if (checkNumber != null) return;
    showCustomPopup<EcheckOption>(
      context: context,
      onSelected: (value) {
        switch (value) {
          case EcheckOption.copy:
            Clipboard.setData(ClipboardData(text: eCheck.expressCheckNumber!));
            SnackBar snackBar = const SnackBar(
              padding: EdgeInsets.only(top: 10),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12),
                    child: Text('E-Check number copied'),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Divider(
                    height: 0,
                    thickness: 1.5,
                  )
                ],
              ),
              duration: Duration(milliseconds: 2000),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
            break;
          case EcheckOption.cancel:
            cancelECheck(eCheck.eCheckId!);
            break;
        }
      },
      items: (context) => EcheckOption.values
          .map<AlvysPopupItem<EcheckOption>?>((e) => e == EcheckOption.copy || (canCancelEcheck && !check.isCanceled)
              ? AlvysPopupItem(value: e, child: Text(e.name.titleCase))
              : null)
          .removeNulls
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var state = ref.watch(echeckPageControllerProvider.call(null));
    var authState = ref.watch(authProvider);
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0, 8, 0, 8),
      child: Material(
        key: index == 0 && tripId == testTrip.id! ? ref.read(tutorialProvider).echeckCard : null,
        elevation: 0,
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(10),
        clipBehavior: Clip.antiAlias,
        child: state.value!.loadingEcheckNumber == eCheck.expressCheckNumber
            ? const Center(child: CircularProgressIndicator())
            : InkWell(
                onLongPress: () {
                  showEcheckMenu(context, authState.value!.shouldShowCancelEcheckButton(companyCode, eCheck.userId),
                      state.value!.loadingEcheckNumber, eCheck);
                },
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(12, 12, 12, 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 4),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  eCheck.expressCheckNumber!.trim(),
                                  style: GoogleFonts.oxygenMono(
                                    fontWeight: FontWeight.w800,
                                    textStyle: Theme.of(context).textTheme.titleMedium!.copyWith(
                                          letterSpacing: 2,
                                          decoration:
                                              eCheck.isCanceled ? TextDecoration.lineThrough : TextDecoration.none,
                                          decorationThickness: 2,
                                        ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          const Text(
                            'Funds Available',
                          ),
                          Text('\$${eCheck.amount?.toStringAsFixed(2)}', style: Theme.of(context).textTheme.bodyLarge),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                            child: Text(eCheck.reason!.trim(), style: Theme.of(context).textTheme.bodySmall),
                          ),
                        ],
                      ),
                      IconButton(
                        constraints: const BoxConstraints(),
                        splashRadius: 24,
                        onPressed: () {
                          showEcheckMenu(
                              context,
                              authState.value!.shouldShowCancelEcheckButton(companyCode, eCheck.userId),
                              state.value!.loadingEcheckNumber,
                              eCheck);
                        },
                        icon: const Icon(Icons.more_vert),
                      )
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
