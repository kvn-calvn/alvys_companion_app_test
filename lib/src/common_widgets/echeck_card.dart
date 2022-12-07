import 'package:alvys3/src/features/trips/domain/app_trip/echeck.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EcheckCard extends StatelessWidget {
  final ECheck eCheck;
  const EcheckCard({Key? key, required this.eCheck}) : super(key: key);

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
          onTap: () {},
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
                    onPressed: () {},
                    icon: const Icon(Icons.more_vert))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
