import 'dart:io';

import 'package:alvys3/src/common_widgets/alvys_dropdown.dart';
import 'package:alvys3/src/features/documents/presentation/upload_documents_controller.dart';
import 'package:alvys3/src/features/documents/presentation/upload_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UploadDocuments extends ConsumerStatefulWidget {
  final UploadDocumentArgs args;
  const UploadDocuments({required this.args, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _UploadDocumentsState();
}

class _UploadDocumentsState extends ConsumerState<UploadDocuments> {
  @override
  Widget build(BuildContext context) {
    final uploadDocsState =
        ref.watch(uploadDocumentsController.call(widget.args));
    final uploadDocsNotifier =
        ref.watch(uploadDocumentsController.call(widget.args).notifier);
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            onPageChanged: uploadDocsNotifier.updatePageNumber,
            itemCount: uploadDocsState.pages.length,
            itemBuilder: (context, index) =>
                Image.file(File(uploadDocsState.pages[index])),
          ),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                DocumentUploadButton.add(widget.args),
                if (uploadDocsNotifier.shouldShowDeleteAndUploadButton) ...[
                  DocumentUploadButton.delete(widget.args),
                  DocumentUploadButton.upload(widget.args)
                ],
              ],
            ),
          ),
          if (uploadDocsNotifier.shouldShowDeleteAndUploadButton)
            Positioned(
              bottom: MediaQuery.of(context).size.height * 0.2,
              left: 0,
              right: 0,
              child: Material(
                child: Text(
                  '${uploadDocsState.pageNumber + 1}/${uploadDocsState.pages.length}',
                ),
              ),
            ),
          Positioned(
            top: 30,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: AlvysDropdown<UploadDocumentOptions>(
                  items: uploadDocsNotifier.dropDownOptions,
                  onItemTap: uploadDocsNotifier.updateDocumentType,
                  dropDownTitle: (item) => item.title,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
