import 'dart:io';

import '../../../../custom_icons/alvys3_icons.dart';
import 'upload_documents_controller.dart';
import '../../../utils/exceptions.dart';
import '../../../utils/magic_strings.dart';
import '../../../utils/permission_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';

class UploadOptions extends ConsumerWidget {
  final DocumentType documentType;
  final String tripId;
  final bool mounted;
  const UploadOptions({required this.tripId, required this.documentType, required this.mounted, super.key});
  String get route {
    switch (documentType) {
      case DocumentType.tripDocuments:
        return RouteName.uploadTripDocument.name;
      case DocumentType.personalDocuments:
        return RouteName.uploadPersonalDocument.name;
      case DocumentType.paystubs:
      case DocumentType.tripReport:
        return RouteName.uploadTripReport.name;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: const Text('Camera'),
            onTap: () async {
              var hasPermission = await PermissionHelper.getPermission(Permission.camera);
              if (!hasPermission) {
                throw PermissionException("Please enable camera permission", () {
                  Navigator.of(context, rootNavigator: false).pop();
                });
              }
              if (mounted) {
                Navigator.of(context, rootNavigator: true).pop();
                context.goNamed(
                  route,
                  extra: UploadType.camera,
                  pathParameters: {ParamType.tripId.name: tripId},
                );
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.photo),
            title: const Text('Gallery'),
            onTap: () async {
              var hasPermission = await PermissionHelper.getPermission(
                  Platform.isAndroid ? Permission.mediaLibrary : Permission.photos);
              if (!hasPermission) {
                throw PermissionException("Please enable gallery permission", () {
                  Navigator.of(context, rootNavigator: false).pop();
                });
              }
              if (mounted) {
                Navigator.of(context, rootNavigator: true).pop();
                context.goNamed(
                  route,
                  extra: UploadType.gallery,
                  pathParameters: {ParamType.tripId.name: tripId},
                );
              }
            },
          )
        ],
      ),
    );
  }
}

class DocumentUploadButton extends ConsumerWidget {
  final void Function(WidgetRef ref) onTap;
  final IconData icon;
  final String title;
  const DocumentUploadButton({
    super.key,
    required this.onTap,
    required this.icon,
    required this.title,
  });
  static DocumentUploadButton upload(UploadDocumentArgs args) => DocumentUploadButton(
      onTap: (ref) async {
        await ref.read(uploadDocumentsController.call(args).notifier).uploadFile();
      },
      icon: Alvys3Icons.upload,
      title: 'Upload');
  static DocumentUploadButton add(UploadDocumentArgs args) => DocumentUploadButton(
        onTap: (ref) async {
          debugPrint('adding');
          await ref.read(uploadDocumentsController.call(args).notifier).startScan();
        },
        icon: Alvys3Icons.add,
        title: 'Add',
      );
  static DocumentUploadButton delete(UploadDocumentArgs args) => DocumentUploadButton(
      onTap: (ref) {
        ref.read(uploadDocumentsController.call(args).notifier).removePage();
      },
      icon: Alvys3Icons.delete,
      title: 'Delete');
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Material(
          shape: const CircleBorder(),
          clipBehavior: Clip.antiAlias,
          elevation: 4,
          child: InkWell(
            onTap: () {
              onTap(ref);
            },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Icon(
                icon,
              ),
            ),
          ),
        ),
        const SizedBox(height: 5),
        Text(title)
      ],
    );
  }
}
