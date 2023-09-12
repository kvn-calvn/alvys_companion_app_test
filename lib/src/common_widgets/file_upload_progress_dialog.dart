import '../network/file_upload_process_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<T?> showDocumentProgressDialog<T>(BuildContext context) => showGeneralDialog(
    context: context,
    useRootNavigator: true,
    pageBuilder: (context, animation1, animation2) => const DocumentProgressDialog());

class DocumentProgressDialog extends ConsumerWidget {
  const DocumentProgressDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Material(
      color: Colors.transparent,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: 70,
                  width: 70,
                  child: CircularProgressIndicator(
                    strokeWidth: 10,
                    strokeCap: StrokeCap.round,
                    value: ref.watch(fileUploadProvider),
                  ),
                ),
                Text("${(ref.watch(fileUploadProvider) * 100).toStringAsFixed(0)}%")
              ],
            ),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text('Uploading....'),
            )
          ],
        ),
      ),
    );
  }
}
