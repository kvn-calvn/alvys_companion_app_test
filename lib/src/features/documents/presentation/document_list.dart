import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../common_widgets/empty_view.dart';
import '../../../common_widgets/large_nav_button.dart';
import '../../../routing/routing_arguments.dart';
import '../../../utils/magic_strings.dart';

class DocumentList extends StatelessWidget {
  const DocumentList(
      {Key? key,
      required this.documents,
      required this.refreshFunction,
      required this.emptyMessage,
      this.extra})
      : super(key: key);
  final List<PDFViewerArguments> documents;
  final Future<void> Function() refreshFunction;
  final String emptyMessage;
  final Widget? extra;
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: refreshFunction,
      child: documents.isEmpty
          ? EmptyView(title: emptyMessage, description: '')
          : ListView(
              children: [
                ...documents
                    .map(
                      (doc) => LargeNavButton(
                        icon: const Icon(Icons.insert_drive_file),
                        title: doc.title,
                        onPressed: () {
                          context.pushNamed(RouteName.documentView.name,
                              extra: doc);
                        },
                      ),
                    )
                    .toList(),
                extra ?? const SizedBox.shrink()
              ],
            ),
    );
  }
}
