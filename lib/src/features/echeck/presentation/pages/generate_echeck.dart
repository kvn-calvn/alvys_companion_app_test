import 'package:alvys3/src/common_widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../../../../common_widgets/echeck_stop_card.dart';
import '../../../../common_widgets/shimmers/generate_echeck_shimmer.dart';
import '../../../../common_widgets/unfocus_widget.dart';
import '../../../../constants/color.dart';
import '../../../../utils/app_theme.dart';
import '../../../../utils/tablet_utils.dart';
import '../../../trips/domain/app_trip/stop.dart';
import '../../../trips/presentation/controller/trip_page_controller.dart';
import '../controller/echeck_page_controller.dart';

Future<String?> showGenerateEcheckDialog(BuildContext context, String tripId,
        [String? stopId]) =>
    showGeneralDialog<String?>(
        context: context,
        useRootNavigator: true,
        pageBuilder: (c, anim1, anim2) => SafeArea(
              child: GenerateEcheck(tripId, stopId),
            ));

class GenerateEcheck extends ConsumerStatefulWidget {
  final String tripId;
  final String? stopId;
  const GenerateEcheck(this.tripId, this.stopId, {super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _GenerateEcheckState();
}

class _GenerateEcheckState extends ConsumerState<GenerateEcheck> {
  GlobalKey<FormState> formGlobalKey = GlobalKey<FormState>();
  var amountMaskFormatter = MaskTextInputFormatter(
      mask: '\$##########',
      filter: {"#": RegExp(r'[0-9\.]')},
      type: MaskAutoCompletionType.eager);
  final TextEditingController amount = TextEditingController(),
      notes = TextEditingController();
  EcheckPageController get notifier =>
      ref.read(echeckPageControllerProvider.call(widget.stopId).notifier);
  @override
  Widget build(BuildContext context) {
    var state = ref.watch(echeckPageControllerProvider.call(widget.stopId));
    return Dialog(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      // contentPadding: EdgeInsets.zero,
      insetPadding: EdgeInsets.symmetric(
          horizontal: TabletUtils.instance.isTablet ? 250 : 12, vertical: 6),
      child: UnfocusWidget(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                state.isLoading ? 'Generating E-Check' : 'Generate E-Check',
                style: AlvysTheme.appbarTextStyle(context, true),
              ),
            ),
            Flexible(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
                  child: state.isLoading
                      ? const GenerateEcheckShimmer()
                      : Form(
                          key: formGlobalKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 16,
                              ),
                              TextFormField(
                                autofocus: true,
                                controller: amount,
                                inputFormatters: [amountMaskFormatter],
                                keyboardType: TextInputType.number,
                                onChanged: notifier.setAmount,
                                validator: notifier.validDouble,
                                decoration:
                                    const InputDecoration(hintText: "Amount"),
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              DropdownButtonFormField(
                                isDense: TabletUtils.instance.isTablet
                                    ? false
                                    : true,
                                value: state.value!.reason,
                                hint: const Text('Reason'),
                                onChanged: notifier.setReason,
                                items: notifier.reasonsDropdown,
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              if (state.value!.showStopDropdown) ...[
                                const Text("Select a Stop"),
                                for (Stop stop in ref
                                    .watch(tripControllerProvider)
                                    .value!
                                    .getTrip(widget.tripId)
                                    .stops)
                                  ECheckStopCard(
                                    stop: stop,
                                    onTap: notifier.setStopId,
                                    currentStopId: state.value!.stopId,
                                    selectedColor: ColorManager.primary(
                                        Theme.of(context).brightness),
                                  ),
                                const SizedBox(
                                  height: 16,
                                ),
                              ],
                              Scrollbar(
                                thickness: 2,
                                child: TextField(
                                  controller: notes,
                                  decoration:
                                      const InputDecoration(hintText: "Note"),
                                  maxLines: 6,
                                  minLines: 2,
                                  keyboardType: TextInputType.multiline,
                                  onChanged: notifier.setNote,
                                ),
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              ButtonStyle1(
                                isDisable: !state.value!.showGenerateButton,
                                onPressAction: () async {
                                  await notifier.generateEcheck(
                                      formGlobalKey, context, widget.tripId);
                                },
                                title: "Generate",
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              TextButton(
                                style: TextButton.styleFrom(
                                  minimumSize: const Size.fromHeight(50),
                                  textStyle:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                                onPressed: () {
                                  notifier.resetState();
                                  Navigator.of(context, rootNavigator: true)
                                      .pop();
                                },
                                child: const Text('Cancel'),
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                            ],
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
