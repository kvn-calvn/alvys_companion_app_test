import '../../authentication/presentation/auth_provider_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../common_widgets/custom_bottom_sheet.dart';
import '../../../common_widgets/load_more_button.dart';
import '../../../common_widgets/shimmers/documents_shimmer.dart';
import '../../../utils/app_theme.dart';
import '../../../utils/magic_strings.dart';
import 'docs_controller.dart';
import 'document_list.dart';
import 'upload_options.dart';

class DocumentsPage extends ConsumerStatefulWidget {
  final DocumentsArgs args;

  const DocumentsPage(this.args, {Key? key}) : super(key: key);

  @override
  ConsumerState<DocumentsPage> createState() => _DocumentsPageState();
}

class _DocumentsPageState extends ConsumerState<DocumentsPage> {
  bool get showFAB {
    switch (widget.args.documentType) {
      case DisplayDocumentType.tripDocuments:
      case DisplayDocumentType.personalDocuments:
      case DisplayDocumentType.tripReport:
        return true;
      case DisplayDocumentType.paystubs:
        return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final docsState = ref.watch(documentsProvider.call(widget.args));
    final authState = ref.watch(authProvider);
    final docsNotifier = ref.read(documentsProvider.call(widget.args).notifier);
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
                  UploadOptions(documentType: widget.args.documentType, tripId: widget.args.tripId, mounted: mounted),
                );
              },
              child: const Icon(Icons.cloud_upload),
            )
          : null,
      body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: docsState.isLoading
              ? const DocumentsShimmer()
              : DocumentList(
                  documents: docsState.value!.documents(widget.args.documentType, authState.value!.canViewPaystubs),
                  refreshFunction: () async {
                    await ref.read(documentsProvider.call(widget.args).notifier).getDocuments();
                  },
                  args: widget.args,
                  emptyMessage: "No ${docsNotifier.pageTitle}",
                  extra: docsState.value!.canLoadMore
                      ? LoadMoreButton(loadMoreFunction: () async {
                          await ref.read(documentsProvider.call(widget.args).notifier).loadMorePaystubs();
                        })
                      : null,
                )),
    );
  }
}
