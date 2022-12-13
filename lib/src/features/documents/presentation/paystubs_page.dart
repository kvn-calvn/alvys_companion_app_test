import 'package:alvys3/src/common_widgets/shimmers/documents_shimmer.dart';
import 'package:alvys3/src/features/documents/presentation/trip_docs_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';

import '../../../common_widgets/empty_view.dart';
import '../../../constants/color.dart';
import '../../../routing/routing_arguments.dart';
import '../../../utils/magic_strings.dart';
import 'document_list.dart';

class PaystubPage extends ConsumerWidget {
  const PaystubPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tripDocsState =
        ref.watch(documentsProvider.call(DocumentType.paystubs));
    return Scaffold(
      appBar: AppBar(title: const Text('Paystubs')),
      body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: tripDocsState.when(
            loading: () => const DocumentsShimmer(),
            error: (error, stack) {
              return const EmptyView(title: "No Paystubs", description: '');
            },
            data: (data) {
              return DocumentList(
                  documents: data.paystubs
                      .map((doc) => PDFViewerArguments(
                          doc.link, DateFormat.MEd().format(doc.datePaid!)))
                      .toList(),
                  refreshFunction: () async {
                    await ref
                        .read(documentsProvider
                            .call(DocumentType.paystubs)
                            .notifier)
                        .getDocuments();
                  },
                  emptyMessage: "No Trip documents");
            },
          )),
    );
  }
}
