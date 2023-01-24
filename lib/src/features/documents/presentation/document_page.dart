// ignore_for_file: library_private_types_in_public_api, no_leading_underscores_for_local_identifiers

import 'package:alvys3/src/common_widgets/custom_bottom_sheet.dart';
import 'package:alvys3/src/common_widgets/empty_view.dart';
import 'package:alvys3/src/common_widgets/load_more_button.dart';
import 'package:alvys3/src/common_widgets/shimmers/documents_shimmer.dart';
import 'package:alvys3/src/features/documents/presentation/document_list.dart';
import 'package:alvys3/src/features/documents/presentation/trip_docs_controller.dart';
import 'package:alvys3/src/features/documents/presentation/upload_options.dart';
import 'package:alvys3/src/utils/magic_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../utils/app_theme.dart';

class DocumentsPage extends ConsumerStatefulWidget {
  final DocumentsArgs args;

  const DocumentsPage(this.args, {Key? key}) : super(key: key);

  @override
  _DocumentsPageState createState() => _DocumentsPageState();
}

class _DocumentsPageState extends ConsumerState<DocumentsPage> {
  bool get showFAB {
    switch (widget.args.documentType) {
      case DocumentType.tripDocuments:
      case DocumentType.personalDocuments:
      case DocumentType.tripReport:
        return true;
      case DocumentType.paystubs:
        return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final docsState = ref.watch(documentsProvider.call(widget.args));
    final docsNotifier =
        ref.watch(documentsProvider.call(widget.args).notifier);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          docsNotifier.pageTitle,
          style: AlvysTheme.appbarTextStyle(context, true),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: showFAB
          ? FloatingActionButton(
              onPressed: () {
                showCustomBottomSheet(
                  context,
                  UploadOptions(
                    documentType: widget.args.documentType,
                    tripId: widget.args.tripId ?? "",
                  ),
                );
              },
              child: const Icon(Icons.cloud_upload),
            )
          : null,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: docsState.when(
          loading: () => const DocumentsShimmer(),
          error: (error, stack) {
            return RefreshIndicator(
              onRefresh: () async {
                await ref
                    .read(documentsProvider.call(widget.args).notifier)
                    .getDocuments();
              },
              child: const EmptyView(
                  title: "Error occurred while loading documents",
                  description: ''),
            );
          },
          data: (data) {
            return DocumentList(
              documents: docsNotifier.documentThumbnails,
              refreshFunction: () async {
                await ref
                    .read(documentsProvider.call(widget.args).notifier)
                    .getDocuments();
              },
              args: widget.args,
              emptyMessage: "No ${docsNotifier.pageTitle}",
              extra: data.canLoadMore
                  ? LoadMoreButton(loadMoreFunction: () async {
                      await ref
                          .read(documentsProvider.call(widget.args).notifier)
                          .loadMorePaystubs();
                    })
                  : null,
            );
          },
        ),
      ),
    );
  }
}
