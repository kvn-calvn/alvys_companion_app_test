import 'dart:html';

import 'package:alvys3/src/constants/color.dart';
import 'package:alvys3/src/constants/text_styles.dart';
import 'package:alvys3/src/features/documents/presentation/trip_docs_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
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
        _getFile(String url) {
          Widget image;

          return () async {
            try {
              final thumbnail = await FilePreview.getThumbnail(url);

              image = thumbnail;
            } catch (e) {
              image = Image.asset("");
            }

            // ignore: unnecessary_null_comparison
            return image != null
                ? Container(
                    width: 210,
                    height: 297,
                    padding: const EdgeInsets.all(8.0),
                    color: Colors.white,
                    child: image,
                  )
                : Container();
          };
        }

        _docsList() {
          _getFile(
              "https://alvyssandboxstorage.blob.core.windows.net/cl358/1000088_a198dc2f-0d6b-4eb3-8b0c-ea0704cead02_Unclassified_2022-07-1913:56:20-125423Z.pdf");
          return docs.map(
            (doc) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(doc.type ?? ''),
              ],
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
