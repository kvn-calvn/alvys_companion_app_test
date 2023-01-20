import 'package:alvys3/src/utils/magic_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class UploadOptions extends ConsumerWidget {
  final DocumentType documentType;
  final String tripId;
  const UploadOptions(
      {required this.tripId, required this.documentType, super.key});
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
            onTap: () {
              Navigator.of(context, rootNavigator: true).pop();

              context.goNamed(
                route,
                extra: UploadType.camera,
                params: {ParamType.tripId.name: tripId},
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.photo),
            title: const Text('Gallery'),
            onTap: () {
              Navigator.of(context, rootNavigator: true).pop();
              context.goNamed(
                route,
                extra: UploadType.gallery,
                params: {ParamType.tripId.name: tripId},
              );
            },
          )
        ],
      ),
    );
  }
}
