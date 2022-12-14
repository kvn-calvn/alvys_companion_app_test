// ignore_for_file: library_private_types_in_public_api, no_leading_underscores_for_local_identifiers

import 'package:alvys3/src/common_widgets/custom_bottom_sheet.dart';
import 'package:alvys3/src/common_widgets/empty_view.dart';
import 'package:alvys3/src/common_widgets/shimmers/documents_shimmer.dart';
import 'package:alvys3/src/features/documents/presentation/document_list.dart';
import 'package:alvys3/src/features/documents/presentation/trip_docs_controller.dart';
import 'package:alvys3/src/features/documents/presentation/upload_options.dart';
import 'package:alvys3/src/utils/magic_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../routing/routing_arguments.dart';

class PersonalDocumentsPage extends ConsumerStatefulWidget {
  const PersonalDocumentsPage({Key? key}) : super(key: key);

  @override
  _TripDocsPageState createState() => _TripDocsPageState();
}

class _TripDocsPageState extends ConsumerState<PersonalDocumentsPage> {
  @override
  Widget build(BuildContext context) {
    final tripDocsState =
        ref.watch(documentsProvider.call(DocumentType.personalDocuments));
    return Scaffold(
      appBar: AppBar(
        title: const Text('Personal Documents'),
      ),
      // backgroundColor: const Color(0xFFF1F4F8),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showCustomBottomSheet(context, const UploadOptions());
        },
        child: const Icon(Icons.cloud_upload),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: tripDocsState.when(
          loading: () => const DocumentsShimmer(),
          error: (error, stack) =>
              const EmptyView(title: "No Documents", description: ''),
          data: (data) {
            return DocumentList(
                documents: data.personalDocuments
                    .map((doc) => PDFViewerArguments(doc.link!, doc.type!))
                    .toList(),
                refreshFunction: () async {
                  await ref
                      .read(documentsProvider
                          .call(DocumentType.personalDocuments)
                          .notifier)
                      .getDocuments();
                },
                emptyMessage: "No Personal Documents");
          },
        ),
      ),
    );
  }
}
