import 'package:alvys3/src/common_widgets/large_nav_button.dart';
import 'package:alvys3/src/constants/color.dart';
import 'package:alvys3/src/constants/text_styles.dart';
import 'package:alvys3/src/features/documents/presentation/trip_docs_controller.dart';
import 'package:alvys3/src/routing/routes.dart';
import 'package:alvys3/src/routing/routing_arguments.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:simple_speed_dial/simple_speed_dial.dart';
import 'package:thumbnailer/thumbnailer.dart';
import 'package:file_previewer/file_previewer.dart';

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
    ref
        .read(tripDocsPageControllerProvider.notifier)
        .getTripDocsList(widget.tripId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black, //change your color here
        ),
        backgroundColor: Colors.transparent,
        title: Text(
          'Documents',
          textAlign: TextAlign.start,
          style: getBoldStyle(color: ColorManager.darkgrey, fontSize: 20),
        ),
        actions: const [],
        centerTitle: true,
        elevation: 0,
      ),
      backgroundColor: const Color(0xFFF1F4F8),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: SpeedDial(
        child: const Icon(Icons.cloud_upload),
        closedForegroundColor: ColorManager.white,
        openForegroundColor: Colors.white,
        closedBackgroundColor: ColorManager.primary,
        openBackgroundColor: ColorManager.primary,
        speedDialChildren: <SpeedDialChild>[
          SpeedDialChild(
            child: const Icon(Icons.camera_enhance),
            foregroundColor: ColorManager.white,
            backgroundColor: ColorManager.primary,
            label: 'Camera',
            onPressed: () {},
            closeSpeedDialOnPressed: false,
          ),
          SpeedDialChild(
            child: const Icon(Icons.photo_album_outlined),
            foregroundColor: ColorManager.white,
            backgroundColor: ColorManager.primary,
            label: 'Gallery',
            onPressed: () {},
          ),
          //  Your other SpeedDialChildren go here.
        ],
      ),
      body: const TripDocsList(),
    );
  }
}

class TripDocsList extends ConsumerWidget {
  const TripDocsList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tripDocsState = ref.watch(tripDocsPageControllerProvider);

    return tripDocsState.when(
      loading: () => SpinKitFoldingCube(
        color: ColorManager.primary,
        size: 50.0,
      ),
      error: (error, stack) => Text('Oops, could not load documents, $stack'),
      data: (data) {
        var docs = data!.data ?? [];

        _docsList() {
          return docs.map((doc) => Container()
              /*LargeNavButton(
                icon: const Icon(Icons.insert_drive_file),
                title: doc.type ?? '',
                route: Routes.pdfViewer,
                args: PDFViewerArguments(docUrl: doc.link!))*/
              );
        }

        return ListView(
          children: [..._docsList()],
        );
      },
    );
  }
}
