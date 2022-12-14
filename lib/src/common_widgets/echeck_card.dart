import 'package:alvys3/src/common_widgets/popup_dropdown.dart';
import 'package:alvys3/src/features/trips/domain/app_trip/echeck.dart';
import 'package:alvys3/src/utils/magic_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/extensions.dart';

class EcheckCard extends StatelessWidget {
  final ECheck eCheck;
  final Function(String echeckNumber) cancelECheck;
  const EcheckCard({Key? key, required this.eCheck, required this.cancelECheck})
      : super(key: key);

  void showEcheckMenu(BuildContext context) {
    showCustomPopup<EcheckOption>(
      context: context,
      onSelected: (value) {
        switch (value) {
          case EcheckOption.copy:
            Clipboard.setData(ClipboardData(text: eCheck.expressCheckNumber));
            SnackBar snackBar = SnackBar(
              padding: const EdgeInsets.only(top: 10),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 8.0, horizontal: 12),
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
              duration: const Duration(milliseconds: 2000),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
            break;
          case EcheckOption.cancel:
            cancelECheck(eCheck.eCheckId!);
            break;
        }
      },
      items: (context) => EcheckOption.values
          .map<AlvysPopupItem<EcheckOption>>(
              (e) => AlvysPopupItem(value: e, child: Text(e.name.titleCase)))
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(10, 12, 10, 12),
      child: Material(
        elevation: 2.5,
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(8),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onLongPress: () {
            showEcheckMenu(context);
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
                            eCheck.expressCheckNumber!,
                            style: GoogleFonts.oxygenMono(
                              fontWeight: FontWeight.w800,
                              textStyle: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .color,
                                      letterSpacing: 2,
                                      decoration: eCheck.isCanceled
                                          ? TextDecoration.lineThrough
                                          : TextDecoration.none,
                                      decorationThickness: 2),
                            ),
                          )
                        ],
                      ),
                    ),
                    const Text(
                      'Funds Available',
                    ),
                    Text(
                      '\$${eCheck.amount?.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(0, 4, 0, 0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            eCheck.reason!,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                  color: const Color(0xFF95A1AC),
                                ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                IconButton(
                  constraints: const BoxConstraints(),
                  splashRadius: 24,
                  onPressed: () {
                    showEcheckMenu(context);
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
