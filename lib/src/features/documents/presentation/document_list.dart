import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../common_widgets/empty_view.dart';
import '../../../common_widgets/large_nav_button.dart';
import '../../../routing/routing_arguments.dart';
import '../../../utils/magic_strings.dart';

class DocumentList<T> extends StatelessWidget {
  const DocumentList(
      {Key? key,
      required this.documents,
      required this.refreshFunction,
      required this.emptyMessage,
      this.extra,
      required this.tripId})
      : super(key: key);
  final List<PDFViewerArguments<T>> documents;
  final String tripId;
  final Future<void> Function() refreshFunction;
  final String emptyMessage;
  final Widget? extra;
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: refreshFunction,
      child: documents.isEmpty
          ? EmptyView(
              title: emptyMessage,
              description: 'Uploaded documents will appear here.')
          : ListView(
              children: [
                ...documents
                    .map(
                      (doc) => LargeNavButton(
                        icon: const Icon(Icons.insert_drive_file),
                        title: doc.title,
                        onPressed: () {
                          context.pushNamed(RouteName.documentView.name,
                              extra: doc,
                              params: {ParamType.tripId.name: tripId});
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
