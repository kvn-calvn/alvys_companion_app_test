import 'package:coder_matthews_extensions/coder_matthews_extensions.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../common_widgets/empty_view.dart';
import '../../../common_widgets/large_nav_button.dart';
import '../../../utils/magic_strings.dart';
import '../domain/app_document/app_document.dart';
import 'docs_controller.dart';

class DocumentList extends StatelessWidget {
  const DocumentList(
      {super.key,
      required this.documents,
      required this.refreshFunction,
      required this.emptyMessage,
      this.extra,
      required this.args});
  final List<AppDocument> documents;
  final DocumentsArgs args;
  final Future<void> Function() refreshFunction;
  final String emptyMessage;
  final Widget? extra;

  String docTitle(DisplayDocumentType docType, AppDocument doc) {
    switch (docType) {
      case DisplayDocumentType.paystubs:
      case DisplayDocumentType.tripReport:
        return DateFormat("MMM dd, yyyy").formatNullDate(doc.date);
      default:
        return doc.documentType;
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: refreshFunction,
      child: documents.isEmpty
          ? EmptyView(
              title: emptyMessage,
              description: 'Uploaded documents will appear here.')
          : ListView(
              //padding: const EdgeInsets.only(top: 200.0),
              children: [
                for (var doc in documents)
                  LargeNavButton(
                    icon: const Icon(Icons.description_outlined),
                    title: docTitle(args.documentType, doc),
                    subtitle: args.documentType ==
                            DisplayDocumentType.personalDocuments
                        ? DateFormat('MMM d, yyyy @ HH:mm')
                            .formatNullDate(doc.date?.toLocal(), "")
                        : null,
                    onPressed: () {
                      switch (args.documentType) {
                        case DisplayDocumentType.tripDocuments:
                          context.pushNamed(RouteName.tripDocumentView.name,
                              extra: doc,
                              pathParameters: {
                                ParamType.tripId.name: args.tripId!
                              });
                          break;
                        case DisplayDocumentType.personalDocuments:
                        case DisplayDocumentType.paystubs:
                        case DisplayDocumentType.tripReport:
                          context.pushNamed(RouteName.documentView.name,
                              extra: doc);
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
