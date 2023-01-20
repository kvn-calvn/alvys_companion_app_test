import 'package:alvys3/src/network/api_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<T?> showDocumentProgressDialog<T>(BuildContext context) =>
    showGeneralDialog(
        context: context,
        useRootNavigator: true,
        barrierColor: Colors.red,
        pageBuilder: (context, animation1, animation2) {
          return const DocumentProgressDialog();
        });

class DocumentProgressDialog extends ConsumerWidget {
  const DocumentProgressDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: CircularProgressIndicator(
        value: ref.watch(fileUploadProvider),
      ),
    );
  }
}
