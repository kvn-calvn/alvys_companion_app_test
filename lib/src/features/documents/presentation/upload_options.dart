import 'package:app_settings/app_settings.dart';
import 'package:coder_matthews_extensions/coder_matthews_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../custom_icons/alvys3_icons.dart';
import '../../../network/posthog/posthog_provider.dart';
import '../../../utils/exceptions.dart';
import '../../../utils/magic_strings.dart';
import '../../../utils/permission_helper.dart';
import 'upload_documents_controller.dart';

class UploadOptions extends ConsumerWidget {
  final DisplayDocumentType documentType;
  final String? tripId;
  final int? tabIndex;
  final bool mounted;
  const UploadOptions(
      {this.tabIndex, required this.tripId, required this.documentType, required this.mounted, super.key});
  String get route {
    switch (documentType) {
      case DisplayDocumentType.tripDocuments:
        return RouteName.uploadTripDocument.name;
      case DisplayDocumentType.personalDocuments:
        return RouteName.uploadPersonalDocument.name;
      case DisplayDocumentType.paystubs:
      case DisplayDocumentType.tripReport:
        return RouteName.uploadTripReport.name;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postHogService = ref.read(postHogProvider);

    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: const Text('Camera'),
            onTap: () async {
              var hasPermission = await PermissionHelper.getPermission(Permission.camera);
              if (!hasPermission) {
                throw PermissionException("Please enable camera permission", () {
                  Navigator.of(context, rootNavigator: false).pop();
                }, [
                  ExceptionAction(
                      title: 'Open Settings', action: () => AppSettings.openAppSettings(type: AppSettingsType.settings))
                ]);
              }
              postHogService.postHogTrackEvent(PosthogTag.userOpenedCamera.toSnakeCase, null);
              if (context.mounted) {
                Navigator.of(context, rootNavigator: true).pop();
                context.goNamed(route,
                    extra: UploadType.camera,
                    pathParameters: tripId != null ? {ParamType.tripId.name: tripId!} : {},
                    queryParameters: tabIndex != null ? {ParamType.tabIndex.name: tabIndex.toString()} : {});
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.photo),
            title: const Text('Gallery'),
            onTap: () async {
              postHogService.postHogTrackEvent(PosthogTag.userOpenedGallery.toSnakeCase, null);
              if (context.mounted) {
                Navigator.of(context, rootNavigator: true).pop();
                context.goNamed(
                  route,
                  extra: UploadType.gallery,
                  pathParameters: tripId != null ? {ParamType.tripId.name: tripId!} : {},
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
  static DocumentUploadButton upload(UploadDocumentArgs args, BuildContext context) => DocumentUploadButton(
      onTap: (ref) async {
        await ref.read(uploadDocumentsController.call(args).notifier).uploadFile(context);
      },
      icon: Alvys3Icons.upload,
      title: 'Upload');
  static DocumentUploadButton add(UploadDocumentArgs args) => DocumentUploadButton(
        onTap: (ref) async {
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
    var backgroundColor = Theme.of(context).cardColor.withOpacity(0.7);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Material(
          color: backgroundColor,
          shape: const CircleBorder(),
          clipBehavior: Clip.antiAlias,
          //elevation: 4,
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
        Material(
            borderRadius: BorderRadius.circular(20),
            color: backgroundColor,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              child: Text(title),
            ))
      ],
    );
  }
}
