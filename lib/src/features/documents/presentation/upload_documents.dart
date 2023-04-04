import 'dart:io';

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
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                DocumentUploadButton.add(widget.args),
                DocumentUploadButton.delete(widget.args),
                DocumentUploadButton.upload(widget.args)
              ],
            ),
          ),
          PageView.builder(
            itemCount: uploadDocsState.pages.length,
            itemBuilder: (context, index) =>
                Image.file(File(uploadDocsState.pages[index])),
          ),
        ],
      ),
    );
  }
}
