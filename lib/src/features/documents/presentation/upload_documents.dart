import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../common_widgets/alvys_dropdown.dart';
import '../../../common_widgets/empty_view.dart';
import 'upload_documents_controller.dart';
import 'upload_options.dart';

class UploadDocuments extends ConsumerStatefulWidget {
  final UploadDocumentArgs args;
  const UploadDocuments({required this.args, super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _UploadDocumentsState();
}

class _UploadDocumentsState extends ConsumerState<UploadDocuments> {
  UploadDocumentsController get uploadDocsNotifier => ref.read(uploadDocumentsController.call(widget.args).notifier);
  Duration get fadeDuration => const Duration(milliseconds: 350);
  @override
  Widget build(BuildContext context) {
    final uploadDocsState = ref.watch(uploadDocumentsController.call(widget.args));
    return Scaffold(
      body: Stack(
        children: [
          uploadDocsState.pages.isEmpty
              ? const EmptyView(title: 'No Pages', description: 'Click the add button to add pages.')
              : PageView.builder(
                  onPageChanged: uploadDocsNotifier.updatePageNumber,
                  itemCount: uploadDocsState.pages.length,
                  itemBuilder: (context, index) => DocumentPageView(File(uploadDocsState.pages[index]), widget.args),
                ),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: AnimatedOpacity(
              opacity: uploadDocsState.showHud ? 1 : 0,
              duration: fadeDuration,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  DocumentUploadButton.add(widget.args),
                  if (uploadDocsNotifier.shouldShowDeleteAndUploadButton) ...[
                    DocumentUploadButton.delete(widget.args),
                    DocumentUploadButton.upload(widget.args, context)
                  ],
                ],
              ),
            ),
          ),
          if (uploadDocsNotifier.shouldShowDeleteAndUploadButton)
            Align(
              alignment: const Alignment(0, 0.7),
              child: AnimatedOpacity(
                opacity: uploadDocsState.showHud ? 1 : 0,
                duration: fadeDuration,
                child: Opacity(
                  opacity: 0.6,
                  child: Chip(
                    backgroundColor: Theme.of(context).cardColor,
                    labelStyle: Theme.of(context).textTheme.labelSmall,
                    elevation: 4,
                    label: Text(
                      '${uploadDocsState.pageNumber + 1}/${uploadDocsState.pages.length}',
                    ),
                  ),
                ),
              ),
            ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: AnimatedOpacity(
                opacity: uploadDocsState.showHud ? 1 : 0,
                duration: fadeDuration,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          context.pop();
                        },
                        icon: Icon(Icons.adaptive.arrow_back),
                      ),
                      Flexible(
                        child: AlvysDropdown<UploadDocumentOptions>(
                          radius: 10,
                          items: uploadDocsNotifier.dropDownOptions,
                          onItemTap: uploadDocsNotifier.updateDocumentType,
                          dropDownTitle: (item) => item.title,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (ref.watch(scanningProvider))
            Center(
              child: Container(
                color: Colors.transparent,
              ),
            )
        ],
      ),
    );
  }
}

class DocumentPageView extends ConsumerWidget {
  const DocumentPageView(this.imageFile, this.args, {super.key});
  final File imageFile;
  final UploadDocumentArgs args;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
        onLongPressStart: (details) {
          ref.read(uploadDocumentsController.call(args).notifier).setShowHud(false);
        },
        onLongPressEnd: (details) {
          ref.read(uploadDocumentsController.call(args).notifier).setShowHud(true);
        },
        child: Image.file(imageFile));
  }
}
