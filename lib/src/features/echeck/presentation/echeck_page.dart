import 'package:alvys3/src/common_widgets/echeck_card.dart';
import 'package:alvys3/src/common_widgets/empty_view.dart';
import 'package:alvys3/src/constants/color.dart';
import 'package:alvys3/src/features/trips/presentation/controller/trip_page_controller.dart';
import 'package:alvys3/src/utils/magic_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../utils/app_theme.dart';
import '../../../utils/extensions.dart';

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
    var echecks =
        ref.watch(tripControllerProvider).value!.getTrip(widget.tripId).eChecks;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'E-Checks',
          style: AlvysTheme.appbarTextStyle(context, true),
        ),
        leading: IconButton(
          // 1
          icon: Icon(
            Icons.adaptive.arrow_back,
          ),
          onPressed: () {
            //Navigator.of(context).maybePop();
            GoRouter.of(context).pop();
          },
        ),
        centerTitle: true,
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.goNamed(RouteName.generateEcheck.name, params: {
            ParamType.tripId.name: widget.tripId,
          });
        },
        backgroundColor: ColorManager.primary(Theme.of(context).brightness),
        child: const Icon(Icons.attach_money, color: Colors.white),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await ref
              .read(tripControllerProvider.notifier)
              .refreshCurrentTrip(widget.tripId);
        },
        child: echecks.isNullOrEmpty
            ? const EmptyView(
                title: 'No E-Checks',
                description: 'Generated E-Checks will appear here.')
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
