import '../domain/app_document/app_document.dart';
import 'docs_controller.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../common_widgets/empty_view.dart';
import '../../../common_widgets/large_nav_button.dart';
import '../../../utils/magic_strings.dart';

class DocumentList extends StatelessWidget {
  const DocumentList(
      {Key? key,
      required this.documents,
      required this.refreshFunction,
      required this.emptyMessage,
      this.extra,
      required this.args})
      : super(key: key);
  final List<AppDocument> documents;
  final DocumentsArgs args;
  final Future<void> Function() refreshFunction;
  final String emptyMessage;
  final Widget? extra;
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: refreshFunction,
      child: documents.isEmpty
          ? EmptyView(title: emptyMessage, description: 'Uploaded documents will appear here.')
          : ListView(
              children: [
                for (var doc in documents)
                  LargeNavButton(
                    icon: const Icon(Icons.insert_drive_file),
                    title: doc.documentType,
                    onPressed: () {
                      switch (args.documentType) {
                        case DocumentType.tripDocuments:
                          context.pushNamed(RouteName.tripDocumentView.name,
                              extra: doc, pathParameters: {ParamType.tripId.name: args.tripId!});
                          break;
                        case DocumentType.personalDocuments:
                        case DocumentType.paystubs:
                        case DocumentType.tripReport:
                          context.pushNamed(RouteName.documentView.name, extra: doc);
                          break;
                      }
                    },
                  ),
                extra ?? const SizedBox.shrink()
              ],
            ),
    );
  }
}
