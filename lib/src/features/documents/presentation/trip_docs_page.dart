// ignore_for_file: library_private_types_in_public_api, no_leading_underscores_for_local_identifiers

import 'package:alvys3/src/common_widgets/large_nav_button.dart';
import 'package:alvys3/src/constants/color.dart';
import 'package:alvys3/src/constants/text_styles.dart';
import 'package:alvys3/src/features/documents/presentation/trip_docs_controller.dart';
import 'package:alvys3/src/utils/magic_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:simple_speed_dial/simple_speed_dial.dart';

class TripDocsPage extends ConsumerStatefulWidget {
  const TripDocsPage({required this.tripId, Key? key}) : super(key: key);

  final String tripId;

  @override
  _TripDocsPageState createState() => _TripDocsPageState();
}

class _TripDocsPageState extends ConsumerState<TripDocsPage> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: const Text('Documents'),
        actions: const [],
        elevation: 0,
      ),
      // backgroundColor: const Color(0xFFF1F4F8),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: SpeedDial(
        closedForegroundColor: ColorManager.white,
        openForegroundColor: Colors.white,
        closedBackgroundColor:
            ColorManager.primary(Theme.of(context).brightness),
        openBackgroundColor: ColorManager.primary(Theme.of(context).brightness),
        speedDialChildren: <SpeedDialChild>[
          SpeedDialChild(
            child: const Icon(Icons.camera_enhance),
            foregroundColor: ColorManager.white,
            backgroundColor: ColorManager.primary(Theme.of(context).brightness),
            label: 'Camera',
            onPressed: () {},
            closeSpeedDialOnPressed: false,
          ),
          SpeedDialChild(
            child: const Icon(Icons.photo_album_outlined),
            foregroundColor: ColorManager.white,
            backgroundColor: ColorManager.primary(Theme.of(context).brightness),
            label: 'Gallery',
            onPressed: () {},
          ),
          //  Your other SpeedDialChildren go here.
        ],
        child: const Icon(Icons.cloud_upload),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TripDocsList(
          tripId: widget.tripId,
        ),
      ),
    );
  }
}

class TripDocsList extends ConsumerWidget {
  final String tripId;
  const TripDocsList({Key? key, required this.tripId}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tripDocsState =
        ref.watch(tripDocsPageControllerProvider.call(tripId));

    return tripDocsState.when(
      loading: () => SpinKitFoldingCube(
        color: ColorManager.primary(Theme.of(context).brightness),
        size: 50.0,
      ),
      error: (error, stack) => const Text('No Documents'),
      data: (data) {
        var docs = data.data ?? [];
        debugPrint(docs.first.type);
        _docsList() {
          return docs.map(
            (doc) => LargeNavButton(
              icon: const Icon(Icons.insert_drive_file),
              title: doc.type ?? '',
              onPressed: () {
                context.pushNamed(RouteName.documentView.name,
                    queryParams: {'docUrl': doc.link!, 'docType': doc.type!});
              },
            ),
          );
        }

        return ListView(
          children: [..._docsList()],
        );
      },
    );
  }
}
