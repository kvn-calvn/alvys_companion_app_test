// ignore_for_file: library_private_types_in_public_api, no_leading_underscores_for_local_identifiers

import 'package:alvys3/src/common_widgets/custom_bottom_sheet.dart';
import 'package:alvys3/src/common_widgets/empty_view.dart';
import 'package:alvys3/src/common_widgets/large_nav_button.dart';
import 'package:alvys3/src/common_widgets/shimmers/documents_shimmer.dart';
import 'package:alvys3/src/constants/color.dart';
import 'package:alvys3/src/constants/text_styles.dart';
import 'package:alvys3/src/features/documents/presentation/document_list.dart';
import 'package:alvys3/src/features/documents/presentation/trip_docs_controller.dart';
import 'package:alvys3/src/features/documents/presentation/upload_options.dart';
import 'package:alvys3/src/utils/magic_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:simple_speed_dial/simple_speed_dial.dart';

import '../../../routing/routing_arguments.dart';

class TripDocsPage extends ConsumerStatefulWidget {
  const TripDocsPage({required this.tripId, Key? key}) : super(key: key);

  final String tripId;

  @override
  _TripDocsPageState createState() => _TripDocsPageState();
}

class _TripDocsPageState extends ConsumerState<TripDocsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trip Documents'),
      ),
      // backgroundColor: const Color(0xFFF1F4F8),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showCustomBottomSheet(context, const UploadOptions());
        },
        child: const Icon(Icons.cloud_upload),
      ),
      // SpeedDial(
      //   closedForegroundColor: ColorManager.white,
      //   openForegroundColor: Colors.white,
      //   closedBackgroundColor:
      //       ColorManager.primary(Theme.of(context).brightness),
      //   openBackgroundColor: ColorManager.primary(Theme.of(context).brightness),
      //   speedDialChildren: <SpeedDialChild>[
      //     SpeedDialChild(
      //       child: const Icon(Icons.camera_enhance),
      //       foregroundColor: ColorManager.white,
      //       backgroundColor: ColorManager.primary(Theme.of(context).brightness),
      //       label: 'Camera',
      //       onPressed: () {},
      //       closeSpeedDialOnPressed: false,
      //     ),
      //     SpeedDialChild(
      //       child: const Icon(Icons.photo_album_outlined),
      //       foregroundColor: ColorManager.white,
      //       backgroundColor: ColorManager.primary(Theme.of(context).brightness),
      //       label: 'Gallery',
      //       onPressed: () {},
      //     ),
      //     //  Your other SpeedDialChildren go here.
      //   ],
      //   child: const Icon(Icons.cloud_upload),
      // ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
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
        ref.watch(documentsProvider.call(DocumentType.tripDocuments));

    return tripDocsState.when(
      loading: () => const DocumentsShimmer(),
      error: (error, stack) =>
          const EmptyView(title: "No Documents", description: ''),
      data: (data) {
        return DocumentList(
            documents: data.tripDocuments
                .map((doc) => PDFViewerArguments(doc.link!, doc.type!))
                .toList(),
            refreshFunction: () async {
              await ref
                  .read(documentsProvider
                      .call(DocumentType.tripDocuments)
                      .notifier)
                  .getDocuments();
            },
            emptyMessage: "No Trip documents");
      },
    );
  }
}
