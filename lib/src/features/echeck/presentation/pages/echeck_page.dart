import '../../../../common_widgets/echeck_card.dart';
import '../../../../common_widgets/empty_view.dart';
import '../../../../constants/color.dart';
import '../../../trips/presentation/controller/trip_page_controller.dart';
import '../../../../utils/magic_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../../../utils/extensions.dart';
import 'generate_echeck.dart';

class EcheckPage extends ConsumerStatefulWidget {
  final String tripId;
  const EcheckPage(this.tripId, {Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _EcheckPageState createState() => _EcheckPageState();
}

class _EcheckPageState extends ConsumerState<EcheckPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var state = ref.watch(tripControllerProvider);
    var echecks = ref.watch(tripControllerProvider).value!.getTrip(widget.tripId).eChecks;
    return state.isLoading
        ? SpinKitFoldingCube()
        : Scaffold(
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                showDialog<void>(
                  context: context,
                  builder: (BuildContext context) {
                    return GenerateEcheck(widget.tripId);
                  },
                );
/*
                context.goNamed(RouteName.generateEcheck.name, pathParameters: {
                  ParamType.tripId.name: widget.tripId,
                });*/
              },
              backgroundColor: ColorManager.primary(Theme.of(context).brightness),
              child: const Icon(Icons.attach_money, color: Colors.white),
            ),
            body: RefreshIndicator(
              onRefresh: () async {
                await ref.read(tripControllerProvider.notifier).refreshCurrentTrip(widget.tripId);
              },
              child: echecks.isNullOrEmpty
                  ? const EmptyView(title: 'No E-Checks', description: 'Generated E-Checks will appear here.')
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      itemCount: echecks!.length,
                      itemBuilder: (context, index) => EcheckCard(
                        eCheck: echecks[index],
                        cancelECheck: (echeckNumber) {},
                      ),
                    ),
            ),
          );
  }
}
