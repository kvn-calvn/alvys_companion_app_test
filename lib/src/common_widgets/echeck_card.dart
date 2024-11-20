import '../network/posthog/domain/posthog_objects.dart';

import '../network/posthog/posthog_provider.dart';
import '../network/posthog/posthog_service.dart';
import 'package:coder_matthews_extensions/coder_matthews_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../features/authentication/presentation/auth_provider_controller.dart';
import '../features/echeck/presentation/controller/echeck_page_controller.dart';
import '../features/trips/domain/app_trip/echeck.dart';
import '../features/tutorial/tutorial_controller.dart';
import '../utils/dummy_data.dart';
import '../utils/magic_strings.dart';
import 'popup_dropdown.dart';
import 'shimmers/shimmer_widget.dart';
import 'snack_bar.dart';

class EcheckCard extends ConsumerWidget {
  final ECheck eCheck;
  final String tripId, companyCode, tripNumber;
  final int index;
  final Future<void> Function(String echeckNumber) cancelECheck;
  const EcheckCard(
      {required this.companyCode,
      required this.index,
      super.key,
      required this.tripNumber,
      required this.eCheck,
      required this.cancelECheck,
      required this.tripId});

  void showEcheckMenu(
      BuildContext context, bool canCancelEcheck, String? checkNumber, ECheck check, PostHogService postHogService) {
    if (checkNumber != null) return;
    showCustomPopup<EcheckOption>(
      context: context,
      onSelected: (value) async {
        var event = PosthogEcheckLog(
                echeckNumber: eCheck.expressCheckNumber!.trim(),
                tripNumber: tripNumber,
                tripId: tripId,
                tenant: companyCode)
            .toJson();
        switch (value) {
          case EcheckOption.copy:
            Clipboard.setData(ClipboardData(text: eCheck.expressCheckNumber!.trim()));
            SnackBar snackBar = SnackBarWrapper.getSnackBar('E-Check number copied');
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
            postHogService.postHogTrackEvent(PosthogTag.userCopiedEcheck.toSnakeCase, {...event});
            break;
          case EcheckOption.cancel:
            await cancelECheck(eCheck.expressCheckNumber!);
            postHogService.postHogTrackEvent(PosthogTag.userCancelledEcheck.toSnakeCase, {...event});
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
    var postHogService = ref.watch(postHogProvider);

    return LayoutBuilder(builder: (context, constraints) {
      return Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(0, 8, 0, 8),
        child: Material(
          key: index == 0 && tripId == testTrip.id! ? ref.read(tutorialProvider).echeckCard : null,
          elevation: 0,
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(10),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            alignment: Alignment.center,
            children: [
              InkWell(
                onLongPress: () {
                  showEcheckMenu(
                    context,
                    authState.value!.shouldShowCancelEcheckButton(companyCode, eCheck.userId),
                    state.value!.loadingEcheckNumber,
                    eCheck,
                    postHogService,
                  );
                },
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(12, 12, 12, 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: constraints.maxWidth * 0.8),
                        child: Column(
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
                                  ConstrainedBox(
                                    constraints: BoxConstraints(maxWidth: constraints.maxWidth * 0.8),
                                    child: Text(
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
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Text('Funds Available',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      decoration: eCheck.isCanceled ? TextDecoration.lineThrough : TextDecoration.none,
                                      decorationThickness: 3,
                                    )),
                            Text('\$${eCheck.amount?.toStringAsFixed(2)}',
                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      decoration: eCheck.isCanceled ? TextDecoration.lineThrough : TextDecoration.none,
                                      decorationThickness: 4,
                                    )),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                              child: Row(
                                children: [
                                  Text(eCheck.reason!.trim(), style: Theme.of(context).textTheme.bodySmall),
                                  const Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 6.0),
                                    child: Icon(
                                      Icons.circle,
                                      size: 4,
                                    ),
                                  ),
                                  Text(DateFormat('MMM dd @ HH:mm').formatNullDate(eCheck.dateGenerated?.toLocal()),
                                      style: Theme.of(context).textTheme.bodySmall),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        constraints: const BoxConstraints(),
                        splashRadius: 24,
                        onPressed: () {
                          showEcheckMenu(
                            context,
                            authState.value!.shouldShowCancelEcheckButton(companyCode, eCheck.userId),
                            state.value!.loadingEcheckNumber,
                            eCheck,
                            postHogService,
                          );
                        },
                        icon: const Icon(Icons.more_vert),
                      )
                    ],
                  ),
                ),
              ),
              if (state.value!.loadingEcheckNumber == eCheck.expressCheckNumber) ...[
                Positioned.fill(
                    child: AlvysSingleChildShimmer(
                        child: DecoratedBox(
                  decoration: BoxDecoration(color: Theme.of(context).cardColor.withOpacity(0.7)),
                ))),
                const Positioned.fill(
                  child: Center(child: Text('Canceling...')),
                ),
              ]
            ],
          ),
        ),
      );
    });
  }
}
