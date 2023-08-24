// ignore_for_file: library_private_types_in_public_api, no_leading_underscores_for_local_identifiers

import '../../../common_widgets/custom_bottom_sheet.dart';
import '../../../common_widgets/empty_view.dart';
import '../../../common_widgets/load_more_button.dart';
import '../../../common_widgets/shimmers/documents_shimmer.dart';
import 'document_list.dart';
import 'trip_docs_controller.dart';
import 'upload_options.dart';
import '../../../utils/magic_strings.dart';
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
        elevation: 0,
        backgroundColor: Colors.transparent,
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
                      mounted: mounted),
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
